#!/bin/bash
# ----------------------------------------------------------------------
# dbcopy_notify
# This is a janky solution to monitor the progress of a DB copy
# initiated using phpmyadmin.
# Watches the mysql proccesslist for processes matching $NEWDB
# Notifies if no matching process for set time period
# The assumption is that no activity means the db copy is done... jank.
# ----------------------------------------------------------------------
# Author:               Alex Atkinson
# Author Date:          January 4, 2012
# Last Modified:        January 4, 2012
# Modified By:          Alex Atkinson
# ----------------------------------------------------------------------
# Sanity Checks
# ----------------------------------------------------------------------
if [ ! $STY ] ; then
    echo "This script must be run within a screen."
	exit 1
fi
# ----------------------------------------------------------------------
# Set Variables
# ----------------------------------------------------------------------
read -p "New Database Name:" newdb
read -p "Username:" dbuser
read -s -p"Password:" dbpass
sec_count=3
recipient="notice@yourdomain.com"											# Edit
# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------
#set -x
i=1
while [ $i -le 10 ] ;
do
        mysqladmin -u$dbuser -p$dbpass processlist |
        egrep -vw 'Sleep|processlist|Binlog Dump' |
        awk -F'|' '{print $6, $7, $8, $9}' | grep "$newdb"
        if [ $? != 0 ] ; then
                (( i++ ))
        else
                (( i=1 )) # Reset i if proccesslist returns activity
        fi
        sleep $sec_count # sleeps to reduce load
done
echo "Copy of $newdb is DONE!" | mailx -s "Copy of $newdb is DONE!" $recipient
exit $?
