################################################################################
#                                                                              #
#         EMC2 WP 2 Processing 0.1                                             #
#         Geopackage and subset preparation from French raw data:              #
#         BD_TOPO (Building and roads),                                        #
#         Filosofi (population)                                                #
#         Author : Perez Joan                                                  #
#                                                                              #
################################################################################

## 0.1 Packages
library(sf)

## 1. Download and subset data

# Download last version of BD_TOPO for a given French department
# Webpage : https://geoservices.ign.fr/bdtopo#telechargementgpkgreg
# BD TOPO® décembre 2023 Tous Thèmes par département format GeoPackage projection légale
# Alpes maritimes department : 
# https://data.geopf.fr/telechargement/download/BDTOPO/BDTOPO_3-3_TOUSTHEMES_GPKG_LAMB93_D006_2023-12-15/BDTOPO_3-3_TOUSTHEMES_GPKG_LAMB93_D006_2023-12-15.7z

# Download last version of Filosofi (2019 on 23/02/2024)
# https://www.insee.fr/fr/statistiques/7655475?sommaire=7655515

# building (3.3 downloaded on 23/02/2024)
building <- st_read("C:/Users/jperez/Documents/Current 1/France - EMC2/Raw data/BDTOPO 3-3/1_DONNEES_LIVRAISON_2023-12-00191\\BDT_3-3_GPKG_LAMB93_D006-ED2023-12-15/BDT_3-3_GPKG_LAMB93_D006-ED2023-12-15.gpkg",
        layer = "batiment")

# road (3.3 downloaded on 23/02/2024)
road <- st_read("C:/Users/jperez/Documents/Current 1/France - EMC2/Raw data/BDTOPO 3-3/1_DONNEES_LIVRAISON_2023-12-00191\\BDT_3-3_GPKG_LAMB93_D006-ED2023-12-15/BDT_3-3_GPKG_LAMB93_D006-ED2023-12-15.gpkg",
                    layer = "troncon_de_route")

# administrative limits (3.3 downloaded on 23/02/2024)
administrative <- st_read("C:/Users/jperez/Documents/Current 1/France - EMC2/Raw data/BDTOPO 3-3/1_DONNEES_LIVRAISON_2023-12-00191\\BDT_3-3_GPKG_LAMB93_D006-ED2023-12-15/BDT_3-3_GPKG_LAMB93_D006-ED2023-12-15.gpkg",
                  layer = "commune")

# Filosofi
population <- st_read("C:/Users/jperez/Documents/Current 1/France - EMC2/Raw data/Filosofi 2019/carreaux_200m_met.gpkg")

# keep population squares for Côte d'azur only
population <- population[administrative,]

# Remove columns with wrong format for geopandas in python
administrative <- administrative[, c(1:8, 13:18, 21:26)]
building <- building[, c(1:6, 11:28)]
road <- road[, c(1:7, 13:43, 46:85)]

## 2. Create GPKG for Côte d'Azur
st_write(population,"EMC2_CA_WP2.gpkg", layer = "population")
st_write(administrative,"EMC2_CA_WP2.gpkg", layer = "administrative")
st_write(road,"EMC2_CA_WP2.gpkg", layer = "road")
st_write(building,"EMC2_CA_WP2.gpkg", layer = "building")

## 3. Create subset for Drap commune
administrative <- administrative[administrative$nom_officiel == "Drap",]
population <- population[administrative,]
road <- road[administrative,]
building <- building[administrative,]

# Record subset on Drap
st_write(population,"EMC2_CA_Subset_WP2.gpkg", layer = "population")
st_write(administrative,"EMC2_CA_Subset_WP2.gpkg", layer = "administrative")
st_write(road,"EMC2_CA_Subset_WP2.gpkg", layer = "road")
st_write(building,"EMC2_CA_Subset_WP2.gpkg", layer = "building")