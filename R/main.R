library( tools )
source( "R/data_retrieval.R" )
source( "R/quality_control.R" )
source( "R/preprocess.R" )
source( "R/pca.R" )

setwd( file.path( "data", "rawData" ) )

datasets <- c("GSE64415", "GSE50006", "GSE48350") 
    
for( i in 1:length( datasets ) ) {
    out.dir <- file.path( "..", "..", "output", datasets[i] )
    dir.create( out.dir )
    out.dir <- normalizePath( out.dir )
    print.string <- paste( "Processing dataset", datasets[i], "now" )
    print( print.string )
    setwd( file.path( datasets[i] ) )
    geo.data <- unpack.data()
    # if dataset has been processed go to next iteration of for-loop
    if ( is.null( geo.data ) ) { next }
    cdf <- cdfName( geo.data )
    print( "eSet:" )
    print( geo.data )
    print( "Unfiltered samples:" )
    print( list.celfiles() )
    aqm.results <- generateAQM( geo.data )
    outlier.files <- filter.data( aqm.results )
    outliers <- sapply( outlier.files, FUN = file_path_sans_ext, 
                        USE.NAMES = FALSE )
    setwd( "../../.." )
    file.of.ol <- paste( datasets[i], "outliers", sep = "-" )
    write( outliers, file.path( "..", "output", file.of.ol ) )
    # samples + outliers preprocessed together, pca
    prp.data.together <- preprocess( datasets[i], cdf, out.dir)
    pca.together( prp.data.together, datasets[i], outliers, out.dir )
    setwd( file.path( "rawData", datasets[i], cdf ) )
    # moving outlier samples
    separate.outliers( datasets[i], outlier.files, cdf )
    print( "Filtered samples: " )
    print( list.celfiles() )
    setwd( "../../.." )
    # samples + outliers preprocessed seperately, pca
    prp.data.clean <- preprocess( datasets[i], cdf, out.dir) 
    prp.data.ol <- preprocess( paste ( datasets[i], "outliers", sep = "-" ), 
                              cdf, out.dir )
    pca.separate( prp.data.clean, prp.data.ol, datasets[i], out.dir )
    setwd( "rawData" )
}
