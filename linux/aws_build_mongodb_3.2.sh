#!/bin/bash
# ----------------------------------------------------------------------
# /root/build_mongod.sh
#
# INSTRUCTIONS:
# LEGACY::Launch in a screen. Pre-warming the devices takes 10-12 hours.
#     EBS no longer requires pre-warming.
# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------
function resultcheck {
	if [ $? -eq $1 ] ; then echo -e "$TASK: \e[00;32mSUCCESS\e[00m" | tee -a build.log ; else echo -e "$TASK: \e[00;31mERROR\e[00m" | tee -a build.log ; fi
}

# ----------------------------------------------------------------------
# Main Operations
# ----------------------------------------------------------------------

echo -e "\n\n"
echo " ██╗ ██╗     ██████╗ ██╗███████╗ █████╗ ██████╗ ██╗     ███████╗    ███████╗███████╗██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
echo "████████╗    ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██║     ██╔════╝    ██╔════╝██╔════╝██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
echo "╚██╔═██╔╝    ██║  ██║██║███████╗███████║██████╔╝██║     █████╗      ███████╗█████╗  ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ "
echo "████████╗    ██║  ██║██║╚════██║██╔══██║██╔══██╗██║     ██╔══╝      ╚════██║██╔══╝  ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ "
echo "╚██╔═██╔╝    ██████╔╝██║███████║██║  ██║██████╔╝███████╗███████╗    ███████║███████╗███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
echo " ╚═╝ ╚═╝     ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝    ╚══════╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"

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

echo -e "\n\n"
echo " ██╗ ██╗     ██╗  ██╗ ██████╗ ███████╗████████╗███╗   ██╗ █████╗ ███╗   ███╗███████╗    ███████╗██╗██╗  ██╗"
echo "████████╗    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝████╗  ██║██╔══██╗████╗ ████║██╔════╝    ██╔════╝██║╚██╗██╔╝"
echo "╚██╔═██╔╝    ███████║██║   ██║███████╗   ██║   ██╔██╗ ██║███████║██╔████╔██║█████╗      █████╗  ██║ ╚███╔╝ "
echo "████████╗    ██╔══██║██║   ██║╚════██║   ██║   ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝      ██╔══╝  ██║ ██╔██╗ "
echo "╚██╔═██╔╝    ██║  ██║╚██████╔╝███████║   ██║   ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗    ██║     ██║██╔╝ ██╗"
echo " ╚═╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═╝"

TASK="Fix hostname preservation in Centos 7"
echo -e "\n$TASK..."
if grep 'CentOS Linux release 7' /etc/centos-release >&/dev/null ;then
    shortname=$(hostname | awk -F '.' '{ print $1 }')
    sudo hostnamectl set-hostname $shortname
    echo -e "\npreserve_hostname: true" | sudo tee -a /etc/cloud/cloud.cfg ; resultcheck 0
fi

echo -e "\n\n"
echo " ██╗ ██╗     ███████╗██████╗ ███████╗██╗         ██████╗ ███████╗██████╗  ██████╗ "
echo "████████╗    ██╔════╝██╔══██╗██╔════╝██║         ██╔══██╗██╔════╝██╔══██╗██╔═══██╗"
echo "╚██╔═██╔╝    █████╗  ██████╔╝█████╗  ██║         ██████╔╝█████╗  ██████╔╝██║   ██║"
echo "████████╗    ██╔══╝  ██╔═══╝ ██╔══╝  ██║         ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║"
echo "╚██╔═██╔╝    ███████╗██║     ███████╗███████╗    ██║  ██║███████╗██║     ╚██████╔╝"
echo " ╚═╝ ╚═╝     ╚══════╝╚═╝     ╚══════╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ "

TASK="Installing EPEL Repository"
echo -e "\n$TASK..."
sudo yum -y install epel-release ; resultcheck 0

TASK="Re-Synchronize Package Index Files"
echo -e "\n$TASK..."
sudo yum -y update ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗         ███████╗████████╗██╗   ██╗███████╗███████╗"
echo "████████╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║         ██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝"
echo "╚██╔═██╔╝    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║         ███████╗   ██║   ██║   ██║█████╗  █████╗  "
echo "████████╗    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║         ╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝  "
echo "╚██╔═██╔╝    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗    ███████║   ██║   ╚██████╔╝██║     ██║     "
echo " ╚═╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝    ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝     "

TASK="Installing Stuff"
echo -e "\n$TASK..."
sudo yum -y install vim lvm2 xfsprogs wget sysstat htop iotop iftop telnet lsof nmap ntp ntpdate gcc tmux bc mlocate unzip screen ; resultcheck 0

