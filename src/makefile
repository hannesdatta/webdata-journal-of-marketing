# Makefile, describing the order of execution and dependencies
# for the source code in this project.

all: ../output/barchart_collapsed.png ../output/tables_and_figures.html

clean: 
	Rscript cleanup.R
	
../output/barchart_collapsed.pdf ../output/barchart_collapsed.png ../output/tables_and_figures.html: tables_and_figures.Rmd ../data/final_coding.csv ../data/final_papers.csv
	Rscript -e "rmarkdown::render('tables_and_figures.Rmd',output_file='../output/tables_and_figures.html')"
	
../data/final_coding.csv ../data/final_papers.csv: prepare_coding.R ../data/coding/coding.csv ../data/wos_papers/1.bib
	Rscript prepare_coding.R
	
../data/coding/coding.csv: get_raw_coding.R 
	Rscript get_raw_coding.R
