#!/bin/bash
#$ -l h_vmem=75g
#$ -cwd

source /oicr/cluster/etc/profile
module load R/3.3.0

Rscript --vanilla --verbose /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/combine_and_run_pipeline.R "$@"