TASK="Reload systemctl daemon"
echo -e "\n$TASK..."
sudo systemctl daemon-reload ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ███████╗███████╗████████╗██╗   ██╗██████╗     ██╗    ██╗   ██╗███╗   ███╗"
echo "████████╗    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██║    ██║   ██║████╗ ████║"
echo "╚██╔═██╔╝    ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██║    ██║   ██║██╔████╔██║"
echo "████████╗    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██║    ╚██╗ ██╔╝██║╚██╔╝██║"
echo "╚██╔═██╔╝    ███████║███████╗   ██║   ╚██████╔╝██║         ███████╗╚████╔╝ ██║ ╚═╝ ██║"
echo " ╚═╝ ╚═╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚══════╝ ╚═══╝  ╚═╝     ╚═╝"

TASK="systemd & LVMs..."
echo -e "\n$TASK..."
sudo systemctl enable lvm2-lvmetad.service ; resultcheck 0
sudo systemctl enable lvm2-lvmetad.socket ; resultcheck 0
sudo systemctl start lvm2-lvmetad.service ; resultcheck 0
sudo systemctl start lvm2-lvmetad.socket ; resultcheck 0

echo "Build First LVM Segment..."
TASK="Initialize Disks"
echo -e "\n$TASK..."
sudo pvcreate -ff /dev/xvd[bcdefghi] ; resultcheck 0

TASK="Create Volume Group"
echo -e "\n$TASK..."
sudo vgcreate vg0 /dev/xvd[bcdefghi] ; resultcheck 0

TASK="Create Logical Volume"
echo -e "\n$TASK..."
sudo lvcreate --extents 100%FREE --stripes 8 --stripesize 128 --readahead 32 --name lv0 vg0 ; resultcheck 0

TASK="Build Linux File System"
echo -e "\n$TASK..."
sudo mkfs.xfs /dev/mapper/vg0-lv0 ; resultcheck 0

TASK="Make /mongodb/data"
echo -e "\n$TASK..."
sudo mkdir -p /mongodb/data ; resultcheck 0

# If blkid caches results.
TASK="Prime blkid"
echo -e "\n$TASK..."
sudo blkid ; resultcheck 0

TASK="Get LVM UUID"
echo -e "\n$TASK..."
uuid="$(sudo blkid | grep vg0 | cut -d' ' -f2 | sed 's/"//g')" ; resultcheck 0

TASK="Add Entry To /etc/fstab"
echo -e "\n$TASK..."
echo "$uuid    /mongodb/data    xfs    defaults,auto,noatime,noexec    0    0" | sudo tee -a /etc/fstab ; resultcheck 0

TASK="Mount LVM"
echo -e "\n$TASK..."
sudo mount -a ; resultcheck 0

TASK="Verify Volume Mount"
echo -e "\n$TASK..."
df -h | grep "vg0"; resultcheck 0

