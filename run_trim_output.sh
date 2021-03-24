#!/bin/bash

# based on /home/157/amh157/process_daily/run_uhrho.sh

#exptdir=/scratch/x77/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle3
exptdir=/scratch/v45/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle3
name='trim_output'

for d in {730..731}
do
   qsub <<HERE
#!/bin/bash
#PBS -l mem=96GB
#PBS -l walltime=5:00:00
#PBS -l storage=gdata/ik11+gdata/hh5+scratch/x77+scratch/v45
#PBS -P x77
#PBS -q normal
#PBS -N ${d}_${name}

# set -x

module use /g/data/hh5/public/modules
module load conda/analysis3-20.07
module load nco/4.7.7

python3 /home/156/aek156/payu/01deg_jra55v140_iaf_cycle3/trim_output.py ${exptdir}/output${d}
HERE
done
