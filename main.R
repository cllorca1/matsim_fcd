pacman::p_load(data.table, dplyr,ggplot2)

setwd("C:/Users/carlloga/LRZ Sync+Share/matsim_ADAC")

source("r_script/load_data.R")
source("r_script/process_data.R")

#write.csv(data,"C:/Users/carlloga/LRZ Sync+Share/matsim_ADAC/comparison.csv",row.names = F)

source("r_script/analyze.data.R")
