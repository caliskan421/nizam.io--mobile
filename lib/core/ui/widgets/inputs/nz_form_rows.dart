import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_pane.dart';
import '../../theme/nz_motion.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
import '../surfaces/nz_reveal.dart';
import 'nz_switch.dart';

enum _RowKind { value, toggle, custom }

/// [NzFormRows] satırı (veri). Üç biçim:
/// - varsayılan: etiket + sağda değer + chevron; [content] verilirse dokununca satırın altında
///   yerinde açılır (chevron 90° döner), yoksa [onTap] (ör. seçici açar);
/// - [NzFormRow.toggle]: sağda anahtar ([NzToggle]); satırın tamamı dokunma alanı;
/// - [NzFormRow.custom]: sağda serbest denetim ([trailing], ör. öncelik seçici).
///
/// Solda 16 px [icon] ya da özel [leading] (ör. öncelik çubukları), ikisi de isteğe bağlı.
@immutable
class NzFormRow {
  const NzFormRow({
    required this.label,
    this.icon,
    this.leading,
    this.value,
    this.valueSet = false,
    this.valueColor,
    this.content,
    this.onTap,
  }) : toggleValue = null,
       onToggle = null,
       trailing = null,
       _kind = _RowKind.value;

  const NzFormRow.toggle({
    required this.label,
    required bool value,
    required ValueChanged<bool>? onChanged,
    this.icon,
    this.leading,
  }) : toggleValue = value,
       onToggle = onChanged,
       value = null,
       valueSet = false,
       valueColor = null,
       content = null,
       onTap = null,
       trailing = null,
       _kind = _RowKind.toggle;

  const NzFormRow.custom({
    required this.label,
    required Widget this.trailing,
    this.icon,
    this.leading,
  }) : toggleValue = null,
       onToggle = null,
       value = null,
       valueSet = false,
       valueColor = null,
       content = null,
       onTap = null,
       _kind = _RowKind.custom;

  final String label;
  final IconData? icon;
  final Widget? leading;

  /// Sağdaki değer metni (ör. "Seçilmedi", "15 Tem").
  final String? value;

  /// Değer seçilmiş → `ink`; değilse `ink-muted` (prototip `data-set`).
  final bool valueSet;

  /// Değer metninin rengi açıkça verilirse [valueSet] kuralının yerine (ör. kaynak "Seç" →
  /// `accent-text`, bekleyen alan → `ink-faint`).
  final Color? valueColor;

  /// Yerinde açılan içerik (açık/kapalı durumu [NzFormRows.expandedIndex]).
  final Widget? content;

  /// [content] yokken dokunuş.
  final VoidCallback? onTap;

  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final Widget? trailing;
  final _RowKind _kind;
}

/// Form satırı kartı (bundle.css `.m-rows` / `.m-row`; prototip "Yeni görev", toplantı, davet,
/// filtre sayfaları): `bg-raised` zemin, köşe `m-r-row` 18, satır en az `m-row` 52, aralarında
/// 1 px `border-subtle`. Aynı anda tek satır açıktır ve durum DIŞARIDADIR: [expandedIndex]
/// açık satır (null → hiçbiri), [onToggle] açılır satıra dokunulunca o satırın indeksiyle
/// çağrılır — ekran controller'ı `expanded = expanded == i ? null : i` yazar.
class NzFormRows extends StatelessWidget {
  const NzFormRows({
    super.key,
    required this.rows,
    this.expandedIndex,
    this.onToggle,
  });

  final List<NzFormRow> rows;
  final int? expandedIndex;
  final ValueChanged<int>? onToggle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(NizamioRadius.row),
      child: ColoredBox(
        color: c.surfaceRaised,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0)
                Divider(
                  height: NizamioSize.borderWidth,
                  thickness: NizamioSize.borderWidth,
                  color: c.border,
                ),
              _RowView(
                row: rows[i],
                expanded: expandedIndex == i,
                onToggle: onToggle == null ? null : () => onToggle!(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RowView extends StatelessWidget {
  const _RowView({
    required this.row,
    required this.expanded,
    required this.onToggle,
  });

  final NzFormRow row;
  final bool expanded;
  final VoidCallback? onToggle;

  // Chevron dönüşü: prototip `.35s cubic-bezier(.34, 1.4, .5, 1)` ≈ easeSpring.
  static const _chevDuration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final content = row.content;
    final icon = row.icon;
    final leading =
        row.leading ??
        (icon == null
            ? null
            : NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.textMuted));
    final label = Text(row.label, style: t.bodyMd);

    Widget line(List<Widget> trailing) => ConstrainedBox(
      constraints: const BoxConstraints(minHeight: NizamioSize.row),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.rowPad,
          vertical: NizamioSpacing.space1,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              SizedBox(
                width: NizamioSize.iconSize,
                child: Center(child: leading),
              ),
              const Gap(NizamioSpacing.space3),
            ],
            ...trailing,
          ],
        ),
      ),
    );

    final wide = NzTabletMetrics.tabletVisualAt(
      MediaQuery.sizeOf(context).width,
    );
    switch (row._kind) {
      case _RowKind.toggle:
        final onChanged = row.onToggle;
        final value = row.toggleValue ?? false;
        final tap = onChanged == null ? null : () => onChanged(!value);
        return Semantics(
          container: true,
          toggled: value,
          enabled: onChanged != null,
          label: row.label,
          onTap: tap,
          excludeSemantics: true,
          child: InkWell(
            onTap: tap,
            child: line([
              Expanded(child: label),
              const Gap(NizamioSpacing.space3),
              NzToggle(value: value, onChanged: onChanged),
            ]),
          ),
        );
      case _RowKind.custom:
        return MergeSemantics(
          child: line([
            Expanded(child: label),
            const Gap(NizamioSpacing.space3),
            // Dar ekranda/büyük metinde denetim taşmasın: sığmazsa daralır. Tablette denetim
            // doğal genişliğinde sağa yaslı (kaynak).
            Flexible(
              flex: 3,
              child: wide
                  ? Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: row.trailing,
                    )
                  : row.trailing!,
            ),
          ]),
        );
      case _RowKind.value:
        final expandable = content != null;
        final tap = expandable ? onToggle : row.onTap;
        final value = row.value;
        final chevron = expandable || row.onTap != null;
        final header = Semantics(
          container: true,
          button: tap != null,
          expanded: expandable ? expanded : null,
          label: value == null ? row.label : '${row.label}, $value',
          onTap: tap,
          excludeSemantics: true,
          child: InkWell(
            onTap: tap,
            child: line([
              // Tablet genişliğinde değer sağa yaslanır (kaynak `label 1fr · değer`); telefonda
              // önceki dağılım.
              if (wide)
                Expanded(flex: 3, child: label)
              else
                Flexible(flex: 3, child: label),
              const Gap(NizamioSpacing.gapMd),
              Expanded(
                flex: 2,
                child: value == null
                    ? const SizedBox.shrink()
                    : Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: t.bodyMd.copyWith(
                          color:
                              row.valueColor ??
                              (row.valueSet ? c.text : c.textMuted),
                        ),
                      ),
              ),
              if (chevron) ...[
                const Gap(NizamioSpacing.gapMd),
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0,
                  duration: NzMotion.of(context, _chevDuration),
                  curve: NizamioMotion.easeSpring,
                  child: NzIcon(
                    NzIcons.chevronRight,
                    size: NizamioSize.iconSizeSm,
                    color: c.textFaint,
                  ),
                ),
              ],
            ]),
          ),
        );
        if (!expandable) return header;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            header,
            NzReveal(open: expanded, child: content),
          ],
        );
    }
  }
}
