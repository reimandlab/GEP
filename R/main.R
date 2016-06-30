source( "R/data_retrieval.R" )
source( "R/quality_control.R" )
source( "R/preprocess.R" )

setwd( file.path( "data", "rawData" ) )

datasets <- dir()

for( i in 1:length( datasets ) ) {
    print.string <- paste( "Processing dataset", datasets[i], "now" )
    print( print.string )
    setwd( file.path( datasets[i] ) )
    geo.data <- unpack.data()
    print( "eSet:" )
    print( geo.data )
    print( "Unfiltered samples:" )
    print( list.celfiles() )
    aqm.results <- generateAQM( geo.data )
    filter.data( aqm.results, datasets[i] )
    print( "Filtered samples: " )
    print( list.celfiles() )
    setwd( "../../.." )
    preprocessed.data <- preprocess( dataset, cdfName( geo.data ) )
    setwd( file.path( "data", "rawData" ) )
}

