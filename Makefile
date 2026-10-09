# NIZAM.IO mobil — yerel komutlar (CI .github/workflows/ci.yml ile aynı adımlar).
# Ağır koşumlar (gerçek backend entegrasyonu) yerelde YALNIZ sıra kilidiyle başlatılır:
#   ../program/araclar/verify-sirasi.sh "$PWD" integration

DART_DIRS := lib test tool

.PHONY: gen gen-check deps format format-check analyze boundaries test lint verify build-dev-apk build-prod-apk

deps:
	flutter pub get --enforce-lockfile

format:
	dart format $(DART_DIRS)

format-check:
	dart format --output=none --set-exit-if-changed $(DART_DIRS)

analyze:
	flutter analyze --fatal-infos

boundaries:
	dart run tool/check_boundaries.dart

test:
	flutter test test/

lint: format-check analyze boundaries

verify: deps lint test

build-dev-apk:
	flutter build apk --debug --flavor dev -t lib/main_dev.dart

# Yayın derlemesi yalnız --obfuscate denetimi içindir (imzalama program dışı, KR-13).
build-prod-apk:
	flutter build apk --release --flavor prod -t lib/main_prod.dart \
		--obfuscate --split-debug-info=build/symbols

# Üretim: api-pin.json pinlerinden (backend ETİKETİ, web COMMIT'i) bütün üretilmiş kod.
# NIZAMIO_BACKEND_DIR / NIZAMIO_FRONTEND_DIR verilmezse ../nizam.io--backend ve ../nizam.io--frontend.
gen:
	dart run tool/gen.dart

# CI kapısı: yeniden üret → izlenen dosyalarda fark yok ve izlenmeyen üretilmiş dosya yok.
gen-check: gen
	git diff --exit-code
	@test -z "$$(git status --porcelain)" || { git status --porcelain; echo "commit'lenmemiş üretilmiş dosya var"; exit 1; }
