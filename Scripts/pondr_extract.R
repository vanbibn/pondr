library(readr)

getwd()
list.files('Data')

pondr <- readLines("Data/Q3BBV0_3.txt")

# remove disorder segment lines
dis_seg <- grepl("Predicted disorder segment", pondr)
all_stat <- pondr[!dis_seg]

# isolate lines by each predictor
vlxt <- all_stat[2:4]
vl3 <- all_stat[6:8]
vsl2 <- all_stat[10:12]

preds <- c(vlxt, vl3, vsl2)
myresult <- NULL

for (p in preds) {
    sl <- sub("\t", ";", p)
    z <- unlist(strsplit(sl, ";"))
    m <- parse_number(z)
    myresult <- c(myresult, m)
}

dim(myresult) <- c(6,3)
colnames(myresult) <- c("vlxt", "vl3", "vsl2")
row.names(myresult) <- c(
    "residues",      # Predicted residues (total number)
    "dis_regions",   # Number Disordered Regions
    "dis_residues",  # Number residues disordered
    "longest",       # Longest Disordered Region
    "pct",           # Overall percent disordered
    "avg"            # Average Prediction Score
)

myresult

df_result <- as.data.frame(t(myresult))
df_result

write.csv(df_result, file = "Output/Q3BBV0_pondr.csv")
