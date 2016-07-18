#!/bin/bash
#$ -l h_vmem=95g
#$ -cwd
#$ -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep.log
#$ -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep.err

source /oicr/cluster/etc/profile
module load R/3.3.0

Rscript --vanilla --verbose /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/main.R 
