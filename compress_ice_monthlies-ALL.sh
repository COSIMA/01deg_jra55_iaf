#!/bin/bash

# Compress CICE monthly output files

# DO NOT USE WHILE MODEL IS RUNNING!

echo "WARNING: do not proceed if the model is still running."
read -p "Proceed? (y/n) " yesno
case $yesno in
    [Yy] ) ;;
    * ) echo "Cancelled. Wait until model has finished before trying again."; exit 0;;
esac

for d in archive/output???/ice/OUTPUT; do
    for f in $d/iceh.????-??.nc; do
        if [[ ! -f ${f/.nc/-COMPRESS-IN-PROGRESS} ]];
        then
            echo "Submitting $f"
            qsub -P v45 -q copyq -l ncpus=1 -l walltime=00:30:00,mem=2GB -l wd -V -N compress_ice_monthlies -- ./compress_ice_monthlies.sh $f && touch ${f/.nc/-COMPRESS-IN-PROGRESS}
        else
            echo "--- Skipping $f"
        fi
        # break
    done
    # break
done

