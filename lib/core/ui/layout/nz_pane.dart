import 'package:flutter/widgets.dart';

import '../../theme/generated/tokens.gen.dart';
import 'nz_layout.dart';
import 'window_class.dart';

/// Tablet yerleşim ölçüleri (prototip `docs/design/tablet/12-Tablet.dc.html`, 1180×820 artboard).
/// Tablet ölçüleri yalnız buradan okunur; ekranlara sabit sayı serpiştirilmez.
// TOKEN-BEKLİYOR: tasarım token kaynağında tablet ölçüsü yok; değerler prototipin satır içi
// stillerinden ve `.tb-pane` / `.tb-rpane` kurallarındandır.
abstract final class NzTabletMetrics {
  /// Gezinme rayı genişliği (`nav[aria-label="Ana menü"]` 100).
  static const double railWidth = 100;

  /// Liste (sol) bölmesi içerik genişliği (390, sağında 1 px kenar); sağ bölme kalanı alır
  /// (1180'de 689).
  static const double masterWidth = 390;

  /// Rayın üst ve alt iç boşluğu (20) ve öğeler arası boşluk (4).
  static const double railPadV = NizamioSpacing.space5;
  static const double railGap = NizamioSpacing.space1;

  /// Ray işareti 36 ve altındaki boşluk 18.
  static const double railBrand = NizamioSize.iconTile;
  static const double railBrandGap = NizamioSpacing.gapLg;

  /// Ray öğesi: 96 genişlik, 7 dikey dolgu, 60×34 kapsül, kapsül–etiket 5, etiket en çok 94.
  static const double railItemWidth = 96;
  static const double railItemPadV = 7;
  static const double railPillWidth = 60;
  static const double railPillHeight = 34;
  static const double railLabelGap = 5;
  static const double railLabelMaxWidth = 94;

  /// Ray etiketi 10.5/13, harf aralığı -0.01em.
  static const double railLabelSize = 10.5;
  static const double railLabelLine = 13;
  static const double railLabelTracking = -0.01;

  /// Ray kapsül dolgusu .35 s, ikon/etiket rengi .3 s geçişi.
  static const railPillFade = Duration(milliseconds: 350);
  static const railInkFade = Duration(milliseconds: 300);

  /// Ray rozeti (`t-badge--count`): kapsülün üstünden 3 yukarı, sağından 10 içeride; 16 yükseklik.
  static const double railBadgeTop = -3;
  static const double railBadgeRight = 10;
  static const double railBadgeSize = 16;

  /// Ray alt düğmeleri: zil ve menü 44, asistan 56 (üstünde ek 8).
  static const double railButton = NizamioSize.controlMd;
  static const double railAssistant = 56;
  static const double railAssistantGap = NizamioSpacing.space2;

  /// Zil noktası: 7 px, üstten 10, sağdan 11, 2 px zemin halkası.
  static const double bellDotTop = 10;
  static const double bellDotRight = 11;
  static const double dotRing = 2;

  /// Bölme içinde kök üst çubuk gizlidir; içerik üstten 18 başlar (`.tb-pane .rp-rise`).
  static const double paneTop = NizamioSpacing.gapLg;

  /// Bölme sayfa sonu boşluğu (40; telefondaki alt menü payı yerine).
  static const double paneBottom = NizamioSpacing.space10;

  /// Sağ bölme içerik yan boşluğu 28, ayrıntı üst çubuğunun yan boşluğu 20 (`.tb-rpane`).
  static const double detailSide = 28;
  static const double detailHeaderSide = NizamioSpacing.space5;

  /// Merkezi modal: en çok 560 genişlik, pencere kenarından 24, dikeyde toplam 64 pay, 28 köşe.
  static const double modalMaxWidth = 560;
  static const double modalEdge = NizamioSpacing.space6;
  static const double modalVerticalInset = NizamioSpacing.space16;

  /// Modal alt eylem satırının alt dolgusu (`padding: 12px 16px 28px`).
  static const double modalFooterBottom = 28;

  /// Genişletilebilir sayfanın kaynak yüksekliği (`hs.sh.h`: 600, genişleyince 800); merkezi
  /// modalda en çok `pencere − 64` ile sınırlanır.
  static const double sheetHeight = 600;
  static const double sheetExpandedHeight = 800;