TASK="Clean /mongodb/data"
echo -e "\n$TASK..."
sudo rm -rf /mongodb/data/* ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ███████╗███████╗████████╗██╗   ██╗██████╗     ███████╗██╗    ██╗ █████╗ ██████╗ "
echo "████████╗    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██╔════╝██║    ██║██╔══██╗██╔══██╗"
echo "╚██╔═██╔╝    ███████╗█████╗     ██║   ██║   ██║██████╔╝    ███████╗██║ █╗ ██║███████║██████╔╝"
echo "████████╗    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ╚════██║██║███╗██║██╔══██║██╔═══╝ "
echo "╚██╔═██╔╝    ███████║███████╗   ██║   ╚██████╔╝██║         ███████║╚███╔███╔╝██║  ██║██║     "
echo " ╚═╝ ╚═╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     "

TASK="Generate Swapfile"
echo -e "\n$TASK..."
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024 ; resultcheck 0

TASK="Setup Swapfile"
echo -e "\n$TASK..."
sudo mkswap /swapfile ; resultcheck 0

TASK="Enable Swapfile"
echo -e "\n$TASK..."
sudo swapon /swapfile ; resultcheck 0

TASK="Add Swapfile Entry to /etc/fstab"
echo -e "\n$TASK..."
echo "/swapfile    swap    swap    defaults    0    0" | sudo tee -a /etc/fstab ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ███╗   ███╗ ██████╗ ███╗   ██╗ ██████╗  ██████╗     ██████╗ ███████╗██████╗  ██████╗ "
echo "████████╗    ████╗ ████║██╔═══██╗████╗  ██║██╔════╝ ██╔═══██╗    ██╔══██╗██╔════╝██╔══██╗██╔═══██╗"
echo "╚██╔═██╔╝    ██╔████╔██║██║   ██║██╔██╗ ██║██║  ███╗██║   ██║    ██████╔╝█████╗  ██████╔╝██║   ██║"
echo "████████╗    ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║██║   ██║    ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║"
echo "╚██╔═██╔╝    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║╚██████╔╝╚██████╔╝    ██║  ██║███████╗██║     ╚██████╔╝"
echo " ╚═╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝     ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ "

TASK="Adding MongoDB 3.0 Repository"
echo -e "\n$TASK..."
echo -e "[mongodb-org-3.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.2/x86_64/\ngpgcheck=0\nenabled=1" | sudo tee -a /etc/yum.repos.d/mongodb.repo ; resultcheck 0

TASK="Re-Synchronize Package Index Files"
echo -e "\n$TASK..."
sudo yum -y update ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ███╗   ███╗ ██████╗ ███╗   ██╗ ██████╗  ██████╗ ██████╗ ██████╗     ██████╗    ██████╗    ██╗  ██╗"
echo "████████╗    ████╗ ████║██╔═══██╗████╗  ██║██╔════╝ ██╔═══██╗██╔══██╗██╔══██╗    ╚════██╗   ╚════██╗   ╚██╗██╔╝"
echo "╚██╔═██╔╝    ██╔████╔██║██║   ██║██╔██╗ ██║██║  ███╗██║   ██║██║  ██║██████╔╝     █████╔╝    █████╔╝    ╚███╔╝ "
echo "████████╗    ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║██║   ██║██║  ██║██╔══██╗     ╚═══██╗   ██╔═══╝     ██╔██╗ "
echo "╚██╔═██╔╝    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║╚██████╔╝╚██████╔╝██████╔╝██████╔╝    ██████╔╝██╗███████╗██╗██╔╝ ██╗"
echo " ╚═╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝     ╚═════╝ ╚═╝╚══════╝╚═╝╚═╝  ╚═╝"

TASK="Make /mongodb/indexes"
echo -e "\n$TASK..."
sudo mkdir /mongodb/indexes ; resultcheck 0

TASK="Build Linux File System"
echo -e "\n$TASK..."
sudo mkfs.xfs /dev/xvdj ; resultcheck 0

TASK="Add Entry To /etc/fstab"
echo -e "\n$TASK..."
echo "/dev/xvdk    /mongodb/indexes    xfs    defaults,auto,noatime,noexec    0    0" | sudo tee -a /etc/fstab ; resultcheck 0

TASK="Make /mongodb/journal"
echo -e "\n$TASK..."
sudo mkdir /mongodb/journal ; resultcheck 0

TASK="Build Linux File System"
echo -e "\n$TASK..."
sudo mkfs.xfs /dev/xvdk ; resultcheck 0

TASK="Add Entry To /etc/fstab"
echo -e "\n$TASK..."
echo "/dev/xvdj    /mongodb/journal    xfs    defaults,auto,noatime,noexec    0    0" | sudo tee -a /etc/fstab ; resultcheck 0

TASK="Mount All"
echo -e "\n$TASK..."
sudo mount -a ; resultcheck 0

TASK="Create Index Link"
echo -e "\n$TASK..."
sudo ln -s /mongodb/indexes /mongodb/data/index ; resultcheck 0

TASK="Create Journal Link"
echo -e "\n$TASK..."
sudo ln -s /mongodb/journal /mongodb/data/journal ; resultcheck 0

TASK="Installing MongoDB 3.2"
echo -e "\n$TASK..."
sudo yum -y install mongodb-org ; resultcheck 0

TASK="Pinning MongoDB Version"
echo -e "\n$TASK..."
echo "exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools" | sudo tee -a /etc/yum.conf ; resultcheck 0

TASK="Hack /etc/init.d/mongod"
echo -e "\n$TASK..."
sudo sed -ir '/# Make sure the default pidfile directory exists/i\  # DIRTY readahead hack to present monogd with an acceptable RA at init time. The LV defiend RA catches up shortly after.\n\  RA="\$(blockdev --report | grep dm-0 | awk \x27{print\ \$2}\x27)" ; if [ \$RA -eq 32 ] ; then : ; else blockdev --setra 32 /dev/dm-0 ; fi' /etc/init.d/mongod ; resultcheck 0

TASK="Chown /mongodb/ to mongod:mongod"
echo -e "\n$TASK..."
sudo chown -R mongod:mongod /mongodb ; resultcheck 0

TASK="Create /etc/mongodb.conf" ; echo -e "\n$TASK..."
sudo bash -c 'cat << EOF > /etc/mongod.conf
storage:
   dbPath: /mongodb/data
   journal:
      enabled: true
   engine: wiredTiger
   wiredTiger:
      engineConfig:
         directoryForIndexes: true
systemLog:
   path: /var/log/mongodb/mongod.log
   logAppend: true
   destination: file
processManagement:
   fork: true
   pidFilePath: /var/run/mongodb/mongod.pid
replication:
   replSetName: rsXXX
   oplogSizeMB: 120000
/etc/mongod.conf (END)
EOF' ; resultcheck 0

TASK="Setup mongod-logroller.sh" 
echo -e "\n$TASK..."
sudo mkdir /root/cron ; resultcheck 0
sudo wget http://deploy.clforest.com/infrastructure/mongodb/mongod-logroller.sh -O /root/cron/mongod-logroller.sh ; resultcheck 0
sudo chmod +x /root/cron/mongod-logroller.sh ; resultcheck 0
(crontab -l 2>/dev/null; echo "*/10 * * * * /root/cron/mongod-logroller.sh") | sudo crontab - ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ████████╗██╗   ██╗███╗   ██╗██╗███╗   ██╗ ██████╗ "
echo "████████╗    ╚══██╔══╝██║   ██║████╗  ██║██║████╗  ██║██╔════╝ "
echo "╚██╔═██╔╝       ██║   ██║   ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗"
echo "████████╗       ██║   ██║   ██║██║╚██╗██║██║██║╚██╗██║██║   ██║"
echo "╚██╔═██╔╝       ██║   ╚██████╔╝██║ ╚████║██║██║ ╚████║╚██████╔╝"
echo " ╚═╝ ╚═╝        ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ "

