ocean/restart387/ocean/ocean_barotropic.res.nc.00??-old are the original restarts

ocean/restart387/ocean/ocean_barotropic.res.nc.00?? have been modified by https://github.com/aekiss/notebooks/blob/master/fix-restarts.ipynb 
to set eta_t and eta_t_bar to zero inside the new land points created in going from  
/g/data3/hh5/tmp/cosima/bathymetry/topog_12_10_17_yenesei.nc
to
/g/data3/hh5/tmp/cosima/bathymetry/topog_13_06_2018.baffin.nc
as discussed here:
https://github.com/OceansAus/access-om2/issues/99

Similarly, ice/iced.0036-01-01-00000.nc-old is the original CICE restart 
and ice/iced.0036-01-01-00000.nc has been modified by https://github.com/aekiss/notebooks/blob/master/fix-restarts.ipynb
to set iceumask to false in the new land points
