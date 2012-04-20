Busybox for Android the Easy Way (just a quick hack)
====================================================

This little package is designed to make your life easier if you are using
the shell under an Android device. It includes a full-fledged Busybox
environment that should make a fair replacement for the poor toolbox that
comes with Android by default.

You can install it in two ways: if you are compiling Android yourself, then
you can add this package to your repository and Busybox will replace the
default Toolbox whenever possible. If you already have a deployed (and
rooted!) Android device, you can deploy busybox on it.

Installing in your Android source tree
--------------------------------------
Simply add a 'local_manifest.xml' file (or edit the existing one) in the .repo
directory located at the root of your Android source tree with the following
lines:

    <?xml version="1.0" encoding="UTF-8"?>
    <manifest>
    <remote name="busybox-android"
            fetch="git://github.com/Gnurou/"/>
    <project path="busybox-android"
             name="busybox-android"
             remote="busybox-android"
             revision="master"/>
    </manifest>

Then run "repo sync" and build your images normally.

Installing on an already-deployed Android device
------------------------------------------------
Run the 'android-install.sh' script while your device is connected. This will
remount the system partition read-write, copy busybox, and make the appropriate
symlinks on your device. You will need adb in your path for this to work.

Misc
----
The files busybox-android.patch and busybox-android.config are a patch that
allows ash history to work on Android and the configuration used to build
Busybox, respectively. The busybox binary has been built statically against
glibc - unfortunately, it seems impossible to build it against Android NDK.

Non-executable .sh scripts are not meant to be run directly by the user.

Compiling yourself
------------------
It should be pretty easy to recompile the binary yourself by following these
steps:

1. Get and install the latest GNU/Linux toolchain from [here]
(http://www.codesourcery.com/sgpp/lite/arm/portal/subscription?@template=lite)
(unless you already have a working toolchain installed). Make sure the binaries
directory is in your PATH.
2. Get and unpack the latest source for Busybox.
3. Apply `busybox-android.patch` from the git repo to Busybox source if you
want to be able to use the profile and history under Android.
4. Copy `busybox-android.config` from the git into Busybox's source root and
rename it to `.config`. Edit it and make sure `CONFIG_CROSS_COMPILER_PREFIX` is
correctly set to your compiler's name.
5. Run `make` and you should obtain the `busybox` binary.

TODO
----
Cleanup, proper configuration options and upstream integration, maybe?

Feedback & contact
------------------
Alexandre Courbot <acourbot@nvidia.com>

