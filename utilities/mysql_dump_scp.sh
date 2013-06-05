#!/bin/bash
# ----------------------------------------------------------------------
# /root/dumphandler/scp_dump_cron
# MySQL dump file retrieval for tape backup
# Runs as scheduled with crontab
# ----------------------------------------------------------------------
# Author:               Alex Atkinson
# Author Date:          December 11, 2012
# Last Modified:        December 13, 2012
# Modified By:          Alex Atkinson
# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
recipient="notice@yourdomain.com"
dump="filename"
notes="$(date +"%Y-%m-%d").notes"
from="user@xxx.xxx.xxx.xxx:/data/"
src="source hostname"
localhost="local hostname"
local_dir="/data"
# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------
# Move Last Week's Files
mkdir /data/cron_bak
mv /data/*.notes /data/cron_bak
mv /data/$dump /data/cron_bak
# Get Files
scp "$from""$notes" "$local_DIR"
if [ $? == 0 ] ; then
    notecopy="ok"
else
	echo "Error: Copy of $notes to $localhost:$local_dir has FAILED!" | mailx -s "Error: Copy of $notes to $localhost:$local_dir has FAILED!" $recipient
	exit 1
fi
scp "$from""$dump" "$local_DIR"
if [ $? == 0 ] ; then
	dumpcopy="ok"
else
	echo "Error: Copy of $dump to $localhost:$local_dir has FAILED!" | mailx -s "Error: Copy of $dump to $localhost:$local_dir has FAILED!" $recipient
	exit 1
fi
# Delete cron_bak dir
if [ $notecopy == "ok" && $dumpcopy == "ok" ] ; then
	rm -rf /data/cron_bak
fi
