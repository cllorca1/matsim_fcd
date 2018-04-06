#calculate errors
data$speed_error = data$speed_avg_fcd - data$speed_avg_matsim
data$speed_error_min = data$speed_avg_fcd - data$speed_min_matsim
data$speed_error_max = data$speed_avg_fcd - data$speed_max_matsim
data$time_error = data$time_fcd - data$time_matsim

data$speed_sq_error = data$speed_error^2
data$time_sq_error = data$time_error^2

ggplot(data, aes(x=speed_error)) + stat_density()
ggplot(data, aes(x=speed_error_min)) + stat_density()  
ggplot(data, aes(x=speed_error_max)) + stat_density() 

ggplot(data, aes(x= LENGTH,  y=abs(speed_error))) + geom_point()
ggplot(data, aes(x=speed_error/speed_avg_fcd)) + stat_density() + xlim(-5,5)
