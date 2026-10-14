import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

enum _TileVariant { standard, navigation, danger }

/// Liste satırı: [leading] · başlık/alt başlık · [trailing]. Görünüm farkı tek `_resolveStyle`'da.
///
/// [onTap] null ise satır salt okunurdur (düğme anlamı ve dokunma tepkisi yok). Dokunma alanı
/// her boyutta en az 48 yüksekliktedir; metin büyüdükçe satır uzar (taşma yok).
class NzListTile extends StatelessWidget {
  /// Düz satır.
  const NzListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.size = NzSize.md,
  }) : _variant = _TileVariant.standard;

  /// Başka ekrana götüren satır: [trailing] verilmezse sağda ok simgesi gösterilir.
  const NzListTile.navigation({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required VoidCallback this.onTap,
    this.selected = false,
    this.size = NzSize.md,
  }) : _variant = _TileVariant.navigation;

  /// Yıkıcı eylem satırı (başlık tehlike renginde).
  const NzListTile.danger({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required VoidCallback this.onTap,
    this.selected = false,
    this.size = NzSize.md,
  }) : _variant = _TileVariant.danger;

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final NzSize size;
  final _TileVariant _variant;

  static const _selectedAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    final shownTrailing =
        trailing ??
        (_variant == _TileVariant.navigation
            ? ExcludeSemantics(
                child: Icon(
                  Icons.chevron_right,
                  color: context.colors.textMuted,
                ),
              )
            : null);

    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: NizamioSpacing.space4,
        vertical: style.verticalPadding,
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const Gap(NizamioSpacing.space3)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: style.title),
                if (subtitle != null) Text(subtitle!, style: style.subtitle),
              ],
            ),
          ),
          if (shownTrailing != null) ...[
            const Gap(NizamioSpacing.space3),
            shownTrailing,
          ],
        ],
      ),
    );

    return MergeSemantics(
      child: Semantics(
        container: true,
        button: onTap != null,
        selected: selected,
        enabled: onTap != null,
        child: Material(
          type: selected ? MaterialType.canvas : MaterialType.transparency,
          color: selected
              ? context.colors.primary.withValues(alpha: _selectedAlpha)
              : null,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: style.minHeight),
              child: Align(
                alignment: Alignment.centerLeft,
                heightFactor: 1,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ({
    double minHeight,
    double verticalPadding,
    TextStyle title,
    TextStyle subtitle,
  })
  _resolveStyle(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final titleColor = _variant == _TileVariant.danger
        ? colors.danger
        : colors.text;
    return (
      minHeight: size.pick(
        sm: NizamioSpacing.space12,
        md: NizamioSpacing.space12 + NizamioSpacing.space2,
        lg: NizamioSpacing.space16 + NizamioSpacing.space8,
      ),
      verticalPadding: size.pick(
        sm: NizamioSpacing.space2,
        md: NizamioSpacing.space3,
        lg: NizamioSpacing.space4,
      ),
      title: size
          .pick(sm: text.bodyMd, md: text.bodyLg, lg: text.titleSm)
          .copyWith(color: titleColor),
      subtitle: text.bodySm.copyWith(color: colors.textMuted),
    );
  }
}
