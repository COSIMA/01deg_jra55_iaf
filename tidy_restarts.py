#!/usr/bin/env python
"""

Tidy up restart files, keeping only the first restart each year
and moving the rest to archive/CHUCKABLE/

"""

from __future__ import print_function
import os
from glob import glob

restarts = glob('archive/restart???')
restarts.sort()
restarts = restarts[:-6]  # don't touch the most recent 6 restarts

year = -999
for r in restarts:
    prevyear = year
    try:
        fn = os.path.join(r, 'ocean/ocean_solo.res')
        with open(fn, 'r') as f:
            lineList = f.readlines()
            year = lineList[-1].split()[0]  # the year of the final time in the run
            if year == prevyear:
                print('Moving ' + r + ' to ' + r.replace('archive', 'archive/CHUCKABLE'))
                os.renames(r, r.replace('archive', 'archive/CHUCKABLE'))
            else:
                print('Keeping ' + r + ': ending time is' + lineList[-1], end='')
    except:
        print('Error: ' + fn + ' is unreadable')
