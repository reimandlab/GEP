source( "R/data_retrieval.R" )

datasets <- c( "GSE64415", "GSE50006", "GSE48350", 
               "GSE68850", "GSE13904", "GSE76275" )

setwd( file.path( "data", "rawData" ) )

for( i in 1:length( datasets ) ) {
        get.raw.data( datasets[i] )
}
