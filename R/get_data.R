# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( GEOquery )
library( R.utils )

get.data <- function( dataset ) {
    # Retreives raw data CEL files for GEO datasets   
    stopifnot( class( dataset ) == "character" )
    print( "Retreiving raw .CEL files from GEO." )
    getGEOSuppFiles( dataset )
    print( "done." )
}


unpack.data <- function() {
    # Decompress raw data files and read as an AffyBatch objecti
    print( "Unpacking tar file containing .CEL files." )
    tar.file <- list.files( pattern = ".tar" )
    untar( tar.file )
    print( "Unpacking .CEL files." )
    cels <- list.files( pattern = "[gz]" )
    sapply( cels, gunzip )
    print( "done." )
}
