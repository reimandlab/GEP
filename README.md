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

2. Within the **data/rawData/** directory there should be directories named after the GSEXXX datasets you specified to download , within each directory is that dataset's raw data **.tar** file

### Computational Pipeline
The **start_gep.sh** script is designed as the interface to funnel datasets through the computational pipeline. In parallel with the data retrieval script, this script also has two options.

1. `./start_gep.sh -d GSE19317 GSE64415 GSE50006 ...` The **-d** option tells the script to use the default action of the pipeline. The default action of the pipeline is to process each GSEXXX dataset listed individually, and the process for each dataset is submitted as a distinct job to the cluster.
  * **Preprocessing.** There are two preprocessing strategies employed in the pipeline following quality control (identifying outliers) in order to see how different strategies affect data points.
   
    1. Peform preprocessing of clean samples and outliers together.
    
    2. Perform preprocessing of clean samples and outliers separately.

2. `./start_gep.sh -c MYTITLE GSE19317 GSE64415 GSE50006 ...` The **-c** option tells the script to combine the listed GSEXXX datasets and process it as if it were one dataset. Only one job is submitted to the cluster for the combined dataset, named **MYTITLE**.
  * **Preprocessing.** Similar to the above option, once again two strategies of preprocessing the data are employed. The difference here is that any dataset you're using with the **-c** option to combine and process must have already been processed by the pipeline individually.
    
    1. Perform preprocessing of clean samples and outliers, as identified by individual processing, together.
    
    2. Perform preprocessing of clean samples and outliers, as identified by individual processing, separately.
     
#### Expected Outputs
1. **Raw Data.** Once a dataset has been funneled through the pipeline, and preprocessed, raw data is movedf from **data/rawData/** to the **data/preprocessedData/** directory. Usually, for each dataset there are three directories for it in **preprocessedData**.

  * **GSEXXX** - this diectory contains all of the dataset's sample files.
  
  * **GSEXXX-clean** - this directory just contains the dataset's clean sample files.
 
  * **GSEXXX-outliers** - this directory just contains the dataset's outlier sample files.
    * This directory is not created if there are no outlier samples. 
 
  * When the **-c** option is used, and a title is used, the files that end up in **preprocessedData** are named **MYTITLE**, **MYTITLE-clean**, and **MYTITLE-outliers**.

2. **Gene Expression Data saved as R objects.** The gene expression data generated as a consequence of the different preprocessing strategies, are saved in the **output/GSEXXX/** directory where GSEXXX is the dataset's name.

  * The gene expression data, when preprocessed altogether, is saved as **GSEXXX_gexprs_df.rsav**
  
  * The gene expression data, where just the clean samples have been preprocessed, is saved as **GSEXXX-clean_gexprs_df.rsav**
  
  * The gene expression data, where just the outlier samples have been processed, is saved as **GSEXXX-outliers_gexprs_df.rsav**
  
  *  If there are **less than two** outlier samples, then no separate preprocessing is performed - i.e., only a **GSEXXX_gexprs_df.rsav** is generated, since more than one sample is required for preprocessing to occur.
  
  * When the **-c** option isused the title is used, the gene expression data files are named **MYTITLE_gexprs_df.rsav**, **MYTITLE-clean_gexprs_df.rsav**, and **MYTITLE-outlier_gexprs_df.rsav** in a directory **output/MYTITLE/**.

3. **Data Visualizations.** There are five plots generated and placed in each dataset's respective **output/GSEXXX/** directory, for each of the two preprocessing strategies. That makes 10 plots in all, when there are two or more outlier samples. The plots include

  * **Principal Component Analysis (PCA).** These files will be titled **pca-GSEXXX-together.png** and **pca-GSEXXX-separate.png**.
  
  * **Variance Explained.** These files will be titled **variance-explained-GSEXXX-together.png** and **variance-explained-GSEXXX-separate.png**.
  
  * **Heatmap.** These files will be titled **heatmap-GSEXXX-together.png** and **heatmap-GSEXXX-separate.png**.
  
  * **Correlation Matrix.** These files will be titled **correlation-GSEXXX-together.png** and **correlation-GSEXXX-separate.png**.
  
  * **Boxplot of Values.** Thesefiles will be titled **boxplot-GSEXXX-together.png** and **boxplot-GSEXXX-separate.png** 
  
  * As stated before, when the **-c** option is used, the **GSEXXX** in the file titles will be replaced by **MYTITLE** specified in the command

### Shiny App

**_This is a very preliminary front end for the pipeline and is not even connected to it as of yet. You can host it locally by going into the `gep-app/` directory and typing `Rscript app.R`._**
