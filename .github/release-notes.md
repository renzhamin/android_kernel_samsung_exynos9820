# ${TITLE}

Tag: `${TAG}`

This is the LineageOS ${LOS} kernel for the Galaxy S10+ (Exynos, `beyond2lte`), changed so it can run [Droidspaces](https://www.droidspaces.org) containers.

> **It only works on LineageOS ${LOS}.** It will not boot on One UI or on other LineageOS versions.

## Base

- Upstream: [LineageOS/android_kernel_samsung_exynos9820](https://github.com/LineageOS/android_kernel_samsung_exynos9820), branch `lineage-${LOS}`, commit `${BASE}`
- Boot image: built from the official LineageOS ${LOS} `boot.img` (build ${STOCK_DATE}). Only the kernel is replaced; the ramdisk, header and vbmeta are unchanged.
- Compiler: ${CLANG}
- Source: [`${SHA}`](https://github.com/${REPO}/tree/${SHA}) on branch `${BRANCH}`

## Changes

- `kernel/cgroup`: restore cgroup file prefix handling (Droidspaces non-GKI patch 02)
- `arch/arm64/configs/droidspaces.config`: kernel options for Droidspaces, added on top of `exynos9820-beyond2lte_defconfig`:
  - SysV IPC, POSIX message queues, and PID/UTS/IPC/NET/USER namespaces
  - seccomp filter
  - cgroups: devices, freezer, pids, CPU accounting, CFS bandwidth, and memory limits with swap accounting enabled by default
  - devtmpfs, overlayfs, tmpfs ACL/xattr, loop, FUSE, TUN
  - container networking: veth, bridge, macvlan, NAT/masquerade over iptables and ip6tables
  - firewall support inside containers (UFW/Fail2Ban): conntrack/state, multiport, recent, limit, hashlimit, ipset, NFLOG, REJECT
  - `ANDROID_PARANOID_NETWORK` disabled
- `build.sh`, `mkboot.sh` and `Dockerfile.build` for reproducible builds

## Root

This image is **not rooted**. To root it, patch it in the Magisk app (Install → Select and Patch a File) and flash the patched image instead.

## Install

1. Boot into Download mode: power off, then hold Vol Down + Bixby and plug in USB. Press Vol Up when the warning screen appears.
2. Flash:
   ```sh
   heimdall flash --BOOT ${ASSET}
   ```
3. After booting, open the Droidspaces app and run Settings → Requirements → Check Requirements.

## Restore

Flash the stock LineageOS ${LOS} `boot.img` from Download mode:

```sh
heimdall flash --BOOT boot.img
```

## Checksum

```
SHA-256  ${SHA256}  ${ASSET}
```
