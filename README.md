# GEP - Gene Expression Pipeline

The aim of the project is to create an interactive and automated pipeline for retrieving, processing and visualising vase public gene expression datasets

### Brief Explanation
Recent biotechnology allows us to simultaneously measure the activation of all genes in a tissue of interest . Consequently, thousands of datasets, millions of measurements, and terabytes of data have been created by scientists and are now stored in public databases such as [ArrayExpress](https://www.ebi.ac.uk/arrayexpress/) and [GEO](http://www.ncbi.nlm.nih.gov/geo/ "Gene Expression Omnibus"). Most of the data remains unused after initial depositing, however it likely hides undiscovered knowledge of genetics, biology, and disease such as cancer. This knowledge can only be revealed when all the data is analysed in a unified model. To enable such analysis, this project will create a computational toolkit to retrieve these big datasets, perform automated pre-processing and quality control with established approaches, and create summary reports and network visualizations to enable interactive exploratory analysis.


So far only the [GEO](http://www.ncbi.nlm.nih.gov/geo/ "Gene Expression Omnibus") database has been used.

### Overview of Pipeline
Data retrieval is done using the packages from [Bioconductor](https://www.bioconductor.org/). Particularly, gene expression raw data was accessed using code from [GEOquery](https://bioconductor.org/packages/release/bioc/html/GEOquery.html) and metadata for datasets was retrieved using [GEOmetadb](https://www.bioconductor.org/packages/release/bioc/html/GEOmetadb.html).

Quality control was performed by the [arrayQualityMetrics](https://bioconductor.org/packages/release/bioc/html/arrayQualityMetrics.html) package from [Bioconductor](https://www.bioconductor.org/).

Normalisation, correction, and preprocessing was performed using code from the [aroma.affymetrix](https://cran.r-project.org/web/packages/aroma.affymetrix/index.html) package - particularly the [Gene 1.0 ST Array Analysis](http://www.aroma-project.org/vignettes/GeneSTArrayAnalysis/) protocol.

Other packages used include [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html) for downloading data, [affy](http://bioconductor.org/packages/release/bioc/html/affy.html) for reading data, and [ggplot2](http://ggplot2.org/) and [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html) for generating different plots of the data.


### Use

So far this collection of R code has been designed to be used in an OICR's SGE HPC Cluster environment. 

**_You must be in the GEP directory (the top level project directory) when submitting jobs._**

For data retrieval the get_raw_data.R script was written, which is submitted the cluster with the get_raw_data.sh script. This script requires network access, so the bash script has been written so the data retrieval job is submitted to a build node which has network access. To submit a job to retrieve raw gene expression data, type the following in the cluster environment

`qsub R/get_raw_data.sh`

To run the pipeline and have it generate the outputs it is supposed to, the main.R script was written. As before, to submit this to the cluster you use the main.sh bash script. To run the pipeline, simply type the following in the cluster environment

`qsub R/run_pipeline.sh [list of datasets]` 

The list of datasets are the ones that were retrieved using the script mentioned above. Specifically, datasets we're looking at are GEO  Series denoted by titles such as GSExxx - [here](http://www.ncbi.nlm.nih.gov/geo/browse/?view=series "GEO Series") is a where they are all listed.

In order to combine the samples from different datasets, and run the the pipeline on these samples together, the combine_and_run_pipeline.R script was written and it's corresponsing job sumission script combine_and_run_pipeline.sh. To use, type

`qsub R/combine_and_run_pipeline.sh [title] [list of datasets]`

Where the title specifies the directory name to save data/outputs under and the list of datasets refers to the list of GEO Series (GSExxx) datasets you wish to combine.

### Outputs

Outputs from running the pipeline are all dumped into the outputs directory - within it, for each dataset put through the pipeline, there is a directory named after the dataset which will contain all of that dataset's respective outputs. This includes the gene expression data when all of the samples in the dataset are preprocessed together, the gene expression data of just the clean samples preprocessed together, and gene expression data just for the outlier samples preprocessed together. Besides this gene expression data, a number of plots are genberate using both strategies where clean and outlier samples are preprecessed together and separately. The plots include Principal Component Anaysis (PCA), variance explained by each component, boxplot of values, heatmaps, and correlation matrices.

### Shiny App

