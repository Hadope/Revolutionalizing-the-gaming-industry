Code Reference: https://www.r-bloggers.com/using-rvest-to-scrape-an-html-table/

library(readxl) 
library(rvest) 
library(xml2)

url <- "https://newzoo.com/insights/rankings/top-100-countries-by-game-revenues/"
pg <- read_html(url) 
tb <- html_table(pg, fill = TRUE)
tb -> esport
write.csv(esport,"newzoo.csv")
