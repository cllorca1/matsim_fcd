#requires load and process data

matsimLinks = 37809 
#this number is the amount of links on the sub-study area in the
#MATSim network (based on diff. OSM links)

newdata = data %>% arrange(desc(number_veh))

newdata$relfreq = 1:nrow(newdata)
newdata$relfreq = newdata$relfreq/matsimLinks*100




ggplot(newdata, aes(x=number_veh, y=relfreq)) +
  geom_line(size = 1) +
  theme_bw() +
  xlim(0,1000) + 
  xlab("Number of FCD-vehicles in the link") + 
  ylab("Percentage of links") + 
  geom_segment(x=30,y=-10,xend=30,yend=15, color = "red", size = 1) + 
  geom_segment(x=-1000,y=15,xend=30,yend=15, color = "red", size = 1) + 
  geom_segment(x=50,y=-10,xend=50,yend=11, color = "red", size = 1) + 
  geom_segment(x=-1000,y=11,xend=50,yend=11, color = "red", size = 1) + 
  geom_segment(x=100,y=-10,xend=100,yend=6.5, color = "red", size = 1) + 
  geom_segment(x=-1000,y=6.5,xend=100,yend=6.5, color = "red", size = 1) 


