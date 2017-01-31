#! /bin/bash

### BEGIN INIT INFO
# Provides:          ephemeral
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Should-Start:      
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Mount ephemeral storage
# Description:       No daemon is created or managed. Based on lucidchart
### END INIT INFO

VG_NAME=ephemeral

. /lib/lsb/init-functions

ephemeral_start() {
    DEVICES=$(/bin/ls /dev/xvdb* /dev/xvdc* /dev/xvdd* /dev/xvde* 2>/dev/null)
    PVSCAN_OUT=$(/sbin/pvscan)

    for device in $DEVICES; do
        if [ -z "$(/bin/echo "$PVSCAN_OUT" | grep " $device ")" ]; then
            /bin/umount "$device"
            /bin/sed -e "/$(basename $device)/d" -i /etc/fstab
            /bin/dd if=/dev/zero of="$device" bs=1M count=10
            /sbin/pvcreate "$device"
        fi
    done

    if [ ! -d "/dev/$VG_NAME" ]; then
        /sbin/vgcreate "$VG_NAME" $DEVICES
    fi


    [ ! -e "/dev/$VG_NAME/swap" ] && /sbin/lvcreate -l5%VG -nswap "$VG_NAME"
    [ ! -e "/dev/$VG_NAME/tmp" ] && /sbin/lvcreate -l100%FREE -ntmp "$VG_NAME"

    # Do swap
    /sbin/mkswap -f /dev/$VG_NAME/swap
    /sbin/swapon /dev/$VG_NAME/swap

    # Do tmp
    /sbin/mkfs.xfs /dev/$VG_NAME/tmp
    /bin/mkdir -p /tmp
    [ -z "$(mount | grep " on /tmp ")" ] && rm -rf /tmp/*
    /bin/mount -t xfs /dev/$VG_NAME/tmp /tmp
    /bin/chmod 1777 /tmp

    log_end_msg 0
} # ephemeral_start

ephemeral_stop() {
    /sbin/swapoff /dev/$VG_NAME/swap
    /bin/umount /tmp

    /sbin/vgchange -an "$VG_NAME"

    log_end_msg 0
} # ephemeral_stop


case "$1" in
  start)
        log_daemon_msg "Mounting ephemeral volumes" "ephemeral"
        ephemeral_start
        ;;

  stop)
        log_daemon_msg "Umounting ephemeral volumes" "ephemeral"
        ephemeral_stop
        ;;

  *)
        echo "Usage: /etc/init.d/ephemeral {start|stop}"
        exit 1
esac

exit 0
