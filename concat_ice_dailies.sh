#!/bin/bash
module load nco

echo "doing ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc} && rm ${1/.nc/-??.nc}"
# ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc}
ncrcat -O -L 5 -7 ${1/.nc/-??.nc} ${1/.nc/-daily.nc} && rm ${1/.nc/-??.nc}
chgrp v45 ${1/.nc/-daily.nc}
chmod g+r ${1/.nc/-daily.nc}
rm ${1/.nc/-IN-PROGRESS}
