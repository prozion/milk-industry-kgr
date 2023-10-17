#! /usr/bin/env Rscript

library(stringr)
library(purrr)

# turn off annoying warnings:
options(warn = -1)

lines <- readLines(file("/home/denis/projects/milk_industry_kgr/source/facts/factories.tree"))

res <- lines %>%
       str_extract(regex("(?<=url:).*?(?>(\\s|$))")) %>%
       # .[!is.na(.)] %>%
       discard(is.na) %>%
       table() %>%
       .[.>1]

print(res)
