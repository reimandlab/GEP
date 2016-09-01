#!/bin/bash

usage() {
    echo ""
    echo "Usage: $0 [-l list_of_datasets] or [-sql GEOmetadb_sql_query]"
    echo ""
    echo ""
    echo "    -l : list the GSE datasets you'd like to download explicitly"
    echo "    -sql : use an SQL query against GEOmetadb, selecting GSEs to specify datasets"
    echo ""
    exit 1
}

if [ "$1" = "-l" ]; then
    shift
    qsub -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.log -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.err -N "GET_DATA" /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/get_raw_data.sh $@
elif [ "$1" = "-sql" ]; then
    qsub -o /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.log -e /.mounts/labs/reimandlab/private/users/nsiddiqui/log/get_data.err -N "GET_DATA" /.mounts/labs/reimandlab/private/users/nsiddiqui/GEP/R/get_raw_data.sh $@
else
    usage
fi
