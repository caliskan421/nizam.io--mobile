# MOB-UI-0 yürütme seti — oturum istemleri

Kaynak gereksinim: [`../../architecture/yol-haritasi-ui-temeli.md`](../../architecture/yol-haritasi-ui-temeli.md)
(A0–A7). Bu klasör o belgeyi **kim, hangi oturumda, hangi sırayla ve hangi paralellikle**
uygular sorusunu cevaplar. Gereksinimin kendisi burada tekrar yazılmaz.

## Roller

| Rol | Model | Yapar | Yapmaz |
|---|---|---|---|
| Koordinatör | Opus (oturumu açan ana model) | Plan, sözleşme, alt ajan başlatma, birleştirme, denetim, PR/CI, kayıt | Feature/kit kodu yazmaz (birleştirme çakışması ve tek satırlık bağlama hariç) |
| Uygulayıcı | Sonnet alt ajan (`Agent`, `model: "sonnet"`) | Kendi worktree'sinde, kendi dosyalarında kod + test | Alt ajan açmaz, push/PR yapmaz, başka uygulayıcının dosyasına dokunmaz |
| Nihai kapı | Codex, salt okunur, tek koşum | Son oturumda bütün MOB-UI-0 hükmü | — |

## Oturum haritası

| Oturum | Dosya | Aşama | Uygulayıcılar | Paralellik |
|---|---|---|---|---|
| O1 | [oturum-1-a0.md](oturum-1-a0.md) | A0 kural + kapılar + ön hazırlık | W01–W04 | Önce koordinatör belgeleri (sıralı), sonra 4 paralel |
| O2 | [oturum-2-temel.md](oturum-2-temel.md) | A1 · A2 · A3b · A6 · §4 | W11–W15 | 5 paralel |
| O3 | [oturum-3-kabuk.md](oturum-3-kabuk.md) | A3 + A4 feedback grubu + katalog | W21–W22 | Koordinatör imzaları sabitler, sonra 2 paralel |
| O4 | [oturum-4-kit-router.md](oturum-4-kit-router.md) | A4 kalan gruplar · A5 | W31–W36 | 6 paralel |
| O5 | [oturum-5-pilot.md](oturum-5-pilot.md) | A7 + kapanış + Codex | W41 | Sıralı |

Oturumlar arasındaki bağımlılık **kesindir**: Ox ancak O(x-1)'in bütün PR'ları `main`'e
birleşip CI yeşilken açılır. Bir oturum biterken iş yarıda kalmışsa aynı oturum dosyası
yeniden açılır ve [ilerleme.md](ilerleme.md)'den devam edilir.

## Kullanım

1. Yeni Claude Code oturumu açın (Opus), çalışma dizini `NIZAM.IO/`.
2. İlgili oturum dosyasındaki **"Açılış istemi"** bloğunu kopyalayıp yapıştırın.
3. Koordinatör uygulayıcı istemlerini aynı dosyadan alır; her istemin başına
   [ortak-sozlesme.md](ortak-sozlesme.md) içeriğini **aynen** ekler.

## İstem yazım ilkesi

Her uygulayıcı isteminde iki liste vardır:

- **KESİN** — güvenlik, katman yönü, ortak dosya sahipliği, sözleşme, kapılar. Pazarlık yok;
  uyulamıyorsa uygulayıcı durur ve raporlar.
- **SERBEST** — geri kalan her şey (iç yapı, adlandırma ayrıntısı, yardımcılar, test kurgusu,
  görsel nötr seçimler). Uygulayıcı kendi yargısıyla karar verir, izin istemez, seçimini
  raporda bir satırla gerekçelendirir.

KESİN listede yazmayan bir konu SERBEST'tir. Koordinatör bir sonraki oturumda bir seçimi
beğenmezse onu KESİN'e taşır; geriye dönük olarak uygulayıcıyı suçlamaz.
