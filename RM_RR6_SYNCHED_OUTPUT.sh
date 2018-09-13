#!/bin/bash
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l wd
#PBS -l walltime=4:00:00,mem=2GB
#PBS -P v45
#PBS -N RM_RR6_SYNCHED_OUTPUT

source sync_output_to_rr6.sh # to define GDATARR6DIR and cd archive
echo
echo "======================================================="
echo

rsync --remove-source-files --include "*/" --include "ocean_daily_3d_*.nc" --exclude "*" --exclude "*.nc.*" --exclude "*ocean_*_3hourly*" --exclude "*iceh_03h*" -vrltoD --safe-links output??? ${GDATARR6DIR}
