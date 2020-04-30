# See the Webscraping in R pdf from the Tampa UseRs group
# I cloned this 

# RSelenium begins around slide 92

library(RSelenium)

# automatically download and install Selenium executiable engine
rd <- RSelenium::rsDriver(port = 4444L, browser = "chrome")
remDR <- rd[["client"]]


