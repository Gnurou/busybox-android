#!/bin/sh

LOCAL_DIR=`dirname $0`

# Remount /system read-write
adb remount

# Install busybox
adb push $LOCAL_DIR/busybox /system/bin
adb shell chmod 755 /system/bin/busybox
adb push $LOCAL_DIR/busybox-install.sh /system
adb shell busybox ash /system/busybox-install.sh
adb shell rm /system/busybox-install.sh

