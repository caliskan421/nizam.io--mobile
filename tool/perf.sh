#!/usr/bin/env bash
# P0 geçiş ölçümü (docs/perf/README.md): tek komutla `flutter drive`.
#   tool/perf.sh <cihaz-kimliği> <senaryolar> <çıktı-adı> [profile|debug] [native|tablet|phone]
# Örnek (telefon, profile):  tool/perf.sh 00008110-000C5D6426C0A01E S3,S4 telefon-profile
# Örnek (macOS vekil):       tool/perf.sh macos S1,S2 tablet-macos profile native
# Sonuç: build/perf/<çıktı-adı>.json (yerel; commit'lenmez).
set -euo pipefail
cd "$(dirname "$0")/.."
device="${1:?cihaz kimliği (flutter devices)}"
only="${2:?senaryolar, ör. S1,S2}"
out="${3:?çıktı adı}"
mode="${4:-profile}"
view="${5:-native}"
PERF_OUT="$out" flutter drive "--$mode" -d "$device" \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/perf_transitions_test.dart \
  --dart-define=PERF_ONLY="$only" --dart-define=PERF_VIEW="$view"
