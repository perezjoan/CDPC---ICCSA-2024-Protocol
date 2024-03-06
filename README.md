## emc2 project : working package 2
Welcome to the code repository of the WP2 of the emc2 project. This repository is maintened by ESPACE laboratory.

[emc2 project](https://emc2-dut.org/)  
[ESPACE laboratory](https://www.umrespace.org/)

## Project sections
- **Dwellings - Population - Catchment areas**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas)  
This section focuses on evaluating the number of dwellings per inhabited building, the number of people per household per dwelling, and determining the potential catchment area (in terms of population/distance) at the segment level (roads). This section is divided into subsections.

    *0.1 Pre-processing  - Main GeoPackage preparation from selected layers of BD_TOPO and Filosofi*

    This section creates a geopackage for a department in France with the following layers : building, road, administrative boundaries, activity areas (from BD_TOP 3.3) and population by square areas of 200x200 meters (Filosophi 2019).
  
  Prerequises : Data from French government (open access)

    *0.2 Pre-processing  - Automated subset preparation for a given city*

    This section creates a subset for a given city containing the same layers as 0.1.
                                                                           
  Prerequises : data from 0.1

    *1.1 Dwelling estimation - Filter no dwelling buildings*

    This section filters all the buildings with no dwellings. 7 kinds of buildings are removed : (1) All buildings with no official dwellings associated. (2) light buildings with no official dwellings associated. (3) all specialized buildings other than residential with no official dwellings associated. (4) Buildings under construction (5) Annex buildings with no official dwellings associated (6) Buildings of less than 10 sqrm (7) large buildings (more than 150 sqrm) within specialized areas with NULL values of dwellings.
  Prerequises : data from 0.1

    *1.2 Dwelling estimation - Morphometry on buildings*    
    *1.3 Evaluate number of dwellings for NA buildings with dwellings*   

- **Road continuity**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas)  
The aim of this section is to analyze road continuity, including notable local connectivity averages related to global connectivity averages. The work on this section is put on hold.

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
