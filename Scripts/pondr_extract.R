# Nathan W. Van Bibber
# 3/27/20
# 
# This is a script to extract data from a test file collected from PONDR
# <url link>


# Load packages
library(tidyverse)

# create a vector of file names in listed directory
files <- list.files("Data/pondr_text_Nathan/")
files


#### Loop through each file and do the following

pondr <- readLines(paste0("Data/pondr_text_Nathan/", files[14]))

## remove disorder segment lines:
# 1. make logical vector for: if line contains "Predicted disorder segment"
dis_seg <- grepl("Predicted disorder segment", pondr)

# 2. make new vector withough disorder segement lines
all_stats <- pondr[!dis_seg]


# isolate lines by each predictor
vlxt <- all_stats[2:4]
vl3 <- all_stats[6:8]
vsl2 <- all_stats[10:12]

# combine all predictors into single vect again (essentially removed head line)
preds <- c(vlxt, vl3, vsl2)


# create an empty vector for data
myresult <- NULL

# replace the first tab in every line with a ";" 
# split line in substrings using the ; just inserted
# extract number values form each substring and add to myresult vector
for (p in preds) {
    sl <- sub("\t", ";", p)
    z <- unlist(strsplit(sl, ";")) # srtsplit returns a list, but parse_number takes a vector
    m <- parse_number(z)
    myresult <- c(myresult, m)
}

## create column names
predictors <- c("VLXT", "VL3", "VSL2")
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

my_matrix <- rbind(matrix(myresult, byrow = TRUE, ncol = 18))
row.names(my_matrix) <- paste0(sub(".txt", "", files[14]))
colnames(my_matrix) <- varnames

myresult
my_matrix

# check if results matrix exists, if not make it, else add row to it
if (!exists("results")) {
    results <- my_matrix
} else {
    results <- rbind(results, my_matrix)
}

results
### END loop

df_result <- as.data.frame(results)
df_result <- df_result %>% 
    rownames_to_column(.data = .) %>% 
    mutate(df_result, protein = paste0(sub(".txt", "", files[14])))
df_result


write.csv(df_result, file = "Output/Q3BBV0_pondr.csv")
