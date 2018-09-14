pacman::p_load(data.table, dplyr,ggplot2, reshape2)

setwd("C:/Users/carlloga/LRZ Sync+Share/matsim_ADAC")

source("r_script/load_data.R")
#source("r_script/process_data.R")
# printableData = data %>% select (LINK, fclass, road_type, speed_avg_fcd, speed_avg_matsim, speed_error)
# write.csv(printableData,"C:/Users/carlloga/LRZ Sync+Share/matsim_ADAC/comparison.csv",row.names = F)
# rm(printableData)

source("r_script/process_data_aggregating.R")

printableData = data %>% select (osmId, fclass, road_type, speed_avg_fcd, speed_avg_matsim, speed_error)
write.csv(printableData,"C:/Users/carlloga/LRZ Sync+Share/matsim_ADAC/comparisonOsmBased.csv",row.names = F)
rm(printableData)

source("r_script/analyze.data.R")

