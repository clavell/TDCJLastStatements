# TDCJLastStatements
This is an R project to scrape the last statements of death row inmates from the Texas department of criminal justice website with the intention of doing sentiment analysis and other NLP. Another goal is to process the prisoner information sheets, which are provided as jpg files using OCR. This data will be put into a CSV file for those who wish to use it.
source: http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html
The rvest package along with the SelectorGadget extension in google chrome were used to find the right elements to extract from the webpage(s). 
OCR has been attempted so far with the tesseract and abbyyR packages in R as well as an OCR website. So far it has been unsuccessful in extracting the prisoner information from the jpgs provided. (See second column on source webpage for links)
