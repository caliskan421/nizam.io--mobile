#!/usr/bin/env bash
# up.sh'in açtığı kaynakları ADIYLA kapatır (paylaşılan makine kuralı, OTURUM §5).
# İmajlar (nizamio-f14/*) bilinçli olarak SİLİNMEZ: yeniden koşumda katman önbelleği; silmek
# gerekirse yalnız adıyla: docker image rm nizamio-f14/backend:<etiket> nizamio-f14/bootstrap:<etiket>
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
docker rm -f nizamio-f14-server nizamio-f14-server-minver >/dev/null 2>&1 || true
if [[ "${NIZAMIO_IT_MODE:-local}" != "ci" ]]; then
  docker compose -p nizamio_f14_mobile -f "$here/compose.yaml" down -v
fi
