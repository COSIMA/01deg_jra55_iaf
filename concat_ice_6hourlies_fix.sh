#!/bin/bash

# concatenate final 6-hourly individual file to final concatenated month-long 6-hourly file in each run
# (since this is skipped by concat_ice_6hourlies-ALL.sh)

# DO NOT USE WHILE MODEL OR concat_ice_6hourlies ARE RUNNING OR IF concat_ice_6hourlies-ALL.sh HASN'T BEEN RUN!

module load nco
set -e

shopt -s nullglob

echo "WARNING: do not proceed if the model or concat_ice_6hourlies are still running, or if concat_ice_6hourlies-ALL.sh hasn't been run."
read -p "Proceed? (y/n) " yesno
case $yesno in
    [Yy] ) ;;
    * ) echo "Cancelled. Wait until model and concat_ice_6hourlies have finished before trying again."; exit 0;;
esac

for f in archive/output???/ice/OUTPUT/iceh*.????-??-01-00000.nc; do
   conc=$(ls -1 `dirname $f`/iceh*.????-??-6hourly.nc | tail -n 1)
   echo "doing ncrcat -O -L 5 -7 ${conc} ${f} ${conc}"
   ncrcat -O -L 5 -7 ${conc} ${f} ${conc}
   chgrp x77 ${conc}
   chmod g+r ${conc}
   mv $f $f-DELETE
done
