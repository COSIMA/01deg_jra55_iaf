#!/bin/bash

# Delete individual CICE daily output files if a concatenated version exists

dest=/g/data/cj50/access-om2/raw-output/access-om2-01/01deg_jra55v140_iaf_cycle2
orig=/scratch/x77/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle2 # delete files from here

for p in $dest/output???; do
    out=$(basename "$p")
    for pf in $p/ice/OUTPUT/iceh.????-??-daily.nc; do
        f=$(basename "$pf")
        delf=$orig/$out/ice/OUTPUT/${f/-daily.nc/-??.nc-DE*}  # files to delete
        delfarr=($delf)

        echo "concatenated file:"
        du -hs $pf

        echo "individual daily files to delete:"
        du -hsc $delf

        diff <(ncdump -h $pf | grep float | sort) <(ncdump -h ${delfarr[0]} | grep float | sort) # show any differences in variable names

        echo "Delete individual daily files?"
        echo "rm $delf"
        read -p "(y/n) " yesno
        case $yesno in
            [Yy] )
                rm $delf
                echo "deleted"
                ;;
            * )
                echo "not deleted"
                ;;
        esac
        echo
    done
done

echo "$0 completed"
