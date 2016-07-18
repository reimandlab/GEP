library( tools )
source( "R/data_retrieval.R" )
source( "R/quality_control.R" )
source( "R/preprocess.R" )
source( "R/pca.R" )

setwd( file.path( "data", "rawData" ) )

datasets <- dir()

for( i in 1:length( datasets ) ) {
    print.string <- paste( "Processing dataset", datasets[i], "now" )
    print( print.string )
    setwd( file.path( datasets[i] ) )
    geo.data <- unpack.data()
    cdf <- cdfName( geo.data )
    print( "eSet:" )
    print( geo.data )
    print( "Unfiltered samples:" )
    print( list.celfiles() )
    aqm.results <- generateAQM( geo.data )
    outliers <- sapply( filter.data( aqm.results ), 
                       FUN = file_path_sans_ext, USE.NAMES = FALSE )
    setwd( "../../.." )
    # samples + outliers preprocessed together, pca
    prp.data.together <- preprocess( datasets[i], cdf )
    pca.together( prp.data.together, datasets[i], outliers )
    setwd( file.path( "rawData", datasets[i], cdf ) )
    # moving outlier samples
    print("Moving outlier samples to an 'outlier' directory." )
    if ( ! length( outliers ) == 0 ) {
        dir.name <- paste( datasets[i], "outliers", sep = "-" )
        rel.path <- file.path( "..", "..", dir.name )
        dir.create( rel.path )
        rel.path <- file.path( rel.path, cdf )
        dir.create( rel.path )
        abs.path <- normalizePath( rel.path )
        file.copy( outliers, abs.path )
        file.remove( outliers )
    }
    print( "Filtered samples: " )
    print( list.celfiles() )
    setwd( "../../.." )
    # samples + outliers preprocessed seperately, pca
    prp.data.clean <- preprocess( datasets[i], cdf ) 
    prp.data.ol <- preprocess( paste ( datasets[i], "outliers", sep = "-"), 
                              cdf )
    pca.separate( prp.data.clean, prp.data.ol, datasets[i] )
    setwd( "rawData" )
}
