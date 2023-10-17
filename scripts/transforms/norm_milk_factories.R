#! /usr/bin/env Rscript

library(magrittr)
library(stringr)

#  do.call(rgb, as.list(runif(3)))

normalize_id <- function(s) {
  s = str_replace_all(s, "\"", "")
  id = s %>%
    str_replace_all(" ", "_") %>%
    str_replace_all("[\"]", "")
  # sprintf("%s name:\"%s\"", id, s)
}

normalize_phone <- function(s) {
  s %>%
  str_replace("\\+7", "8") %>%
  str_replace_all("[ \"\\-()+]", "")
}

normalize_place <- function(s) {
  s %>%
  str_replace_all("\"", "") %>%
  str_replace_all(" \\(.*\\)", "")
}

content = readLines("~/projects/milk_industry_kgr/_generated/new_milk_factories.tree") %>%
          str_replace("^(\".+?\")(?= )", normalize_id) %>%
          str_replace("phone:\"(.*?)\"(?= )", normalize_phone) %>%
          str_replace("place:\".*?\"(?= )", normalize_place) %>%
          str_replace("fabr-url:.*$", "") %>%
          str_replace("/ ", " ") %>%
          str_replace("www.", "")
          # %>% print

writeLines(content, "~/projects/milk_industry_kgr/_generated/new_milk_factories_cleaned.tree")
