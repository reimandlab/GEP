# create plots for normalized gene expression data
library(ggplot2)
library(reshape2)

pca <- function( data, title, outliers, out.dir) {
    #perform pca
    pca.df <- prcomp( data )
    rotation <- pca.df$rotation
    # generate variance explained plot
    # Eigenvalues
    eig <- (pca.df$sdev)^2
    #variances in percentage
    variance <- eig*100/sum(eig)
    # Cumulative variances
    cumvar <- cumsum(variance)
    eig.data <- data.frame( eig = eig, variance = variance,
                            cumvariance = cumvar )
    out.file <- file.path( out.dir,
                       paste( "variance", "explained", title, sep="-" ))
    print("Plotting variance graph.")
    png( paste( out.file, 'png', sep='.' ) )
    barplot( eig.data[, 2][1:10], names.arg=1:10,
             main  = "Variance",
             xlab = "Principal Components",
             ylab = "Percentage of variances",
             ylim = c(-10, 100),
             col = "steelblue" )
    lines( x=1:10, eig.data[, 2][1:10], type="b", pch=19, col="red" )
    dev.off()
    # create data frame for ggplot2, type column to identify outliers
    # 1 - regular sample, 0 - outlier sample
    pca.df <- data.frame( name = rownames(rotation), type = 1, 
                         PC1 = rotation[,1], PC2 = rotation[,2] )
    if(nrow(pca.df[which(rownames(pca.df) %in% outliers),]) != 0)
        pca.df[ which( rownames( pca.df ) %in% outliers ), ]$type <- 0

    # create plot
    print( "Plotting PCA graph." )
    ggplot( pca.df, aes( x = PC1, y = PC2, colour = factor( type ) )) +
        geom_point() +
        scale_colour_discrete( name = "Type", labels =
                             c( "Outlier samples", "Regular samples" )) +
        ggtitle( sprintf("Principal Component Analysis - %s", title ))
    
    dest <- file.path( out.dir, 
                      paste( "pca-", title, ".png", sep = "" ) )
    
    print( "Saving plot." )
    ggsave( dest )
}

pca.together <- function( data, title, outliers, out.dir ) {
    print( "Performing Principle Component Analysis on all data together." )
    title <- paste( title, "together", sep = "-" )
    # only numeric columns
    data.matrix <- as.matrix( data[ -c(1, 1:5) ] )
    pca( data.matrix, title, outliers, out.dir )
}

pca.separate <- function( clean.data, ol.data, title, out.dir ) {
    print( "Performing Principle Component Analysis on clean/outlier data separately." )
    title <- paste( title, "separate", sep = "-" )
    # identify outliers
    outliers <- names( ol.data[ -c( 1, 1:5 ) ] )
    # numeric columns
    matrix.clean <- as.matrix( clean.data[ -c( 1, 1:5 ) ] )
    matrix.ol <- as.matrix( ol.data[ -c( 1, 1:5 ) ] )
    data.matrix <- cbind(matrix.clean, matrix.ol )
    pca( data.matrix, title, outliers, out.dir )
}

# calculate variance of a row (gene)

RowVar <- function(x) {
    rowSums((x-rowMeans(x))^2)/(dim(x)[2]-1)
}

# rank genes in gene expression by variance

rankByVar <- function(gexprs.mat) {
    gexprs.df <- data.frame( variance = RowVar(gexprs.mat), gexprs.mat)
    gexprs.mat <- as.matrix(gexprs.df)
    gexprs.sorted <- gexprs.mat[order(gexprs.mat[,1], decreasing=TRUE),]
    return(gexprs.sorted[,-1])
}

# generate heatmap for gene expression data where outlier and clean data was 
# normalized together

heatmap.together <- function(gexprs, title, out.dir) {
    fname <- paste('heatmap', title, 'together', sep='-')
    gexprs.mat <- as.matrix(gexprs[-c(1,1:5)])
    ranked.gexprs <- rankByVar(gexprs.mat)
    out.file <- file.path(out.dir, fname)
    print("Plotting heatmap with hierarchical clusting.")
    png(paste(out.file, 'png', sep='.'))
    heatmap(ranked.gexprs[1:1000,])
    dev.off()
}

# generate heatmap for gene expression data where outlier and clean data was 
# normalized separately

heatmap.separate <- function(gexprs.clean, gexprs.ol, title, out.dir) {
    fname <- paste('heatmap', title, 'separate', sep='-')
    gexprs.cl.mat <- as.matrix(gexprs.clean[-c(1,1:5)])
    gexprs.ol.mat <- as.matrix(gexprs.ol[-c(1,1:5)])
    gexprs.mat <- cbind(gexprs.cl.mat, gexprs.ol.mat)
    ranked.gexprs <- rankByVar(gexprs.mat)
    print("Plotting heatmap with hierarchical clustering.")
    out.file <- file.path(out.dir, fname)
    png(paste(out.file, 'png', sep='.'))
    heatmap(ranked.gexprs[1:1000,])
    dev.off()
}

correlation.plot <- function(corr.data) {
    qplot(x=Var1, y=Var2, data=melt(corr.data), fill=value, geom='tile') +
        theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
              axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
        scale_fill_gradient2(limits=c(-1,1))
}
correlation.together <- function(gexprs, title, out.dir) {   
    fname <- paste('correlation', title, 'together', sep='-')
    gexprs.mat <- as.matrix(gexprs[-c(1, 1:5)])
    gexprs.corr <- cor(gexprs.mat, use="p")
    print("Plotting correlation matrix.")
    out.file <- file.path(out.dir, fname)
    correlation.plot(gexprs.corr)
    ggsave(paste(out.file, 'png', sep='.'))
}

correlation.separate <- function(gexprs.clean, gexprs.ol, title, out.dir) {
    fname <- paste('correlation', title, 'separate', sep='-')
    gexprs.cl.mat <- as.matrix(gexprs.clean[-c(1, 1:5)])
    gexprs.ol.mat <- as.matrix(gexprs.ol[-c(1, 1:5)])
    gexprs.mat <- cbind(gexprs.cl.mat, gexprs.ol.mat)
    gexprs.corr <- cor(gexprs.mat, use="p")
    print("Plotting correlation matrix.")
    out.file <- file.path(out.dir, fname)
    correlation.plot(gexprs.corr)
    ggsave(paste(out.file, 'png', sep='.'))
}

boxplot.together <- function(gexprs, title, out.dir) {
    fname <- paste('boxplot', title, 'together', sep='-')
    gexprs.mat <- as.matrix(gexprs[-c(1,1:5)])
    out.file <- file.path(out.dir, fname)
    print("Plotting boxplot of values.")
    png(paste(out.file, 'png', sep='.'), width=3000, units='px')
    boxplot(gexprs.mat, log='y', las=2)
    dev.off()
}

boxplot.separate <- function(gexprs.clean, gexprs.ol, title, out.dir) {
    fname <- paste('boxplot', title, 'separate', sep='-')
    gexprs.cl.mat <- as.matrix(gexprs.clean[-c(1, 1:5)])
    gexprs.ol.mat <- as.matrix(gexprs.ol[-c(1, 1:5)])
    gexprs.mat <- cbind(gexprs.cl.mat, gexprs.ol.mat)
    out.file <- file.path(out.dir, fname)
    print("Plotting boxplot of values.")
    png(paste(out.file, 'png', sep='.'), width=3000, units='px')
    boxplot(gexprs.mat, log='y', las=2)
    dev.off() 
}
