#!/bin/bash

dest=/g/data/cj50/access-om2/raw-output/access-om2-01/01deg_jra55v140_iaf_cycle2
orig=/scratch/x77/aek156/access-om2/archive/01deg_jra55v140_iaf_cycle2 # delete files from here

for p in $dest/output245; do
    out=$(basename "$p")
    for pf in $p/ice/OUTPUT/iceh.????-??-daily.nc; do
        f=$(basename "$pf")
        delf=$orig/$out/ice/OUTPUT/${f/-daily.nc/-??.nc-DE*}  # files to delete
        echo $p
        echo $out
        ls -lh $pf
        echo $f
        du -hsc $delf
        # diff <(ncdump -h $pf | grep float | sort) <(ncdump -h $orig/$out/ice/OUTPUT/${f/-daily.nc/-01.nc-DE*} | grep float | sort)
        diff <(ncdump -h $pf | grep float | sort) <(ncdump -h ${delf[0]} | grep float | sort)
        read -p "Delete? (y/n) " yesno
        case $yesno in
            [Yy] )
                echo "ok";;
            * )
                ;;
        esac
    done
done

echo "$0 completed"
