#!/bin/bash

# Concatenate and compress CICE daily output files

# DO NOT USE WHILE MODEL IS RUNNING! This could concatenate and delete a partial set of daily files.

echo "WARNING: do not proceed if the model is still running."
read -p "Proceed? (y/n) " yesno
case $yesno in
    [Yy] ) ;;
    * ) echo "Cancelled. Wait until model has finished before trying again."; exit 0;;
esac

for d in archive/output???/ice/OUTPUT; do
    for f in $d/iceh.????-??.nc; do
        if [[ -f ${f/.nc/-01.nc} ]] && [[ ! -f ${f/.nc/-IN-PROGRESS} ]];
        then
            echo "Submitting $f"
            qsub -P v45 -q copyq -l ncpus=1 -l walltime=00:30:00,mem=2GB -l wd -V -N concat_ice_dailies -- ./concat_ice_dailies.sh $f && touch ${f/.nc/-IN-PROGRESS}
        else
            echo "--- Skipping $f"
        fi
    done
done

