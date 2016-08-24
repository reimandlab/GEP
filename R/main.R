library( tools )
source( "R/data_retrieval.R" )
source( "R/quality_control.R" )
source( "R/preprocess.R" )
source( "R/pca.R" )
source( "R/plots.R" )

setwd( file.path( "data", "rawData" ) )

args = commandArgs( trailingOnly= TRUE )

if ( length( args ) == 0 ) {
    stop( "Please specify atleast one dataset - i.e., GSEXXXX.",
         call. = FALSE )
} else {
    datasets <- args
}

run <- function(datasets) {
    for( i in 1:length( datasets ) ) {
        if ( grepl("clean", datasets[i]) || grepl("outliers", datasets[i] ))
            next
        out.dir <- file.path( "..", "..", "output", datasets[i] )
        if (!dir.exists(out.dir)) dir.create( out.dir )
        out.dir <- normalizePath( out.dir )
        print.string <- paste( "Processing dataset", datasets[i], "now" )
        print( print.string )
        setwd( file.path( datasets[i] ) )
        geo.data <- unpack.data()
        # if dataset has been processed go to next iteration of for-loop
        if ( is.null( geo.data ) ) next
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
        write( outliers, file.path( out.dir, file.of.ol ) )
        # samples + outliers preprocessed together, pca
        prp.data.together <- preprocess( datasets[i], cdf, out.dir)
        pca.together( prp.data.together, datasets[i], outliers, out.dir )
        heatmap.together( prp.data.together, datasets[i], out.dir )
        correlation.together( prp.data.together, datasets[i], out.dir )
        boxplot.together( prp.data.together, datasets[i], out.dir )
        setwd( file.path( "rawData", datasets[i], cdf ) )
        clean.files <- dir()[ which( ! dir()  %in% outlier.files ) ]
        # moving outlier samples
        separate.outliers( datasets[i], outlier.files, clean.files, cdf )
        print( "Filtered samples: " )
        setwd("../..")
        print( list.celfiles( file.path(paste(datasets[i], "clean", sep="-" ),
                                        cdf ) ) )
        if ( length(outliers) == 0 ) next
        setwd( ".." )
        # samples + outliers preprocessed seperately, pca
        prp.data.clean <- preprocess( paste ( datasets[i], "clean", sep = "-"), 
                                     cdf, out.dir) 
        prp.data.ol <- preprocess( paste ( datasets[i], "outliers", sep = "-" ), 
                                  cdf, out.dir )
        pca.separate( prp.data.clean, prp.data.ol, datasets[i], out.dir )
        heatmap.separate( prp.data.clean, prp.data.ol, datasets[i], out.dir )
        correlation.separate( prp.data.clean, prp.data.ol, datasets[i], out.dir )
        boxplot.separate( prp.data.clean, prp.data.ol, datasets[i], out.dir )
        setwd( "rawData" )
    }
}

run(datasets)
