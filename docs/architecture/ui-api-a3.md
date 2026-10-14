# UI API — A3 imzaları (durum kalıbı · sayfa kabuğu · feedback kiti · katalog)

Durum: **Sabit (MOB-UI-0 O3, 2026-10-14).** Kaynak: [yol haritası A3/A4](yol-haritasi-ui-temeli.md),
[ADR-0003](adr-0003-ui-temeli.md). Bu belge **imza** belgesidir: iç uygulama, görünüm ayrıntısı ve
yardımcılar uygulayıcının SERBEST alanıdır. İmzadan sapma gerekiyorsa uygulayıcı imzayı değiştirmez,
"SAPMA" olarak raporlar; koordinatör bu belgeyi düzeltir ve `docs/yurutme/mob-ui-0/ilerleme.md`'ye yazar.

Ortak ilkeler (A4): önek `Nz`; bileşen başına tek dosya; `const` yapıcı; iş mantığı yok, yalnız geri
çağrı; varyant = **isimli yapıcı** (+ gerekirse enum); dışarıdan `style:`/renk/padding parametresi
**yok**; değerler `context.colors` / `context.text` / `context.layout` / token ve boşluk `Gap`
(U1–U6). Kullanıcı metni ARB'den (`context.l10n`), hata metni yalnız `errorText`. ARB metinlerinde
yer tutucu (`{}`) yoktur (O1 kuralı): sayı gibi değişken parçalar ayrı `Text` olarak çizilir,
erişilebilirlik etiketi `Semantics` ile birleştirilir.

İmzalardaki alan listeleri kamu yüzeyidir; her isimli yapıcının kullanmadığı alanları nasıl
ilklendirdiği (initializer list, özel alt sınıf vb.) uygulayıcıya kalır. Parametre adları, tipleri,
isimli yapıcı adları ve varsayılanlar bağlayıcıdır.

## 1. Ortak

```dart
// lib/core/ui/widgets/nz_size.dart  (W21; O4 grupları da kullanır)
enum NzSize { sm, md, lg }
```

`NzContentWidth` (`form` · `reading` · `list`) A2'de tanımlıdır
(`lib/core/ui/layout/nz_layout.dart`); yeniden tanımlanmaz.

## 2. Feedback kiti — `lib/core/ui/widgets/feedback/` (W21)

Metinler `i18n/ui/feedback.tr.json` (`ui.feedback.*`); ortak "Yeniden dene" `ui.common.retry`.

