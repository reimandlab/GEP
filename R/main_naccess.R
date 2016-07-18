source( "R/data_retrieval.R" )


setwd( "data" )
con <- dbConnect( SQLite(), 'GEOmetadb.sqlite' )
query_ret <- dbGetQuery(con, "SELECT gse.gse FROM gse 
                              JOIN gse_gpl ON gse_gpl.gse = gse.gse 
                              WHERE gpl = 'GPL570' LIMIT 1000" )
datasets <- query_ret$gse
setwd( "rawData" )

for( i in 1:length( datasets ) ) {
        get.raw.data( datasets[i], con )
}

dbDisconnect( con )
