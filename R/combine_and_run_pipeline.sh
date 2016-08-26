#!/bin/bash
#$ -l h_vmem=75g
#$ -cwd
#$ -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_combine.log
#$ -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_combine.err

source /oicr/cluster/etc/profile
module load R/3.3.0

Rscript --vanilla --verbose /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/combine_and_run_pipeline.R "$@"
