# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( GEOquery )

get.data <- function( dataset ) {
    # Retrieves specified dataset from public database
    #
    # Args:
    #   dataset: character string naming desired dataset, specified by user

    # Enforce datatype of 'dataset' parameter
    stopifnot( class( dataset ) == "character" )
    print(dataset)
    # if GEO dataset:
    getGEOSuppFiles( dataset )
    # if ArrayExpress dataset 
    # ...
}
