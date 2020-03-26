# Nathan Van Bibber
# 3/26/2020
# 
# Exercise for today's lecture by Dr. Blanck


# Load packages
library(tidyverse)

# read data
mylgg <- read_csv("Data/LGG_data.csv")

# transform type into a factor variable
mylgg <- mutate(mylgg, type = factor(type))


expression_summary <- mylgg %>% 
    select(-c(1:2,type)) %>% 
    sapply(summary)

# visualize summaries with boxplots comparing btw complementary and non-comp
boxplot(mylgg$TP53 ~ mylgg$type)
boxplot(mylgg$CDKN2A ~ mylgg$type)
boxplot(mylgg$MDM2 ~ mylgg$type)
boxplot(mylgg$MDM4 ~ mylgg$type)


## MDM2 looks promising!