```dart
// nz_loader.dart — belirsiz ilerleme göstergesi.
class NzLoader extends StatelessWidget {
  const NzLoader({super.key, this.size = NzSize.md, this.semanticLabel});
  /// Bulunduğu alanı kaplayan, ortalanmış gösterge (sayfa/bölüm yüklemesi).
  const NzLoader.page({super.key, this.semanticLabel}) : size = NzSize.lg;
  final NzSize size;
  final String? semanticLabel; // null → ui.feedback.loading
}

// nz_skeleton.dart — içerik yer tutucusu (iskelet). Animasyon SERBEST.
class NzSkeleton extends StatelessWidget {
  /// [lines] metin satırı; son satır kısa.
  const NzSkeleton.text({super.key, this.lines = 1});
  /// Sabit yükseklikte blok (kart/görsel yeri). Genişlik üst kısıttan.
  const NzSkeleton.block({super.key, required this.height});
  /// [count] adet liste satırı (avatar + iki satır).
  const NzSkeleton.list({super.key, this.count = 3});
  final int lines;
  final double? height;
  final int count;
}

// nz_empty_state.dart — boş liste/sonuç. Feature'a özgü isimli yapıcı core'da YOKTUR
// (core → features yasak); feature kendi metniyle bu yapıcıyı çağırır.
class NzEmptyState extends StatelessWidget {
  const NzEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String? message;
  final IconData? icon;
  final String? actionLabel; // onAction ile birlikte verilir (assert)
  final VoidCallback? onAction;
}

// nz_error_state.dart — hata görünümü. Metin yalnız errorText(context.l10n, error).
// error.retryAfter varsa "Yeniden dene" düğmesi süre dolana dek devre dışıdır ve kalan saniye
// ayrı Text ile gösterilir; süre dolunca düğme yalnız ETKİNLEŞİR — onRetry kendiliğinden
// ÇAĞRILMAZ (otomatik yeniden deneme yok). onRetry null → düğme yok.
class NzErrorState extends StatelessWidget {        // iç sayaç için StatefulWidget olabilir
  /// Sayfa/bölüm ortası (ikon + başlık + metin + düğme).
  const NzErrorState({super.key, required this.error, this.onRetry});
  /// Liste içi / kart içi tek satırlık biçim.
  const NzErrorState.inline({super.key, required this.error, this.onRetry});
  final ApiError error;
  final VoidCallback? onRetry;
}

// nz_banner.dart — sayfa üstü şerit. Tonlar isimli yapıcıdır.
class NzBanner extends StatelessWidget {
  const NzBanner.info({super.key, required this.message, this.actionLabel, this.onAction});
  const NzBanner.warning({super.key, required this.message, this.actionLabel, this.onAction});
  const NzBanner.danger({super.key, required this.message, this.actionLabel, this.onAction});
  /// Çevrimdışı şeridi: metin ui.feedback.offline; onAction varsa ui.common.retry düğmesi.
  /// Yeniden deneme yalnız kullanıcı dokunuşuyla (A3b).
  const NzBanner.offline({super.key, this.onAction}) : message = null, actionLabel = null;
  final String? message;     // offline'da null (ARB'den)
  final String? actionLabel; // offline'da null (ui.common.retry)
  final VoidCallback? onAction;
}

// nz_toast.dart — snackbar servisi (durumsuz; ScaffoldMessenger üzerinden).
// MaterialApp.builder'daki PrivacyMask altında kalır; ayrı Overlay/pencere açılmaz.
enum NzToastTone { info, success, danger }

abstract final class NzToast {
  static void show(
    BuildContext context,
    String message, {
    NzToastTone tone = NzToastTone.info,
    String? actionLabel,
    VoidCallback? onAction,
  });
  static void success(BuildContext context, String message);
  /// Metin errorText; oturum bitti sınıfı hataları ayıklamak ÇAĞIRANIN işidir (listenErrors).
  static void error(BuildContext context, ApiError error);
}
```

## 3. Sayfa kabuğu — `lib/core/ui/page/nz_page.dart` (W22)

```dart
/// Her ekranın kabuğu (U6: features presentation'da Scaffold yasağının tek karşılığı).
/// Scaffold + SafeArea + NzTextScaleLimit (A2) + context.layout.pagePadding (yatay) +
/// NzContentWidth azami genişlik (ortalanır) + connectivityStateProvider == offline iken
/// gövdenin üstünde NzBanner.offline(onAction: onRetry) + loading: true iken dokunmayı kesen
/// NzLoader örtüsü. PrivacyMask'ın altında kalır (kendi Overlay'i yoktur).
class NzPage extends ConsumerWidget {
  const NzPage({
    super.key,
    required this.title,
    required this.body,
    this.width = NzContentWidth.list,
    this.actions = const [],
    this.floatingAction,
    this.loading = false,
    this.onRetry,
  });
  final String title;              // AppBar başlığı (ARB'den)
  final Widget body;
  final NzContentWidth width;
  final List<Widget> actions;      // AppBar eylemleri (O4: NzIconButton)
  final Widget? floatingAction;
  final bool loading;
  final VoidCallback? onRetry;     // çevrimdışı şeridindeki "yeniden dene"
}
```

## 4. Durum görünümü — `lib/core/ui/state/nz_async_view.dart` (W22)

```dart
/// AsyncValue → yükleniyor / hata / boş / veri.
/// - İlk yükleme: [loading] ya da NzLoader.page().
/// - Hata: NzErrorState(error: toApiError(e), onRetry: onRetry). ApiError dışı istisna
///   toApiError ile client.invalid_response'a iner (sızmaz).
/// - Yenileme (önceki veri varken): eski veri gösterilir (skipLoadingOnRefresh); yenileme
///   hatasında da önceki veri gösterilmeye devam eder — hata ref.listenErrors ile bildirilir.
/// - Veri: isEmpty(data) true ise [empty] (verilmediyse data çağrılır), değilse data(data).
class NzAsyncView<T> extends StatelessWidget {
  const NzAsyncView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.loading,
  });
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;
  final Widget? loading;           // örn. NzSkeleton.list()
}
```

