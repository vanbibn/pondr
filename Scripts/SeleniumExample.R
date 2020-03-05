# This example is from 2014 and is therefore dated information but you can see
# the basic ideas: https://www.r-bloggers.com/scraping-with-selenium/


## Start Selenium
library('RSelenium')
checkForServer() # search for and download Selenium Server java binary.  Only need to run once.
startServer() # run Selenium Server binary
remDr <- remoteDriver(browserName="firefox", port=4444) # instantiate remote driver to connect to Selenium Server
remDr$open(silent=T) # open web browser


# Start scraping
library('XML')
master <- c()
n <- 5 # number of pages to scrape.  80 pages in total.  I just scraped 5 pages for this example.
for(i in 1:n) {
    site <- paste0("https://www.fidelity.com/fund-screener/evaluator.shtml#!&ntf=N&ft=BAL_all&msrV=advanced&sortBy=FUND_MST_MSTAR_CTGY_NM&pgNo=",i) # create URL for each page to scrape
    remDr$navigate(site) # navigates to webpage
    
    elem <- remDr$findElement(using="id", value="tbody") # get big table in text string
    elem$highlightElement() # just for interactive use in browser.  not necessary.
    elemtxt <- elem$getElementAttribute("outerHTML")[[1]] # gets us the HTML
    elemxml <- htmlTreeParse(elemtxt, useInternalNodes=T) # parse string into HTML tree to allow for querying with XPath
    fundList <- unlist(xpathApply(elemxml, '//input[@title]', xmlGetAttr, 'title')) # parses out just the fund name and ticker using XPath
    master <- c(master, fundList) # append fund lists from each page together
}

head(master)