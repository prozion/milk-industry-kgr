#! /usr/bin/env Rscript

library(wdman)
library(RSelenium)
library(magrittr)

get_parameter_by_xpath <- function(driver, section, title, href = FALSE) {
  plain_text_path <- sprintf("//div[@class='title-site--h2'][text()='%s']/following-sibling::div//div[text()='%s']/following-sibling::div", section, title)
  href_text_path <- sprintf("//div[@class='title-site--h2'][text()='%s']/following-sibling::div//div[text()='%s']/following-sibling::div//a", section, title)
  xpath <- ifelse(href, href_text_path, plain_text_path)
  result <- tryCatch({
    element <- driver$findElement(using = "xpath", xpath)
    element$getElementText()
  },
  error = function(e) {
    # message(sprintf("Error for %s: %s", driver$getCurrentUrl(), e))
    return("")
  })
  return(result)
}

get_company_info = function(driver, url) {
  print(sprintf("SCRAP %s", url))
  driver$setImplicitWaitTimeout(3000)
  driver$navigate(url)
  name <- driver$getTitle(url)
  place <- get_parameter_by_xpath(driver, 'Контакты', 'Населенный пункт')
  phone <- get_parameter_by_xpath(driver, 'Контакты', 'Телефон', TRUE)
  email <- get_parameter_by_xpath(driver, 'Контакты', 'Электронная почта', TRUE)
  url <- get_parameter_by_xpath(driver, 'Контакты', 'Веб-сайт', TRUE)
  w <- get_parameter_by_xpath(driver, 'Реквизиты', 'Количество сотрудников')
  return(list(id = name, place = place, phone = phone, email = email, url = url, w = w))
}

factory_tabtree_line = function(pars, fabr_url) {
  place <- ifelse(pars$place == "", "", sprintf(" place:\"%s\"", pars$place))
  phone <- ifelse(pars$phone == "", "", sprintf(" phone:\"%s\"", pars$phone))
  email <- ifelse(pars$email == "", "", sprintf(" email:%s", pars$email))
  url <- ifelse(pars$url == "", "", sprintf(" url:%s", pars$url))
  w <- ifelse(pars$w == "", "", sprintf(" w:%s", pars$w))
  id <- sprintf("\"%s\"", pars$id)
  fabr_url <- sprintf(" fabr-url:%s", fabr_url)
  res <- paste0(id, place, phone, email, url, w, fabr_url)
}

URLS_FILE <- "~/temp/fabricator/milk_urls.txt"
TABTREE_FILE <- "~/temp/fabricator/new_milk_factories.tree"

cl <- chrome(port=3006L, version="117.0.5938.132", verbose=FALSE)
driver <- remoteDriver(
      browserName="chrome",
      extraCapabilities = list(chromeOptions = list(args = list('--headless'))),
      port = 3006L
    )
driver$open(silent=TRUE)

urls <- readLines(URLS_FILE)

for(i in 1:length(urls)) {
  fp <- file(TABTREE_FILE, "a")
  driver %>% get_company_info(urls[i]) %>% factory_tabtree_line(urls[i]) %>% writeLines(fp)
}
