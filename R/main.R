source("get_data.R")
source("quality_control.R")

args <- commandArgs()
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "",  args[grep(file.arg.name, args)])
path.to.script <- dirname(normalizePath(script.name))
setwd(file.path(path.to.script,"..", "data"))
get.data("GSE64415")
setwd(file.path("GSE64415/"))
generateAQMreports()
