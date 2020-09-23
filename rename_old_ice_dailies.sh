#!/bin/bash

# Rename individual CICE daily output files if a concatenated version exists

# DO NOT USE WHILE MODEL IS RUNNING! This could concatenate and delete a partial set of daily files.
set -e

echo "WARNING: do not proceed if the model is still running."
read -p "Proceed? (y/n) " yesno
case $yesno in
    [Yy] ) ;;
    * ) echo "Cancelled. Wait until model has finished before trying again."; exit 0;;
esac

for d in /g/data/ik11/outputs/access-om2-01/01deg_jra55v140_iaf/output???/ice/OUTPUT; do
    for f in $d/iceh.????-??-daily.nc; do
        if [[ ! -f ${f/-daily.nc/-IN-PROGRESS} ]];
        then
            for ff in ${f/-daily.nc/-??.nc}; do
               if [[ -f $ff ]]
               then
                  echo "mv $ff $ff-DELETE"
                  mv $ff $ff-DELETE
               fi
            done
        else
            echo "--- Skipping $f"
        fi
    done
done

