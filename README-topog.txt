/short/v45/aek156/access-om2/input/mom_01deg/topog_12_10_17_yenesei.nc is the same as 
/g/data3/hh5/tmp/cosima/bathymetry/topog_12_10_17_yenesei.nc 
and was used as topog.nc until the end of run 387 (Dec year 35) of 01deg_jra55v13_ryf8485_spinup6

However this had potholes and problems on Baffin Island and elsewhere
https://github.com/OceansAus/access-om2/issues/99

So from run 388 (Jan year 36) onwards 
/short/v45/aek156/access-om2/input/mom_01deg/topog.nc
was changed to a copy of this corrected topography
/g/data3/hh5/tmp/cosima/bathymetry/topog_13_06_2018.baffin.nc

NB: topog.nc and ocean_mask.nc were inconsistent for runs 388-398 inclusive!

From run 399 (Dec year 36) onwards
/short/v45/aek156/access-om2/input/mom_01deg/ocean_mask.nc
was made consistent with this new topog.nc, fixed with fix-restarts.ipynb
https://github.com/aekiss/notebooks/blob/b166a007807516ff737749fb931b93e688d62b8f/fix-restarts.ipynb
with the previous ocean_mask renamed ocean_mask_12_10_17_yenesei.nc

/short/v45/aek156/access-om2/archive/01deg_jra55_ryf/restart387/ice/kmt.nc-old 
is the original CICE restart, and 
/short/v45/aek156/access-om2/archive/01deg_jra55_ryf/restart387/ice/kmt.nc 
has been modified by
https://github.com/aekiss/notebooks/blob/master/fix-restarts.ipynb
to set kmt to false in the new land points.

After run 413, did
mv /short/v45/aek156/access-om2/input/cice_01deg/kmt.nc /short/v45/aek156/access-om2/input/cice_01deg/kmt_12_10_17_yenesei.nc
cp /short/v45/aek156/access-om2/archive/01deg_jra55_ryf/restart413/ice/kmt.nc /short/v45/aek156/access-om2/input/cice_01deg/kmt.nc
so that kmt.nc in the inputs dir is the same as in the restarts.
