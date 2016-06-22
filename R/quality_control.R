library( affy )
library( arrayQualityMetrics )

generateAQM <- function( marray.data ) {
    # Assess quality of dataset with functions from arrayQualityMetrics package
    out.file <- file.path( 
                "/.mounts/labs/reimandlab/private/users/nsiddiqui/R", 
                "AQM.RData" )
    m <- list()
    print("Preparing data for summary statistics.")
    x <- prepdata( marray.data, intgroup = c(), do.logtransform = TRUE )
    print( "Generating array quality metrics." )
    print( "Heatmap" )
    m$heatmap <- aqm.heatmap( x )
    print("PCA")
    m$pca <- aqm.pca( x )
    print( "Boxplot" )
    m$boxplot <- aqm.boxplot( x )
    print( "Density" )
    m$density <- aqm.density( x )
    print( "Meansd" )
    m$meansd <- aqm.meansd( x )
    print( "Probesmap" )
    m$probesmap <- aqm.probesmap( x )
    print( "Preparing data to perform Affymetrix-specific quality metrics." )
    x <- prepaffy( marray.data, x )
    print( "Generating Affymetrix-specific array quality metrics." )
    print( "RLE" )
    m$rle <- aqm.rle( x )
    print( "NUSE" )
    m$nuse <- aqm.nuse( x )
    print( "RNAdeg" )
    m$rnadeg <- aqm.rnadeg( marray.data, x )
    print( "PMMM" )
    m$pmmm <- aqm.pmmm( x )
    print( "MAplot" )
    m$maplot = aqm.maplot( x )
    print( "Saving AQM object." ) 
    save( m, file = out.file )
    print( "done." )
    return( m )
}

filter.marrays <- function( marray.data, aqm ) {
    # Filter low-quality arrays out
    
    # identifying outliers provided from aqm functions
    outliers <- c()
    for( statistic in names( aqm ) ) {
        outlier <- unlist( attributes ( aqm[[ statistic  ]]@outliers@which ), 
                          use.names = FALSE )     
        append(outliers, outlier)
    }
    
    filtered.marray <- marray.data[, which( ! sampleNames(marray.data) %in% outliers ) ]
}

