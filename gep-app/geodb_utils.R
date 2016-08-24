library(GEOmetadb)

list.all.gpl <- function(con) {
    query <- "SELECT DISTINCT gpl FROM gse_gpl WHERE gse IN
                (SELECT gse FROM gse_gpl GROUP BY gse HAVING COUNT(gpl)=1)"
    gpl.list <- dbGetQuery(con, query)[,1]
    return(gpl.list)
}

list.all.gse <- function(con) {
    query <- "SELECT gse FROM 
                (SELECT gse FROM gse_gpl GROUP BY gse HAVING COUNT(gpl)=1)"
    gse.list <- dbGetQuery(con, query)[,1]
    return(gse.list)
}

list.gse.by.gpl <- function(con, gpl) {
    if (is.null(gpl)) 
       return(list.all.gse(con)) 
    gse.list <- c()
    for (i in 1:length(gpl)) {
        query <- sprintf(
                 "SELECT gse.gse FROM gse JOIN (SELECT * FROM gse_gpl 
                                                GROUP BY gse 
                                                HAVING COUNT(gpl)=1) gpl
                  ON gse.gse=gpl.gse WHERE gpl='%s'", gpl[i])
        gse.list <- c(gse.list, dbGetQuery(con, query)[,1])
    }
    return(gse.list)
}

count.gse.one.gpl <- function(con, gpl) {
    query <- sprintf(
             "SELECT COUNT(gse.gse) FROM gse JOIN (SELECT * FROM gse_gpl
                                                   GROUP BY gse
                                                   HAVING COUNT(gpl)=1) gpl
              ON gse.gse=gpl.gse WHERE gpl='%s'", gpl)
    cnt <- dbGetQuery(con, query)[,1]
    return(cnt)
}

count.gsm.for.gse <- function(con, gse) {
    query <- sprintf("SELECT COUNT(gsm) FROM gsm WHERE series_id='%s'", gse)
    cnt <- dbGetQuery(con, query)[,1]
    return(cnt)
}

gse.status <- function(con, gse) {
    query <- sprintf("SELECT status FROM gse WHERE gse='%s'", gse)
    status <- dbGetQuery(con, query)[,1]
    return(status)
}

gse.title <- function(con, gse) {
    query <- sprintf("SELECT title FROM gse WHERE gse='%s'", gse)
    title <- dbGetQuery(con, query)[,1]
    return(title)
}

gse.organism <- function(con, gse) {
    query <- sprintf("SELECT gpl.organism FROM gse 
                        JOIN gse_gpl ON gse.gse=gse_gpl.gse
                        JOIN gpl ON gse_gpl.gpl=gpl.gpl
                      WHERE gse.gse='%s'", gse)
    organism <- dbGetQuery(con, query)[,1]
    return(organism)
}

gse.type <- function(con, gse) {
    query <- sprintf("SELECT type FROM gse WHERE gse='%s'", gse)
    type <- dbGetQuery(con, query)[,1]
    return(type)
}

gse.summary <- function(con, gse) {
    query <- sprintf("SELECT summary FROM gse WHERE gse='%s'", gse)
    summary <- dbGetQuery(con, query)[,1]
    return(summary)
}

gse.overall.design <- function(con, gse) {
    query <- sprintf("SELECT overall_design FROM gse WHERE gse='%s'", gse)
    overall.design <- dbGetQuery(con, query)[,1]
    return(overall.design)
}

list.gsm.by.gse <- function(con, gse) {
    query <- sprintf("SELECT gsm FROM gsm WHERE series_id='%s'", gse)
    gsm.list <- dbGetQuery(con, query)[,1]
    return(gsm.list)
}

gsm.status <- function(con, gsm) {
    query <- sprintf("SELECT status FROM gsm WHERE gsm='%s'", gsm)
    status <- dbGetQuery(con, query)[,1]
    return(status)
}

gsm.title <- function(con, gsm) {
    query <- sprintf("SELECT title FROM gsm WHERE gsm='%s'", gsm) 
    title <- dbGetQuery(con, query)[,1]
    return(title)
}

gsm.type <- function(con, gsm) {
    query <- sprintf("SELECT type FROM gsm WHERE gsm='%s'", gsm)
    type <- dbGetQuery(con, query)[,1]
    return(type)
}
gsm.source <- function(con, gsm) {
    query <- sprintf("SELECT source_name_ch1 FROM gsm WHERE gsm='%s'", gsm)
    source.name <- dbGetQuery(con, query)[,1]
    return(source.name)
}

gsm.organism <- function(con, gsm) {
    query <- sprintf("SELECT organism_ch1 FROM gsm WHERE gsm='%s'", gsm)
    organism <- dbGetQuery(con, query)[,1]
    return(organism)
}

gsm.characteristics <- function(con, gsm) {
    query <- sprintf("SELECT characteristics_ch1 FROM gsm WHERE gsm='%s'", gsm)
    characteristics <- dbGetQuery(con, query)[,1]
    characteristics <- gsub('\t', '\n', characteristics)
    return(characteristics)
}

gsm.treatment_protocol <- function(con, gsm) {
    query <- sprintf("SELECT treatment_protocol_ch1 FROM gsm WHERE gsm='%s'", gsm)
    treatment_protocol <- dbGetQuery(con, query)[,1]
    return(treatment_protocol)   
}

gsm.molecule <- function(con, gsm) {
    query <- sprintf("SELECT molecule_ch1 FROM gsm WHERE gsm='%s'", gsm)
    molecule <- dbGetQuery(con, query)[,1]
    return(molecule)
}

gsm.extract_protocol <- function(con, gsm) {
    query <- sprintf("SELECT extract_protocol_ch1 FROM gsm WHERE gsm='%s'", gsm)
    extract_protocol <- dbGetQuery(con, query)[,1]
    return(extract_protocol)
}

gsm.label <- function(con, gsm) {
    query <- sprintf("SELECT label_ch1 FROM gsm WHERE gsm='%s'", gsm)
    label <- dbGetQuery(con, query)[,1]
    return(label)
}


gsm.label_protocol <- function(con, gsm) {
    query <- sprintf("SELECT label_protocol_ch1 FROM gsm WHERE gsm='%s'", gsm)
    label_protocol <- dbGetQuery(con, query)[,1]
    return(label_protocol)
}

gsm.hyb_protocol <- function(con, gsm) {
    query <- sprintf("SELECT hyb_protocol FROM gsm WHERE gsm='%s'", gsm)
    hyb_protocol <- dbGetQuery(con, query)[,1]
    return(hyb_protocol)
}

gsm.description <- function(con, gsm) {
    query <- sprintf("SELECT description FROM gsm WHERE gsm='%s'", gsm)
    description <- dbGetQuery(con, query)[,1]
    return(description)
}

gsm.data_processing <- function(con, gsm) {
    query <- sprintf("SELECT data_processing FROM gsm WHERE gsm='%s'", gsm)
    data_processing <- dbGetQuery(con, query)[,1]
    return(data_processing)
}
