source( "R/data_retrieval.R" )


setwd( "data" )
con <- dbConnect( SQLite(), 'GEOmetadb.sqlite' )
gpl570_query <- "SELECT gse.gse FROM gse JOIN (SELECT * FROM gse_gpl
                                               GROUP BY gse
                                               HAVING COUNT(gpl) = 1 ) gpl
                 ON gse.gse=gpl.gse
                 WHERE gpl='GPL570' ORDER BY RANDOM() LIMIT 1000"

query_ret <- dbGetQuery( con, gpl570_query )
                             
                            
datasets <- query_ret$gse
setwd( "rawData" )

for( i in 1:length( datasets ) ) {
        get.raw.data( datasets[i], con )
}

dbDisconnect( con )
