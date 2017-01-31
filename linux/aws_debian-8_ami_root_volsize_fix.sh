#!/bin/bash
# Run this to create init script for Debian 8 AMIs that autoresizes the root EBS partition
ROOTDEV="xvda"
ROOTPART="xvda1"
rootdevsize=$(blockdev --getsize /dev/${ROOTDEV})
rootpartsize=$(blockdev --getsize /dev/${ROOTPART})
if ! grep -q ${ROOTPART} /proc/partitions
then
    # EBS volume is unpartitioned ... no work for us
    exit 0
fi
source /etc/os-release
if [ $VERSION_ID -gt 8 ]
then
    # Exclude future Debian AMIs that hopefully will have this fixed
    exit 0
fi
cat >/etc/init.d/ami-resizerootpart.sh <<'EOF'
#! /bin/sh
### BEGIN INIT INFO
# Provides:          ami-resizerootpart
# Required-Start:    $local_fs $syslog
# Required-Stop:
# Should-Start:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Resize root partition on AWS if it smaller than the size of the device
# Description:       When using the Debian 8 AWS AMIs with root EBS fs, EBS is partitioned.
#                    As a result, when launching a new instance with a larger than default
#                    root EBS size, /dev/xvda has desired size but not /dev/xvda1 root
#                    partition.
#                    /etc/init.d/ami-resizerootpart detects this discrepancy and resizes
#                    the partition, triggering a reboot and fsck. cloud-init will resize the
#                    fs by itself after the reboot.
### END INIT INFO
. /lib/init/vars.sh
. /lib/init/mount-functions.sh
. /lib/lsb/init-functions
PATH=/sbin:/bin:/usr/sbin:/usr/bin
do_start() {
    ROOTDEV="xvda"
    ROOTPART="xvda1"
    LOGFILE="/var/log/resizerootfs.log"
    rootdevsize=$(blockdev --getsize /dev/${ROOTDEV})
    rootpartsize=$(blockdev --getsize /dev/${ROOTPART})
    if ! grep -q ${ROOTPART} /proc/partitions
    then
        # EBS volume is unpartitioned ... no work for us
        echo "Unpartitioned EBS volume no need to run" >>$LOGFILE
        return 0
    fi
    # Check if raw EBS device and partition differ by more than 10MB
    if [ ! $(($rootdevsize-$rootpartsize)) -ge 10485760 ]
    then
       # No need to resize
        echo "EBS partition is <=10MB of the device size; no need to act" >>$LOGFILE
       return 0
    fi
    # Resize root partition
    /sbin/parted ---pretend-input-tty /dev/${ROOTDEV} resizepart 1 yes 100%
    if [ ! $? -eq 0 ]
    then
        echo "Resize failed" >>$LOGFILE
        return 0
    fi
    echo "Successfully resized rootfs!" >>$LOGFILE
    # Force fsck on next reboot
    /usr/bin/touch /forcefsck
    # Disable myself job done
    rm /etc/rc5.d/S05ami-resizerootpart.sh
    sync
    reboot
}
case "$1" in
  start|"")
        do_start
        ;;
  stop|status)
        # No-op
        ;;
  *)
        echo "Usage: ami-resizerootpart.sh [start|stop]" >&2
        exit 3
        ;;
esac
EOF
chmod 755 /etc/init.d/ami-resizerootpart.sh
chown root:root /etc/init.d/ami-resizerootpart.sh
ln -s /etc/init.d/ami-resizerootpart.sh /etc/rc5.d/S05ami-resizerootpart.sh
