#analyze data

dataBackup = data
data = data %>% filter(number_veh > 30)

ggplot(data, aes(x=number_veh)) +
  stat_ecdf()+ xlim(0,100)


ggplot(data, aes(x=LENGTH)) +
  geom_histogram() 

ggplot(data, aes(x=vc_ratio)) +
  geom_histogram()


data$congestionLevel = "0 < v/c < 0.25"
data$congestionLevel[data$vc_ratio > 0.25] = "0.25 < v/c < 0.5"
data$congestionLevel[data$vc_ratio > 0.5] = "0.5 < v/c < 1"

#get the counts of each one of the cells of the grid of previous plot:
annotations = data%>% group_by(road_type, congestionLevel) %>% summarize(count = n())
annotations = annotations %>% rowwise() %>% mutate(label = paste("n = ",count,sep=""))

ggplot(data, aes(x=speed_avg_fcd, y=speed_avg_matsim)) +
  geom_abline(slope=1, intercept = 0, color = "red", alpha = 0.5,size = 13) + 
  geom_abline(slope=1, intercept = -20, color = "red", alpha = 0.5,size = 1) + 
  geom_abline(slope=1, intercept = +20, color = "red", alpha = 0.5, size = 1) +
  geom_point(alpha = 0.25, size = .5) +
  facet_grid(congestionLevel~road_type) + 
  xlim(0,130) + ylim(0,130) + 
  theme_bw() +
  geom_smooth(method='lm',se = F, formula=y~x, size = 1) + 
  xlab("FCD-average speed (km/h)") + 
  ylab("MATSim-average speed (km/h)") + 
  geom_text(data = annotations, mapping = aes(x=110, y=20, label = label))






ggplot(data, aes(x=time_fcd, y=time_matsim)) +
  geom_point(size  = 1) + 
  geom_abline(slope=1, intercept = 0, color = "red") + 
  geom_abline(slope=1.25, intercept = 0, color = "red", linetype = "dashed", size = 1) + 
  geom_abline(slope=0.75, intercept = 0, color = "red", linetype = "dashed", size = 1) +
  ylim(0,200) + xlim(0,200) + 
  facet_grid(congestionLevel~road_type) + 
  theme_bw()


