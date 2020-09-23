#!/bin/bash
module load nco
set -e

echo "doing ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc}"
ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc}
# echo "doing ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc} && rm ${1/.nc/-??.nc}"
# ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc} && rm ${1/.nc/-??.nc}
chgrp x77 ${1/.nc/-daily.nc}
chmod g+r ${1/.nc/-daily.nc}
for f in ${1/.nc/-??.nc}
do
   mv $f $f-DELETE
done
rm ${1/.nc/-IN-PROGRESS}
