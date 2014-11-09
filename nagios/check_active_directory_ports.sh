#!/bin/bash
# ----------------------------------------------------------------------
# File:         check_ad_ds_ports.sh
# Description:  Checks port availability required for Active Directory functionality
#
# Use:  ./check_ad_ds_ports.sh
#
# ----------------------------------------------------------------------
# Author:       Alex Atkinson
# Date:         June 13, 2014
# Modified:     June 13, 2014
# Version:      1.0
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------

echo -n "Enter the hostname or IP of a Domain Controller and press [ENTER]: "
read host

dnscheck=$(host $host)
if [[ $? -eq 0 ]]; then
    echo $dnscheck
else

    echo -e "\e[00;31mERROR\e[00m: DNS was unable to resolve the provided hostname or IP:" $host"."
    echo -n "Press [ENTER] key to continue, or [Q] to quit..."
    read -n 1 -s key
    if [[ $key = q ]] || [[ $key = Q ]]; then
        echo -e "\nExiting...\n"
        exit 1
    fi
fi

echo -e "\nChecking Common Active Directory Domain Services Ports...\n"
#echo -e "Result \t\t Details \t\t\t Port Use"
#echo -e "------ \t\t ------- \t\t\t --------"
printf '%-10s %-20s \t %-s %-s \n' Result Details Port Use
printf '%-10s %-20s \t %-s %-s \n' ------ ------- --------
echo "tcp 389 LDAP
tcp 135 RPC EPM
udp 135 RPC EPM
tcp 137 NetBIOS Name Service
udp 137 NetBIOS Name Service
udp 138 NetBIOS Datagram Service
tcp 139 NetBIOS Session Service
tcp 389 LDAP Ping
udp 389 LDAP
tcp 636 LDAP SSL
tcp 3268 LDAP GC
tcp 3269 LDAP GC SSL
tcp 88 Kerberos
udp 88 Kerberos
tcp 53 DNS
udp 53 DNS
tcp 445 SMB, CIFS, SMB2, DFSN, LSARPC, NbtSS, NetLogonR, SamR, SrvSvc
udp 445 SMB, CIFS, SMB2, DFSN, LSARPC, NbtSS, NetLogonR, SamR, SrvSvc
tcp 25 SMTP
dcp 5722 RPC, DFSR (SYSVOL)
udp 123 Windows Time
tcp 464 Kerberos change/set password
udp 464 Kerberos change/set password
tcp 9389 SOAP
tcp 67 DHCP, MADCAP
udp 2535 DHCP, MADCAP'" | \
while read protocol port traffic; do
    if [[ $portocol -eq "tcp" ]]; then
        nc -w 1 $host $port < /dev/null
    else
        nc -u -w 1 $host $port < /dev/null
    fi
    if [[ $? -eq "0" ]]; then
#        echo -e "SUCCESS: \t Port" $port "("$protocol") is open. \t "$traffic
#    else
#        echo -e "FAIL: \t\t Port "$port "("$protocol") is closed. \t "$traffic
        printf '%-10s %-s %-s %-10s \t %-s %-s %-s %-s %-s %-s %-s %-s %-s\n' "SUCCESS:" "Port" $port "("$protocol") is open." $traffic
    else
        printf '%-10s %-s %-s %-10s \t %-s %-s %-s %-s %-s %-s %-s %-s %-s\n' "FAIL:" "Port" $port "("$protocol") is closed." $traffic
    fi
done
echo -e "\nVisit http://technet.microsoft.com/en-us/library/dd772723%28WS.10%29.aspx for more information on port use by Active Directory\n"
exit
