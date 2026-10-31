#!/usr/bin/env bash
# Yerel GELİŞTİRME backend'i: up.sh (api-pin.json etiketi) + prototip örnek verisi (seed_dev.py).
# Hesap dev girişinin varsayılanıdır (lib/main_dev.dart): admin@nizam.local; diğer örnek
# hesaplar <ad.soyad>@nizam.local, parola aynı. Veritabanı atılabilirdir; baştan kurmak için
# önce down.sh. Entegrasyon testleri (make integration) boş kurulum bekler: onlardan önce
# down.sh + up.sh.
#
# Yerelde sıra kilidiyle: ../program/araclar/agir-is.sh "mobil dev backend" -- test_integration/backend/dev-up.sh
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
export NIZAMIO_IT_ADMIN_EMAIL="${NIZAMIO_IT_ADMIN_EMAIL:-admin@nizam.local}"
export NIZAMIO_IT_ADMIN_PASSWORD="${NIZAMIO_IT_ADMIN_PASSWORD:-Pasword.123123}"
"$here/up.sh"
python3 "$here/seed_dev.py"
