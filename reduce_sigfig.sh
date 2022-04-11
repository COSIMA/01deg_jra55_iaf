#!/bin/bash

# Reduce precision of output files.
# Script accepts 1 arg, which is the path to an ocean output dir, e.g.
# /g/data/ik11/outputs/access-om2-01/01deg_jra55v140_iaf_cycle4/output734/ocean

module load nco

# define number of significant figures, copied from
# https://docs.google.com/spreadsheets/d/1UCdeUC1zi-52g7-nAFyXAZVy5iaOGZz2fmyMiPNVILU/edit#gid=1669515973
# and duplicates removed
declare -A sf
sf[adic_int100]=4
sf[adic_intmld]=4
sf[adic_xflux_adv]=3
sf[adic_yflux_adv]=3
sf[adic_zflux_adv]=3
sf[adic]=4
sf[alk]=4
sf[caco3_xflux_adv]=3
sf[caco3_yflux_adv]=3
sf[caco3_zflux_adv]=3
sf[caco3]=3
sf[det_int100]=3
sf[det_intmld]=3
sf[det_xflux_adv]=3
sf[det_yflux_adv]=3
sf[det_zflux_adv]=3
sf[det]=3
sf[dic_int100]=4
sf[dic_intmld]=4
sf[dic_xflux_adv]=3
sf[dic_yflux_adv]=3
sf[dic_zflux_adv]=3
sf[dic]=4
sf[fe_int100]=3
sf[fe_intmld]=3
sf[fe_xflux_adv]=3
sf[fe_yflux_adv]=3
sf[fe_zflux_adv]=3
sf[fe]=3
sf[no3_int100]=3
sf[no3_intmld]=3
sf[no3_xflux_adv]=3
sf[no3_yflux_adv]=3
sf[no3_zflux_adv]=3
sf[no3]=3
sf[npp_int100]=3
sf[npp_intmld]=3
sf[npp1]=3
sf[npp2d]=3
sf[npp3d]=3
sf[o2_int100]=4
sf[o2_intmld]=4
sf[o2_xflux_adv]=3
sf[o2_yflux_adv]=3
sf[o2_zflux_adv]=3
sf[o2]=4
sf[paco2]=4
sf[pco2]=4
sf[phy_int100]=3
sf[phy_intmld]=3
sf[phy]=3
sf[pprod_gross_2d]=3
sf[pprod_gross_int100]=3
sf[pprod_gross_intmld]=3
sf[pprod_gross]=3
sf[radbio_int100]=3
sf[radbio_intmld]=3
sf[radbio1]=3
sf[radbio3d]=3
sf[src01]=2
sf[src03]=2
sf[src05]=2
sf[src06]=2
sf[src07]=2
sf[src09]=2
sf[src10]=2
sf[stf03]=4
sf[stf07]=4
sf[stf09]=4
sf[surface_adic]=4
sf[surface_alk]=4
sf[surface_caco3]=3
sf[surface_det]=3
sf[surface_dic]=4
sf[surface_fe]=3
sf[surface_no3]=3
sf[surface_o2]=4
sf[surface_phy]=3
sf[surface_zoo]=3
sf[wdet100]=3
sf[zoo]=3

shopt -s nullglob

for var in "${!sf[@]}"
do
    echo ${var}
    for path_file in ${1}/oceanbgc-[23]d-${var}-*-mean-*.nc
    do
        if [[ $(basename ${path_file}) == *sigfig* ]]
        then
            continue;  # don't bit-groom a bit-groomed file
        fi
        out_path_file=${path_file/-mean-/-mean-${sf[${var}]}-sigfig-}
        lockfile=${out_path_file/.nc/-IN-PROGRESS}  # to prevent 2 jobs processing the same file
        if [[ ! -f ${out_path_file} ]] && [[ ! -f ${lockfile} ]]
        then
            touch ${lockfile}
            echo "ncks -v ${var} -7 -L 5 --baa=4 --ppc ${var}=${sf[${var}]} ${path_file} ${out_path_file}"
            if ncks -v ${var} -7 -L 5 --baa=4 --ppc ${var}=${sf[${var}]} ${path_file} ${out_path_file}
            then
                chgrp ik11 ${out_path_file}
                chmod g+r ${out_path_file}
                pre_size=`stat -c %s ${path_file}`
                post_size=`stat -c %s ${out_path_file}`
                let "post_size_scaled = 100 * ${post_size}"
                if (( post_size_scaled > pre_size ))
                then
                    echo "rm ${path_file}"
                    rm ${path_file} && rm ${lockfile}
                else
                    echo "*** output suspiciously small - retaining ${path_file} and ${lockfile}"
                fi
            else
                echo "*** FAILED! - retaining ${path_file} and ${lockfile}"
            fi
        else
            echo "--- Skipping ${path_file}"
        fi
    done
done
