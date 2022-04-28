#!/bin/bash
module load nco
set -e

echo "doing ncrcat -O -L 5 -7 ${1/-01-64800.nc/-??-?????.nc} ${1/-01-64800.nc/-6hourly.nc}"
ncrcat -O -L 5 -7 ${1/-01-64800.nc/-??-?????.nc} ${1/-01-64800.nc/-6hourly.nc}
chgrp x77 ${1/-01-64800.nc/-6hourly.nc}
chmod g+r ${1/-01-64800.nc/-6hourly.nc}
for f in ${1/-01-64800.nc/-??-?????.nc}
do
   mv $f $f-DELETE
done
rm ${1/.nc/-IN-PROGRESS}
