## emc2 project : working package 2
Welcome to the code repository of the WP2 of the emc2 project. This repository is maintened by ESPACE laboratory.

[emc2 project](https://emc2-dut.org/)  
[ESPACE laboratory](https://www.umrespace.org/)

## Project sections
- **Dwellings - Population - Catchment areas / Protocol tailored for french data**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas)  

This section focuses on evaluating the number of dwellings per inhabited building, the number of people per household per dwelling, and determining the potential catchment area (in terms of population/distance) at the segment level (roads). This section is divided into subsections.

   *0.1 Pre-processing  - MAIN GeoPackage & SUBSET preparation - Python script*

This section creates a geopackage for a department in France with the following layers : building, road, administrative boundaries, activity areas (from BD_TOP 3.3) and population by square areas of 200x200 meters (Filosophi 2019). Prerequises : Data from French government (open access - links within the codes)

   *1.0 Dwelling estimation - Morphometry on buildings - Python script*  

Morphometry on buildings : handle missing values in building height and number of floors ; generate new indicators for building data : F (number of floors), A (surface area of the building footprint), P (perimeter),
E (elongation), C (convexity), FA (floor-area), ECA (elongation-convexity-area), EA (elongation-area) and SW (shared walls).

  *1.1 Dwelling estimation - Filter no dwelling buildings - Python script*

This script performs a series of spatial data processing tasks aimed at preparing building data for further analysis. Firstly, it conducts a spatial join between building and activity area datasets, assigning each building a category of activity area based on spatial intersection. Next, it identifies and removes specific indexes from the building dataset to refine the data for the learning phase of the classification model (1.2). These include light buildings, buildings under construction, annex buildings, and buildings with small footprints. Subsequently, additional indexes are identified and removed from the dataset for the estimation of the number of dwellings (1.3). This includes buildings with no dwellings, specialized buildings, and large buildings within specialized areas with null values of dwellings.

  *A.1 Test of Complete Spatial Randomness - Python script*

This script analyzes the spatial distribution of two observed point patterns and compares it to a random distribution of points to determine if there is clustering, dispersion, or randomness in the point pattern. In the context of the EMC2 project, this script is used to compare the distribution of all buildings and buildings with NA values for the number of dwellings to a random distribution of points. The objective is to assess if 
NA values are more or less randomly distributed than the observed data.


- **Road continuity**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas)  
The aim of this section is to analyze road continuity, including notable local connectivity averages related to global connectivity averages. The work on this section is put on hold, but a light version of this protocol has been implemented in the first step of the light protocol discussed below.

- **Road continuity - Dwellings - Population - Catchment areas / ICCSA 2024 Protocol version**: [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Road%20continuity%20-%20Dwellings%20-%20Population%20-%20Catchment%20area%20(light%20protocol))

This section is a light protocol version of Dwellings - Population - Catchment areas [Link to Section](https://github.com/perezjoan/emc2-WP2/tree/main/Dwellings%20-%20Population%20-%20Catchment%20areas) As compared to the main version (under developement), the light version protocol does not implement configurational analysis, spatial lags for the morphometry indicators, test of complete spatial randomness (CSR), zero-truncated Poisson or negative binomial regressions for the dwelling estimations, use of disaggregated census data or network distance for the catchment areas.
A sample data that contains information on several municipalities, buildings, and roads in both southern and northern France is associated with this section. This sample data can be downloaded from [Zenodo](xx). The sample data enables the execution of all algorithms mentioned above. Additionally, it contains the results of each section, thus allowing to run the algorithms independently. 
The light version is divided into four simple steps :
  
  *1. The identification of main streets in local contexts - R Script*
  
  Using the outputs of the Morpheo QGIS plugin (gpkg with ways + places, Lagesse, 2015), this code produces three new indicators at the Morpheo segment level: CONN_LocSum: Total Connectivity for the direct neighborhood of each Morpheo way; CONN_LocAvg: Local Average Connectivity; CONN_LocRel : Local Relative Connectivity
  
  *2. Morphometry on buildings – Python script*
  
This code computes a basic set of morphometric indicators at the building level : F (number of floors), A (surface area of the building footprint), P (perimeter), E (elongation), C (convexity), FA (floor-area), ECA (elongation-convexity-area), EA (elongation-area) and SW (shared walls).
  
  *3. Evaluation of the number of dwellings within inhabited buildings – R Script*

This script is aimed at estimating the number of dwellings within buildings using a combination of machine learning techniques, specifically classification and regression models, based on building morphometry indicators.
  
  *4. Projecting population potential to main streets – R Script*

This script estimates the population potential within catchment areas of 5/10 and 15 minutes around main axes using euclidean distance (buffers of 400, 800, and 1200 meters around main axes). 
  
  *Appendix. thematic maps – Python script*

## Installation Steps

Follow these steps to run the Python algorithms :
- Install the Anoconda distribution of Python [Link](https://www.anaconda.com/download)
- Ensure you have installed the following dependencies : geopandas, pyogrio and contextily by running the following commands in the anaconda prompt :    
      `conda install -c conda-forge geopandas`    
      `conda install -c conda-forge pyogrio`    
      `conda install -c conda-forge contextily`   
      `conda install -c conda-forge momepy`
      `pip install --upgrade cityseer`     
- Navigate to a section on GitHub
- Download the required data or prerequises and set your local paths (link provided in "Packages, local filepaths & parameters" within the code of each section)

To execute the R algorithms, follow these steps:
- Install R: Download and install the latest version of R from [here](https://cran.r-project.org/bin/windows/base/). If compatibility issues occur, install the [specific version](https://cran.r-project.org/bin/windows/base/old/) of R mentioned in the scripts. You can find this information in each script.
- Navigate to a section
- Download the required data or prerequises and set your local paths (link provided in "Packages, local filepaths & parameters" within the code of each section)
- Install Required Packages: Open the R script and navigate to the "Packages, local filepaths & parameters" section. Install the required packages using the install.packages('package_name') command. If compatibility issues arise, install older versions of the packages mentioned in the script. You can find this information in each script. You may need to use rtools to install older package versions.

## LICENSE

The emc2 project is licensed under the [Creative Commons Zero v1.0 Universal]. See the [LICENSE](https://github.com/perezjoan/emc2-WP2/blob/main/LICENSE) file for details.
