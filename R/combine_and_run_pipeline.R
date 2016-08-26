# for use only on datasets that have been put through the pipeline

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
    title <- args[1]
    datasets <- args[-1]
}



combine.and.process <- function( title, cdf, datasets ) {
    out.dir <- normalizePath( file.path( "output", title ) )
    dir.create( output.dir )
    data.dir <- normalizePath( file.path( "data", "rawData", title, cdf ) )
    dir.create( data.dir )
    outliers <- c()
    
    msg <- sprintf( "Moving .CEL files to %s directory for preprocessing",
                    title )
    print( msg )
    for( i in 1:length(datasets) ) {
        ol.dir <- normalizePath( file.path( "data", "rawData", 
                             paste(datasets[i], "outliers", sep = "-"),
                             cdf ) )
        outlier.files <- c( outliers.files, list.celfiles( ol.dir ) )
        source.dir <- file.path( "data", "rawData", datasets[i], cdf )
        source.dir <- normalizePath( source.dir )
        setwd( source.dir )
        file.copy( list.celfiles(), data.dir )
        setwd( "../../.." )
    }

    outliers <- sapply( outlier.files, FUN = file_pat_sans_ext, 
                       USE.NAMES = FALSE )
    file.of.ol <- paste( datasets[i], "outliers", sep = "-" )
    write( outliers, file.path( out.dir, file.of.ol ) )
    prp.data.together <- preprocess( title, cdf, out.dir ) 
    pca.together( prp.data.together, title, outliers, out.dir )
    heatmap.together( prp.data.together, title, out.dir )
    correlation.together( prp.data.together, title, out.dir )
    boxplot.together( prp.data.together, title, out.dir )
    setwd( file.path("rawData", title, cdf ) )
    clean.files <- dir()[ which( ! dir() %in% outlier.files ) ]
    separate.outliers( title, outlier.files, clean.files, cdf )
    setwd("../../..")
    prp.data.clean <- preprocess( paste( title, "clean", sep = "-" ),
                                  cdf, out.dir)
    prp.data.ol <- preprocess( paste( title, "outliers", sep = "-" ),
                               cdf, out.dir )
    pca.separate( prp.data.clean, prp.data.ol, title, out.dir )
    heatmap.separate( prp.data.clean, prp.data.ol, title, out.dir )
    correlation.separate( prp.data.clean, prp.data.ol, title, out.dir )
    boxplot.separate( prp.data.clean, prp.data.ol, title. out.dir)
}

combine.and.process( title, "HG-U133_Plus_2", datasets)
