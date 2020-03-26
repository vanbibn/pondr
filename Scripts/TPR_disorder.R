library(readr)
library(readxl)
library(dplyr)
library(stringr)

mydf <- read_xlsx(path = "./Data/TPR_disorder_data.xlsx")

names(mydf) <- names(mydf) %>%
    gsub(pattern = " ", replacement = "_", x = .) %>%
    gsub(pattern = "-", replacement = "_", x = .) %>%
    gsub(pattern = "\\.", replacement = "_", x = .)

names(mydf)

pondrFIT_means <- mydf %>%
    select(UniProt_ID,Disease_Associated:pondr_FIT_avg) %>%
    group_by(Disease_Associated, Mutagenesis) %>%
    print
sapply(pondrFIT_means$pondr_FIT_avg, mean)    

pondrFIT_means <- pondrFIT_means %>%
    group_by(Disease_Associated) %>%
    mutate(average_by_disease = mean(pondr_FIT_avg)) %>%
    print

unique(pondrFIT_means$average_by_disease)

filter(pondrFIT_means, pondrFIT_means$average_by_disease > 0.32)
