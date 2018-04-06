#analyze routes
library(dplyr)


folder = "C:/models/matsimRouteAnalyzer/"

routeAnalysis = data.frame()
for (i in 1:180){
  file = paste(i,".csv",sep = "")
  routes = read.csv(paste(folder,file,sep=""))
  routes$travel_time = routes$arrival_time - routes$departure_time
  
  links4route = routes %>% group_by(link) %>% summarize(freq = n(), tt = mean(travel_time))
  write.csv(links4route, paste(folder,i,"_aggregated.csv", sep=""), row.names = F)
  
  
  header = '"Integer","Integer","Real"'
  write(header, paste(folder,i,"_aggregated.csvt", sep=""))
  
  routesPeakHour = routes %>% filter(departure_time > 6*3600, arrival_time < 10*3600)
  persons = as.numeric(unique(routesPeakHour$person_id))
  originLink = routesPeakHour$origin_link[1]
  destinationLink = routesPeakHour$destination_link[1]

  for (person in persons){
    route = routesPeakHour %>% filter(person_id == person) %>% select(sequence,link)
    subsetLinks = data %>% filter(LINK %in% route$link)
    validity = T
    if (nrow(route) != nrow(subsetLinks)){
      validity = F
    }
    travel_time_matsim = sum(subsetLinks$time_matsim)
    travel_time_fcd = sum(subsetLinks$time_fcd)
    length_route = sum(subsetLinks$LENGTH)
    print(paste("OD pair: ", i, " tt _fcd = " ,travel_time_fcd, " tt_mstsim = ", travel_time_matsim, " in data? ", validity,sep = ""))
    row = data.frame(origin = originLink ,
                     destination = destinationLink,
                     person_id = person,
                     tt_matsim = travel_time_matsim,
                     tt_fcd = travel_time_fcd,
                     length = length_route,
                     flag = validity)
    routeAnalysis = rbind(routeAnalysis,row)
  
  }
}

rm(links4route, route,routesPeakHour, routes,row,subsetLinks)


routeAnalysisT = routeAnalysis %>% filter(flag)



ggplot(routeAnalysisT, aes(x=tt_fcd/3600, y=tt_matsim/3600)) +
  geom_point() + 
  geom_abline(intercept = 0, slope = 1, color = "red", size = 1) + 
  xlim(0,1.5) + ylim(0,1.5) + theme_bw()


ggplot(routeAnalysisT, aes(x=length/1000, y=tt_matsim/3600)) +
  geom_point() + theme_bw()

ggplot(routeAnalysisT, aes(x=length/1000, y=tt_fcd/3600)) +
  geom_point() + theme_bw()

rankOfRoutes = routeAnalysisT %>% group_by(origin, destination,tt_matsim) %>% summarize(tt_fcd = mean(tt_fcd))
rankOfRoutes = rankOfRoutes %>% rowwise() %>% mutate(odpair = paste(origin,destination,sep="-"))
ggplot(rankOfRoutes, aes(x=tt_fcd/3600, y=tt_matsim/3600, group = as.factor(odpair), color = as.factor(odpair))) +
  geom_line() + geom_point() + 
  geom_abline(intercept = 0, slope = 1, color = "red", size = 1) + 
  xlim(0,1.5) + ylim(0,1.5) + theme_bw()




#aux
#listOfLinks = c(477096,248691,498205,416762,182557,359,668,471389,248691,162917,399009,89707,165304,392267,165304)
#data %>% filter(LINK %in% listOfLinks)
