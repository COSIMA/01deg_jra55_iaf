#!/bin/bash
#PBS -S /bin/bash
#PBS -P v45
#PBS -q normal
#PBS -l walltime=03:00:00
#PBS -V
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -j oe
#PBS -lstorage=scratch/x77+scratch/v45+gdata/ik11+gdata/cj50+gdata/hh5

date

umask 027

set -xeuEo pipefail

function traperr
{
    echo "  ERROR TRAPPED at line $1"
    kill 0 # kill the master shell and all subshells
}

trap 'traperr $LINENO' ERR

chmod u+w ${destdir}/${dir}/ice/OUTPUT
rsync ${rsyncflags} ${exclude} ${srcdir}/${dir}/ice/OUTPUT/*.nc ${destdir}/${dir}/ice/OUTPUT
chmod u-w ${destdir}/${dir}/ice/OUTPUT/*
chmod u-w ${destdir}/${dir}/ice/OUTPUT
