#calculate errors
data$speed_error = data$speed_avg_fcd - data$speed_avg_matsim
data$time_error = data$time_fcd - data$time_matsim

data$speed_sq_error = data$speed_error^2
data$time_sq_error = data$time_error^2

data %>% 
  filter(speed_avg_fcd != 0) %>%
  group_by(fclass) %>% 
  summarize(count = n(), fcd_vehicles = sum(number_veh), matsim_volume = sum(v),
            speed_rmse = sqrt(mean(speed_sq_error)), speed_avg_fcd = mean(speed_avg_fcd),
            time_rmse = sqrt(mean(time_sq_error)), time_fcd = mean(time_fcd))
  
summary(data)

#congested links
data %>% 
  filter(speed_avg_fcd != 0, vc_ratio > 0.5) %>%
  group_by(fclass) %>% 
  summarize(count = n(), fcd_vehicles = sum(number_veh), matsim_volume = sum(v),
            speed_rmse = sqrt(mean(speed_sq_error)), speed_avg_fcd = mean(speed_avg_fcd),
            time_rmse = sqrt(mean(time_sq_error)), time_fcd = mean(time_fcd))


#long links
data %>% 
  filter(speed_avg_fcd != 0, LENGTH > 500) %>%
  group_by(fclass) %>% 
  summarize(count = n(), fcd_vehicles = sum(number_veh), matsim_volume = sum(v),
            speed_rmse = sqrt(mean(speed_sq_error)), speed_avg_fcd = mean(speed_avg_fcd),
            time_rmse = sqrt(mean(time_sq_error)), time_fcd = mean(time_fcd))
