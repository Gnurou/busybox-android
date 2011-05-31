for c in `busybox --list`; do busybox rm -f /system/bin/$c; busybox ln -s busybox /system/bin/$c; done
