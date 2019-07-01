#!/usr/bin/Rscript --vanilla
if(!require("pacman"))install.packages("pacman")
pacman::p_load("here", "fs", "tidyverse")

#----charisma----
charisma <- read_csv(url("https://raw.githubusercontent.com/seanchrismurphy/A-Psychologists-Guide-to-R/master/Week%203/charisma%20data.csv"))
write_csv(charisma, here("data", "raw", "charisma.csv"))

#----oasis----
# this is not the original source!
# orignally provided by http://www.oasis-brains.org
# data can be obtained (behind login wall) at https://www.kaggle.com/jboysen/mri-and-alzheimers
oasis <- read_csv(url("https://raw.githubusercontent.com/aaronpeikert/hu_ml/master/data/raw/oasis.csv"))
write_csv(oasis, here("data", "raw", "oasis.csv"))

#----wine----
wine_names <- c("class",
                "alcohol",
                "malic_acid",
                "ash",
                "alcalin_ash",
                "magnesium",
                "tot_phenols",
                "flav_phenols",
                "nonflav_phenols",
                "proanthocyanins",
                "color",
                "hue",
                "od280",
                "proline")
wine <- read_csv(url("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"),
                 col_names = wine_names)
write_csv(wine, here("data", "raw", "wine.csv"))

#----nature----
nature_zip <- tempfile()
nature_dir <- fs::path(tempdir(), "zip")
download.file("https://openpsychometrics.org/_rawdata/NR6-data-14Nov2018.zip",
              destfile = nature_zip)
unzip(nature_zip, exdir = nature_dir)
fs::file_copy(dir_ls(nature_dir, recurse = TRUE, glob = "*.csv"),
              here("data", "raw", "nature.csv"),
              overwrite = TRUE)

#----credit----
credit <- read_csv(url("https://gist.githubusercontent.com/Bart6114/8675941/raw/ac4cddcc0909c15ceada2d8c6a303206b10796d9/creditset.csv"))
write_csv(credit, here("data", "raw", "credit.csv"))

