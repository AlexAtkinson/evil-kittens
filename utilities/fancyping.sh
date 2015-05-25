#!/bin/bash
# ------------------------------------------------------------------
# superuserping.sh # Can be changed :P
# /usr/bin/superuserping.sh # Put it wherever you like...
# ------------------------------------------------------------------
# Usage:           ./superuserping.sh [fqdn|shortname|ip]
#                  If no argument is passed it will ask for one
# Author:          Alex Atkinson (www.alexatkinson.ca)
# Author Date:     May 25, 2015

# ------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------
domain="pernicious.dog"
rxshort='^[A-Za-z0-9]{1,63}$'
rxfqdn='^([A-Za-z0-9-]{1,63}\.)+[A-Za-z]{2,6}$'
rxip='^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# ------------------------------------------------------------------
# Check for argument. Get one if none found.
# ------------------------------------------------------------------
if [ -z $1 ]; then
    echo -n "Enter the hostname or IP to ping and press [ENTER]: "
    read host
else
    host=$1
fi

# ------------------------------------------------------------------
# ARGUMENT VALIDATION
# ------------------------------------------------------------------
checkshort=$([[ $host =~ $rxshort ]])
checkshort=$?
checkfqdn=$([[ $host =~ $rxfqdn ]])
checkfqdn=$?
checkip=$([[ $host =~ $rxip ]])
checkip=$?

# ------------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------------
function check_userinput()
{
# Validate userinput against shortname, fqdn, and IP regex. If shortname then add domain.
    if [[ $checkshort == '0' ]] || [[ $checkfqdn == "0" ]] || [[ $checkip == "0" ]] ; then
        if [[ $checkip == 1 ]]; then
            if [[ $host != *$domain ]]; then
                host=$host.$domain
            fi
        fi
    else
        echo -e "\e[00;31mERROR\e[00m: ERROR:" $host "does not appear to be a valid shortname, fqdn, or IP."
        exit 1
    fi
}

function resolve_host()
{
# Check for DNS host resolution.
    dnscheck=$(host $host)
    if [[ $? -eq 0 ]]; then
        echo -e "\n"$dnscheck "\n"
    else
        echo -e "\n\e[00;31mERROR\e[00m: DNS was unable to resolve the provided hostname or IP:" $host".\n"
        echo -n "Press [ENTER] key to continue with ping, or [Q] to quit..."
        read -n 1 -s key
        if [[ $key = q ]] || [[ $key = Q ]]; then
            echo -e "\nExiting...\n"
            exit 1
        fi
    fi
}

# ------------------------------------------------------------------
# MAIN OPERATIONS
# ------------------------------------------------------------------
check_userinput
resolve_host
ping $host
