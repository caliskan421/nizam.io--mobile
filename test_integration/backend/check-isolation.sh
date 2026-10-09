#!/usr/bin/env bash
# Entegrasyon ilk yönetici aracının (nizamio-e2e-bootstrap) hiçbir üretim çıktısına girmediğinin
# denetimi (F06 CX-Ö-03 deseni):
#   image  — etiketten üretilen backend çalışma imajında /usr/local/bin yalnız server, migrate,
#            setup'tır; araç ikilisi yoktur (backend çalışma imajına test aracı girmez).
#   apk    — mobil derleme çıktıları (build/app/outputs) araç adını/kaynağını içermez.
set -euo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"
# Boru hattında `grep -q` KULLANILMAZ (CX-r2-K-01): grep erken çıkınca üretici SIGPIPE (141)
# alır ve pipefail altında eşleşme "yok" sanılırdı. Girdi önce dosyaya alınır, sonra aranır.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

case "${1:-}" in
  image)
    tag="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["backendTag"])' "$root/api-pin.json")"
    image="nizamio-f14/backend:$tag"
    name="nizamio-f14-isocheck"
    docker rm -f "$name" >/dev/null 2>&1 || true
    docker create --name "$name" "$image" >/dev/null
    trap 'docker rm -f "$name" >/dev/null 2>&1 || true; rm -rf "$tmp"' EXIT
    docker export "$name" | tar -t >"$tmp/files.txt"
    bins="$(sed -nE 's#^usr/local/bin/([^/]+)$#\1#p' "$tmp/files.txt" | sort | tr '\n' ' ')"
    echo "backend imajı /usr/local/bin: $bins"
    if grep -q 'e2e-bootstrap' "$tmp/files.txt"; then
      echo "HATA: entegrasyon aracı backend çalışma imajında" >&2
      exit 1
    fi
    [[ "$bins" == "migrate server setup " ]] || { echo "HATA: beklenmeyen ikili kümesi" >&2; exit 1; }
    ;;
  apk)
    out="${NIZAMIO_IT_APK_DIR:-$root/build/app/outputs}"
    test -d "$out" || { echo "HATA: $out yok (önce flutter build apk)" >&2; exit 1; }
    found=0
    while IFS= read -r apk; do
      unzip -p "$apk" >"$tmp/apk.bin"
      if LC_ALL=C grep -a -q -e 'e2e-bootstrap' -e 'FakeControlPlaneAdaptor' -e 'IssueActivationCode' "$tmp/apk.bin"; then
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
