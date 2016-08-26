#!/bin/bash
#$ -l h_vmem=75g
#$ -cwd
#$ -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_pipeline.log
#$ -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_pipeline.err

source /oicr/cluster/etc/profile
module load R/3.3.0

Rscript --vanilla --verbose /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/run_pipeline.R "$@"
