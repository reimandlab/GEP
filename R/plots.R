# create plots for normalized gene expression data
library(ggplot2)
library(reshape2)


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

heatmap.together <- function(gexprs, title, outDir) {
    fname <- paste('heatmap', title, 'together', sep='-')
    gexprs.mat <- as.matrix(gexprs[-c(1,1:5)])
    ranked.gexprs <- rankByVar(gexprs.mat)
    out.file <- file.path(outDir, fname)
    print("Plotting heatmap with hierarchical clusting.")
    png(paste(out.file, 'png', sep='.'))
    heatmap(ranked.gexprs[1:1000,])
    dev.off()
}

# generate heatmap for gene expression data where outlier and clean data was 
# normalized separately

heatmap.separate <- function(gexprs.clean, gexprs.ol, title, outDir) {
    fname <- paste('heatmap', title, 'separate', sep='-')
    gexprs.cl.mat <- as.matrix(gexprs.clean[-c(1,1:5)])
    gexprs.ol.mat <- as.matrix(gexprs.ol[-c(1,1:5)])
    gexprs.mat <- cbind(gexprs.cl.mat, gexprs.ol.mat)
    ranked.gexprs <- rankByVar(gexprs.mat)
    print("Plotting heatmap with hierarchical clustering.")
    out.file <- file.path(outDir, fname)
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
correlation.together <- function(gexprs, title, outDir) {   
    fname <- paste('correlation', title, 'together', sep='-')
    gexprs.mat <- as.matrix(gexprs[-c(1, 1:5)])
    gexprs.corr <- cor(gexprs.mat, use="p")
    print("Plotting correlation matrix.")
    out.file <- file.path(outDir, fname)
    correlation.plot(gexprs.corr)
    ggsave(paste(out.file, 'png', sep='.'))
}

correlation.separate <- function(gexprs.clean, gexprs.ol, title, outDir) {
    fname <- paste('correlation', title, 'separate', sep='-')
    gexprs.cl.mat <- as.matrix(gexprs.clean[-c(1, 1:5)])
    gexprs.ol.mat <- as.matrix(gexprs.ol[-c(1, 1:5)])
    gexprs.mat <- cbind(gexprs.cl.mat, gexprs.ol.mat)
    gexprs.corr <- cor(gexprs.mat, use="p")
    print("Plotting correlation matrix.")
    out.file <- file.path(outDir, fname)
    correlation.plot(gexprs.corr)
    ggsave(paste(out.file, 'png', sep='.'))
}

boxplot.together <- function(gexprs, title, outDir) {
    fname <- paste('boxplot', title, 'together', sep='-')
    gexprs.mat <- as.matrix(gexprs[-c(1,1:5)])
    out.file <- file.path(outDir, fname)
    print("Plotting boxplot of values.")
    png(paste(out.file, 'png', sep='.'), width=3000, units='px')
    boxplot(gexprs.mat, log='y', las=2)
    dev.off()
}

boxplot.separate <- function(gexprs.clean, gexprs.ol, title, outDir) {
    fname <- paste('boxplot', title, 'separate', sep='-')
    gexprs.cl.mat <- as.matrix(gexprs.clean[-c(1, 1:5)])
    gexprs.ol.mat <- as.matrix(gexprs.ol[-c(1, 1:5)])
    gexprs.mat <- cbind(gexprs.cl.mat, gexprs.ol.mat)
    out.file <- file.path(outDir, fname)
    print("Plotting boxplot of values.")
    png(paste(out.file, 'png', sep='.'), width=3000, units='px')
    boxplot(gexprs.mat, log='y', las=2)
    dev.off() 
}
