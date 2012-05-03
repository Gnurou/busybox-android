#!/bin/bash

# I modified the original script as below for use with my rooted Atrix phone.
# I'm using a retail build that still thinks it's a production device.
# The best way to state this is that ro.secure=1 in default.prop, but su
# executes under a shell on the device and yields root permissions
#
# Another oddity that I encountered is that mv can fail giving
# errors citing cross-device linkage:
#     It seems that this error is given because mv tries
#     to move the hard link to the data, but fails because
#     in this case, the src and dest filesystems aren't the same.
#
# Symptoms of this state are that the following adb commands fail (not an ordered list, but executing any atomically):
#   adb remount
#   adb ls /data/app/
#   adb root
# but executing this works fine:
#   adb shell
#   $ su
#   $ ls /data/app/
#

LOCAL_DIR=`dirname $0`
SCRIPT='android-remote-install.sh'
TMP='/sdcard'
TGT='/system/bin'

function execMount()
{
    local cmd="$@"
    local output=
    "mount -o remount,rw /system"
}

function doMain()
{
    # move the files over to an adb writable location
    adb push $LOCAL_DIR/busybox-android $TMP/
    adb push $LOCAL_DIR/$SCRIPT $TMP/
    
    # now execute a string of commands over one adb connection using a
    # so-called here document
    # redirect chatter to /dev/null -- adb apparently puts stdin and stderr in
    # stdin so to add error checking we'd need to scan all the text
adb shell <<DONE
su
# this is a remount form that works on "partially rooted devices"
mount -o remount,rw /system
cat $TMP/busybox-android > $TGT/busybox
chmod 755 $TGT/busybox
cat $TMP/$SCRIPT > $TGT/$SCRIPT
rm $TMP/$SCRIPT
cd $TGT                                 
chmod 755 $SCRIPT
busybox ash $TGT/$SCRIPT
rm $TGT/$SCRIPT

# cleanup
rm $TMP/busybox-android

mount -o remount,r /system
exit
exit

DONE

}

set -x
doMain
set +x

