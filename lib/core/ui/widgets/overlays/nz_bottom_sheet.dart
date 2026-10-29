import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_layout.dart';
import '../../theme/nz_motion.dart';
import '../../theme/nz_surfaces.dart';

/// Alt sayfanın alt sabit eylem satırı kurucusu: sayfa bağlamıyla çağrılır (kapatmak için
/// `Navigator.pop(sheetContext, değer)`).
typedef NzSheetActionsBuilder = List<Widget> Function(
  BuildContext sheetContext,
);

/// Alt sayfa servisi (durumsuz). Uygulamanın Navigator'ında açılır (`showModalBottomSheet`
/// varsayılanı); `MaterialApp.builder` içindeki PrivacyMask altında kalır, ayrı Overlay yoktur.
/// Açılış `easeSheet` / `durSheet`, kapanış `easeExit` / `durExit` (hareketi azalt → anlık).
abstract final class NzBottomSheet {
  /// [title] başlıktır ve ekran okuyucuya başlık olarak bildirilir; [description] başlığın
  /// altında kısa açıklama. Kapanınca [T] sonucu (sayfa içinden `Navigator.pop(context, değer)`);
  /// kapatma/sürükleme/geri `null` döner. [dismissible] false ise dışarı dokunma, sürükleme,
  /// geri tuşu ve kapat düğmesi kapalıdır (sayfa içeriği kendi eylemiyle kapatır).
  /// [actions] alt sabit düğme satırıdır (ör. "Vazgeç / Oluştur"; iki düğmede 1:2 genişlik).
  /// [expandable] tutamağı genişlet/daralt düğmesi yapar; [expansion] verilirse genişlik
  /// durumu dışarıdadır (ekran bir satırı açınca sayfayı kendisi büyütebilir).
  /// [headerAction] başlık satırında kapat düğmesinin solunda durur (ör. "Tümünü temizle").
  /// [showHeader] false → başlık satırı (başlık + kapat) çizilmez; [title] yalnız ekran
  /// okuyucuya söylenir (prototipte başlıksız işlem sayfaları: tutamak + satır grupları).
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    bool dismissible = true,
    String? description,
    NzSheetActionsBuilder? actions,
    bool expandable = false,
    ValueNotifier<bool>? expansion,
    Widget? headerAction,
    bool showHeader = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      showDragHandle: false,
      constraints: BoxConstraints(
        maxWidth: context.layout.contentMaxWidth(NzContentWidth.form),
      ),
      sheetAnimationStyle: AnimationStyle(
        duration: NzMotion.of(context, NizamioMotion.durSheet),
        reverseDuration: NzMotion.of(context, NizamioMotion.durExit),
        curve: NizamioMotion.easeSheet,
        reverseCurve: NizamioMotion.easeExit,
      ),
      builder: (sheetContext) => PopScope(
        canPop: dismissible,
        child: NzBottomSheetContent(
          title: title,
          description: description,
          dismissible: dismissible,
          expandable: expandable,
          expansion: expansion,
          headerAction: headerAction,
          showHeader: showHeader,
          actions: actions?.call(sheetContext),
          child: Builder(builder: builder),
        ),
      ),
    );
  }
}

/// [NzBottomSheet.show] içeriği (prototip alt sayfası, bundle.css `.m-sheet`): `bg-surface`,
/// üst köşeler `m-r-sheet` 28, üstte 1 px `border-strong`, `m-sh-sheet` gölgesi; tutamak 36×4
/// `border-control` (72×24 alan); başlık `m-sheet-title` + isteğe bağlı açıklama + sağda kapat;
/// kaydırılabilir gövde; isteğe bağlı alt eylem satırı (üstünde 1 px `border-subtle`).
/// Golden/katalog çizimi için dışa açıktır.
class NzBottomSheetContent extends StatefulWidget {
  const NzBottomSheetContent({
    super.key,
    required this.title,
    required this.child,
    this.dismissible = true,
    this.description,
    this.actions,
    this.expandable = false,
    this.expansion,
    this.headerAction,
    this.showHeader = true,
  });

  final String title;
  final Widget child;
  final bool dismissible;
  final String? description;
  final List<Widget>? actions;
  final bool expandable;

  /// Dış genişlik durumu ([expandable] ile); null → iç durum.
  final ValueNotifier<bool>? expansion;
  final Widget? headerAction;

  /// false → başlık satırı gizli; [title] yalnız anlamsal etiket.
  final bool showHeader;

  @override
  State<NzBottomSheetContent> createState() => _NzBottomSheetContentState();
}