  /// Giriş ekranı ortada 420 genişlik.
  static const double loginWidth = 420;

  /// Çift bölme (ray + liste + ayrıntı) pencere genişliği eşiği: expanded (≥ 840). Daha dar
  /// tablette (600–839) ray + tek bölme. Kabuk ve kök rotalar aynı ölçüyü okur (pencere).
  static bool splitsAt(double windowWidth) =>
      WindowClass.fromWidth(windowWidth).isExpanded;

  /// Kaynağın tablet görsel kuralları (merkezi modal, ortada giriş) çift bölme
  /// genişliğinde uygulanır; 600–839 (kaynakta tanımsız) telefon görselindedir.
  static bool tabletVisualAt(double windowWidth) => splitsAt(windowWidth);

  /// Ray (tek bölme dahil) pencere genişliği eşiği: medium ve üstü.
  static bool railAt(double windowWidth) =>
      !WindowClass.fromWidth(windowWidth).isCompact;
}

/// Tablet bölmesinin rolü: sol liste ([master]) ya da sağ ayrıntı ([detail]).
enum NzPaneRole { master, detail }

/// Tablet çift bölmesinde sayfaya bulunduğu bölmeyi ve sağ yığının geri davranışını bildirir
/// (yalnız uygulama kabuğu verir; telefonda yoktur). Sayfa kabuğu ve üst çubuk prototipin
/// `.tb-pane` / `.tb-rpane` kurallarını buradan uygular: liste bölmesinde kök üst çubuk gizli
/// ve içerik üstten 18; ayrıntı bölmesinde yan boşluk 28, üst çubuk yanları 20; [canBack]
/// false iken "Geri" düğmeleri gizli (`[data-canback="false"] [aria-label^="Geri"]`).
/// [role] null ise yerleşim kuralı yoktur, yalnız geri davranışı taşınır (tek bölmede sağ yığın).
class NzPaneScope extends InheritedWidget {
  const NzPaneScope({
    super.key,
    this.role,
    this.canBack = false,
    this.onBack,
    required super.child,
  });

  final NzPaneRole? role;

  /// Sağ bölme yığınında geri dönülecek ekran var mı (prototip `rs.length > 1`).
  final bool canBack;

  /// Sağ yığını bir adım geri alır (prototip `tback`); null → `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Bölme dışında (telefon, tek bölme) null.
  static NzPaneScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NzPaneScope>();

  /// Üst çubuktaki "Geri" düğmesi görünür mü: ayrıntı bölmesinde yalnız [canBack] iken.
  static bool showsBack(NzPaneScope? pane) =>
      pane == null || pane.role != NzPaneRole.detail || pane.canBack;

  /// "Geri"nin yapacağı iş: sağ yığın varsa onu geri alır, yoksa gezgini.
  static void back(BuildContext context) {
    final onBack = maybeOf(context)?.onBack;
    if (onBack != null) {
      onBack();
    } else {
      Navigator.maybePop(context);
    }
  }

  /// Sayfa gövdesinin yan boşluğu ([constraints] gövdeye ayrılan alan): sağ bölmede en az 28
  /// (`.tb-rpane`), aksi hâlde sayfa dolgusu; ikisinde de [width] azami genişliği ortalanır.
  static double sideInset(
    BuildContext context,
    BoxConstraints constraints,
    NzContentWidth width,
  ) {
    final local = NzLayout.fromConstraints(constraints);
    return maybeOf(context)?.role == NzPaneRole.detail
        ? local.horizontalInset(width, padding: NzTabletMetrics.detailSide)
        : local.horizontalInset(width);
  }

  /// Kaydırılan sayfanın sonundaki boşluk: alt güvenli alan + bölmede 40 (`.tb-pane`), telefonda
  /// `gap-xl` (alt menü payı kabukta).
  static double pageBottom(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom +
      (maybeOf(context)?.role == null
          ? NizamioSpacing.gapXl
          : NzTabletMetrics.paneBottom);

  @override
  bool updateShouldNotify(NzPaneScope old) =>
      old.role != role || old.canBack != canBack || old.onBack != onBack;
}