TASK="Adjust Limits"
echo -e "\n$TASK..."
sudo sed -i '/# End of file/d' /etc/security/limits.conf ; resultcheck 0
echo "mongod           hard    fsize           unlimited" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           soft    fsize           unlimited" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           hard    cpu             unlimited" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           soft    cpu             unlimited" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           hard    nofile          64000" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           soft    nofile          64000" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           hard    nproc           64000" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "mongod           soft    nproc           64000" | sudo tee -a /etc/security/limits.conf ; resultcheck 0
echo "# End of file" | sudo tee -a /etc/security/limits.conf ; resultcheck 0

TASK="Disable THP - Create init script"
echo -e "\n$TASK..."
sudo bash -c 'cat << EOF > /etc/init.d/disable-transparent-hugepages
#!/bin/sh
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    \$local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case \$1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo '"'"'never'"'"' > \${thp_path}/enabled
    echo '"'"'never'"'"' > \${thp_path}/defrag

    unset thp_path
    ;;
esac
EOF' ; resultcheck 0

TASK="Disable THP - Set init script permissions"
echo -e "\n$TASK..."
sudo chmod 755 /etc/init.d/disable-transparent-hugepages ; resultcheck 0

TASK="Disable THP - Enable init script"
echo -e "\n$TASK..."
sudo chkconfig --add disable-transparent-hugepages ; resultcheck 0

TASK="Disable THP - Create tuned profile"
echo -e "\n$TASK..."
sudo mkdir /etc/tuned/no-thp ; resultcheck 0

TASK="Disable THP - Create tuned profile config"
echo -e "\n$TASK..."
sudo bash -c 'cat << 'EOF' > /etc/tuned/no-thp/tuned.conf
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
EOF' ; resultcheck 0

TASK="Disable THP - Enable tuned profile"
echo -e "\n$TASK..."
sudo tuned-adm profile no-thp ; resultcheck 0

TASK="Set TCPKeepAlive Time: 120"
echo -e "\n$TASK..."
echo "net.ipv4.tcp_keepalive_time = 120" | sudo tee -a /etc/sysctl.conf ; resultcheck 0

TASK="Check Zone-Reclaim Mode"
echo -e "\n$TASK..."
sudo grep 0 /proc/sys/vm/zone_reclaim_mode ; resultcheck 0

