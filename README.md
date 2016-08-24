# GEP - Gene Expression Pipeline

The aim of the project is to create an interactive and automated pipeline for retrieving, processing and visualising vase public gene expression datasets

### Brief Explanation
Recent biotechnology allows us to simultaneously measure the activation of all genes in a tissue of interest . Consequently, thousands of datasets, millions of measurements, and terabytes of data have been created by scientists and are now stored in public databases such as [ArrayExpress](https://www.ebi.ac.uk/arrayexpress/) and [GEO](http://www.ncbi.nlm.nih.gov/geo/ "Gene Expression Omnibus"). Most of the data remains unused after initial depositing, however it likely hides undiscovered knowledge of genetics, biology, and disease such as cancer. This knowledge can only be revealed when all the data is analysed in a unified model. To enable such analysis, this project will create a computational toolkit to retrieve these big datasets, perform automated pre-processing and quality control with established approaches, and create summary reports and network visualizations to enable interactive exploratory analysis.


So far only the [GEO](http://www.ncbi.nlm.nih.gov/geo/ "Gene Expression Omnibus") database has been used.

### Overview of Pipeline
Data retrieval is done using the packages from [Bioconductor](https://www.bioconductor.org/). Particularly, gene expression raw data was accessed using code from [GEOquery](https://bioconductor.org/packages/release/bioc/html/GEOquery.html) and metadata for datasets was retrieved using [GEOmetadb](https://www.bioconductor.org/packages/release/bioc/html/GEOmetadb.html).
