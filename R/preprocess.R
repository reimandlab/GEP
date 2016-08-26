library( aroma.affymetrix )

preprocess <- function( dataset, chipType, outDir ) {   
    
    file.name <- paste( dataset, "gexprs_df.rsav", sep = "_" )
    out.file <- file.path( outDir, file.name )

    # Low level analysis of microarrays
    verbose <- Arguments$getVerbose( -8, timestamp = TRUE )

    # get annotation data files
    print( "Getting annotation data files." )
    cdf <- AffymetrixCdfFile$byChipType( chipType )
    print( cdf )
    
    # define CEL seti
    print( "Defining CEL set." )
    cs <- AffymetrixCelSet$byName( dataset, cdf = cdf )
    print(cs)

    # background adjustment and normalization
    print( "Performing background adjustment and normalization." )
    bc <- RmaBackgroundCorrection( cs )
    csBC <- process( bc, verbose = verbose )
    qn <- QuantileNormalization( csBC, typesToUpdate="pm" )
    print( qn )
    csN <- process( qn, verbose = verbose )
    print( csN )

    # summarization
    print( "Summarization" )
    plm <- RmaPlm( csN )
    print( plm )
    fit( plm, verbose = verbose )

    # quality assesment 
    #qam <- QualityAssessmentModel( plm )
    # Save 'qam' object and see if you can extract outliers
    
    ces <- getChipEffectSet( plm )
    gExprs <- extractDataFrame( ces, units = NULL, addNames = TRUE )
    save( gExprs, file = out.file )
    return( gExprs )
}
