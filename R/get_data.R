# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( GEOquery )
library( affy )

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
    sapply( list.celfiles(), gunzip )
    print( "Reading in .CEL files as an AffyBatch object." )
    affy.data <- ReadAffy()
    # altering directory structure for aroma.affymetrix package
    print( "Altering directory structure." )
    cdf.name <- cdfName( affy.data )
    print( "Creating directory named after chip type." )
    dir.create( cdf.name )
    print( "Moving .CEL files to chip directory." (
    file.copy( list.celfiles(), cdf.name )
    file.remove( list.celfiles() )
    print( "done." )
    return( affy.data )
}
