#!/system/bin/sh
# adaway_hosts: manual rebind / status (KernelSU action button).
MODDIR="${0%/*}"
TARGET=/system/etc/hosts
HOSTS_FILE="$MODDIR/system/etc/hosts"

if grep -q " $TARGET " /proc/mounts; then
    echo "bind: active ($HOSTS_FILE -> $TARGET)"
    head -1 "$TARGET"
else
    echo "bind: missing -- rebinding"
    umount -l "$TARGET" 2>/dev/null
    mount --bind "$HOSTS_FILE" "$TARGET" && echo "rebound OK" || echo "rebind FAILED"
fi
