#Code Reference: https://www.r-bloggers.com/using-rvest-to-scrape-an-html-table/

library(readxl) 
library(rvest) 
library(xml2)

url <- "https://www.esportsearnings.com/tournaments/largest-overall-prize-pools-x400"
pg <- read_html(url) 
tb <- html_table(pg, fill = TRUE)
tb -> esport
write.csv(esport,"esport_tournament4.csv")