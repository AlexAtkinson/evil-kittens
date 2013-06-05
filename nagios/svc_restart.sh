#!/bin/bash
# ----------------------------------------------------------------------
# Nagios Event Handler Script
# Called By NRPE To Restart Failed Services
# See /etc/nagios/nrpe.cfg For Command Definitions
# ----------------------------------------------------------------------
# Author:               Alex Atkinson
# Author Date:          December 06, 2012
# Last Modified:        December 14, 2012
# Modified By:          Alex Atkinson
# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
NOW=[$(date +"%b %d %T")]
USER="nrpe"
RESTART="/usr/bin/sudo /sbin/service $SERVICE restart"
LOG_DIR="/var/log/nagios"
LOG="/var/log/nagios/nrpe_actions.log"
SUCCESS_MSG='sudo echo -e "$NOW\tNOTICE: Nagios has restarted the $SERVICE service" >> $LOG'
FAILURE_MSG='sudo echo -e "$NOW\tWARNING: Nagios has FAILED to restart the $SERVICE service" >> $LOG'
RESTART_TRY='sudo echo -e "$NOW\tINFO: Nagios initiated a call to restart the $SERVICE service, but it was already running." >> $LOG'
# ----------------------------------------------------------------------
# Sanity Checks
# ----------------------------------------------------------------------
# Script must be runs as nrpe
if [ "$(whoami)" != $USER ] ; then
        echo -e "\nError: This script *must* be run as $USER!\n"
        exit 1
fi
# SVC_CHK must be defined & service must not be running
if [ -n $SVC_CHK ] ; then
        if [ $SVC_CHK ] ; then
                echo -e "\nError: The $SERVICE service (PID $SVC_CHK) is already running.\n"
                eval $RESTART_TRY
                exit 1
        fi
else
        echo -e "\nError: Undefined variable SVC_CHK.\n"
        exit 1
fi
# $LOG_DIR & $LOG must exist and be writable
if [ ! -d $LOG_DIR ] ; then
        mkdir "$LOG_DIR"
        chown -R nrpe:nrpe "$LOG_DIR"
elif [ ! -w $LOG_DIR ] ; then
        chown -R nrpe:nrpe "$LOG_DIR"
fi
if [ ! -f $LOG ] ; then
        touch "$LOG"
        chmod 0640 "$LOG"
elif [ ! -w $LOG ] ; then
        chmod 0640 "$LOG"
        if [ ! -w $LOG ] ; then
                echo -e "\nError: Could not verify write access to $LOG.\n"
                exit 1
        fi
fi
# ----------------------------------------------------------------------
# Main Command Sequence
# ----------------------------------------------------------------------
$RESTART && eval $SUCCESS_MSG || eval $FAILURE_MSG
echo "DONE! EOF"
exit 0
