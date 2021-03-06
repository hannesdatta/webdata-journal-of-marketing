# Fields of Gold: Scraping Web Data for Marketing Insights
## Replication package [![DOI](https://zenodo.org/badge/502820580.svg)](https://zenodo.org/badge/latestdoi/502820580)


This repository hosts the replication package for "Fields of Gold: Scraping Web Data for Marketing Insights", *Journal of Marketing*. [https://doi.org/10.1177%2F00222429221100750]().


Specifically, the repository provides the code and data files to report on the use of web data (i.e., collected using web scraping and APIs) in academic marketing research.

- Included Journals: *Journal of Marketing*, *Journal of Marketing Research*, *Journal of Consumer Research*, *Journal of Consumer Psychology*, *Marketing Science*
- Hand-coding of 300+ articles across almost two decades (2004-2020)
- Citation metrics on the basis of Web of Science Data for all publications in the selected journals

## Dependencies
- [R](https://tilburgsciencehub.com/get/R)
- [GNU Make](https://tilburgsciencehub.com/get/make)
- R packages:
	`install.packages("stargazer", "bibliometrix", "googledrive")`

## Other resources
- [Web companion](https://web-scraping.org) for article
- [Archive]() of this repository at Zenodo

## Running instructions

### Starting the workflow

The project consist of multiple source code files, and its running instructions are formalized in the `makefile` in `\src`. Simply type `make` (followed by `<ENTER>` on the command prompt/terminal). Do make sure to have installed the required software.

### Output

The code generates the figures and tables for the paper, and exports a list of web data papers (including their DOI). 

```
/output/barchart_collapsed.png
/output/barchart_collapsed.pdf
/output/tables_and_figures.html
/output/webdata_papers.csv
```

See [here](https://github.com/hannesdatta/webdata-journal-of-marketing/blob/main/output/) for the files.
