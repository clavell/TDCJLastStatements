#Exploratory Analysis
executions <- fread("TexasDeathRowLastStatements.csv")[,Date:=lubridate::ymd(Date)]
library(ggplot2)
library(plotly)
library(data.table)

#Do some exploratory analysis
g <- ggplot(data = executions)
g + geom_histogram(aes(x=Date,colour = Age))
g + geom_boxplot(aes(x=Race,y=Age,colour=Race),alpha=.02)
h <- g + geom_point(aes(x=Date,y=Race,colour=Race),alpha=.8)
g + geom_point(aes(x=newTDCJ,y=Date,colour=Race),alpha=.8)
gh <- g + geom_point(aes(y=Execution,x=Date,colour = Race),alpha = .5) + 
        facet_grid(Race~.) + 
        coord_cartesian(xlim = c(ymd("2000-10-12"),ymd("2002-10-12")))
ggplotly(gh)




#what's wrong (code for trying out ideas before putitng into functions)
jamesBigby <- read_html(statementLinks[3])
(current <- jamesBigby %>% html_nodes(statementEl) %>% html_text())
concatenate(current)
grepl("no_last",statementLinks[77])

text2 <- ocr("http://jeroenooms.github.io/files/dog_hq.png")
cat(text2)
