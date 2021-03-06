#!/bin/bash

# This script is used to run the pipeline on any number of datasets
# to process each dataset individually, use the -d (default option)
# To combine a set of datasets and process them altogether use -c
# (combine option)

usage() {
    echo "GEP - Gene Expression Pipeline"
    echo "usage: $0 [options]"
    echo "                [-d gse_list]            default, submits each dataset listed to be processed as an individual job"
    echo "                [-c title gse_list]      combine datasets listed and process the combined dataset, named title"
    echo ""
    echo "gse_list          GSEXXX ..."
    echo "title             TITLE"
    echo ""
    exit 1
}

if [ "$1" = "-d" ]; then
    shift
    # for loop loops over all datasets provided as arguments and submits jobs to run the pipeline on each dataset
    for file in $@; do
        qsub -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_pipeline_$file.log -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_pipeline_$file.err -N $file /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/run_pipeline.sh $file
        shift
    done
elif [ "$1" = "-c" ]; then
    shift
    qsub -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_combine_$1.log -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/gep_combine_$1.err -N $1 /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/combine_and_run_pipeline.sh $@
else
    usage
fi
