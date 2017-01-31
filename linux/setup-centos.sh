#!/bin/bash
# ----------------------------------------------------------------------
# ./centos_setup.sh
#
# Hint:
#     sudo su -
#     mkdir scripts; vi scripts/centos_setup.sh
#
# Note: Insert the nagplug SSH key below.
#
# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
function resultcheck {
	if [ $? -eq "$1" ] ; then echo -e "$TASK: \e[00;32mSUCCESS\e[00m" | tee -a centos_setup.log ; else echo -e "$TASK: \e[00;31mERROR\e[00m" | tee -a centos_setup.log ; fi
}

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------

TASK="Disable SELinux via Configuration File"
echo -e "\n$TASK..."
sudo sed 's/SELINUX=enforcing/SELINUX=disabled/g' -i /etc/selinux/config ; resultcheck 0

TASK="Verifying SELinux Configuration File"
echo -e "\n$TASK..."
sudo sestatus | grep "Mode from config file" | grep disabled ; resultcheck 0

TASK="Disable IPtables - CentOS v <= 6. Fails on 7. Could add sanity..."
echo -e "\n$TASK..."
sudo chkconfig iptables off ; resultcheck 0
sudo /etc/init.d/iptables stop ; resultcheck 0
sudo service iptables stop ; resultcheck 0

TASK="Fix hostname preservation in Centos 7"
echo -e "\n$TASK..."
if grep 'CentOS Linux release 7' /etc/centos-release >&/dev/null ;then
    shortname=$(hostname | awk -F '.' '{ print $1 }')
    sudo hostnamectl set-hostname "$shortname"
    echo -e "\npreserve_hostname: true" | sudo tee -a /etc/cloud/cloud.cfg ; resultcheck 0
fi

TASK="Installing EPEL Repository"
echo -e "\n$TASK..."
sudo yum -y install epel-release ; resultcheck 0

TASK="Re-Synchronize Package Index Files"
echo -e "\n$TASK..."
sudo yum -y update ; resultcheck 0

TASK="Installing Stuff"
echo -e "\n$TASK..."
sudo yum -y install vim psmisc lvm2 parted wget sysstat dstat htop iotop iftop \
telnet lsof nc telnet nmap ntp ntpdate gcc tmux bc mlocate unzip screen pcp \
pcp-webapi ; resultcheck 0

TASK="Initiate mlocate"
echo -e "\n$TASK..."
sudo updatedb ; resultcheck 0

TASK="vi: set bg=dark"
echo -e "\n$TASK..."
echo -e "\nset bg=dark" | sudo tee -a /etc/vimrc ; resultcheck 0

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
echo "ssh-rsa gggggggggggg" | sudo tee -a /home/nagplug/.ssh/authorized_keys2 ; resultcheck 0

TASK="Enable authorized_keys2 handling by sshd"
echo -e "\n$TASK..."
sudo sed -e "/AuthorizedKeysFile/ s/^#*/#/" -i /etc/ssh/sshd_config ; resultcheck 0

TASK="Reload sshd"
echo -e "\n$TASK..."
sudo service sshd reload ; resultcheck 0

TASK="Add Startup Service: ntpd"
echo -e "\n$TASK..."
sudo
sudo systemctl enable ntpd ; resultcheck 0

TASK="Start Service: ntpd"
echo -e "\n$TASK..."
sudo systemctl start ntpd ; resultcheck 0

TASK="Fix hostname preservation in Centos 7"
echo -e "\n$TASK..."
if grep 'CentOS Linux release 7' /etc/centos-release >&/dev/null ;then
    shortname=$(hostname | awk -F '.' '{ print $1 }')
    sudo hostnamectl set-hostname "$shortname"
    echo -e "\npreserve_hostname: true" | sudo tee -a /etc/cloud/cloud.cfg ; resultcheck 0
fi
