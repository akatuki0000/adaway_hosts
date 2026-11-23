#!/system/bin/sh
# adaway_hosts: safety rebind -- if the bind was lost (race/late unmount), redo it.
MODDIR="${0%/*}"
TARGET=/system/etc/hosts
HOSTS_FILE="$MODDIR/system/etc/hosts"

sleep 10
if [ -f "$HOSTS_FILE" ] && ! grep -q " $TARGET " /proc/mounts; then
    mount --bind "$HOSTS_FILE" "$TARGET" 2>/dev/null
fi
