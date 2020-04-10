# Nathan W. Van Bibber
# 4/10/20
# 
# This is a script to extract data from a test file collected from PONDR
# <url link>
# These files are missing data for the VL3 predictor.


# Load packages
# library(readr)  # added readr:: to the only function called from package.

## create column names
# make vectors for predictors and variables
predictors <- c("VLXT", "VSL2")
varbs <- c(
    "resid",      # Predicted residues (total number)
    "dis_rgns",   # Number Disordered Regions
    "n_dis",      # Number residues disordered
    "lg_rgn",     # Longest Disordered Region
    "pct",        # Overall percent disordered
    "avg"         # Average Prediction Score
)
# combine each value of predictors and varbs with "." between them
varnames <- as.vector(outer(varbs, predictors, paste, sep = "."))

# create a vector of file names in listed directory
directory <- "Data/pondr_text_withoutVL3/"
files <- list.files(directory)
files


#### Loop through each file and do the following
for (f in 1:length(files)) {
    pondr <- readLines(paste0(directory, files[f]))
    
    ## remove disorder segment lines:
    # 1. make logical vector for: if line contains "Predicted disorder segment"
    dis_seg <- grepl("Predicted disorder segment", pondr)
    
    # 2. make new vector withough disorder segement lines
    all_stats <- pondr[!dis_seg]
    
    
    # isolate lines by each predictor
    vlxt <- all_stats[2:4]
    vsl2 <- all_stats[6:8]
    
    
    # combine all predictors into single vect again (essentially removed head line)
    preds <- c(vlxt, vsl2)
    
    
    # create an empty vector for data
    myresult <- NULL
    
    # replace the first tab in every line with a ";" 
    # split line in substrings using the ; just inserted
    # extract number values form each substring and add to myresult vector
    for (p in preds) {
        sl <- sub("\t", ";", p)
        z <- unlist(strsplit(sl, ";")) # srtsplit returns a list, but parse_number takes a vector
        m <- readr::parse_number(z)
        myresult <- c(myresult, m)
    }
    
    # convert myresults vector into a matrix
    my_matrix <- rbind(matrix(myresult, byrow = TRUE, ncol = 12))
    row.names(my_matrix) <- paste0(sub(".txt", "", files[f]))
    colnames(my_matrix) <- varnames
    
    
    # check if results matrix exists, if not make it, else add row to it
    if (!exists("results")) {
        results <- my_matrix
    } else {
        results <- rbind(results, my_matrix)
    }
    
}
results
### END loop


write.csv(results, file = "Output/pondr_withoutVL3.csv")
