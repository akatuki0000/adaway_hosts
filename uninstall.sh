#!/system/bin/sh
# adaway_hosts: remove our bind on uninstall (best effort).
umount -l /system/etc/hosts 2>/dev/null
exit 0
