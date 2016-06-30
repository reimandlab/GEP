# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( GEOquery )
library( affy )
library( RCurl )

find.directories <- function( url ) {
    # get a vector of all instances of 'pattern' from 'url'
    dirlist <- getURL( url, verbose = TRUE, dirlistonly = TRUE )
    dirlist <- strsplit( dirlist, "\n")[[1]]
    return( dirlist )
}

get.all.gse <- function( ) {
    # Get list of all GEO series records
    all.gse<- c()

    # first get list of all gse directory names on ftp website
    gse.url <- "ftp://ftp.ncbi.nlm.nih.gov/geo/series/"
    gse.dirs <- find.directories( gse.url )
    gse.dir.urls <- paste( gse.url, gse.dirs, "/", sep = "" )

    # then enter each gse directory and collect name of each series record
    for( i in 1:length( gse.dir.urls ) ) {
        series <- find.directories( gse.dir.urls[i] )
        all.gse <- append( all.gse, series )
    }

    return( all.gse )
}

get.raw.data <- function( dataset ) {
    # Retreives raw data CEL files for GEO datasets   
    stopifnot( class( dataset ) == "character" )
    print( "Retreiving raw .CEL files from GEO." )
    getGEOSuppFiles( dataset )
    print( "done." )
}

unpack.data <- function( ) {
    # Decompress raw data files and read as an AffyBatch object
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
    print( "Moving .CEL files to chip directory." )
    file.copy( list.celfiles(), cdf.name )
    file.remove( list.celfiles() )
    setwd( cdf.name )
    print( "done." )
    return( affy.data )
}
