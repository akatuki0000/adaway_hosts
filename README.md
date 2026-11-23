# adaway_hosts

A minimal, manager-agnostic **systemless hosts** module that makes [AdAway](https://adaway.org)
work reliably on **KernelSU / SukiSU / APatch / Magisk**.

## Why

AdAway's root mode writes directly to `/system/etc/hosts` with `dd` after a
`test -w` check. On KernelSU-family managers, `/system` is usually an EROFS or
read-only overlay, so the write fails unless something provides a writable
backing file. This module does exactly that — nothing more.

## How it works

- `skip_mount` keeps the payload under `/data/adb/modules/adaway_hosts/` on
  every manager (no reliance on magic-mount, overlayfs, or meta-overlayfs).
- `post-fs-data.sh` bind-mounts
  `/data/adb/modules/adaway_hosts/system/etc/hosts` over `/system/etc/hosts`.
- Writes through `/system/etc/hosts` land on the `/data` file: writable,
  persistent across reboots, visible immediately.
- `service.sh` re-binds after boot as a safety net. `uninstall.sh` removes the
  bind on uninstall. `action.sh` reports/repairs the bind from the manager UI.

The module id (`adaway_hosts`) and layout match what
[AdAway PR #4293](https://github.com/AdAway/AdAway/pull/4293) expects, so it
will also work with upstream AdAway once KernelSU support lands.

## Install

1. Download `adaway_hosts.zip` from the latest release.
2. Install it as a module in KernelSU / SukiSU / Magisk / APatch.
3. Reboot. Open AdAway and press **Apply**.

## Conflicts

Disable other modules that manage `/system/etc/hosts` themselves (e.g.
**bindhosts** — it periodically regenerates the file and will overwrite
AdAway's content).

## Update mechanism

`module.prop` carries an `updateJson` URL pointing at `update.json` on the
`main` branch. Each tag push triggers a GitHub Actions workflow that builds
the zip, publishes a release, and refreshes `update.json`, so root managers
with update checking can pick up new versions automatically.

## License

Public domain (CC0). The scripts are trivial — do whatever you want with them.
