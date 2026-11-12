#!/bin/sh
set -eu

# Crashlytics dSYM yükleme. YALNIZ yapılandırılmış (GoogleService-Info.plist kopyalanmış) ve
# dSYM üreten (Release/Profile) derlemelerde çalışır; aksi halde sessizce atlanır, böylece
# prod (yapılandırma yok), Debug ve simülatör derlemeleri etkilenmez. Hata verirse derlemeyi
# DURDURMAZ (sembol yükleme bir dağıtım adımıdır, derleme kapısı değildir).
# Flutter/Dart sembolleri (--split-debug-info) ayrı yüklenir: docs/yurutme/hata-takibi.md.

plist="${TARGET_BUILD_DIR:-}/${UNLOCALIZED_RESOURCES_FOLDER_PATH:-}/GoogleService-Info.plist"
# Simülatör derlemelerinde yükleme YAPILMAZ (gerçek cihaz/arşiv yolu kalır).
case "${PLATFORM_NAME:-}${EFFECTIVE_PLATFORM_NAME:-}" in
  *simulator*) echo "Crashlytics sembol yükleme atlandı (simülatör)."; exit 0 ;;
esac
case "${CONFIGURATION:-}" in
  Release*|Profile*|*-Release|*-Profile) ;;
  *) echo "Crashlytics sembol yükleme atlandı (${CONFIGURATION:-?})."; exit 0 ;;
esac
if [ ! -f "$plist" ]; then
  echo "Crashlytics sembol yükleme atlandı: Firebase yapılandırması yok."
  exit 0
fi

run=""
build_dir="${BUILD_DIR:-/nonexistent/Build/x}"
for candidate in \
  "${build_dir%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run" \
  "${PODS_ROOT:-/nonexistent}/FirebaseCrashlytics/run"; do
  if [ -x "$candidate" ]; then run="$candidate"; break; fi
done
if [ -z "$run" ]; then
  echo "warning: Crashlytics 'run' betiği bulunamadı; dSYM elle yüklenmeli."
  exit 0
fi

dsym="${DWARF_DSYM_FOLDER_PATH:-}/${DWARF_DSYM_FILE_NAME:-}"
if [ ! -d "$dsym" ]; then
  echo "warning: dSYM üretilmedi ($dsym); Archive/Release derlemesinde çalışır."
  exit 0
fi

"$run" || echo "warning: Crashlytics dSYM yükleme başarısız; elle yükleyin."
