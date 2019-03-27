#!/bin/bash
module use /g/data3/hh5/public/modules/
module load conda/analysis3-unstable 

echo "doing nccompress --nccopy -r -o -v $1"
nccompress --nccopy -r -o -v $1
chgrp v45 $1
chmod g+r $1
# rm ${1/.nc/-IN-PROGRESS}
