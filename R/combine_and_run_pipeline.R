# for use only on datasets that have been put through the pipeline individually

source( "R/process_data.R" )

args = commandArgs( trailingOnly= TRUE )

if ( length( args ) == 0 ) {
    stop( "Please specify atleast one dataset - i.e., GSEXXXX.",
         call. = FALSE )
} else {
    title <- args[1]
    datasets <- args[-1]
}

# combines multiple datasets and runs the pipeline on the altogether
combine.and.process <- function( title, datasets, cdf="HG-U133_Plus_2" ) {
    
    # create directory where samples of combined dataset will be copied to
    setwd( file.path( "data" ) )
    data.dir <- normalizePath( file.path( "rawData", title, cdf ) )
    dir.create( data.dir )
    outliers.files <- c()
    
    msg <- sprintf( "Moving .CEL files to %s directory for preprocessing",
                    title )
    print( msg )

    # copy sample files to combined dataset directory
    # all datasets should have already gone through the pipeline individually
    for( i in 1:length(datasets) ) {
        
        # outlier directory for datasets[i]
        ol.dir <- normalizePath( file.path( "preprocessedData", paste( datasets[i],
                                                                       "outliers",
                                                                       sep = "-" ),
                                           cdf ) )
        outlier.files <- c( outliers.files, list.celfiles( ol.dir ) )
        source.dir <- normalizePath( file.path( "preprocessedData", datasets[i], cdf ) )
        setwd( source.dir )
        file.copy( list.celfiles(), data.dir )
    }

    # this function performs all preprocessing and generates all plots    
    process.data( title, cdf, outlier.files )
}

combine.and.process( title, datasets )
