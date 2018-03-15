#load fcd data
fcd_speeds = read.csv("osm_mutual_links_avg_speed.csv")

#load conversion file between matsim id and osm id
matsim2osm = read.csv("matsimAndOsmLinks_clipped.csv") %>% select (matsimId, osmId, inverseMatsimId)

#read matsim link volumes and times
matsimData = fread("matsimDataLinks.txt")

#merge matsim data with osm ids
matsimData = merge(x=matsimData,y=matsim2osm, by.x="LINK", by.y="matsimId" )

#select the useful variables
matsimData = matsimData %>% select (LINK,
                                    osmId,
                                    LENGTH,
                                    CAPACITY,
                                    inverseMatsimId,
                                    FREESPEED,
                                    v6 = `HRS6-7avg`,
                                    v7 = `HRS7-8avg`,
                                    v8 = `HRS8-9avg`,
                                    v9 = `HRS9-10avg`,
                                    tt6 = `TRAVELTIME6-7avg`, 
                                    tt7 = `TRAVELTIME7-8avg`,
                                    tt8 = `TRAVELTIME8-9avg`,
                                    tt9 = `TRAVELTIME9-10avg`,
                                    tt6min = `TRAVELTIME6-7min`, 
                                    tt7min = `TRAVELTIME7-8min`,
                                    tt8min = `TRAVELTIME8-9min`,
                                    tt9min = `TRAVELTIME9-10min`,
                                    tt6max = `TRAVELTIME6-7max`, 
                                    tt7max = `TRAVELTIME7-8max`,
                                    tt8max = `TRAVELTIME8-9max`,
                                    tt9max = `TRAVELTIME9-10max`)

#read osm characteristics
osmCategories = fread("osm_links_in_study_area.csv") %>% select (osm_id, fclass, oneway)
matsimData = merge(x=matsimData, y=osmCategories, by.x = "osmId", by.y = "osm_id")


#merge matsim data with osm data
#in the direction osm --> matsim
linksFcd2Matsim = merge(x=matsimData, y=fcd_speeds, by.x = "osmId", by.y = "osm_way_id" )


#clean auxiliary files
rm(fcd_speeds, matsim2osm, matsimData, osmCategories)

