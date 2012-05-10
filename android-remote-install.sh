for c in `/system/bin/busybox --list`; do /system/bin/busybox rm -f /system/bin/$c; /system/bin/busybox ln -s busybox /system/bin/$c; done
