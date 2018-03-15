#analyze data

ggplot(data, aes(x=LENGTH)) +
  geom_histogram()

ggplot(data, aes(x=speed_avg_fcd, y=speed_avg_matsim, alpha = number_veh)) +
  geom_point(size  = 1) + 
  scale_alpha_continuous(range = c(0.1,0.25)) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  facet_wrap(~fclass, nrow = 3)


data = data %>% mutate(vc_ratio = v/4/CAPACITY)

subset = data %>% filter(vc_ratio > 0.75)

ggplot(subset, aes(x=speed_avg_fcd, y=speed_avg_matsim, alpha = number_veh)) +
  geom_point(size  = 1) + 
  #scale_alpha_continuous(range = c(0.1,0.25)) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  facet_wrap(~fclass, nrow = 2)

subset = data %>% filter(oneway == "F")

ggplot(subset, aes(x=speed_avg_fcd, y=speed_avg_matsim, alpha = number_veh)) +
  geom_point(size  = 1) + 
  #scale_alpha_continuous(range = c(0.1,0.25)) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  facet_wrap(~fclass, nrow = 3)


