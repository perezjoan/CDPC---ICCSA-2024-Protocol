## emc2 project : working package 2
Welcome to the code repository of the WP2 of the emc2 project. This repository is maintened by ESPACE laboratory.

[emc2 project](https://emc2-dut.org/)  
[ESPACE laboratory](https://www.umrespace.org/)

## Project sections
- **Dwellings - Population - Catchment areas**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas)  
This section focuses on evaluating the number of dwellings per inhabited building, the number of people per household per dwelling, and determining the potential catchment area (in terms of population/distance) at the segment level (roads). This section is divided into subsections.

    0.1 Pre-processing  - Main GeoPackage preparation from selected layers of BD_TOPO and Filosofi    
    0.2 Pre-processing  - Automated subset preparation for a given city    
    1.1 Dwelling estimation - Filter no dwelling buildings    
    1.2 Dwelling estimation - Evaluate number of dwellings for inhabited buildings with NA values from BD_TOPO    
    1.3 Evaluate number of dwellings for NA buildings with dwellings   

- **Road continuity**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas)  
The aim of this section is to analyze road continuity, including notable local connectivity averages related to global connectivity averages.

## Installation Steps

Follow these steps to run the algorithms :
- Install the Anoconda distribution of Python [Link](https://www.anaconda.com/download)
- Ensure you have installed the following dependencies : geopandas, pyogrio and contextily by running the following commands in the anaconda prompt :    
      `conda install -c conda-forge geopandas`    
      `conda install -c conda-forge pyogrio`    
      `conda install -c conda-forge contextily`    
- Navigate to a section
- Download the required data or prerequises and set your local paths (link provided in "Packages, local filepaths & parameters" within the code of each section)

## LICENSE

The emc2 project is licensed under the [Creative Commons Zero v1.0 Universal]. See the [LICENSE](https://github.com/perezjoan/emc2-WP2/blob/main/LICENSE) file for details.
