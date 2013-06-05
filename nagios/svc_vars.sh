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
# Set Variables, Export & Handoff To svc_restart
# ----------------------------------------------------------------------
SERVICE="<service name>"
# Set PROCESS if pgrep string != SERVICE
PROCESS="<process name>"
# If PROCESS is not set, edit SVC_CHECK accordingly
SVC_CHK=$(pgrep -u apache -f $PROCESS)
export SERVICE
export PROCESS
export SVC_CHK
THIS_DIR=$(dirname $0)
$THIS_DIR/$1
