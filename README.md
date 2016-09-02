# GEP - Gene Expression Pipeline

The aim of the project is to create an interactive and automated pipeline for retrieving, processing and visualising vase public gene expression datasets

## Brief Explanation
Recent biotechnology allows us to simultaneously measure the activation of all genes in a tissue of interest . Consequently, thousands of datasets, millions of measurements, and terabytes of data have been created by scientists and are now stored in public databases such as [ArrayExpress](https://www.ebi.ac.uk/arrayexpress/) and [GEO](http://www.ncbi.nlm.nih.gov/geo/ "Gene Expression Omnibus"). Most of the data remains unused after initial depositing, however it likely hides undiscovered knowledge of genetics, biology, and disease such as cancer. This knowledge can only be revealed when all the data is analysed in a unified model. To enable such analysis, this project will create a computational toolkit to retrieve these big datasets, perform automated pre-processing and quality control with established approaches, and create summary reports and network visualizations to enable interactive exploratory analysis.


So far only the [GEO](http://www.ncbi.nlm.nih.gov/geo/ "Gene Expression Omnibus") database has been used.

## Overview of Pipeline
Data retrieval is done using the packages from [Bioconductor](https://www.bioconductor.org/). Particularly, gene expression raw data was accessed using code from [GEOquery](https://bioconductor.org/packages/release/bioc/html/GEOquery.html) and metadata for datasets was retrieved using [GEOmetadb](https://www.bioconductor.org/packages/release/bioc/html/GEOmetadb.html).

Quality control was performed by the [arrayQualityMetrics](https://bioconductor.org/packages/release/bioc/html/arrayQualityMetrics.html) package from [Bioconductor](https://www.bioconductor.org/).

Normalisation, correction, and preprocessing was performed using code from the [aroma.affymetrix](https://cran.r-project.org/web/packages/aroma.affymetrix/index.html) package - particularly the [Gene 1.0 ST Array Analysis](http://www.aroma-project.org/vignettes/GeneSTArrayAnalysis/) protocol.

Other packages used include [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html) for downloading data, [affy](http://bioconductor.org/packages/release/bioc/html/affy.html) for reading data, and [ggplot2](http://ggplot2.org/) and [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html) for generating different plots of the data.

**Here is a consolidated list of R package dependencies you are required to install to use the tool**

* [aroma.affymetrix](https://cran.r-project.org/web/packages/aroma.affymetrix/index.html)
* [ggplot2](http://ggplot2.org/)
* [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html)

_[Bioconductor](https://www.bioconductor.org/) Packages (follow links for installation instructions)_
* [GEOquery](https://bioconductor.org/packages/release/bioc/html/GEOquery.html)
* [GEOmetadb](https://www.bioconductor.org/packages/release/bioc/html/GEOmetadb.html)
* [arrayQualityMetrics](https://bioconductor.org/packages/release/bioc/html/arrayQualityMetrics.html)
* [affy](http://bioconductor.org/packages/release/bioc/html/affy.html)

**_Please make sure you have all of the above packages installed in your cluster enviroment before beginning use._**

## Use

So far this collection of R scripts, executed by bash scripts, that  have been designed to be used in an OICR's SGE High Performance Computing (HPC) Cluster environment. 

**_You must update the directory locations in the Shell scripts provided - start_gep.sh and get_data.sh in the top-level GEP directory, and run_pipeline.sh, combine_and_run_pipeline.sh, get_raw_data.sh, get_data_sql.sh in the R directory - to use any of the provided utilities._**

### Data Retrieval
The **get_data.sh** script is the interface designed to let you download a list of GSEXXX datasets you wish to download. There are two methods used to specify the list of datasets you wish to download, and these method are toggled by options fed to the script. The options are
  * **-l** : if you specify this option, it is followed by a list of GSEXXX datasets seprated by spaces. Here is an example wit some random GSE datasets
  
  `./get_data.sh -l GSE19317 GSE64415 GSE50006 ...`
  * **-sql**: this option should be followed by an SQL query, as a single string, against the GEOmetadb database. If no SQL query follows the option, the default query is used
  
  `SELECT gse.gse FROM gse JOIN (SELECT * FROM gse_gpl GROUP BY gse HAVING COUNT(gpl) = 1) gpl ON gse.gse=gpl.gse WHERE gpl='GPL570' ORDER BY RANDOM()`

  Otherwise you specify your query like this
    
   `./get_data -sql "SELECT gse FROM gse WHERE ... "`
    
#### Expected Outputs
1. **get_data.log** and **get_data.err** files located wherever you specify the location of the log files in the **get_data.sh** script.
  * **get_data.log** tells the user whether a dataset was downloaded or not, depending whether it could find the dataset's raw data **.tar** file online
  * **get_data.err** shows the progress of each dataset being downloaded, and also if the program unexpectedly stops it will tell you where it stopped and an error message.

2. Within the **data/rawData** directory there should be directories named after the GSEXXX datasets you specified to download , within each directory is that dataset's raw data **.tar** file

### Running Pipeline


### Outputs

Outputs from running the pipeline are all dumped into the outputs directory - within it, for each dataset put through the pipeline, there is a directory named after the dataset which will contain all of that dataset's respective outputs. This includes the gene expression data when all of the samples in the dataset are preprocessed together, the gene expression data of just the clean samples preprocessed together, and gene expression data just for the outlier samples preprocessed together. Besides this gene expression data, a number of plots are genberate using both strategies where clean and outlier samples are preprecessed together and separately. The plots include Principal Component Anaysis (PCA), variance explained by each component, boxplot of values, heatmaps, and correlation matrices.

### Shiny App

