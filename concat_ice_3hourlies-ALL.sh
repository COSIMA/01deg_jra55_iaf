#!/bin/bash

# Concatenate and compress CICE 3hourly output files

# DO NOT USE WHILE MODEL IS RUNNING! This could concatenate and delete a partial set of 3hourly files.

shopt -s nullglob

echo "WARNING: do not proceed if the model is still running."
read -p "Proceed? (y/n) " yesno
case $yesno in
    [Yy] ) ;;
    * ) echo "Cancelled. Wait until model has finished before trying again."; exit 0;;
esac

for d in archive/output???/ice/OUTPUT; do
    for f in $d/iceh*.????-??-01-75600.nc; do
        if [[ ! -f ${f/.nc/-IN-PROGRESS} ]] && [[ ! -f ${f/-01-75600.nc/-3hourly.nc} ]];
        then
            echo "Submitting $f"
            qsub -P x77 -q copyq -l ncpus=1 -l walltime=01:30:00,mem=2GB -l wd -l storage=gdata/hh5+gdata/ik11+scratch/v45+scratch/x77+scratch/g40 -V -N concat_ice_3hourlies -- ./concat_ice_3hourlies.sh $f && touch ${f/.nc/-IN-PROGRESS}
        else
            echo "--- Skipping $f"
        fi
    done
done

echo
echo "After the qsub jobs have all successfully completed, you should run concat_ice_3hourlies_fix.sh"