class _NzBottomSheetContentState extends State<NzBottomSheetContent> {
  late ValueNotifier<bool> _expansion =
      widget.expansion ?? ValueNotifier(false);

  bool get _expanded => _expansion.value;

  @override
  void initState() {
    super.initState();
    _expansion.addListener(_changed);
  }

  @override
  void didUpdateWidget(NzBottomSheetContent old) {
    super.didUpdateWidget(old);
    if (old.expansion != widget.expansion) {
      _expansion.removeListener(_changed);
      if (old.expansion == null) _expansion.dispose();
      _expansion = widget.expansion ?? ValueNotifier(false)
        ..addListener(_changed);
    }
  }

  @override
  void dispose() {
    _expansion.removeListener(_changed);
    if (widget.expansion == null) _expansion.dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  // Genişletilebilir sayfanın daraltılmış payı (prototip yüksekliği ≈ %62); genişleyince tam.
  static const _collapsedFraction = 0.62;
  // Tutamak alanı ve çizgisi (bundle.css `.m-sheet__grab`): 72×24, 36×4.
  static const _grabSize = Size(72, 24);
  static const _handleSize = Size(36, 4);
  // Başlık metni kapat düğmesiyle hizalı (prototip `padding-top: 6px`).
  static const _titleTop = 6.0;

  static const _radius = BorderRadius.vertical(
    top: Radius.circular(NizamioRadius.sheet),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final material = MaterialLocalizations.of(context);
    final description = widget.description;
    final actions = widget.actions;
    final bottomInset =
        MediaQuery.viewInsetsOf(context).bottom +
        MediaQuery.paddingOf(context).bottom;

    final handle = SizedBox.fromSize(
      size: _grabSize,
      child: Center(
        child: SizedBox.fromSize(
          size: _handleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.borderControl,
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
            ),
          ),
        ),
      ),
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: widget.expandable
              ? Semantics(
                  button: true,
                  expanded: _expanded,
                  label: _expanded
                      ? material.expandedIconTapHint
                      : material.collapsedIconTapHint,
                  excludeSemantics: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _expansion.value = !_expanded,
                    child: handle,
                  ),
                )
              : ExcludeSemantics(child: handle),
        ),
        if (!widget.showHeader)
          Semantics(
            header: true,
            label: widget.title,
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                height: NizamioSpacing.space1,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NizamioSpacing.space4,
              0,
              NizamioSpacing.space2,
              NizamioSpacing.space3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: _titleTop),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(widget.title, style: t.titleSm),
                        ),
                        if (description != null) ...[
                          const Gap(NizamioSpacing.space1),
                          Text(
                            description,
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                ?widget.headerAction,
                if (widget.dismissible)
                  IconButton(
                    tooltip: l.uiCommonClose,
                    constraints: const BoxConstraints(
                      minWidth: NizamioSpacing.space12,
                      minHeight: NizamioSpacing.space12,
                    ),
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
              ],
            ),
          ),
        Flexible(
          fit: widget.expandable ? FlexFit.tight : FlexFit.loose,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              NizamioSpacing.space4,
              0,
              NizamioSpacing.space4,
              NizamioSpacing.space4 + (actions == null ? bottomInset : 0),
            ),
            child: widget.child,
          ),
        ),
        if (actions != null && actions.isNotEmpty)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: c.border,
                  width: NizamioSize.borderWidth,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                NizamioSpacing.space4,
                NizamioSpacing.space3,
                NizamioSpacing.space4,
                NizamioSpacing.space4 + bottomInset,
              ),
              child: Row(
                spacing: NizamioSpacing.space2,
                children: [
                  for (var i = 0; i < actions.length; i++)
                    Expanded(
                      // `.m-sheet__foot`: iki düğmede 1fr / 2fr.
                      flex: actions.length == 2 && i == 1 ? 2 : 1,
                      child: actions[i],
                    ),
                ],
              ),
            ),
          ),
      ],
    );

    final Widget sized = widget.expandable
        ? LayoutBuilder(
            builder: (context, constraints) {
              final full = constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : MediaQuery.sizeOf(context).height;
              final h = _expanded ? full : full * _collapsedFraction;
              return AnimatedContainer(
                duration: NzMotion.of(context, NizamioMotion.durSheet),
                curve: NizamioMotion.easeSheet,
                height: h,
                child: column,
              );
            },
          )
        : column;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: _radius,
        boxShadow: context.shadows.sheet,
      ),
      child: CustomPaint(
        foregroundPainter: NzEdgeLightPainter(
          color: c.borderStrong,
          borderRadius: _radius,
          inset: 0,
        ),
        child: sized,
      ),
    );
  }
}
