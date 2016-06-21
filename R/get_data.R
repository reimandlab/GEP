# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( GEOquery )
library( affy )
library( R.utils )

get.data <- function( dataset ) {
    
    stopifnot( class( dataset ) == "character" )
    getGEOSuppFiles( dataset )
    print( file.path(dataset) )
    print( getwd() )
    setwd( file.path( "GSE64415" ) )
    tar.file <- list.files( pattern = ".tar" )
    untar( tar.file )
    cel.files <- sapply( list.celfiles(), gunzip )
    affy.data <- ReadAffy( filenames = cel.files )
    setwd( file.path( ".." ) )
    unlink( dataset, recursive = TRUE )
    return( affy.data )
}


