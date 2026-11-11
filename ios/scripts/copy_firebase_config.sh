#!/bin/sh
set -eu

# Her derlemede çalışır: aynı çıktı diziniyle dev → prod geçişinde eski dosya kalmaz.
destination="${TARGET_BUILD_DIR:?}/${UNLOCALIZED_RESOURCES_FOLDER_PATH:?}/GoogleService-Info.plist"
case "${CONFIGURATION:?}" in
  *-dev) flavor=dev ;;
  *-prod|Debug|Profile|Release) flavor=prod ;;
  *) echo "error: Bilinmeyen Firebase yapılandırması: $CONFIGURATION" >&2; exit 1 ;;
esac
source_file="${SRCROOT:?}/Firebase/$flavor/GoogleService-Info.plist"

rm -f "$destination"
if [ ! -f "$source_file" ]; then
  if [ "$flavor" = prod ]; then
    echo "Firebase prod yapılandırması yok; Firebase kapalı."
    exit 0
  fi
  echo "error: Firebase dev yapılandırması bulunamadı." >&2
  exit 1
fi

bundle_id=$(/usr/libexec/PlistBuddy -c 'Print :BUNDLE_ID' "$source_file")
if [ "$bundle_id" != "${PRODUCT_BUNDLE_IDENTIFIER:?}" ]; then
  echo "error: Firebase BUNDLE_ID uygulama kimliğiyle eşleşmiyor." >&2
  exit 1
fi
mkdir -p "$(dirname "$destination")"
cp "$source_file" "$destination"
