#!/bin/bash
#$ -q deb6build
#$ -cwd
#$ -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/getbigdata.log
#$ -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/getbigdata.err

source /oicr/cluster/etc/profile
module load R/3.3.0

Rscript --verbose /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/main_naccess.R 
