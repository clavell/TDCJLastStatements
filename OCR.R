#OCR on prisoner information jpg files
#source http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html

#can try to get prisoner information, but mostly stored as photos
#first get the link addresses
prisonURL <- "http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html"
prison <- read_html(prisonURL)
offenderInfo <- "td:nth-child(2) a"
offenderInfoLinks <-html_nodes(x = prison, css = offenderInfo) %>%
        html_attr("href")
parent <- "https://www.tdcj.state.tx.us/death_row/"
offenderInfoLinks <- paste(parent,offenderInfoLinks,sep = "")
#use the tesseract package to do some ocr
download.file(offenderInfoLinks[1],destfile = "bigbyjames.jpg")

library(tesseract)
library(abbyyR)
offenderInfoLinks[1:10]
ocr(offenderInfoLinks[1])
processRemoteImage(offenderInfoLinks[1])

#here's the dataset scraped from the source 
#http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html
executions <- fread("TexasDeathRowLastStatements.csv")[,Date:=lubridate::ymd(Date)]
