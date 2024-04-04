################################################################################
#                                                                              #
#   1- Connexity locally weighted by global connexity                          # 
#                                                                              #
#   Project website : http://emc2-dut.org/                                     #
#   Data sample : XXX                                                          #
#                                                                              #
#   Author : PEREZ, J.* (2024)                                                 #
#   * UMR 7300 ESPACE-CNRS, Université Côte d'Azur, Nice, France.              #
#   Contact: Joan.PEREZ@univ-cotedazur.fr                                      #
#                                                                              #
#   Note : Using the outputs of the Morpheo QGIS plugin ( gpkg with ways       #
#   + places, Lagesse, 2015), this code produces three new indicators at the   #
#   morpheo segment level :                                                    #
#   LocSum_CONN : Total Connexity for each Morpheo road segment                #
#   LocAvg_CONN : Total Connexity Weighted by number of intersecting segments  #
#   LocRel_CONN : Morpheo Connexity Weighted                                   #
#                                                                              #
# Packages, local filepaths & parameters                                       #
# R version 4.3.2 (2023-10-31 ucrt)                                            #
library(sf) # v.1.0.14                                                         #
library(dplyr) # v.1.1.3                                                       #
#                                                                              #
# Load ways and places (morpheo)                                               #
# Load either DPC_06.gpkg or DPC_59.gpkg within ""                             #
road <- st_read("", layer = "road_morpheo")                                    #
buffer <- st_read("", layer = "buffer_morpheo")                                #
################################################################################

# Remove buffers in dead ends
buffer <- buffer[is.na(buffer$END_VTX), ]

# Perform a spatial join between buffer and road, then group by buffer_id 
# and calculate the sum of connexity (CONN) for each group. Create a temporary
# dataset (temp)
buffer$buffer_id = 1:nrow(buffer)
temp <- st_join(buffer, road) %>%
  group_by(buffer_id) %>%
  summarise(LocSum_CONN = sum(CONN, na.rm = TRUE))
st_geometry(temp) = NULL

# Merge the results back to original buffer dataset
buffer <- merge(buffer, temp, by = "buffer_id", all.x = TRUE)

# Calculate lengths and sums
lengths <- st_intersection(road, buffer) %>%
  group_by(OGC_FID) %>%
  summarise(Len_P = n())

sums <- st_intersection(road, buffer) %>%
  group_by(OGC_FID) %>%
  summarise(CONN_TOTBUF_TEMP = sum(LocSum_CONN))

# Join the lengths and sums back to the road dataset
st_geometry(lengths) = NULL
road <- merge(road, lengths, by = "OGC_FID", all.x = TRUE)
st_geometry(sums) = NULL
road <- merge(road, sums, by = "OGC_FID", all.x = TRUE)

# Total Connexity (Remove all double counts from buffers intersecting the 
# segment where the temporary calculus CONN_TOTBUF_TEMP was performed)
road$LocSum_CONN <- road$CONN_TOTBUF_TEMP-(road$CONN*road$Len_P)

# Total Connexity weighteby number of intersecting segments
road$LocAvg_CONN <- road$LocSum_CONN/road$Len_P

# Morpheo Connexity ponderated
road$LocRel_CONN <- road$CONN/road$LocAvg_CONN

# Results are available in the sample data as a layer named "road_CONN"