AWS Boot Scripts
================

These are a couple of helper scripts to facilitate the automatic creation and
deletion of machine hostnames and CNAME records at boot and shutdown/reboot as
well as handling removing a node from puppet on shutdown/reboot.

Installation
------------

Simply put `startup.sh` and `shutdown.sh` into `/usr/sbin` and edit them to
set the necessary variables.

Add something like this to your rc.local to run the startup script:
`/bin/bash /usr/sbin/startup.sh 1> /tmp/startup.out 2>&1`

And you can use provided `shutdown-init` init script to run the shutdown/reboot
script.

That's it!
