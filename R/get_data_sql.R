# This script will attempt retrieving all datasets with GPL570 only
# edit SQLite query to specify other datasets
# comment
library(GEOmetadb)
source( "R/data_retrieval.R" )


args <- commandArgs( trailingOnly = TRUE )

if ( length( args ) == 0 ) {
    query <- "SELECT gse.gse FROM gse JOIN (SELECT * FROM gse_gpl
                                            GROUP BY gse
                                            HAVING COUNT(gpl) = 1) gpl
              ON gse.gse=gpl.gse
              WHERE gpl='GPL570' ORDER BY RANDOM()"
} else if ( length( args ) == 1 ) {
    query <- args
} else {
    stop( "Please provide a single SQL query as a string for the argument" )
}

setwd( "data" )
getSQLiteFile()
con <- dbConnect( SQLite(), 'GEOmetadb.sqlite' )

query_ret <- dbGetQuery( con, query )
                             
                            
datasets <- query_ret$gse
setwd( "rawData" )

for( i in 1:length( datasets ) ) {
        get.raw.data( datasets[i], con )
}

dbDisconnect( con )
