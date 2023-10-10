#! /usr/bin/env Rscript

library(wdman)
library(RSelenium)
library(magrittr)

get_factories_urls <- function(driver, pagenumber) {
  urls = c()
  list_url <- sprintf("https://fabricators.ru/zavody?product=21925&page=%s", pagenumber-1)
  driver$navigate(list_url)
  elements <- driver$findElements(using = "xpath", "//a[@class='title-site--h3']")
  # print(elements[[2]]$getElementAttribute("href"))
  for (i in 1:length(elements)) {
    urls[i] <- tryCatch({
      as.character(elements[[i]]$getElementAttribute("href"))
    }, error = function(e) {
      return("")
    })
  }
  urls
  # urls$getElementAttribute("href")
}

URLS_FILE <- "~/temp/fabricator/milk_urls.txt"

cl <- chrome(port=3006L, version="117.0.5938.132", verbose=FALSE)
driver <- remoteDriver(
      browserName="chrome",
      extraCapabilities = list(chromeOptions = list(args = list('--headless'))),
      port = 3006L
    )
driver$open(silent=TRUE)

add_urls <- function(page_numbers) {
  all_urls <- c()
  f <- file(URLS_FILE, "a")
  for(i in page_numbers) {
      # f <- file(sprintf("%s_%s", URLS_FILE, i))
      ith_urls <- get_factories_urls(driver, i)
      writeLines(ith_urls, f)
  }
}

unique_urls <- function() {
  f <- file(URLS_FILE, "r+w")
  urls <- readLines(f)
  writeLines(unique(urls), f)
}

# final page: 310

add_urls(1:32)
# unique_urls()
