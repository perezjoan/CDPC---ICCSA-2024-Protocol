## Road Continuity - Dwellings - Population - Catchment Areas (CDPC) (ICCSA 2024 Protocol version)
Light protocol of Road Continuity - Dwellings - Population - Catchment areas developed for the ICCSA 2024 Conference on the data from the French census (BD TOPO®3 - IGN, 2023). This script identifies main streets in local contexts (#1), calculate morphometric indicators on buildings (#2), use the indicators of #2 to evaluate the number of dwellings within inhabited buildings using a decision tree classifier (#3) and projects the population potential to the identified main streets (#4). 
Link to the paper : https://www.springerprofessional.de/en/potential-of-the-15-minute-peripheral-city-identifying-main-stre/27388226 

[emc2 project](https://emc2-dut.org/)  

- **Sample data**:

A sample data that contains information on several municipalities, buildings, and roads in both southern and northern France is associated with this section. The [sample data can be downloaded from Zenodo](https://zenodo.org/records/10946415). The sample data enables the execution of all algorithms within this protocol. Additionally, it contains the results of each section, thus allowing to run the sections independently. 

- **Step by step guide**:

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
- Install the Anaconda distribution of Python [Link](https://www.anaconda.com/download)
The following dependencies are required to run the Python scripts
      `conda install -c conda-forge geopandas`    
      `conda install -c conda-forge pyogrio`    
      `conda install -c conda-forge contextily`   
      `conda install -c conda-forge momepy`
- Download the required data or prerequises and set your local paths (link provided in "Packages, local filepaths & parameters" within the code of each section)

To execute the R algorithms, follow these steps:
- Install R: Download and install the latest version of R from [here](https://cran.r-project.org/bin/windows/base/). If compatibility issues occur, install the [specific version](https://cran.r-project.org/bin/windows/base/old/) of R mentioned in the scripts. You can find this information in each script.
- Navigate to a section
- Download the required data or prerequises and set your local paths (link provided in "Packages, local filepaths & parameters" within the code of each section)
- Install Required Packages: Open the R script and navigate to the "Packages, local filepaths & parameters" section. Install the required packages using the install.packages('package_name') command. If compatibility issues arise, install older versions of the packages mentioned in the script. You can find this information in each script. You may need to use rtools to install older package versions.

## Acknowledgement 
This resource was produced within the emc2 project, which is funded by ANR (France), FFG (Austria), MUR (Italy) and Vinnova (Sweden) under the Driving Urban Transition Partnership, which has been co-funded by the European Commission.

## License
The emc2 project is licensed under the [Attribution-ShareAlike 4.0 International]. See the [LICENSE](https://github.com/perezjoan/CDPC---ICCSA-2024-Protocol?tab=CC-BY-SA-4.0-1-ov-file) file for details.
