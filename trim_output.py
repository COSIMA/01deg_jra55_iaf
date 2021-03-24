#!/usr/bin/env python3

# based on /home/157/amh157/process_daily/process_dt_south900.py

import subprocess as sp
import sys
import time
import xarray as xr
from pathlib import Path
import pandas as pd
from glob import glob

# latmax = 900
latmax = 511  # j=511 = 58.98163 S

# def format_date(dateobj, timeformat='%Y_%m'):
# 
#     try:
#         datestring = dateobj.strftime(timeformat)
#     except:
#         # Use pandas as an intermediate as it can grok np.datetime64
#         # as well as standard datetime objects
#         datestring = pd.Timestamp(dateobj).strftime(timeformat)
# 
#     return datestring

# def process_file(path, variable, time, latname, nsigfig, number):
def process_file(path, variable, latname, nsigfig):

    # outpath = Path(path).parent / (Path(path).stem + '_{0:02d}.nc'.format(number))
    outpath = Path(path).parent / (Path(path).stem + '_jmax{}_sigfig{}.nc'.format(latmax, nsigfig))
    print('outpath =', outpath)

    command = ['/usr/bin/time', 
               'ncks', 
               '-v', 
               variable, 
               '--ppc', '{var}={sf}'.format(var=variable, sf=nsigfig), 
               '-L', '-5', 
               '-7', 
               '-d', '{lat},0,{max}'.format(lat=latname, max=latmax-1),
               # '-d', 'time,{start},{end}'.format(start=time[0], end=time[1]),
               str(path),
               str(outpath)
              ]

    print(' '.join(command))
    sp.check_output(command)

    return outpath

variables = {
             # 'u':('yu_ocean',3), 
             # 'v':('yu_ocean',3), 
             'salt':('yt_ocean',4), 
             # 'temp':('yt_ocean',5),
             # 'wt':('yt_ocean',2), 
             'vhrho_nt':('yt_ocean',3),
             'uhrho_et':('yt_ocean',3),
            }

for dir in sys.argv[1:]:

    for (var, (latvar, sf)) in variables.items():

        # dirpath = Path(dir) / 'ocean' / 'ocean_daily_3d_{var}.nc'.format(var=var)
        varpath = Path(dir) / 'ocean' / 'ocean-3d-{var}-1-daily-mean-ym_????_??.nc'.format(var=var)
        dirpaths = [Path(p) for p in glob(str(varpath))]
        dirpaths.sort()
        for dirpath in dirpaths:
            print("Opening {file}".format(file=dirpath))
            # ds = xr.open_dataset(dirpath, decode_cf=False).isel({latvar: slice(0, latmax)})
            # 
            # # ds.time_bounds.attrs['calendar'] = ds.time.attrs['calendar']
            # # ds.time_bounds.attrs['units'] = ds.time.attrs['units']
            # 
            # ds = xr.decode_cf(ds)
            # 
            # for v in ds:
            #     if 'chunksizes' in ds[v].encoding:
            #         ds[v] = ds[v].chunk(ds[v].encoding['chunksizes'])

            remove_original = True

            # i = 0
            # # for (date, subds) in ds.resample({'time': 'M'}):
            # for (i, subds) in ds.groupby('time.month'):
            #     times = [subds.time_bounds[0][0].values, subds.time_bounds[-1][1].values]
            #     print("Extracting data between {start} and {finish}".format(start=times[0], finish=times[1]))
            #     sum_before = subds[var].sum().values
            #     print("Sum before: ",sum_before)

            try:
                # outfile = process_file(dirpath, var, times, latvar, sf, i)
                outfile = process_file(dirpath, var, latvar, sf)
            except Exception as e:
                print("Processing file failed!")
                print(e)
                remove_original = False
            finally:
                print("Created processed file: {file}".format(file=outfile))

            # newds = xr.open_dataset(outfile)
            # sum_after = newds[var].sum().values
            # print("Sum after: ", sum_after)
            # print("Sum difference (fraction): ", abs(sum_after-sum_before)/sum_before)

            # # Insist sum of the field differs by no more than 1e-3
            # if abs((sum_after-sum_before)/sum_before) > 1e-3:
            #     print("Sum of new file is not sufficiently close to original")
            #     remove_original = False

            # Insist processed file no less than 1 percent the size of the original
            if Path(outfile).stat().st_size < dirpath.stat().st_size * 0.01:
                print("Size of new file is suspiciously small")
                print("Original: {} New: {}".format(Path(outfile).stat().st_size, dirpath.stat().st_size))
                remove_original = False

            print("remove original: {}".format(remove_original))
            if remove_original:
                print("Removing original {}".format(dirpath))
                dirpath.unlink()
            else:
                "Original file {} not removed".format(dirpath) 
