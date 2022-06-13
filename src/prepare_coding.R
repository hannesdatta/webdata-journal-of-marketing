################################################################

# Performs bibliometric analysis on the basis of
# data from Web of Science, and merges dataset with
# own classification of published papers using web data.

################################################################

# Initialize workspace
rm(list = ls())

# Load packages
library(knitr)
library(bibliometrix)
library(stringr)
library(data.table)

##################################
# Perform bibliographic analysis #
##################################

# Merge raw bibliography data into one file
fns <- list.files('../data/wos_papers', pattern = 'bib', full.names=T)

dir.create('../temp', recursive=T)
bibfile = '../temp/joined.bib'
sink(bibfile, append=F)
sink()

for (fn in fns) {
  print(fn)
  sink(bibfile, append=T)
  cat(paste(readLines(fn),collapse='\n'))
  sink()
}

# Convert to bibliographic data frame
papers <- convert2df(bibfile, dbsource = "wos", format = "bibtex")
  
# retain target years
papers <- papers[papers$PY %in% 2001:2020,]

# Load raw coding of published work using web data 
raw_coding <- fread('../data/coding/coding.csv')

# some DOIs in the WoS raw data are missing - fill them in
papers$DI[grepl("THE NETWORK VALUE OF PRODUCTS", papers$TI, ignore.case=T)] <- '10.1509/jm.11.0400'
papers$DI[grepl("we are what we post", papers$TI, ignore.case=T)] <- '10.1086/378616'
papers$DI[grepl("emotional branding and the strategic value", papers$TI, ignore.case=T)] <- '10.1509/jmkg.2006.70.1.50'

stopifnot(nrow(raw_coding[!doi%in%papers$DI])==0)

# filter out irrelevant articles
table(papers$DT)
nrow(papers)
papers$remove = grepl('retract|biographical|book|correction|editorial|letter', papers$DT, ignore.case=T)
papers <- papers[which(papers$remove==F),] 
nrow(papers)

# Conduct bibliographic analysis
bib_analysis <- biblioAnalysis(papers, sep = ";")

papers <- data.table(papers)

########################
# Build final data set #
########################

# select columns
tmp = data.table(papers[, c('DI','PY', 'JI', 'DE', 'AB', 'PN', 'VL', 'UT', 'AU', 'TI')])

# merge w/ citation data
tmp[,cites_per_year := bib_analysis$TCperYear]
tmp[,cites := bib_analysis$TotalCitation]

# add journal abbreviations  
tmp[, journal:=as.character(NA)]
tmp[grepl('Psych', JI,ignore.case=T), journal:='JCP']
tmp[grepl('Consum[.] Res', JI,ignore.case=T), journal:='JCR']
tmp[grepl('Mark[.] Res', JI,ignore.case=T), journal:='JMR']
tmp[grepl('Mark[.]$', JI,ignore.case=T), journal:='JM']
tmp[grepl('Sci[.]$', JI,ignore.case=T), journal:='MktSci']

# rename columns  
setnames(tmp, 'AB', 'abstract_wos')
setnames(tmp, 'PY', 'year')
setnames(tmp, 'DE', 'keywords')
setnames(tmp, 'VL', 'vol')
setnames(tmp, 'PN', 'issue')
setnames(tmp, 'UT', 'wos_id')
setnames(tmp, 'DI', 'doi')
setnames(tmp, 'AU', 'authors')
setnames(tmp, 'TI', 'title_wos')
  
# add author count
tmp[, nauthors := length(unique(unlist(strsplit(authors, ';', fixed=T)))), by = c('wos_id')]
  
# merge w/ our own coding of web data based papers
coding <- merge(tmp, raw_coding, by='doi', all.x=T)

# set column names to lower caps
colnames(coding) <- tolower(colnames(coding))

# add indicator for web data based publications (web = 1, 0 if not)
coding[, web:=doi%in%raw_coding$doi]

# cleaning
coding[, keywords:=tolower(keywords)]
coding[, keywords:=gsub('[,]',';', keywords)]

coding[web==T, scraped:=as.numeric(scraped)]
coding[web==T, api:=as.numeric(api)]
  
vars <- c('scraped','api','use_data_dumps')
for (.v in vars) coding[is.na(get(.v)), (.v):=0]
  
dir.create('../data/',recursive=T)
fwrite(coding, '../data/final_coding.csv')
fwrite(papers, '../data/final_papers.csv')
save(coding, papers, bib_analysis, file= '../data/citation_database.RData')