## 5. Yan etki uzantıları — `lib/core/ui/extensions/ref_ext.dart` (W22)

```dart
/// Ekranın göstermeyeceği "oturum bitti" sınıfı hata kodları: faz makinesi
/// (deriveAppPhase → router) kullanıcıyı zaten yönlendirir. Liste koddan kurulur
/// (ClientErrorCode sabitleri); sunucu kodu dizgesi varsa testle errorCatalog'da varlığı
/// doğrulanır. En az: client.session_ended, client.not_signed_in, client.reauth_required,
/// identity.force_password_change_required. Eksiksizlik W22 raporunda gerekçelenir.
const Set<String> sessionEndedErrorCodes = { /* ... */ };

extension NzRefListen on WidgetRef {
  /// [provider] AsyncError'a GEÇTİĞİNDE (aynı hata tekrar bildirilmez) NzToast.error;
  /// kod sessionEndedErrorCodes içindeyse hiçbir şey gösterilmez. build içinde çağrılır
  /// (ref.listen); etkinin kendisi geri çağrıdadır.
  void listenErrors<T>(ProviderListenable<AsyncValue<T>> provider, BuildContext context);

  /// Yükleniyor → AsyncData geçişinde onData(data) (gönderim başarısı: yönlendirme, toast).
  void listenSuccess<T>(
    ProviderListenable<AsyncValue<T>> provider,
    void Function(T data) onData,
  );
}
```

## 6. Katalog (yalnız dev flavor) — `lib/app/dev/` (W21)

```dart
// lib/app/dev/catalog/catalog_entry.dart
class CatalogEntry {
  const CatalogEntry({required this.group, required this.name, required this.builder});
  final String group;          // 'feedback', 'buttons', ...
  final String name;           // 'NzBanner.offline'
  final WidgetBuilder builder;
}

// lib/app/dev/catalog/<grup>_catalog.dart — her kit grubu YALNIZ kendi dosyasını yazar.
List<CatalogEntry> get feedbackCatalogEntries;   // W21

// lib/app/dev/catalog/catalog_registry.dart — grup başına tek satır (O4'te her grup kendi satırı).
List<CatalogEntry> get allCatalogEntries => [...feedbackCatalogEntries];

// lib/app/dev/catalog_page.dart — allCatalogEntries'i gruplar; açık/koyu ve pencere sınıfı
// önizlemesi (360 · 700 · 1024 genişlik) sunar. Düzen SERBEST.
class CatalogPage extends StatelessWidget { const CatalogPage({super.key}); }
```

Rota: `/dev/catalog`. `createRouter` imzası genişler (W21, `lib/app/router.dart` — O4/W36 sonrası `lib/app/router/router.dart` — yalnız katalog
satırları; `lib/app/app.dart` yalnız çağrı satırı):

```dart
GoRouter createRouter(ValueNotifier<AppPhase> phase, {bool devCatalog = false});
// app.dart: createRouter(_phase, devCatalog: ref.read(flavorProvider) == Flavor.dev)
```

`devCatalog: false` iken rota **tanımlı değildir** (prod; testle kanıt). `devCatalog: true` iken
`/dev/catalog` faz yönlendirmesinden muaftır; diğer rotalar faz makinesine bağlı kalır.

## 7. Dosya sahipliği (O3)

| Yol | Sahip |
|---|---|
| `lib/core/ui/widgets/nz_size.dart`, `lib/core/ui/widgets/feedback/**`, `lib/app/dev/**`, `i18n/ui/feedback.tr.json`, `lib/app/router.dart` (katalog satırları; O4/W36 ile `lib/app/router/router.dart`), `lib/app/app.dart` (createRouter çağrısı) | W21 |
| `lib/core/ui/page/**`, `lib/core/ui/state/**`, `lib/core/ui/extensions/ref_ext.dart` | W22 |
