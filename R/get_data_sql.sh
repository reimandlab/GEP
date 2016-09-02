#!/bin/bash
#$ -q deb8build
#$ -cwd

source /oicr/cluster/etc/profile
module load R/3.3.0

Rscript --verbose /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/get_data_sql.R "$@" 
