#!/bin/bash
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l wd
#PBS -l walltime=4:00:00,mem=2GB
#PBS -P v45
#PBS -N sync_output_to_rr6

# Set this directory to something in /g/data/rr6/cosima/
# Make a unique path for your set of runs.
# DOUBLE-CHECK IT IS UNIQUE SO YOU DON'T OVERWRITE EXISTING OUTPUT!
GDATARR6DIR=/g/data/rr6/cosima/access-om2-01/01deg_jra55v13_iaf

mkdir -p ${GDATARR6DIR}
cd archive
rsync --include '*/' --include 'ocean_daily_3d_*.nc' --exclude '*' --exclude 'ocean_daily_3d_wt.nc' --exclude "*.nc.*" --exclude "*ocean_*_3hourly*" --exclude "*iceh_03h*" -vrltoD --safe-links output* ${GDATARR6DIR}
