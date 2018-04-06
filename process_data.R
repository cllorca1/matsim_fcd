#data processing

#matsim average peak hour values
data = linksFcd2Matsim

#expand by 1 / scaling factor
scaleFactor = 0.05
data = data %>% rowwise() %>%  mutate(v6 = v6 / scaleFactor)
data = data %>% rowwise() %>%  mutate(v7 = v7 / scaleFactor)
data = data %>% rowwise() %>%  mutate(v8 = v8 / scaleFactor)
data = data %>% rowwise() %>%  mutate(v9 = v9 / scaleFactor)


data = data %>%
  rowwise() %>% 
  #mutate(v = v6 + v7 + v8 +v9)
  mutate(v = v7)
data = data %>%
  rowwise() %>% 
  #mutate(tt_avg = (tt6*v6+tt7*v7+tt8*v8+tt9*v9)/v)
  mutate(tt_avg = tt7)
data = data %>%
  rowwise() %>% 
  mutate(tt_min = min(tt6min,tt7min,tt8min,tt9min))
data = data %>%
  rowwise() %>% 
  mutate(tt_max = max(tt6max,tt7max,tt8max,tt9max))

data = data %>% rowwise() %>% mutate(speed_min_matsim = LENGTH / tt_max * 3.6)
data = data %>% rowwise() %>% mutate(speed_avg_matsim = min(LENGTH / tt_avg * 3.6, FREESPEED*3.6, na.rm = T))
data = data %>% rowwise() %>% mutate(speed_max_matsim = LENGTH / tt_min * 3.6)

rm(linksFcd2Matsim, scaleFactor)

#rename fcd speed
data = data %>% mutate(speed_avg_fcd = avg_speed)

data = data %>% mutate(time_fcd = LENGTH/speed_avg_fcd*3.6)
data = data %>% mutate(time_matsim = LENGTH/speed_avg_matsim*3.6)
data = data %>% mutate(vc_ratio = v/CAPACITY)
#data = data %>% mutate(vc_ratio = v/4/CAPACITY)


data$road_type = "other"
data$road_type[data$fclass == "motorway"] = "motorway"
data$road_type[data$fclass == "primary"] = "arterial"
data$road_type[data$fclass == "secondary"] = "arterial"
data$road_type[data$fclass == "tertiary"] = "arterial"
data$road_type[data$fclass == "trunk"] = "arterial"

