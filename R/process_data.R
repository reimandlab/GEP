library( tools )
source( "R/preprocess.R" )
source( "R/plots.R" )

# creates different directories to store clean and outlier samples in
# aroma preprocessing requires this to preprocess them separately
separate.outliers <- function( dataset, outliers, clean, cdf) {
    print("Moving outlier samples to an 'outlier' directory." )
        if ( ! length( outliers ) == 0 ) {
            dir.name <- paste( dataset, "outliers", sep = "-" )
            rel.path <- file.path( "..", "..", dir.name )
            dir.create( rel.path )
            rel.path <- file.path( rel.path, cdf )
            dir.create( rel.path )
            abs.path <- normalizePath( rel.path )
            file.copy( outliers, abs.path )
        }
        if ( ! length( clean ) == 0 ) {
            dir.name <- paste( dataset, "clean", sep = "-" )
            rel.path <- file.path("..", "..", dir.name )
            dir.create( rel.path )
            rel.path <- file.path( rel.path, cdf )
            dir.create( rel.path )
            abs.path <- normalizePath( rel.path )
            file.copy( clean, abs.path )
        }
}

# moves preprocessed data to preprocessedData directory
move.preprocessed.data <- function( dataset ) {
    file.copy( file.path( "rawData", dataset ), file.path( "preprocessedData" ),
               recursive = TRUE )
    unlink( file.path( "rawData", dataset ), recursive = TRUE )
}

process.data <- function( dataset, cdf, outliers.files ) {

    # go to data directory, which must be the working directory to execute
    # preprocessing with aroma on dataset
    setwd( "../../.." )

    # create output directory named after dataset being currently processed
    out.dir <- normalizePath( file.path("..", "output", dataset) )
    if( !dir.exists( out.dir ) ) dir.create( output.dir )
    outliers <- sapply( outlier.files, FUN = file_path_sans_ext,
                        USE.NAMES = FALSE )

    # creating a text file in the output directory containing a list of
    # outliers in the dataset
    file.of.ol <- paste( dataset, "outliers", sep = "-" )
    write( outliers, file.path( out.dir, file.of.ol ) )

    # preprocess clean and outlier samples together
    preprocessed.data.together <- preprocess( dataset, cdf, out.dir )

    # generate PCA plot of the above preprocessed data
    pca.together( preprocessed.data.together, dataset, outliers, out.dir )
    
    # generate heatmap " " " " "
    heatmap.together( preprocessed.data.together, dataset, out.dir )

    # generate correaltion matrix " " " " " 
    correlation.together( preprocessed.data.together, dataset, out.dir )

    # generate boxplot of values  " " " " "
    boxplot.together( preprocessed.data.together, dataset, out.dir )

    # identify and store all file names for clean samples
    setwd( file.path( "rawData", dataset, cdf ) )
    clean.files <- dir()[ which( ! dir() %in% outlier.files ) ]

    # separate outlier and clean samples to different directories to
    # allow for aroma to be able to preprocess the data separately
    separate.outliers( dataset, outlier.files, clean.files, cdf )
    
    # printing list of clean samples
    print( "Filtered samples: " )
    setwd( "../.." )
    filtered <- list.celfiles( file.path( paste( dataset, "clean", sep = "-" ),
                                          cdf ) )
    print( filtered )
    
    # preprocessing doesn't make sense or work when there are 0 or 1 microarrays 
    if ( length( filtered ) <= 1 ) {
        stop( "Less than two clean microarrays - no need for separate preprocessing." )
    }
    if ( length( outliers ) <= 1 ) {
        stop( "Less than two outlier microarrays - no need for separate preprocessing." )
    }

    # again, go to data directory to accommodate aroma preprocessing
    setwd( ".." )
    
    # move preprocessed data to preprocessedData directory
    move.preprocessed.data( dataset )

    # preprocess clean and outlier samples separately
    preprocessed.clean.data <- preprocess( paste( dataset, "clean", sep = "-" ),
                                           cdf, out.dir )
    preprocessed.outlier.data <- preprocess( paste( dataset, "outliers", sep = "-"),
                                             cdf out.dir )
    
    # generate PCA plot of the above preprocessed data
    pca.separate( preprocessed.clean.data, preprocessed.outlier.data, dataset, out.dir )

    # generate heatmap " " " " "
    heatmap.separate( preprocessed.clean.data, preprocessed.outlier.data, dataset, out.dir )

    # generate correlation matrix " " " " "
    correlation.separate( preprocessed.clean.data, preprocessed.outlier.data, dataset, out.dir )

    # generate boxplot of values " " " " "
    boxplot.separate( preprocessed.clean.data, preprocessed.outlier.data, dataset, out.dir )

    # move preprocessed data to preprocessedData directory
    move.preprocessed.data( paste( dataset, "clean", sep = "-" ) )
    move.preprocessed.data( paste( dataset, "outliers", sep = "-" ) )

}
