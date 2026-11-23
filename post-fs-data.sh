#!/system/bin/sh
# adaway_hosts: bind-mount a persistent /data hosts file over /system/etc/hosts.
# Runs on every root manager that executes module scripts (Magisk/KernelSU/APatch).
MODDIR="${0%/*}"
TARGET=/system/etc/hosts
HOSTS_FILE="$MODDIR/system/etc/hosts"

# Seed the managed file once from the real hosts file.
if [ ! -f "$HOSTS_FILE" ]; then
    mkdir -p "$MODDIR/system/etc"
    cp "$TARGET" "$HOSTS_FILE" 2>/dev/null
    [ -s "$HOSTS_FILE" ] || printf '127.0.0.1 localhost\n::1 localhost\n' > "$HOSTS_FILE"
fi

chmod 644 "$HOSTS_FILE" 2>/dev/null
chown 0:0 "$HOSTS_FILE" 2>/dev/null
chcon u:object_r:system_file:s0 "$HOSTS_FILE" 2>/dev/null

# Clear anything stacked on the target, then bind ours.
while grep -q " $TARGET " /proc/mounts; do
    umount -l "$TARGET" || break
done
mount --bind "$HOSTS_FILE" "$TARGET"
