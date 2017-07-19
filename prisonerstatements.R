#Getting last statements of prisoners executed in texas from 1984 to Jan - 2017
#source http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html
#this script can be run again once more prisoners are executed to add new prisoners, 
#provided the website doesn'tchange their formula.
#This script was written for a macbook pro 15-inch 2010 running OSX 10.10.5, R version 3.3.2

version <- R.Version()
save(version,file = "Rversion")
prisonURL <- "http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html"
library(dplyr)#
library(rvest)
library(data.table)
library(ngram)
library(lubridate)

prison <- read_html(prisonURL)
#used the SelectorGadget extension in chrome to find the css selector
selector_name <- "td~ td+ td a"
#used the rvest package to get the links to the laststatements
statementLinks <-html_nodes(x = prison, css = selector_name) %>%
                        html_attr("href")
#it only gave the relative address so pasted the rest of the link in front
parent <- "https://www.tdcj.state.tx.us/death_row/"
statementLinks <- paste(parent, statementLinks,sep ="")

#we'll make a function to extract each statement from each webpage using rvest package
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

#Used the SelectorGadget extension in chrome to find out which css selectors to use
statementEl <- "p:nth-child(10), p:nth-child(11), p:nth-child(12)"
statements <- extractStatement(statementEl,statementLinks)

#if there's an error see which prisoner is generating the error
sink();543 - length(readLines("test"))

#create the table with the prisoner information
tablenames <- html_nodes(prison,css = "th")
tablenames <- gsub("<.*?>", "", tablenames)
theTable <- html_nodes(prison, css = "td")
theTable <- gsub("<.*?>", "", theTable)

executions <- as.data.table(t(matrix(theTable,ncol = 542))) 
names(executions) <- tablenames
##Add statements and clean up a bit
executions <- executions[,-c(2:3)][,lastStatement := statements]
executions <- executions[,Execution := as.integer(Execution)]
setkey(executions, Execution)
executions <- executions[,Race := gsub(" ", "", Race)]
executions <- executions[,Date := mdy(Date)]
executions <- executions[,Age := as.integer(gsub(" ", "", Age))]
#it looks like instead of going to 1000 when they got to 999, they started using 999001,999002,
#etc. replacing 999 prefixes with "1" makes for a better grpahing experience.
executions <- executions[,newTDCJ := as.integer(gsub("999", "1", `TDCJ Number`))]
#oops turned TDCJ Number 999 to 1, better change it back.
executions <- executions[,newTDCJ := as.integer(gsub("^1$", "999", newTDCJ))]
executions <- executions[,County := gsub("^ | $", "", County)]

#make sure all of the counties are actually counties of texas and correctly spelled
#check against wikipedia for consistency at least
wikiCountiesPage <- "https://en.wikipedia.org/wiki/List_of_counties_in_Texas#List"
countiesSelector <- "td:nth-child(1) a" #SelectorGadget strikes again
countiesListWiki <- read_html(wikiCountiesPage) %>% html_nodes(countiesSelector) %>%
                        html_text()
countiesListWiki <- countiesListWiki[256:length(countiesListWiki)]
countiesListWiki <- gsub(" County", "", countiesListWiki)
all(executions$County %in% countiesListWiki)
#looks ok!

#export the file now as csv for others to use if they like
fwrite(executions,file = "TexasDeathRowLastStatements.csv")
#does it come back in ok?
test <- fread("TexasDeathRowLastStatements.csv")[,Date:=ymd(Date)]
str(test)
