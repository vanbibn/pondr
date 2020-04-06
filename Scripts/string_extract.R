# Nathan W. Van Bibber
# 2020-04-04
# 
# This is a script to extract data from sheets for an Excel file containing 
# protein-protein interaction data from the STRING database.  Data were copied 
# at medium (0.4), high (0.7), and highest (0.9) confidence for each protien, 
# and pasted into Sheet1, Sheet2, Sheet3 respectuflly.


# Load Packages
library(readxl)

# create vector of even numbers between 2 and 12
evens <- seq(from = 2, to = 12, by = 2)

# create column names
## first make individual vectors
confidence <- c("0.4", "0.7", "0.9")
names <- c(
    "num_nodes",
    "num_edges",
    "avg_node_degree",
    "avg_local_clustering_coef",
    "expected_num_edges",
    "PPI_enrichment_p-value")

## combine each value of confidence and names with "." between them
varnames <- as.vector(outer(names, confidence, paste, sep = "."))


# create a vector of file names in listed directory
direct <- "Data/string/"
files <- list.files(direct)

## for each file in folder 
for (f in seq_along(files)) {
    
    # read data from sheet1-3
    sheet1 <- read_xlsx(paste0(direct, files[f]), sheet = "Sheet1", col_names = "mix")
    sheet2 <- read_xlsx(paste0(direct, files[f]), sheet = "Sheet2", col_names = "mix")
    sheet3 <- read_xlsx(paste0(direct, files[f]), sheet = "Sheet3", col_names = "mix")
    
    # extract data for columns from even cells of each sheet
    m1 <- matrix(as.numeric(sheet1$mix[evens]), nrow = 1, ncol = 6, byrow = TRUE)
    m2 <- matrix(as.numeric(sheet2$mix[evens]), nrow = 1, ncol = 6, byrow = TRUE)
    m3 <- matrix(as.numeric(sheet3$mix[evens]), nrow = 1, ncol = 6, byrow = TRUE)
    
    # combine into one matrix with one row per protein
    my_matrix <- cbind(m1,m2,m3)
    row.names(my_matrix) <- toupper(paste0(sub("_string.xlsx", "",  files[f])))
    colnames(my_matrix) <- varnames
    
    # compile all proteins into one matrix
    ## check if results matrix exists, if not make it, else add row to it
    if (!exists("results")) {
        results <- my_matrix
    } else {
        results <- rbind(results, my_matrix)
    }
    
}
# End loop

results

# write results matrix to csv

write.csv(results, file = "Output/String.csv")
