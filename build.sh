#!/bin/bash
# Build Lineage beyond2lte kernel + Droidspaces fragment. Run inside the container.
set -e
export ARCH=arm64 SUBARCH=arm64
M="make -j$(nproc) O=out LLVM=1 LLVM_IAS=0 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-"
$M exynos9820-beyond2lte_defconfig
scripts/kconfig/merge_config.sh -m -O out out/.config arch/arm64/configs/droidspaces.config
$M olddefconfig
# report options that didn't stick
grep -E '^(CONFIG_[A-Z0-9_]+)=' arch/arm64/configs/droidspaces.config | while IFS= read -r l; do
  grep -qx "$l" out/.config || echo "WARN not set: $l"; done
$M "$@"
