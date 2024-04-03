################################################################################
#                                                                              #
#   4 . Estimation of population potential for 5/10 and 15 minutes catchment   #
#   areas around main axes                                                     #
#                                                                              #
#   http://emc2-dut.org/                                                       #
#                                                                              #
#   Author : PEREZ, J.* (2024)                                                 #
#   * UMR 7300 ESPACE-CNRS, Université Côte d'Azur, Nice, France.              #
#   Contact: Joan.PEREZ@univ-cotedazur.fr                                      #
#                                                                              #
#   Note : XXXXXXXX                                                            #
################################################################################

road <- st_read("DPC_06.gpkg",                                         
                layer = "road_CONN")

building <- st_read("DPC_06.gpkg", 
                    layer = "building_dwellings")

boundaries <- st_read("DPC_06.gpkg",                                         
                layer = "adm_boundaries")

# Select main roads (10th decile from LocRel_CONN) and
road_subset <- road[road$LocRel_CONN > quantile(road$LocRel_CONN, 0.9), ]

# create catchment areas (400/800/1200 meters)
road_subset_b400 <- st_buffer(road_subset, 400)
road_subset_b800 <- st_buffer(road_subset, 800)
road_subset_b1200 <- st_buffer(road_subset, 1200)

# Calculate population potential per buidling (average household size in France
# is 1.92 for collective housings, 2.44 for single family homes)
building$pot_pop <- ifelse(building$building.dwellings_estimate == 1, 
                           building$building.dwellings_estimate * 2.44,
                           ifelse(building$building.dwellings_estimate > 0, 
                                  building$building.dwellings_estimate * 1.92, 0))

# Centroid of building
cent <- st_centroid(building)

# sum to roads
joined <- st_join(cent, road_subset_b400)
sum_400 <- joined %>%
  group_by(WAY_ID) %>%
  summarise(total_pop_400 = sum(pot_pop, na.rm = TRUE))
st_geometry(sum_400) = NULL

# sum to roads
joined <- st_join(cent, road_subset_b800)
sum_800 <- joined %>%
  group_by(WAY_ID) %>%
  summarise(total_pop_800 = sum(pot_pop, na.rm = TRUE))
st_geometry(sum_800) = NULL

# sum to roads
joined <- st_join(cent, road_subset_b1200)
sum_1200 <- joined %>%
  group_by(WAY_ID) %>%
  summarise(total_pop_1200 = sum(pot_pop, na.rm = TRUE))
st_geometry(sum_1200) = NULL

results <- merge(road_subset, sum_400, by = "WAY_ID")
results <- merge(results, sum_800, by = "WAY_ID")
results <- merge(results, sum_1200, by = "WAY_ID")

results <- results[boundaries,]

st_write(results, "DPC_06.gpkg", layer = "road_pop_results")

