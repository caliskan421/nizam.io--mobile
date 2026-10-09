#!/usr/bin/env bash
# Mobil entegrasyon (F14) için gerçek backend'i ayağa kaldırır — kaynak YALNIZ api-pin.json'daki
# etiket. F06 web e2e deseninin (nizam.io--frontend e2e/backend/up.sh) mobil uyarlaması.
#
# Sıra (backend README "Binary yüzeyleri ve kurulum sırası"): imaj (etiketin build/Dockerfile'ı)
# → yönetici bağlantısıyla migrations/roles.sql → migrator kimliğiyle `migrate up` → roles.sql
# tekrar → ilk yönetici (nizamio-e2e-bootstrap; bkz. bootstrap/main.go başlığı) → uygulama
# kimliğiyle server. Fixture verisi yalnız API ile kurulur (test_integration/).
#
# Kip (NIZAMIO_IT_MODE):
#   local (varsayılan) — Postgres `nizamio_f14_mobile` Compose projesinde (127.0.0.1:15440),
#                        server'lar 127.0.0.1:18140 ve :18141 (asgari mobil sürüm 99.0.0).
#   ci                 — Postgres GitHub Actions servis konteyneri (127.0.0.1:5432),
#                        konteynerler --network host.
# Dokunulan kaynaklar ADIYLA: Compose projesi nizamio_f14_mobile, konteynerler
# nizamio-f14-server ve nizamio-f14-server-minver, imajlar nizamio-f14/*. Toplu docker
# müdahalesi YOKTUR. Yerelde yalnız sıra kilidiyle: ../program/araclar/verify-sirasi.sh <depo> integration
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../.." && pwd)"
mode="${NIZAMIO_IT_MODE:-local}"
backend_dir="${NIZAMIO_BACKEND_DIR:-$root/../nizam.io--backend}"
case "$backend_dir" in /*) ;; *) backend_dir="$root/$backend_dir" ;; esac
state="$root/test_integration/.state"
server_port="${NIZAMIO_IT_SERVER_PORT:-18140}"
minver_port="${NIZAMIO_IT_MINVER_PORT:-18141}"
server_name="nizamio-f14-server"
minver_name="nizamio-f14-server-minver"
project="nizamio_f14_mobile"
db_name="nizamio_f14_test"
admin_email="${NIZAMIO_IT_ADMIN_EMAIL:-yonetici@f14.nizamio.test}"
# Yalnız atılabilir entegrasyon veritabanına ait sabit test parolası (sır değildir).
admin_password="${NIZAMIO_IT_ADMIN_PASSWORD:-F14-Yonetici-Parola-2026}"

tag="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["backendTag"])' "$root/api-pin.json")"
git -C "$backend_dir" rev-parse --verify "refs/tags/$tag^{commit}" >/dev/null

echo "== backend kaynağı: $tag (etiketten, çalışma ağacı değil)"
rm -rf "$state/src"
mkdir -p "$state/src"
git -C "$backend_dir" archive "refs/tags/$tag" | tar -x -C "$state/src"
mkdir -p "$state/src/cmd/nizamio-e2e-bootstrap"
cp "$here/bootstrap/main.go" "$state/src/cmd/nizamio-e2e-bootstrap/main.go"
# GO_VERSION backend Makefile ile aynı kaynaktan: etiketteki go.mod'un `go` satırı (tam değer).
go_version="$(awk '/^go /{print $2}' "$state/src/go.mod")"

# TABAN İMAJ PİNLERİ (CX-Ö-04, CX-r2-Ö-01). Etiketin build/Dockerfile'ı tabanları yalnız
# etiketle anar (`golang:${GO_VERSION}-bookworm`, `gcr.io/distroless/static-debian12:nonroot`).
# Backend deposuna yazılmaz; yalnız `$state/src` altındaki GEÇİCİ kopyanın FROM satırları
# digest'li referanslara yeniden yazılır. Dockerfile frontend'i BUILDKIT_SYNTAX ile digest'e
# sabittir. Digest'ler registry Docker-Content-Digest başlığından çözülmüştür. Kalıcı çözüm
# backend Dockerfile'ında digest pinidir (F23).
# PAYLAŞILAN DAEMON KURALI: bu betik `docker tag`/`docker rmi` KULLANMAZ; hiçbir genel
# (NIZAM.IO adı taşımayan) etiket oluşturulmaz veya değiştirilmez. Yalnız nizamio-f14/*
# imajları `docker build -t` ile üretilir. CI bunu grep ile denetler.
golang_pin() { # go sürümü → golang:<sürüm>-bookworm digest'i
  case "$1" in
    1.26.0) echo "sha256:2a0ba12e116687098780d3ce700f9ce3cb340783779646aafbabed748fa6677c" ;;
    *) echo "" ;;
  esac
}
distroless_ref="gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab"
syntax_ref="docker/dockerfile:1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e"
golang_digest="$(golang_pin "$go_version")"
if [[ -z "$golang_digest" ]]; then
  echo "HATA: go.mod Go $go_version için taban imaj pini yok; test_integration/backend/up.sh golang_pin güncellenmeli" >&2
  exit 1
fi
golang_ref="golang:${go_version}-bookworm@${golang_digest}"

dockerfile="$state/src/build/Dockerfile"
pin_from() { # beklenen-satır yeni-satır
  local expected="$1" replacement="$2" count
  count="$(grep -cxF "$expected" "$dockerfile" || true)"
  if [[ "$count" != "1" ]]; then
    echo "HATA: geçici Dockerfile'da beklenen satır $count kez bulundu (1 beklenir): $expected" >&2
    exit 1
  fi
  awk -v e="$expected" -v r="$replacement" '$0 == e { print r; next } { print }' "$dockerfile" \
    >"$dockerfile.pinned"
  mv "$dockerfile.pinned" "$dockerfile"
  echo "== taban: $replacement"
}
pin_from 'FROM golang:${GO_VERSION}-bookworm AS build' "FROM $golang_ref AS build"
pin_from 'FROM gcr.io/distroless/static-debian12:nonroot AS runtime' "FROM $distroless_ref AS runtime"

image="nizamio-f14/backend:$tag"
bootstrap_image="nizamio-f14/bootstrap:$tag"
build_log="$state/backend-build.log"
echo "== imaj: $image (etiketin build/Dockerfile'ı, geçici kopyada digest'li FROM, Go $go_version)"
# İnşa aracı: BuildKit (buildx) varsa web F06 ile aynı yol (syntax ön ucu digest'li, günlükte pinli
# FROM denetimi). Yoksa (paylaşılan yerel Colima daemon'ında buildx eklentisi kurulu değil) klasik
# inşacı: Dockerfile'lar BuildKit'e özgü özellik kullanmaz; FROM satırları yine digest'lidir ve
# çalışma imajı katman denetimi aynen koşar. CI daima BuildKit yolundadır.
if docker buildx version >/dev/null 2>&1; then
  docker build --progress=plain \
    --build-arg "BUILDKIT_SYNTAX=$syntax_ref" --build-arg "GO_VERSION=$go_version" \
    -f "$dockerfile" -t "$image" "$state/src" >"$build_log" 2>&1 ||
    { cat "$build_log" >&2; exit 1; }
  docker build -q -f "$here/bootstrap.Dockerfile" -t "$bootstrap_image" "$state/src"
  log_check=("$build_log" "$golang_ref")
else
  echo "== inşacı: klasik (buildx yok); FROM digest'li, günlük denetimi atlanır"
  DOCKER_BUILDKIT=0 docker build --build-arg "GO_VERSION=$go_version" \
    -f "$dockerfile" -t "$image" "$state/src" >"$build_log" 2>&1 ||
    { cat "$build_log" >&2; exit 1; }
  DOCKER_BUILDKIT=0 docker build -q -f "$here/bootstrap.Dockerfile" -t "$bootstrap_image" "$state/src"
  log_check=()
fi

# DENETİM — geçici Dockerfile digest'li mi, (BuildKit'te) pinli referanslar mı çözüldü, çalışma
# imajı pinli distroless katmanlarıyla mı başlıyor?
"$here/check-base-pins.sh" "$image" "$distroless_ref" "$dockerfile" ${log_check[@]+"${log_check[@]}"}
"$here/check-base-pins.sh" "$bootstrap_image" "$distroless_ref" "$here/bootstrap.Dockerfile"

if [[ "$mode" == "ci" ]]; then
  net=(--network host)
  db_host="127.0.0.1"
  listen="127.0.0.1:$server_port"
else
  docker compose -p "$project" -f "$here/compose.yaml" up -d --wait
  net=(--network "${project}_default")
  db_host="db"
  listen="0.0.0.0:8080"
fi
pg_image="postgres:16@sha256:ca0bd484cb98bf4b24eb1010e73fb3fcbd6714d240fbc1a10eea5b7dbecb641d"
admin_url="postgres://postgres:postgres@$db_host:5432/$db_name?sslmode=disable"
psql_run() { docker run --rm -i "${net[@]}" "$pg_image" psql "$admin_url" -X -q -v ON_ERROR_STOP=1 "$@"; }

migrator_role="${db_name}_migrator"
app_role="${db_name}_app"
role_password="$(openssl rand -hex 24)"
echo "== roller: $migrator_role / $app_role"
psql_run -v "migrator_role=$migrator_role" -v "app_role=$app_role" -v "db_name=$db_name" -f - \
  <"$state/src/migrations/roles.sql"
psql_run -v "migrator_role=$migrator_role" -v "app_role=$app_role" -v "role_password=$role_password" <<'SQL'
ALTER ROLE :"migrator_role" PASSWORD :'role_password';
ALTER ROLE :"app_role" PASSWORD :'role_password';
SQL
migrator_url="postgres://$migrator_role:$role_password@$db_host:5432/$db_name?sslmode=disable"
app_url="postgres://$app_role:$role_password@$db_host:5432/$db_name?sslmode=disable"

env_file="$state/backend.env"
umask 077
cat >"$env_file" <<ENV
NIZAMIO_ENV=test
NIZAMIO_CONFIG_SCHEMA_VERSION=1
NIZAMIO_PRODUCT_VERSION=0.0.0-f14-mobile
NIZAMIO_INSTANCE_ID=f14-mobile
NIZAMIO_INSTANCE_TIMEZONE=Europe/Istanbul
NIZAMIO_TOKEN_SIGNING_SECRET=$(openssl rand -hex 32)
NIZAMIO_SESSION_TTL=15m
NIZAMIO_HTTP_LISTEN_ADDR=$listen
NIZAMIO_STORAGE_LOCAL_ROOT=/tmp/nizamio-storage
NIZAMIO_CONTROL_PLANE_ADAPTER=fake
NIZAMIO_OUTBOX_MAX_ATTEMPTS=3
NIZAMIO_OUTBOX_RETRY_BACKOFF=1s
NIZAMIO_LOGIN_MAX_FAILURES=10
NIZAMIO_LOGIN_FAILURE_WINDOW=24h
NIZAMIO_LOGIN_LOCK_DURATION=1m
NIZAMIO_LOGIN_ATTEMPT_RETENTION=48h
NIZAMIO_LOGIN_ATTEMPT_CLEANUP_INTERVAL=1m
NIZAMIO_DISCOVERY_RATE_LIMIT_PER_MINUTE=60
ENV

echo "== migrate up (migrator kimliği; yedek kontrolü: atılabilir entegrasyon DB için 'migrate verify')"
docker run --rm "${net[@]}" --env-file "$env_file" -e "NIZAMIO_DATABASE_URL=$migrator_url" \
  --entrypoint /usr/local/bin/migrate "$image" "--backup-check-cmd=/usr/local/bin/migrate verify" up
psql_run -v "migrator_role=$migrator_role" -v "app_role=$app_role" -v "db_name=$db_name" -f - \
  <"$state/src/migrations/roles.sql"

echo "== ilk yönetici: $admin_email"
printf '%s\n' "$admin_password" | docker run --rm -i "${net[@]}" --env-file "$env_file" \
  -e "NIZAMIO_DATABASE_URL=$app_url" "$bootstrap_image" \
  --admin-email "$admin_email" --company-name "NIZAM.IO F14 Mobil"

# İki server aynı veritabanı ve yapılandırmayla koşar; ikincisi YALNIZ asgari mobil sürümü
# yüksek (99.0.0) — "sürüm uyumsuzluğunda giriş akışı başlamaz" senaryosu içindir.
start_server() { # ad host-portu [ek -e argümanları...]
  local name="$1" port="$2"
  shift 2
  local pub=() addr="$listen"
  if [[ "$mode" == "ci" ]]; then addr="127.0.0.1:$port"; else pub=(-p "127.0.0.1:$port:8080"); fi
  echo "== server: $name → 127.0.0.1:$port"
  docker rm -f "$name" >/dev/null 2>&1 || true
  docker run -d --name "$name" "${net[@]}" "${pub[@]}" --env-file "$env_file" \
    -e "NIZAMIO_DATABASE_URL=$app_url" -e "NIZAMIO_HTTP_LISTEN_ADDR=$addr" "$@" "$image" >/dev/null
}
wait_ready() { # ad host-portu
  local name="$1" port="$2"
  for _ in $(seq 1 60); do
    if [[ "$(docker inspect -f '{{.State.Running}}' "$name" 2>/dev/null)" != "true" ]]; then
      break
    fi
    if curl -fsS "http://127.0.0.1:$port/healthz/ready" >/dev/null 2>&1; then
      echo "== backend hazır: $name http://127.0.0.1:$port"
      return 0
    fi
    sleep 1
  done
  echo "HATA: $name hazır olmadı" >&2
  docker logs "$name" >&2 || true
  return 1
}

start_server "$server_name" "$server_port"
start_server "$minver_name" "$minver_port" -e NIZAMIO_MINIMUM_MOBILE_VERSION=99.0.0
wait_ready "$server_name" "$server_port"
wait_ready "$minver_name" "$minver_port"
