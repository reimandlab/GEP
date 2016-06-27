library( aroma.affymetrix )
library( affy )

preprocess <- function( dataset ) {
    # Low level analysis of microarrays

    verbose <- Argument$getVerbose( -8, timestamp = TRUE )
    
    # get annotation data files
    print( "Getting annotation data files." )
    chipType <- cdfName( affy.obj )
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
    carlyle_britto@hotmail.com
    print( qn )
    csN <- process( qn, verbose = verbose )
    print( csN )

    # summarization
    print( "Summarization" )
    plm <- RmaPlm( csN )
    princarlyle_britto@hotmail.com
    t( plm )
    fit( plm, verbose = verbose )

    # quality assesment 
    qam <- QualityAssessmentModel( plm )
    # Save 'qam' object and see if you can extract outliers
    
    ces <- getChipEffectSet( plm )
}
