#!/usr/bin/env bash
# check-isolation.sh negatif öz-testi (CX-r2-K-01): yasak işareti içeren sentetik APK'da kapı
# KIRMIZI olmalı, temiz APK'da yeşil. İşaret arşivin başında, ardından büyük veri: eski
# `unzip -p | grep -q` boru hattında grep erken çıkar, üretici SIGPIPE (141) alır ve
# `set -o pipefail` altında eşleşme "yok" sayılırdı. Docker gerektirmez; CI verify işinde koşar.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/bad" "$work/good" "$work/src"
{ printf 'e2e-bootstrap\n'; head -c 8000000 /dev/urandom; } >"$work/src/classes.dex"
(cd "$work/src" && zip -q -0 "$work/bad/app-bad.apk" classes.dex)
head -c 8000000 /dev/urandom | LC_ALL=C tr -d 'e' >"$work/src/classes.dex"
(cd "$work/src" && zip -q -0 "$work/good/app-good.apk" classes.dex)

if NIZAMIO_IT_APK_DIR="$work/bad" "$here/check-isolation.sh" apk >/dev/null 2>&1; then
  echo "HATA: yasak işaretli APK kapıdan GEÇTİ (kapı kör)" >&2
  exit 1
fi
echo "öz-test: yasak işaretli APK reddedildi"
NIZAMIO_IT_APK_DIR="$work/good" "$here/check-isolation.sh" apk >/dev/null
echo "öz-test: temiz APK kabul edildi"
