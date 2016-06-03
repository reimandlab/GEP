# R script for performing quality analysis and quality control on sets of 
# Microarrays. Uses arrayQualityMetrics as a tool for analyzing quality of
# arrays, then filters out low-quality arrays

#==============================================================================

library( affy )
library( arrayQualityMetrics)

generateAQMreports <- function() {
    # Loops over 20 CEL files at a time, and spits out arrayQualityMetrics
    # reports for each subset of microarrays.
    # *data too big to have all 200+ or even 50 microattays processed at a time
    
    start <- 1  # start index to choose which CEL files to process
    end <- 20  # end index, same as above
    report.num <- 1 # which [number] report is being written?
    files <- list.celfiles()
    len <- length( files )
    while ( end < len ) {
        gse.data <- ReadAffy( filenames = files[start:end] )
        arrayQualityMetrics( expressionset = gse.data,
                             outdir = file.path( "..","..", "output",
                                                paste( "aqm_report", report.num ) ),
                             force = TRUE,
                             do.logtransform = TRUE )
        start <- start + 20
        end <- end + 20
        report.num <- report.num + 1
    }

    # spit out QA reports for any left over microarrays (< 20)
    remaining.arrays <- len - start + 1
    gse.data <- ReadAffy( filenames = tail( files, remaining.arrays ) )
    arrayQualityMetrics( expressionset = gse.data,
                         outdir = file.path( "..", "..", "output",
                                            paste( "aqm_report", report.num ) ),
                         force = TRUE,
                         do.logtransform = TRUE )
}
