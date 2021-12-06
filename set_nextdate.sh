#!/usr/bin/bash

# This script modifies the reference date for daily-mean ocean diagnostics saved every 5 days (or any frequency you like).
# https://github.com/COSIMA/access-om2/issues/241
# 
# Created by Hakase Hayashida on 2021-11-30
#
# This script should be executed before the start of a restart run. This can be done by defining this script to be executed during `payu init` in `config.yaml`.
# See https://github.com/COSIMA/01deg_jra55_iaf/tree/01deg_jra55v140_iaf_cycle4
# The trick is to add `# set_nextdate` at the end of `start_time` for the diagnostics you want to modify the reference date in in `diag_table_source.yaml`
# What it does:
# - looks for the date on which the daily-mean-5-daily-* was last save in the most recent run (if it exists, otherwise ignored).
# - adds 5 days from that date, and set it as the reference date for the diagnostics for the next run.
# - generates the updated `diag_table` which is used in the next run.
#
# The only thing you need to modify is `namediag` below.


#Define the name of the diagnostic that you want to modify the reference date
namediag=oceanbgc-3d-no3-1-daily-mean-5-daily-ymd*

### NO NEED TO MODIFY BELOW ###

#Identify the most recent run
lastoutput=$(ls -d archive/output* | tail -n 1)

#Do the rest if the target diags exist in the most recent run.
if [ -z "$(ls ${lastoutput}/ocean/${namediag})" ]
then
	echo "${lastoutput}/ocean/${namediag} does not exist..."
else
	# Look for the date on which the daily output was last saved.
	ls ${lastoutput}/ocean/${namediag} | tail -n 1 | grep -o [0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9] > lastdate.txt

	# Replace underscores with hyphens to enable the `date` command to work (next step).
	sed -i 's/_/-/g' lastdate.txt

	# Add 5 days from the last date.
	nextdate=$(date '+%C%y %m %d' -d $(cat lastdate.txt)+5days)

	# Replace the reference date for daily mean at every 5 days with the new reference date (next saving date)
	sed -i "s/start_time.*set_nextdate/start_time: [ $nextdate 0 0 0 ] # set_nextdate/g" ocean/diag_table_source.yaml
	cd ocean
	./make_diag_table.py
	cd ../
fi
