#!/bin/bash
# Repack a stock Lineage boot.img with our kernel Image. Run inside the container:
#   docker exec exynos9820-kbuild ./mkboot.sh [stock-boot.img] [out.img]
set -e
cd "$(dirname "$0")"
SRC=$(realpath "${1:-lineage23.2-boot.img}")
OUT=$(realpath -m "${2:-new-boot.img}")
IMAGE=$(realpath out/arch/arm64/boot/Image)
[ -f "$SRC" ] || { echo "missing stock boot image: $SRC"; exit 1; }
[ -f "$IMAGE" ] || { echo "missing $IMAGE, run ./build.sh Image first"; exit 1; }

mkdir -p bootimg && cd bootimg
case "$(uname -m)" in aarch64) ABI=arm64-v8a ;; x86_64) ABI=x86_64 ;; *) echo "unsupported arch"; exit 1 ;; esac
if [ ! -x magiskboot ]; then
  URL=$(curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep -o 'https[^"]*Magisk[^"]*\.apk' | head -1)
  curl -sfLo magisk.apk "$URL"
  unzip -o -j magisk.apk "lib/$ABI/libmagiskboot.so" >/dev/null
  mv libmagiskboot.so magiskboot && chmod +x magiskboot && rm magisk.apk
fi

rm -rf work && mkdir work && cd work
../magiskboot unpack "$SRC"
cp "$IMAGE" kernel
../magiskboot repack "$SRC" "$OUT"
cd .. && rm -rf work

echo "stock: $(strings "$SRC" | grep -m1 'Linux version' | cut -c1-60)"
echo "new:   $(strings "$OUT" | grep -m1 'Linux version' | cut -c1-60)"
ls -l "$OUT"
