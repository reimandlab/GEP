# 1. preprocess outliers and filtered data seperately, merge, pca
# 2. preprocess entire dataset together, pca
# 3. preprocess all datasets seperately, merge, pca
# 4. preprocess all datasets together, pca

library( ggplot2 )

pca <- function( data, title, outliers ) {
    #perform pca
    pca.df <- prcomp( data )
    rotation <- pca$rotation
    # create data frame for ggplot2, type column to identify outliers
    # 1 - regular sample, 0 - outlier sample
    pca.df <- data.frame( type = 1, PC1 = rotation[,1], PC2 = rotation[,2] )
    pca.df[ which( rownames( pca.df ) %in% outliers ), ]$type <- 0

    # create plot
    ggplot( pca.df, aes( x = PC1, y = PC2, colour = factor( type ) )) +
        geom_point() +
        scale_colour_discrete( name = "Type", labels =
                             c( "Outlier samples", "Regular samples" )) +
        ggtitle( sprintf("Principal Component Analysis - %s", title ))
    
    dest <- paste( "pca-", title, ".png", "" )
    ggsave(dest, path = file.path("..", "output" ) )
}

pca.together <- function( data, title, outliers ) {
    # only numeric columns
    title <- paste( title, 'together', sep = '-' )
    data.matrix <- as.matrix( data[ -c( 1, 1:5 ) ] )
    pca( data.matrix, title, outliers )
}

pca.separate <- function( clean.data, ol.data, title ) {
    # identify outlier samples
    title <- paste( title, 'seperate', sep = '-' )
    outliers <- names( ol.data[ -c( 1, 1:5 ) ] )
    matrix.clean <- as.matrix( clean.data[ -c( 1, 1:5 ) ] )
    matrix.ol <- as.matrix( ol.data[ -c( 1, 1:5 ) ] )
    data.matrix <- cbind( matrix.clean, matrix.ol )
    pca( data.matrix, title, outliers )
}
