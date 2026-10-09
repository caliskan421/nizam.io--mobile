# MOB-0 r2 — identity domain katmanı + sınır kuralları A1/A2/A3/B6/B7/B8: Codex hükmü

Ürün sahibi incelemesi (2026-10-09): üretilmiş API DTO'ları feature iç katmanlarına sızıyordu
(`IdentityService.me()` → `MeResponse`). PR #12 domain katmanını ve sızıntıyı kapatan sınır
kurallarını ekler. Denetçi: Codex `gpt-5.6-sol`, salt okunur, 6 koşum.

| Koşum | Commit | Hüküm | Bulgular → düzeltme |
|---|---|---|---|
| 1 | `b05c767` | UYGUN DEĞİL | CX-a-Ö-01 A1 atlatma (koşullu import, `package:..`, barrel, `part`); CX-a-K-01 `LoginGrant.toString` hesap kimliği → `c5561bc` |
| 2 | `c5561bc` | UYGUN DEĞİL | CX-a-Ö-01 sürüyor (`part`/`part of` tüneli) → `3db11a7` (B6, sözdizimsel A2) |
| 3 | `3db11a7` | UYGUN DEĞİL | CX-a-Ö-02 sözdizimsel A2 çıkarımlı tip/yapıcı/typedef zinciriyle aşılır; CX-a-K-02 ad çakışması yanlış pozitifi → `0337912` (tip çözümlemeli `tool/api_surface.dart` A2/A3; bulunan gerçek sızıntılar `ApiError.fields`, `RefreshCall`, `IdentityRepository` yapıcısı kapatıldı) |
| 4 | `0337912` | UYGUN DEĞİL | CX-a-Ö-03 koşullu import dalı; CX-a-Ö-04 `.g.dart` kökü + part; CX-a-Ö-05 çözümleme arızasında fail-open; CX-a-K-03 README → `649d507` (B7, A0 fail-closed, part sahipliği) |
| 5 | `649d507` | UYGUN DEĞİL | CX-a-Ö-06 yüzde-kodlu paket URI'si A1/G1/G2'yi aşar; CX-a-K-04 `ApiFieldError.message` düştü → `d50132b` (B8 kanonik URI) |
| 6 | `d50132b` | **UYGUN** | yok |

Kanıt (yerel): `make verify` 221/221, lint/sınır temiz; `make integration` (verify-sirasi.sh) 8/8 @ `0337912`.

## Son hüküm (6. koşum, aynen)

- Hüküm: **UYGUN**
- Denetlenen: f14-r2-domain-katmani @ `d50132b608fd208e96730be1b34e5e9191aa6565` (6. koşum) (diff `cb7f444..`)
- Gerekçe: **CX-a-Ö-06 ve CX-a-K-04 kapanmıştır**. Kanonik olmayan URI’ler B8/B6 ile fail-closed reddedilmekte; `ApiFieldError` artık `field/code/message` üçlüsünü eksiksiz korumaktadır.  
  Bütün değişiklikte derleme-geçerli yeni bir sınır kaçışı veya fail-open yol saptanmadı. Kullanıcının 221/221, temiz lint/sınır ve 8/8 entegrasyon kanıtı kabul edildi; talimat gereği test çalıştırılmadı.

## Bulgular

yok