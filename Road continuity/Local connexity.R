################################################################################
#                                                                              #
#   Connexity locally ponderated by global connexity                           #
#                                                                              #
#   http://emc2-dut.org/                                                       #
#                                                                              #
#   Author : PEREZ, J.* (2024)                                                 #
#   * UMR 7300 ESPACE-CNRS, Université Côte d'Azur, Nice, France.              #
#   Contact: Joan.PEREZ@univ-cotedazur.fr                                      #
#                                                                              #
#   Note : Using the outputs of the Morpheo QGIS plugin ( gpkg with ways       #
#   + places, Lagesse, 2015), this code produces three new indicators at the   #
#   morpheo segment level :                                                    #
#   CONN_T : Total Connexity for each Morpheo road segment                     #
#   CONN_T_P : Total Connexity Ponderated by number of intersecting segments   #
#   CONN_P : Morpheo Connexity ponderated                                      #
#   Only BOX 1 (layers preparation) and BOX 2 (Saves) need to be filled        #                                                                          #
################################################################################

library(sf)
library(dplyr)

################################################################################
# box 1 : LAYERS PREPARATION                                                   #
# WAYS (morpheo road segments)                                                 #
road <- st_read("Roads.gpkg", layer = "Raw_morpheo_Results_59_B4_A60")         #
# PLACES (morpheo buffers)                                                     #
place <- st_read("Roads.gpkg", layer = "Buffer_morpheo_Results_59_B4_A60")     #
################################################################################

# Remove buffers in dead ends
place <- place[is.na(place$END_VTX), ]

# Perform a spatial join between 'place' and 'road', then group by place_id 
# and calculate the sum of CONN for each group
starttime <- Sys.time()
place$place_id = 1:nrow(place)
temp <- st_join(place, road) %>%
  group_by(place_id) %>%
  summarise(CONN_LocSum = sum(CONN, na.rm = TRUE))
st_geometry(temp) = NULL
# Merge the summarized 'temp' dataframe back into the 'place' dataframe based
# on place_id, 
place <- merge(place, temp, by = "place_id", all.x = TRUE)
endtime <- Sys.time()
print(paste0(difftime(endtime, starttime, units = "secs"), " secs for total 
             connexity"))

# Calculate lengths and sums
starttime <- Sys.time()
lengths <- st_intersection(road, place) %>%
  group_by(OGC_FID) %>%
  summarise(Len_P = n())

sums <- st_intersection(road, place) %>%
  group_by(OGC_FID) %>%
  summarise(CONN_TOTBUF_TEMP = sum(CONN_LocSum))

endtime <- Sys.time()
print(paste0(difftime(endtime, starttime, units = "secs"), " secs for 
             intersection"))

# Join the lengths and sums back to the road dataframe
st_geometry(lengths) = NULL
road <- merge(road, lengths, by = "OGC_FID", all.x = TRUE)
st_geometry(sums) = NULL
road <- merge(road, sums, by = "OGC_FID", all.x = TRUE)

# Total Connexity (Remove all double counts from buffers intersecting the 
# segment where the temporary calculus CONN_TOTBUF_TEMP was performed)
road$CONN_LocSum <- road$CONN_TOTBUF_TEMP-(road$CONN*road$Len_P)

# Total Connexity Ponderated by number of intersecting segments
road$CONN_LocAvg <- road$CONN_LocSum/road$Len_P

# Morpheo Connexity ponderated
road$CONN_LocRel <- road$CONN/road$CONN_LocAvg

################################################################################
# BOX 2 : Saves                                                                #
st_write(road, "Roads.gpkg", layer = "morpheo+_Results_06_B4_A60")             #
################################################################################
