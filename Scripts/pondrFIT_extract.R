# This was my first attempt at writting the script to extract data from 
# PONDR-FIT (http://original.disprot.org/pondr-fit.php)

# load packages
library(readr)
library(stringr)



## test first with one url
# read data from temporary url for PONDR-FIT data
# start reading from line 2 (skip first line)
fit1 <- read_table2(my_urls$url[1], col_names = FALSE, skip = 1)

# add column names and write out to text file
colnames(fit1) <- c("position", "residue", "score", "error")
write.csv(fit1, file = paste0("Output/",my_urls$UniprotID[1],"_pondrFIT.csv"))

#calculate the mean disorder score
meanDis <- mean(fit1$score)

## Percent disorder: count num resid score >0.5 and divid by total num residues
## Taking the mean of a logical vector (ie. 1's and 0's) will give same result
# total <- length(fit1$score)
# numDis <- sum(fit1$score > 0.5)
# percDisorder <- numDis/total
percDisorder2 <- mean(fit1$score > 0.5)



## Old stuff from first try =================================================

# paste in temporary url fro PONDR-FIT data
u <- url("http://original.disprot.org/temp/1585181708.562184.pondrfit")

# Create a data frame start reading from line 2 (skip first line)
fit1 <- read_table2(u, col_names = FALSE, skip = 1)
close(u)

# add column names and write out to text file
colnames(fit1) <- c("position", "residue", "score", "error")
write.csv(fit1, file = "Output/test_pondrFIT.csv")

# new function to calculate mean and % disorder scores
# pfit <- function(directory, ...) {
    # create an empty data frame with 3 named columns 
    fit_df <- data.frame(matrix(ncol = 3, nrow = 0))
    colnames(fit_df) <- c("uniprotID","meanDisorder","percentDisorder")
    
    #begin for loop here
    # for (file in folder) {
        # open csv file
        df <- read.csv("Output/test_pondrFIT.csv")
        
        # extract uniprot ID form file name and save to a variable
        uniprotID <- "test"
        
        #calculate the mean disorder score
        meanDisorder <- mean(df$score)
        
        # Percent disorder: count num resid score >0.5 and divid by total num residues
        total <- length(df$score)
        numDis <- sum(df$score > 0.5)
        percDisorder <- numDis/total
        
        # concatinate these values to growing matrix
        fit_df <- rbind(fit_df,data.frame(uniprotID, meanDisorder, percDisorder))
    }
    
    round(fit_df$meanDisorder, digits = 3)
    round(fit_df$percentDisorder, digits = 3)
    fit_df
}

