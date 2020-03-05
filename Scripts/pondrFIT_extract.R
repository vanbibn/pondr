# 
library(readr)
library(stringr)

# paste in temporary url fro PONDR-FIT data
u <- url("http://original.disprot.org/temp/1582230290.859100.pondrfit")

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

