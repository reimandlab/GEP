# R script for retrieving publicly accessible Gene Expression datasets
# initial support for GEO, will add ArrayExpress in the future
# Assumes user already has GEOquery package installed

#==============================================================================

library( RCurl )
library( affy )
library( GEOmetadb )

# download raw gene expression data file into 'rawData' directory
get.raw.data <- function( dataset, db.con ) {
    # check if dataset argument provided is a string as required
    stopifnot( class( dataset ) == 'character' )
    print( paste( "Getting url for dataset", dataset ) )

    # create SQL query for desired dataset
    query <- sprintf( "SELECT supplementary_file FROM gse WHERE gse='%s'", 
                     dataset )

    # use http protocol to download dataset instead of ftp
    # this improved functionality on cluster
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
    
    # create directory where to place raw data file 
    suppressWarnings( dir.create ( storedir ) )
    print( "Retreiving .tar file, contining raw .CEL files, from GEO." )

    # download raw data file
    download.file( supp_file, file.path( storedir, file.name ), 
                  mode='wb', method='wget' )
    print( "done." )
}

unpack.data <- function( ) {
    print( "Unpacking tar file containing .CEL files." )
    
    # find raw data tar file and uncompress it
    tar.file <- list.files( pattern = ".tar" )
    untar( tar.file )
    print( "Unpacking .CEL files." )

    # uncompress celfiles if the are compressed
    if ( length( grep( pattern = ".gz", list.celfiles(), value = TRUE ) ) > 0)
        sapply( list.celfiles(), gunzip )
    
    print( "Reading in .CEL files as an AffyBatch object." )
    
    # read in microarray data as an AffyBatch object
    affy.data <- ReadAffy()

    print( "Altering directory structure." )
    
    # change directory structure to accomodate aroma.affymetrix preprocessing
    # create directory named after chip type and move cel files there
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
