#!/bin/bash

source /oicr/cluster/etc/profile
module load R/3.3.0
module load openssl/1.0.1r
Rscript --verbose main.R 
