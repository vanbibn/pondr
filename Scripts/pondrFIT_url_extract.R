# Nathan W. Van Bibber
# 2020-03-25
# 
# This is a script to extract data from a tempory URL containing to PONDR-FIT 
# data for a protein


# Load Packages
library(tidyverse)

my_urls <- read_csv("./Data/pondrfit-url.csv")

# create two empty columns for PONDR-FIT average and % disorder scores
my_urls <-  my_urls %>% 
    mutate(meanDisorder = NA, percentDisorder = NA, length = NA)



# Write a for loop to do them all iteratively #################################

for (u in 1:length(my_urls$url)) {
    # read data from temporary url for PONDR-FIT data
    # start reading from line 2 (skip first line)
    fit1 <- read_table2(my_urls$url[u], col_names = FALSE, skip = 1)
    
    # add column names and write out to text file
    colnames(fit1) <- c("position", "residue", "score", "error")
    write.csv(fit1, file = paste0("Output/",my_urls$UniprotID[u],"_pondrFIT.csv"))
    
    #calculate the mean disorder score
    my_urls$meanDisorder[u] <- mean(fit1$score)
    
    ## Percent disorder: count # resid score>0.5 and divid by total # residues
    ## Taking mean of a logical vector (ie. 1's and 0's) will give same result
    my_urls$percentDisorder[u] <- mean(fit1$score > 0.5)
    
    my_urls$length[u] <- length(fit1$score)
}


write.csv(my_urls, file = paste0("Output/", Sys.Date(), "_Nathan", 
                                 length(my_urls$url),"_pondrFIT-calc.csv"))
