library( affy )
library( arrayQualityMetrics )

generateAQM <- function( marray.data ) {
    # Assess quality of dataset with functions from arrayQualityMetrics package
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
    print( "done." )
    return( m )
}

filter.data <- function( aqm ) {
    # Filter low-quality arrays out
    
    # identifying outliers provided from aqm functions
    print( "Identifying outliers." )
    outliers <- c()
    for( statistic in names( aqm ) ) {
        outlier <- unlist( attributes ( aqm[[ statistic  ]]@outliers@which ), 
                          use.names = FALSE )     
        outliers <- append(outliers, outlier)
    }
    outliers <- unique( outliers )
    print( outliers )
    
    # moving outlier samples 
    print("Moving outlier samples to an 'outlier' directory." )
    if ( ! length( outliers ) == 0 ) {
        dir.create( "outliers" )
        file.copy( outliers, "outliers" )
        file.remove( outliers )
    }
 
    # Filter dataset
    #print( "Filtering low-quality arrays.")
    #filtered.marrays <- marray.data[, which( ! sampleNames(marray.data) %in% outliers ) ]
    print( "done." ) 
}
