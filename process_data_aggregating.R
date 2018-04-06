#data processing

#matsim average peak hour values
data = linksFcd2Matsim

temp_data = data

#expand by 1 / scaling factor
scaleFactor = 0.05
temp_data = temp_data %>% rowwise() %>%  mutate(v6 = v6 / scaleFactor)
temp_data = temp_data %>% rowwise() %>%  mutate(v7 = v7 / scaleFactor)
temp_data = temp_data %>% rowwise() %>%  mutate(v8 = v8 / scaleFactor)
temp_data = temp_data %>% rowwise() %>%  mutate(v9 = v9 / scaleFactor)



temp_data = temp_data %>%
  rowwise() %>% 
  mutate(v = v6 + v7 + v8 +v9)

temp_data = temp_data %>%
  rowwise() %>% 
  mutate(tt_avg = (tt6*v6+tt7*v7+tt8*v8+tt9*v9)/v)

temp_data = temp_data %>%
  rowwise() %>% 
  mutate(tt_min = min(tt6min,tt7min,tt8min,tt9min))

temp_data = temp_data %>%
  rowwise() %>% 
  mutate(tt_max = max(tt6max,tt7max,tt8max,tt9max))

#calculate the matsim speed at the matsim links

temp_data = temp_data %>% rowwise() %>% mutate(speed_min_matsim = LENGTH / tt_max * 3.6)
temp_data = temp_data %>% rowwise() %>% mutate(speed_avg_matsim = min(LENGTH / tt_avg * 3.6, FREESPEED*3.6, na.rm = T))
temp_data = temp_data %>% rowwise() %>% mutate(speed_max_matsim = LENGTH / tt_min * 3.6)


#aggregate all the matsim links that share the same osm link: 
temp_data = temp_data %>% 
  rowwise() %>%
  mutate(weight_temp = v * LENGTH)
temp_data = temp_data %>% 
  rowwise() %>% 
  mutate(weighted_sum_avg_speed = speed_avg_matsim* v * LENGTH)
temp_data = temp_data %>% 
  rowwise() %>% 
  mutate(weighted_sum_min_speed = speed_min_matsim* v * LENGTH)
temp_data = temp_data %>% 
  rowwise() %>% 
  mutate(weighted_sum_max_speed = speed_max_matsim* v * LENGTH)
temp_data = temp_data %>% 
  rowwise() %>% 
  mutate(weighted_sum__CAPACITY = CAPACITY* v * LENGTH)
temp_data = temp_data %>% 
  rowwise() %>% 
  mutate(weighted_sum__FREESPEED = FREESPEED* v * LENGTH)

temp_data$aux = 2
temp_data$aux[temp_data$inverseMatsimId == -1] = 1
temp_data = temp_data %>% rowwise() %>%  mutate(LENGTH = LENGTH / aux)

temp_data = temp_data %>% group_by(osmId) %>% summarize(weighted_sum_avg_speed = sum(weighted_sum_avg_speed),
                                                        weighted_sum_min_speed = sum(weighted_sum_min_speed),
                                                        weighted_sum_max_speed = sum(weighted_sum_max_speed),
                                              weighted_sum__CAPACITY = sum(weighted_sum__CAPACITY),
                                              weighted_sum__FREESPEED = sum(weighted_sum__FREESPEED),
                                              LENGTH = sum(LENGTH),
                                              weight_temp = sum(weight_temp),
                                              aux = mean(aux),
                                              count = n(),
                                              v= sum(v))

temp_data = temp_data %>% rowwise() %>% mutate(v = v/count*aux)

temp_data = temp_data %>% rowwise() %>% mutate(speed_avg_matsim = weighted_sum_avg_speed/weight_temp)
temp_data = temp_data %>% rowwise() %>% mutate(speed_min_matsim = weighted_sum_min_speed/weight_temp)
temp_data = temp_data %>% rowwise() %>% mutate(speed_max_matsim = weighted_sum_max_speed/weight_temp)
temp_data = temp_data %>% rowwise() %>% mutate(CAPACITY_osm_link = weighted_sum__CAPACITY/weight_temp)
temp_data = temp_data %>% rowwise() %>% mutate(FREESPEED_osm_link = weighted_sum__FREESPEED/weight_temp)

temp_data = temp_data %>% select(osmId, 
                                 speed_avg_matsim,
                                 speed_min_matsim,
                                 speed_max_matsim,
                                 CAPACITY_osm_link,
                                 FREESPEED_osm_link,
                                 LENGTH,
                                 v)

#aggreagate FCD data to osm Id, aggregate LENGTH

temp_data_from_fcd = data %>% group_by(osmId, fclass,avg_speed, number_veh) %>% summarize()

data = merge(temp_data, temp_data_from_fcd, by = "osmId")



rm(linksFcd2Matsim, scaleFactor, temp_data, temp_data_from_fcd)

#rename fcd speed
data = data %>% mutate(speed_avg_fcd = avg_speed)

data = data %>% mutate(time_fcd = LENGTH/speed_avg_fcd*3.6)
data = data %>% mutate(time_matsim = LENGTH/speed_avg_matsim*3.6)

data = data %>% rowwise() %>% mutate(vc_ratio = v/CAPACITY_osm_link/8)

data$road_type = "other"
data$road_type[data$fclass == "motorway"] = "motorway"
data$road_type[data$fclass == "primary"] = "arterial"
data$road_type[data$fclass == "secondary"] = "arterial"
data$road_type[data$fclass == "tertiary"] = "arterial"
data$road_type[data$fclass == "trunk"] = "arterial"

