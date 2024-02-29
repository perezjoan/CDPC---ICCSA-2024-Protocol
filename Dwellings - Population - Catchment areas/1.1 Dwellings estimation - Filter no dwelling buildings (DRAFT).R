################################################################################
#                                                                              #
#         EMC2 WP 2 Processing 1.0                                             #
#         Filter on buildings with no dwellings                                #
#         Author : Perez Joan                                                  #
#                                                                              #
################################################################################

## 0.1 Packages & layers
library(sf)
building <- st_read("EMC2_CA_Subset_WP2.gpkg", layer = "building") 

## 1. Indexes to remove
# light buildings
indexes_1 <- which(building$construction_legere == TRUE)
# Building with no dwelling
indexes_2 <- which(building$nombre_de_logements == 0)
# Specialized buildings
indexes_3 <- which(building$nature != "Indifférenciée")
# Building under construction (not in service)
indexes_4 <- which(building$etat_de_l_objet != "En service")
# Annex buildings (Définition : Petit bâtiment à vocation d'annexe au sens fiscal : garage externe, abri...)
indexes_5 <- which(building$usage_1 == "Annexe")
# Remove the buildings with less the 5 m² of footprint 
indexes_6 <- which(as.numeric(st_area(building)) < 5)

# merge indexes, remove duplicates & perform the filter
merged_idx <- c(indexes_1, indexes_2, indexes_3, indexes_4, indexes_5, indexes_6)
unique_idx <- unique(merged_idx)
filtered_building <- building[-unique_idx,]

# Write layer
st_write(filtered_building, "EMC2_CA_Subset_WP2.gpkg", layer = "Buildings_with_dwellings_NA")
