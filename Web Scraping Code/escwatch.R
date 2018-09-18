#Code Reference: https://stackoverflow.com/questions/49702680/web-scraping-in-r-i-am-not-able-to-get-the-csv-file-in-proper-table-format-in-r

library(rvest)
library(dplyr)
table <- list()
for(i in 1:42){
  url = paste0("https://esc.watch/games?page=",i)
  webpage = read_html(url)
  table[[i]] <- as.data.frame(html_table(html_nodes(webpage, "table"))) 
  cat("page ",i, " complete", "\n")
}
table2 <- bind_rows(table)

for(i in 1:dim(table2)[2]){
  
}

write.csv(table2, "escwatch1.csv")
