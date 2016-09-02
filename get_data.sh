#!/bin/bash

usage() {
    echo "GEP - Data Retrieval"
    echo "Usage: $0 [options]"
    echo "                [-l gse_list]          downloads raw data for specified list of datasets"
    echo "                [-sql sql_query]       downloads raw data for datasets specified by an SQL query against the GEOmetadb"
    echo ""
    echo "-l          GSEXXX ..."
    echo "-sql        \"SELECT gse FROM gse WHERE ...\"" 
    echo ""
    exit 1
}

if [ "$1" = "-l" ]; then
    shift
    qsub -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.log -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.err -N "GET_DATA" /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/get_raw_data.sh $@
elif [ "$1" = "-sql" ]; then
    shift
    qsub -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.log -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.err -N "GET_DATA" /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/get_data_sql.sh $@
else
    usage
fi
