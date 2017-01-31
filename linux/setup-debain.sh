#!/bin/bash

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
function resultcheck {
	if [ $? -eq $1 ] ; then echo -e "$TASK: \e[00;32mSUCCESS\e[00m" | tee -a debian_setup.log ; else echo -e "$TASK: \e[00;31mERROR\e[00m" | tee -a debian_setup.log ; fi
}

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------

TASK="Run: apt-get update"
echo -e "\n$TASK..."
sudo apt-get -y update ; resultcheck 0
TASK="Run: apt-get upgrade"
echo -e "\n$TASK..."
sudo apt-get -y upgrade ; resultcheck 0
TASK="Install stuff"
echo -e "\n$TASK..."
sudo apt-get -y install vim less psmisc parted sysstat dstat curl htop iotop \
iftop telnet lsof nmap ntp ntpdate tmux bc unzip screen mlocate binutils \
pcp pcp-webapi; resultcheck 0

TASK="Initiate mlocate"
echo -e "\n$TASK..."
sudo updatedb ; resultcheck 0

TASK="Add User: nagplug"
echo -e "\n$TASK..."
sudo useradd -m nagplug -s /bin/bash ; resultcheck 0

TASK="Setup: /home/nagplug/.ssh"
echo -e "\n$TASK..."
sudo mkdir /home/nagplug/.ssh ; resultcheck 0

TASK="Setup: authorized_keys2"
echo -e "\n$TASK..."
sudo touch /home/nagplug/.ssh/authorized_keys2 ; resultcheck 0

TASK="Chown -R /home/nagplug"
echo -e "\n$TASK..."
sudo chown -R nagplug:nagplug /home/nagplug/ ; resultcheck 0

TASK="Setup Permissions"
echo -e "\n$TASK..."
sudo chmod 700 /home/nagplug/.ssh/ && sudo chmod 644 /home/nagplug/.ssh/authorized_keys2 ; resultcheck 0

TASK="Insert SSH Key"
echo -e "\n$TASK..."
echo "ssh-rsa gggggggggggggg" | sudo tee -a /home/nagplug/.ssh/authorized_keys2 ; resultcheck 0

TASK="Enable authorized_keys2 handling by sshd"
echo -e "\n$TASK..."
sudo sed -e "/AuthorizedKeysFile/ s/^#*/#/" -i /etc/ssh/sshd_config ; resultcheck 0

TASK="Reload sshd"
echo -e "\n$TASK..."
sudo service sshd reload ; resultcheck 0
