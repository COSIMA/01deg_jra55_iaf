#!/bin/bash
#PBS -S /bin/bash
#PBS -P p93
#PBS -q normal
#PBS -l walltime=00:60:00
#PBS -V
#PBS -l ncpus=1
#PBS -l mem=1GB
#PBS -j oe
##PBS -W block=true
#PBS -lstorage=scratch/v14+scratch/x77

date

umask 027
SRCDIR=/scratch/v45/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle3
#SRCDIR=/scratch/v45/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle3/CHUCKABLE

#SRCDIR=/scratch/x77/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle2/CHUCKABLE/
WDIR=/scratch/v14/pas548/restarts
TARDIR=${WDIR}/TRANSFER2
cd ${WDIR}

restarts=`ls -d ${SRCDIR}/res*`
    for  mem in $restarts
        do
           (
	     export mem=`basename ${mem}` srcdir=${SRCDIR} tardir=${TARDIR}
	     qsub -N Rsync-${mem} -v mem=${mem},srcdir=${SRCDIR},tardir=${TARDIR} ${WDIR}/run_rsync.sh
            ) &
     done
     wait

   echo ">>Done"


 date

 exit 0
