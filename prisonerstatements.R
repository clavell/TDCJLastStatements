prisonURL <- "http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html"
library(dplyr)
library(rvest)
library(data.table)
library(ngram)
library(lubridate)
library(ggplot2)
library(plotly)
prison <- read_html(prisonURL)
#used the SelectorGadget extension in chrome to find the css selector
selector_name <- "td~ td+ td a"
#used the rvest package to get the links to the laststatements
statementLinks <-html_nodes(x = prison, css = selector_name) %>%
                        html_attr("href")
#it only gave the relative address so pasted the rest of the link in front
parent <- "https://www.tdcj.state.tx.us/death_row/"
statementLinks <- paste(parent, statementLinks,sep ="")
#according to the SelectorGadget extension the actual text seems to be given by 
#this paragraph in most cases. Some have 2 paragraphs, so this is included
#we'll make a function to extract the actual statement from each webpage using rvest package
extractStatement <- function(element,links){
        sink("test")
        statements <- character()
        for(i in seq_along(links)){
                if(grepl("no_last",links[i])){
                        statements[i] <- NA
                } else{
                statements[i] <- read_html(links[i]) %>% html_nodes(element) %>%
                        html_text() %>% concatenate()
                
                }
                print(i)
        }
        sink()
        statements
}
#here i'm testing rprof
Rprof()
badboytest <- extractStatement(statementEl,statementLinks[1:6])
Rprof(NULL)
summaryRprof()$by.self
#testing system.time
system.time(badboytest <- extractStatement(statementEl,statementLinks[1:6]))

statementEl <- "p:nth-child(10), p:nth-child(11)"
badboytalk <- extractStatement(statementEl,statementLinks)
#not all of statement recorded in some cases
statementEl2 <- "p:nth-child(10), p:nth-child(11), p:nth-child(12)"
badboytalk2 <- extractStatement(statementEl2,statementLinks)

#if there's an error see which prisoner is generating the error
sink();543 - length(readLines("test"))
murderers$lastStatement

#can try to get prisoner information, but mostly stored as photos
#first get the link addresses
offenderInfo <- "td:nth-child(2) a"
offenderInfoLinks <-html_nodes(x = prison, css = offenderInfo) %>%
        html_attr("href")
offenderInfoLinks <- paste(parent,offenderInfoLinks,sep = "")
#use the tesseract package to do some ocr
install.packages("tesseract")
library(tesseract)
library(abbyyR)
offenderInfoLinks[1:10]
ocr(offenderInfoLinks[1])
processRemoteImage(offenderInfoLinks[1])
download.file(offenderInfoLinks[1],destfile = "bigbyjames.jpg")
#create the table with the prisoner information
tablenames <- html_nodes(prison,css = "th")
tablenames <- gsub("<.*?>", "", tablenames)
theTable <- html_nodes(prison, css = "td")
theTable <- gsub("<.*?>", "", theTable)

murderers <- as.data.table(t(matrix(theTable,ncol = 542))) 
names(murderers) <- tablenames
murderers <- murderers[,-c(2:3)][,lastStatement := badboytalk2]
murderers <- murderers[,Execution := as.integer(Execution)]
setkey(murderers, Execution)
murderers <- murderers[,Race := gsub(" ", "", Race)]
murderers <- murderers[,Date := mdy(Date)]
murderers <- murderers[,Age := as.integer(gsub(" ", "", Age))]
murderers <- murderers[,newTDCJ := as.integer(gsub("999", "1", `TDCJ Number`))]
murderers <- murderers[,newTDCJ := as.integer(gsub("^1$", "999", newTDCJ))]
murderers <- murderers[,County := gsub("^ | $", "", County)]

#make sure all of the counties are actually counties of texas and correctly spelled
#check against wikipedia for consistency at least
wikiCountiesPage <- "https://en.wikipedia.org/wiki/List_of_counties_in_Texas#List"
countiesSelector <- "td:nth-child(1) a" 
countiesListWiki <- read_html(wikiCountiesPage) %>% html_nodes(countiesSelector) %>%
                        html_text()
countiesListWiki <- countiesListWiki[256:length(countiesListWiki)]
countiesListWiki <- gsub(" County", "", countiesListWiki)
all(murderers$County %in% countiesListWiki)

fwrite(murderers,file = "TexasDeathRowLastStatements.csv")
test <- fread("TexasDeathRowLastStatements.csv")[,Date:=ymd(Date)]
murderers[510]

setkey(murderers,County,`Last Name`)
#Do some exploratory analysis
g <- ggplot(data = murderers)
g + geom_histogram(aes(x=Date,colour = Age))
g + geom_boxplot(aes(x=Race,y=Age,colour=Race),alpha=.02)
h <- g + geom_point(aes(x=Date,y=Race,colour=Race),alpha=.8)
g + geom_point(aes(x=newTDCJ,y=Date,colour=Race),alpha=.8)
gh <- g + geom_point(aes(y=Execution,x=Date,colour = Race),alpha = .5) + 
        facet_grid(Race~.) + 
        coord_cartesian(xlim = c(ymd("2000-10-12"),ymd("2002-10-12")))
ggplotly(gh)
murderers[,unique(Date)]


#what's wrong
jamesBigby <- read_html(statementLinks[3])
(current <- jamesBigby %>% html_nodes(statementEl) %>% html_text())
concatenate(current)
grepl("no_last",statementLinks[77])

text2 <- ocr("http://jeroenooms.github.io/files/dog_hq.png")
cat(text2)
