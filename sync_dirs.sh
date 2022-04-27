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

# rsync each directory in SRCDIR to DESTDIR in a separate parallel job

umask 027

dirtype=output
# dirtype=restart  # also need to change exclude - see below

#expt=01deg_jra55v140_iaf_cycle4
#SCRIPTDIR=/home/156/aek156/payu/${expt}
SCRIPTDIR=$(pwd)
expt=$(basename ${SCRIPTDIR})

#SRCDIR=/scratch/x77/aek156/access-om2/archive/${expt}
#SRCDIR=/scratch/v45/aek156/access-om2/archive/${expt}
SRCDIR=$(readlink -e archive)

# for copying 01deg_jra55v140_iaf_cycle3 to cj50
# DESTDIR=/g/data/cj50/admin/incoming/access-om2/raw-output/access-om2-01/${expt}
#exclude="--exclude=*.nc.* --exclude=iceh.????-??-??.nc --exclude=*-DEPRECATED --exclude=*-DELETE --exclude=*-IN-PROGRESS --exclude=*passive*.nc --exclude=ocean-3d-*-1-daily*.nc"

# for copying 01deg_jra55v140_iaf_cycle3 to ik11
#DESTDIR=/g/data/ik11/outputs/access-om2-01/${expt}
#exclude="--prune-empty-dirs --include=*/ --include=*passive*.nc --include=ocean-3d-*-1-daily*.nc --exclude=*"  # for dirtype=output
# exclude=""  # for dirtype=restart

# rsyncflags="-vrltoD --safe-links"

# normal sync options, copied from sync_data.sh
#exclude="--exclude=*.nc.* --exclude=iceh.????-??-??.nc --exclude=*-DEPRECATED --exclude=*-DELETE --exclude=*-IN-PROGRESS"
eval "$(grep "^rsyncflags=" ${SCRIPTDIR}/sync_data.sh)"
eval "$(grep "^exclude=" ${SCRIPTDIR}/sync_data.sh)"
eval "$(grep "^SYNCDIR=" ${SCRIPTDIR}/sync_data.sh)"
DESTDIR=${SYNCDIR}

# for copying 01deg_jra55v140_iaf_cycle4 from ik11 to cj50
SRCDIR=/g/data/ik11/outputs/access-om2-01/${expt}
DESTDIR=/g/data/cj50/admin/incoming/access-om2/raw-output/access-om2-01/${expt}

echo "About to rsync" ${rsyncflags} ${exclude}
echo ${SRCDIR}
echo ${dirtype} "to"
echo ${DESTDIR}
echo "in parallel using"
echo ${SCRIPTDIR}/sync_dir.sh
read -p "Proceed? (y/n) " yesno
case $yesno in
    [Yy] ) ;;
    * ) echo "Cancelled."; exit 0;;
esac

mkdir -p ${DESTDIR}
cd ${SCRIPTDIR}

# first delete any cice log files that only have a 105-character header and nothing else
find ${SRCDIR}/output* -size 105c -iname "ice.log.task_*" -delete

for dirpath in ${SRCDIR}/${dirtype}[0-9][0-9][0-9]
    do
    (
        echo ${dirpath}
        export dir=`basename ${dirpath}` srcdir=${SRCDIR} destdir=${DESTDIR} rsyncflags exclude
        qsub -N Rsync-${dir} -v dir=${dir},srcdir=${srcdir},destdir=${destdir},rsyncflags="${rsyncflags}",exclude="${exclude}" ${SCRIPTDIR}/sync_dir.sh
    ) &
done
wait

exit 0