TASK="Add 'set bg=dark' to /etc/vimrc "
echo -e "\n$TASK..."
echo "set bg=dark" | sudo tee -a /etc/vimrc ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ███████╗████████╗ █████╗ ██████╗ ████████╗██╗   ██╗██████╗     ██╗████████╗███████╗███╗   ███╗███████╗"
echo "████████╗    ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝██║   ██║██╔══██╗    ██║╚══██╔══╝██╔════╝████╗ ████║██╔════╝"
echo "╚██╔═██╔╝    ███████╗   ██║   ███████║██████╔╝   ██║   ██║   ██║██████╔╝    ██║   ██║   █████╗  ██╔████╔██║███████╗"
echo "████████╗    ╚════██║   ██║   ██╔══██║██╔══██╗   ██║   ██║   ██║██╔═══╝     ██║   ██║   ██╔══╝  ██║╚██╔╝██║╚════██║"
echo "╚██╔═██╔╝    ███████║   ██║   ██║  ██║██║  ██║   ██║   ╚██████╔╝██║         ██║   ██║   ███████╗██║ ╚═╝ ██║███████║"
echo " ╚═╝ ╚═╝     ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝"


TASK="Add Startup Service: ntpd"
echo -e "\n$TASK..."
sudo systemctl enable ntpd ; resultcheck 0

TASK="Start Service: ntpd"
echo -e "\n$TASK..."
sudo systemctl start ntpd ; resultcheck 0

TASK="Add Startup Service: mongod"
echo -e "\n$TASK..."
sudo systemctl enable mongod ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ███╗   ██╗ █████╗  ██████╗ "
echo "████████╗    ████╗  ██║██╔══██╗██╔════╝ "
echo "╚██╔═██╔╝    ██╔██╗ ██║███████║██║  ███╗"
echo "████████╗    ██║╚██╗██║██╔══██║██║   ██║"
echo "╚██╔═██╔╝    ██║ ╚████║██║  ██║╚██████╔╝"
echo " ╚═╝ ╚═╝     ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ "

TASK="Add User: nagios"
echo -e "\n$TASK..."
sudo useradd -m nagios ; resultcheck 0

TASK="Setup: /home/nagios/.ssh"
echo -e "\n$TASK..."
sudo mkdir /home/nagios/.ssh ; resultcheck 0

TASK="Setup: authorized_keys2"
echo -e "\n$TASK..."
sudo touch /home/nagios/.ssh/authorized_keys2 ; resultcheck 0

TASK="Chown -R /home/nagios"
echo -e "\n$TASK..."
sudo chown -R nagios:nagios /home/nagios/ ; resultcheck 0

TASK="Setup Permissions"
echo -e "\n$TASK..."
sudo chmod 700 /home/nagios/.ssh/ && sudo chmod 644 /home/nagios/.ssh/authorized_keys2 ; resultcheck 0

TASK="Insert SSH Key"
echo -e "\n$TASK..."
echo "ssh-rsa ggggggggggggggggggggggggg" | sudo tee -a /home/nagios/.ssh/authorized_keys2 ; resultcheck 0

TASK="Enable authorized_keys2 handling by sshd"
echo -e "\n$TASK..."
sudo sed -e "/AuthorizedKeysFile/ s/^#*/#/" -i /etc/ssh/sshd_config ; resultcheck 0

TASK="Reload sshd"
echo -e "\n$TASK..."
sudo service sshd reload ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗      ██████╗██╗     ███████╗ █████╗ ███╗   ██╗██╗   ██╗██████╗ "
echo "████████╗    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██║   ██║██╔══██╗"
echo "╚██╔═██╔╝    ██║     ██║     █████╗  ███████║██╔██╗ ██║██║   ██║██████╔╝"
echo "████████╗    ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██║   ██║██╔═══╝ "
echo "╚██╔═██╔╝    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║╚██████╔╝██║     "
echo " ╚═╝ ╚═╝      ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     "

#TASK="Delete: buildmongod.sh"
#echo -e "\n$TASK..."
#sudo rm $0 ; resultcheck 0

echo -e "\n\n"
echo " ██╗ ██╗     ██████╗ ███████╗███████╗████████╗ █████╗ ██████╗ ████████╗"
echo "████████╗    ██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝"
echo "╚██╔═██╔╝    ██████╔╝█████╗  ███████╗   ██║   ███████║██████╔╝   ██║   "
echo "████████╗    ██╔══██╗██╔══╝  ╚════██║   ██║   ██╔══██║██╔══██╗   ██║   "
echo "╚██╔═██╔╝    ██║  ██║███████╗███████║   ██║   ██║  ██║██║  ██║   ██║   "
echo " ╚═╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   "

#TASK="Host Setup Complete! Rebooting NOW!"
#echo -e "\n$TASK..."
#sudo shutdown -r 0
echo -e "Build Complete. Review results, edit /etc/mongod.conf & restart system.\nBye-bye!" | tee -a build.log
