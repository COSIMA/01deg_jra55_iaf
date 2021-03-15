#!/bin/bash
#PBS -S /bin/bash
#PBS -P v45
#PBS -q normal
#PBS -l walltime=01:00:00
#PBS -V
#PBS -l ncpus=1
#PBS -l mem=1GB
#PBS -j oe
#PBS -lstorage=scratch/x77+scratch/v45+gdata/ik11+gdata/cj50+gdata/hh5

date

umask 027

expt=01deg_jra55v140_iaf_cycle3
dirtype=output
SCRIPTDIR=/home/156/aek156/payu/${expt}

SRCDIR=/scratch/x77/aek156/access-om2/archive/${expt}
# SRCDIR=/scratch/v45/aek156/access-om2/archive/${expt}
RSYNCFLAGS="-vrltoD --safe-links"

# for copying to cj50
DESTDIR=/g/data/cj50/admin/incoming/access-om2/raw-output/access-om2-01/${expt}
EXCLUDE="--exclude=*.nc.* --exclude=iceh.????-??-??.nc --exclude=*-DEPRECATED --exclude=*-DELETE --exclude=*-IN-PROGRESS --exclude=*passive*.nc --exclude=ocean-3d-*-1-daily*.nc"

# for copying to ik11
# DESTDIR=/g/data/ik11/outputs/access-om2-01/${expt}
# EXCLUDE="--prune-empty-dirs --include=*/ --include=*passive*.nc --include=ocean-3d-*-1-daily*.nc --exclude=*"


mkdir -p ${DESTDIR}
cd ${SCRIPTDIR}

# first delete any cice log files that only have a 105-character header and nothing else
find ${SRCDIR}/output* -size 105c -iname "ice.log.task_*" -delete

for dirpath in ${SRCDIR}/${dirtype}[0-9][0-9][0-9]
    do
    (
        echo ${dirpath}
        export dir=`basename ${dirpath}` srcdir=${SRCDIR} destdir=${DESTDIR} rsyncflags=${RSYNCFLAGS} exclude=${EXCLUDE}
        qsub -N Rsync-${dir} -v dir=${dir},srcdir=${srcdir},destdir=${destdir},rsyncflags="${rsyncflags}",exclude="${exclude}" ${SCRIPTDIR}/sync_dir.sh
    ) &
done
wait

echo ">>Done"


date

exit 0
