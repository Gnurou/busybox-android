#!/bin/sh

LOCAL_DIR=`dirname $0`

# Remount /system read-write
adb remount

# Install busybox
adb push $LOCAL_DIR/busybox-android /system/bin/
adb shell mv /system/bin/busybox-android /system/bin/busybox
adb shell chmod 755 /system/bin/busybox
adb push $LOCAL_DIR/android-remote-install.sh /system
adb shell busybox ash /system/android-remote-install.sh
adb shell rm /system/android-remote-install.sh

