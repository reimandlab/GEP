# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( RCurl )
library( affy )
library( GEOmetadb )

get.raw.data <- function( dataset, db.con ) {
    # Retreives raw data CEL files for GEO datasets
    stopifnot( class( dataset ) == 'character' )
    print( paste( "Getting url for dataset", dataset ) )
    query <- sprintf( "SELECT supplementary_file FROM gse WHERE gse='%s'", 
                     dataset )
    # downloading files from http url works better on cluster
    supp_file <- sub( "ftp", "http", dbGetQuery( db.con, query ) )
    supp_file <- strsplit( supp_file, ";")[[1]][1]
    file.name <- tail( strsplit( supp_file, '/' )[[1]], n = 1 )
    
    # dataset doesn't exist or not found in GEOmetadb
    if ( !url.exists( supp_file ) ) {
        message( 'Supplemental file URL not found.' )
        message( 'Check URL manually if in doubt' )
        message( supp_file )
        print( "No supplementary files found" )
        return( 1 )
    }

    storedir <- file.path( getwd(), dataset )
    
    # check if dataset already exists locally
    if ( file.exists( storedir ) &&
         file.exists( file.path( storedir, file.name ) ) ) {
         print( "Already exists!" )
         return( 1 )
    }

    suppressWarnings( dir.create ( storedir ) )
    print( "Retreiving .tar file, contining raw .CEL files, from GEO." )
    download.file( supp_file, file.path( storedir, file.name ), 
                  mode='wb', method='wget' )
    print( "done." )
}

unpack.data <- function( ) {
    # Decompress raw data files and read as an AffyBatch object
    print( "Unpacking tar file containing .CEL files." )
    tar.file <- list.files( pattern = ".tar$" )
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
