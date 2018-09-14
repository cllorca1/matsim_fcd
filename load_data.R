#load fcd data
fcd_speeds = read.csv("osm_mutual_links_avg_speed.csv")

fcd_speeds_wo_zero = read.csv("FCD/fcd_102017_6to10am_avg_speed_wo0.csv", sep = ";")
fcd_speeds_wo_zero = fcd_speeds_wo_zero %>% 
  filter(osm_way_id %in% fcd_speeds$osm_way_id)  

fcd_speeds_wo_zero = fcd_speeds_wo_zero %>%
  group_by(osm_way_id) %>%
  summarize(number_veh_0 = sum(number_veh), avg_speed_0 = mean(avg_speed))

fcd_speeds = merge(x=fcd_speeds, y= fcd_speeds_wo_zero, by.x = "osm_way_id", by.y = "osm_way_id", all = F)

fcd_speeds = fcd_speeds %>% select(osm_way_id,number_veh = number_veh_0, avg_speed = avg_speed_0)


#load conversion file between matsim id and osm id
matsim2osm = read.csv("matsimAndOsmLinks_clipped.csv") %>% select (matsimId, osmId, inverseMatsimId)

#read matsim link volumes and times
#matsimData = fread("matsimDataLinks.txt")
matsimData = fread("mito_assignment.50.linkstats.txt")

#merge matsim data with osm ids
matsimData = merge(x=matsimData,y=matsim2osm, by.x="LINK", by.y="matsimId" )

#select the useful variables
matsimData = matsimData %>% select (LINK,
                                    FROM,
                                    TO,
                                    osmId,
                                    LENGTH,
                                    CAPACITY,
                                    inverseMatsimId,
                                    FREESPEED,
                                    v6 = `HRS6-7avg`,
                                    v7 = `HRS7-8avg`,
                                    v8 = `HRS8-9avg`,
                                    v9 = `HRS9-10avg`,
                                    tt6 = `TRAVELTIME6-7avg` , 
                                    tt7 = `TRAVELTIME7-8avg` ,
                                    tt8 = `TRAVELTIME8-9avg` ,
                                    tt9 = `TRAVELTIME9-10avg` ,
                                    tt6min = `TRAVELTIME6-7min` , 
                                    tt7min = `TRAVELTIME7-8min` ,
                                    tt8min = `TRAVELTIME8-9min` ,
                                    tt9min = `TRAVELTIME9-10min` ,
                                    tt6max = `TRAVELTIME6-7max` , 
                                    tt7max = `TRAVELTIME7-8max` ,
                                    tt8max = `TRAVELTIME8-9max` ,
                                    tt9max = `TRAVELTIME9-10max`)

#add direction - heading of the links

##read node data
nodes = fread("nodeCoordinates.csv")


originNodes = nodes %>% select (FROM = ID, FROMX = xcoord, FROMY = ycoord) 
destNodes= nodes %>% select (TO = ID, TOX = xcoord, TOY = ycoord) 
rm(nodes)

#merge with matsimData
matsimData = merge(x=matsimData, y=originNodes, by = "FROM")
matsimData = merge(x=matsimData, y=destNodes, by = "TO")

#calculate heading
matsimData = matsimData %>%
  rowwise() %>% 
  mutate(matsim_link_heading = atan2(TOY-FROMY, TOX-FROMX)*180/pi )


#read osm characteristics
osmCategories = fread("osm_links_in_study_area.csv") %>% select (osm_id, fclass, oneway)
matsimData = merge(x=matsimData, y=osmCategories, by.x = "osmId", by.y = "osm_id")


#merge matsim data with osm data
#in the direction osm --> matsim
linksFcd2Matsim = merge(x=matsimData, y=fcd_speeds, by.x = "osmId", by.y = "osm_way_id" )


#clean auxiliary files
rm(fcd_speeds, matsim2osm, matsimData, osmCategories, originNodes, destNodes, fcd_speeds_wo_zero)

