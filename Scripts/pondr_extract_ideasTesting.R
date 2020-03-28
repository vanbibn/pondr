# Nathan W. Van Bibber
# 3/27/20
# 
# This is a script to extract data from a test file collected from PONDR
# <url link>

# load packages
library(tidyverse)

dirs <- list.dirs('Data')
dirs

files <- list.files("Data/pondr_text_Nathan/")
files

pondr <- readLines(paste0("Data/pondr_text_Nathan/", files[14]))

pondr %>% 
    str_detect("Predicted disorder segment", negate = TRUE) %>% 
    filter(as_tibble(pondr), .) 



for (f in 1:length(files)) {
    print(files[f])
}

