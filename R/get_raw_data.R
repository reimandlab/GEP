# This script will attempt retrieving all datasets with GPL570 only
# edit SQLite query to specify other datasets

source( "R/data_retrieval.R" )

args <- commandArgs( trailingOnly = TRUE )

if ( length( args ) == 0 ) {
    stop( "Please specify atleast one dataset - i.e., GSEXXXX.",
         call. = FALSE )
} else {
    datasets <- args
}

setwd( "data" )
con <- dbConnect( SQLite(), 'GEOmetadb.sqlite' )

setwd( "rawData" )

for( i in 1:length( datasets ) ) {
        get.raw.data( datasets[i], con )
}

dbDisconnect(con)
