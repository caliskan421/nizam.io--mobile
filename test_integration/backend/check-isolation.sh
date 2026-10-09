#!/usr/bin/env bash
# Entegrasyon ilk yönetici aracının (nizamio-e2e-bootstrap) hiçbir üretim çıktısına girmediğinin
# denetimi (F06 CX-Ö-03 deseni):
#   image  — etiketten üretilen backend çalışma imajında /usr/local/bin yalnız server, migrate,
#            setup'tır; araç ikilisi yoktur (backend çalışma imajına test aracı girmez).
#   apk    — mobil derleme çıktıları (build/app/outputs) araç adını/kaynağını içermez.
set -euo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"

case "${1:-}" in
  image)
    tag="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["backendTag"])' "$root/api-pin.json")"
    image="nizamio-f14/backend:$tag"
    name="nizamio-f14-isocheck"
    docker rm -f "$name" >/dev/null 2>&1 || true
    docker create --name "$name" "$image" >/dev/null
    trap 'docker rm -f "$name" >/dev/null 2>&1 || true' EXIT
    bins="$(docker export "$name" | tar -t | sed -nE 's#^usr/local/bin/([^/]+)$#\1#p' | sort | tr '\n' ' ')"
    echo "backend imajı /usr/local/bin: $bins"
    if docker export "$name" | tar -t | grep -q 'e2e-bootstrap'; then
      echo "HATA: entegrasyon aracı backend çalışma imajında" >&2
      exit 1
    fi
    [[ "$bins" == "migrate server setup " ]] || { echo "HATA: beklenmeyen ikili kümesi" >&2; exit 1; }
    ;;
  apk)
    out="$root/build/app/outputs"
    test -d "$out" || { echo "HATA: $out yok (önce flutter build apk)" >&2; exit 1; }
    found=0
    while IFS= read -r apk; do
      if unzip -p "$apk" | LC_ALL=C grep -a -q -e 'e2e-bootstrap' -e 'FakeControlPlaneAdaptor' -e 'IssueActivationCode'; then
        echo "HATA: entegrasyon aracı izi $apk içinde" >&2
        exit 1
      fi
      found=1
      echo "$(basename "$apk"): entegrasyon aracı izi yok"
    done < <(find "$out" -name '*.apk')
    [[ "$found" == "1" ]] || { echo "HATA: APK bulunamadı" >&2; exit 1; }
    ;;
  *)
    echo "kullanım: $0 image|apk" >&2
    exit 2
    ;;
esac
