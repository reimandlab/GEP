# run_pipeline.R is fed one dataset on which it executes the computational pipeline

source( "R/data_retrieval.R" )
source( "R/quality_control.R" )
source( "R/process_data.R" )

# parse arguments - expecting a single dataset

args <- commandArgs( trailingOnly= TRUE )

if ( length( args ) == 0 ) {
    stop( "Please specify a dataset - i.e., GSEXXXX.",
         call. = FALSE )
} else {
    dataset <- args
}

# executes computational pipeline on dataset

run.pipeline <- function( dataset ) {
    
    # check if dataset has been preprocessed
    setwd( file.path("data") )
    preprocessed.datasets <- list.files("preprocessedData")
    if( dataset %in% preprocessed.datasets )
        stop( "This dataset has already been processed" ) 
    
    # go to rawData directory where raw gene expression data files are located 
    setwd( file.path( "rawData" ) )

    print.string <- paste( "Processing dataset", dataset, "now" )
    print( print.string )

    # set directory to directory named after current dataset
    # this is where compressed the raw gene expression data file resides
    setwd( file.path( dataset ) )

    # unpacking compressed raw gene expression data file
    # the unpacking function returns an AffyBatch object
    # it returns null if the dataset has already been processed
    geo.data <- unpack.data()

    # get the chip type of the dataset
    cdf <- cdfName( geo.data )

    print( "eSet:" )
    print( geo.data )
    print( "Unfiltered samples:" )
    print( list.celfiles() )
    
    # perform array quality metrics
    # aqm function returns an aqm object that contains outliers
    aqm.results <- generateAQM( geo.data )

    # extract and identify outlier samples from aqm object
    outlier.files <- filter.data( aqm.results )
    
    # this function performs all preprocessing and generates any outputs
    process.data( dataset, cdf, outlier.files )

}

run.pipeline(dataset)
