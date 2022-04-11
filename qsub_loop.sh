#!/bin/bash

for dir_num in {882..882}
do
    # qsub -P v45 -q copyq -l wd -l ncpus=1,mem=12GB,walltime=10:00:00 -l storage=gdata/ik11+scratch/v45+scratch/x77 -V -N sigfig${dir_num} -- ./reduce_sigfig.sh /g/data/ik11/outputs/access-om2-01/01deg_jra55v140_iaf_cycle4/output$dir_num/ocean
    qsub -P v45 -q copyq -l wd -l ncpus=1,mem=12GB,walltime=10:00:00 -l storage=gdata/ik11+scratch/v45+scratch/x77 -V -N sigfig${dir_num} -- ./reduce_sigfig.sh /scratch/v45/hh0162/access-om2/archive/01deg_jra55v140_iaf_cycle4/output$dir_num/ocean
#	./reduce_sigfig.sh /g/data/ik11/outputs/access-om2-01/01deg_jra55v140_iaf_cycle4/output${dir_num}/ocean
#	./reduce_sigfig.sh /scratch/v45/hh0162/access-om2/archive/01deg_jra55v140_iaf_cycle4/output$dir_num/ocean
done
