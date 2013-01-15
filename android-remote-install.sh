# List of programs to leave to toolbox
TOOLBOX_PROGS=" reboot getprop setprop start stop "
BB="/system/xbin/busybox"
for c in `$BB --list`; do
	# There must be a better way to do this
	IN_LIST=0
	for p in $TOOLBOX_PROGS; do
		if [ "$c" == "$p" ]; then
			IN_LIST=1
		fi
	done
	if [ $IN_LIST -eq 0 ]; then
		$BB rm -f /system/bin/$c;
		$BB ln -s $BB /system/bin/$c;
	fi
done
