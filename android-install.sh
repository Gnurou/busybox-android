#!/bin/bash

# ryan:
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
# Gnurou:
# Another issue is that some devices come with most basic commands like mount
# removed, which requires us to use BB to remount /system read-write. This is
# why we first upload BB to a temporary, executable location before moving it
# to /system/bin

LOCAL_DIR=`dirname $0`
BBNAME=busybox-android
LOCALBB=${LOCAL_DIR}/${BBNAME}
SCRIPT='android-remote-install.sh'
# /data is preferred over /sdcard because it will allow us to execute BB
TMP='/data/'
TMPBB=${TMP}busybox
TGT='/system/xbin/'
TGTBB=${TGT}busybox

function doMain()
{
    # try to remount /system r/w
    adb remount
    adb shell mount |grep "\bsystem\b" |grep "\brw\b"
    # this is a remount form that works on "partially rooted devices"
    if [ $? -ne 0 ]; then
        adb push $LOCALBB $TMPBB
	adb shell <<DONE
su
mount -oremount,rw /system
$TMPBB mount -oremount,rw /system
$TMPBB rm $TMPBB
exit
exit

DONE
    fi

    # we should be mounted r/w, push BB
    adb push $LOCALBB $TGTBB
    # if push fails, try to upload to /sdcard and copy from there
    if [ $? -ne 0 ]; then
	    adb push $LOCALBB $TMPBB
	    adb push $LOCALBB /sdcard/
	    adb shell <<DONE
su
cp /sdcard/$BBNAME $TGTBB
chmod 755 $TGTBB
rm /sdcard/$BBNAME
$TMPBB cp $TMPBB $TGTBB
$TMPBB rm $TMPBB
exit
exit

DONE
    fi

    # BB is now installed in /system/xbin/busybox

    # now execute a string of commands over one adb connection using a
    # so-called here document
    # redirect chatter to /dev/null -- adb apparently puts stdin and stderr in
    # stdin so to add error checking we'd need to scan all the text
    # move the files over to an adb writable location
    adb push $LOCAL_DIR/$SCRIPT /sdcard/

    adb shell <<DONE
su
$TGTBB ash /sdcard/$SCRIPT
rm /sdcard/$SCRIPT
sync
exit
exit

DONE

    # needs to be done separately to avoid "device busy" error
    adb shell mount -o remount,ro /system
}

doMain

