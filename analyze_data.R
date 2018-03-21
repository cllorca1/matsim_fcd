#analyze data

ggplot(data, aes(x=LENGTH)) +
  geom_histogram()

ggplot(data, aes(x=speed_avg_fcd, y=speed_avg_matsim)) +
  geom_point(size  = 1, alpha = 0.1) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") +
  facet_wrap(~fclass, nrow = 3)

ggplot(data, aes(x=time_fcd, y=time_matsim)) +
  geom_point(size  = 1, alpha = 0.1) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  ylim(0,200) + xlim(0,200) + 
  facet_wrap(~fclass, nrow = 3)




subset = data %>% filter(vc_ratio > 0.5)

ggplot(subset, aes(x=speed_avg_fcd, y=speed_avg_matsim, alpha = number_veh)) +
  geom_point(size  = 1) + 
  #scale_alpha_continuous(range = c(0.1,0.25)) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  facet_wrap(~fclass, nrow = 2)

ggplot(subset, aes(x=time_fcd, y=time_matsim)) +
  geom_point(size  = 1, alpha = 0.1) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  ylim(0,200) + xlim(0,200) + 
  facet_wrap(~fclass, nrow = 3)


subset = data %>% filter(oneway == "F")

ggplot(subset, aes(x=speed_avg_fcd, y=speed_avg_matsim, alpha = number_veh)) +
  geom_point(size  = 1) + 
  #scale_alpha_continuous(range = c(0.1,0.25)) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  facet_wrap(~fclass, nrow = 3)


subset = data %>% filter(LENGTH > 200)

ggplot(subset, aes(x=speed_avg_fcd, y=speed_avg_matsim, alpha = number_veh)) +
  geom_point(size  = 1) + 
  #scale_alpha_continuous(range = c(0.1,0.25)) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  facet_wrap(~fclass, nrow = 2)

ggplot(subset, aes(x=time_fcd, y=time_matsim)) +
  geom_point(size  = 1, alpha = 0.1) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1, intercept = -20, color = "red") + 
  geom_abline(slope=1, intercept = +20, color = "red") + 
  ylim(0,200) + xlim(0,200) + 
  facet_wrap(~fclass, nrow = 3)


