rawdata: data/raw/charisma.csv data/raw/oasis.csv data/raw/wine.csv data/raw/nature.csv data/raw/credit.csv

data/raw/%.csv: R/get_data.R
	R/get_data.R

.PHONY: publish

# does not render due to bug in rmarkdown
#publish: build_site.R
#	R/build_site.R
