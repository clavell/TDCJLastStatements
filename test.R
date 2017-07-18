#ithica example to figure out how to read in the data
library(dplyr)
library(rvest)
library(ggmap)
library(leaflet)
library(RColorBrewer)
url<-read_html("http://www.visitithaca.com/attractions/wineries.html")


movie <- read_html("http://www.imdb.com/title/tt1490017/")
cast <- html_nodes(movie, "#titleCast span.itemprop")
html_text(cast)
html_name(cast)
html_attrs(cast)
html_attr(cast, "class")
