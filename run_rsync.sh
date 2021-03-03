#PBS -S /bin/bash
#PBS -P v14
#PBS -q normal
#PBS -l walltime=02:00:00
#PBS -V
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -j oe
##PBS -W block=true
#PBS -lstorage=scratch/x77+scratch/v14+scratch/v45

date

umask 027
  
set -xeuEo pipefail

function traperr
{
    echo "  ERROR TRAPPED at line $1"
    kill 0 # kill the master shell and all subshells
}

trap 'traperr $LINENO' ERR


rsync -avhr ${srcdir}/${mem} ${tardir}


chgrp -R v14 ${tardir} 
