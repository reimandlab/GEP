# 1. preprocess outliers and filtered data seperately, merge, pca
# 2. preprocess entire dataset together, pca
# 3. preprocess all datasets seperately, merge, pca
# 4. preprocess all datasets together, pca

library( ggplot2 )

pca <- function( data, title, outliers, outDir) {
    #perform pca
    pca.df <- prcomp( data )
    rotation <- pca.df$rotation
    # create data frame for ggplot2, type column to identify outliers
    # 1 - regular sample, 0 - outlier sample
    pca.df <- data.frame( type = 1, PC1 = rotation[,1], PC2 = rotation[,2] )
    pca.df[ which( rownames( pca.df ) %in% outliers ), ]$type <- 0

    # create plot
    print( "Plotting PCA graph." )
    ggplot( pca.df, aes( x = PC1, y = PC2, colour = factor( type ) )) +
        geom_point() +
        scale_colour_discrete( name = "Type", labels =
                             c( "Outlier samples", "Regular samples" )) +
        ggtitle( sprintf("Principal Component Analysis - %s", title ))
    
    dest <- file.path( outDir, 
                      paste( "pca-", title, ".png", sep = "" ) )
    
    print( "Saving plot." )
    ggsave( dest )
}

pca.together <- function( data, title, outliers, outDir ) {
    print( "Performing Principle Component Analysis on all data together." )
    title <- paste( title, 'together', sep = '-' )
    # only numeric columns
    data.matrix <- as.matrix( data[ -c( 1, 1:5 ) ] )
    pca( data.matrix, title, outliers, outDir )
}

pca.separate <- function( clean.data, ol.data, title, outDir ) {
    print( "Performing Principle Component Analysis 
            on clean/outlier data separately." )
    title <- paste( title, 'seperate', sep = '-' )
    # identify outliers
    outliers <- names( ol.data[ -c( 1, 1:5 ) ] )
    # numeric columns
    matrix.clean <- as.matrix( clean.data[ -c( 1, 1:5 ) ] )
    matrix.ol <- as.matrix( ol.data[ -c( 1, 1:5 ) ] )
    data.matrix <- cbind( matrix.clean, matrix.ol )
    pca( data.matrix, title, outliers, outDir )
}
