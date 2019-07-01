#!/usr/bin/Rscript --vanilla
if(!require("pacman"))install.packages("pacman")
pacman::p_load("here", "rmarkdown", "git2r")

#----build---
rmarkdown::render_site(here())

#----commit---
add(here(), here("docs"))
commit(here(), "update site")
# push() # doesn't work with ssh
