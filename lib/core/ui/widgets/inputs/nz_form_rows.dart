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

enum _RowKind { value, toggle, custom, input }

/// [NzFormRows] satırı (veri). Tek düzen kuralı: etiket SOLDA (doğal genişliğinde, satırın en
/// çok [NzFormRows.labelMaxFraction]'ı), değer/denetim SAĞDA tek satır. Dört biçim:
/// - varsayılan: etiket + sağda değer + chevron; [content] verilirse dokununca satırın altında
///   yerinde açılır (chevron 90° döner), yoksa [onTap] (ör. seçici açar). Uzun değer `…` ile
///   kısalır; seçim yokken yer tutucu ([valueSet] false) soluk görünür;
/// - [NzFormRow.toggle]: sağda anahtar ([NzToggle]); satırın tamamı dokunma alanı;
/// - [NzFormRow.custom]: sağda serbest denetim ([trailing], ör. öncelik seçici);
/// - [NzFormRow.input]: sağda çerçevesiz serbest metin girdisi (ör. davet e-postası); yer
///   tutucu soluk ve sağa yaslı, satırın tamamına dokunmak girdiye odaklanır.
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
       controller = null,
       hint = null,
       onChanged = null,
       keyboardType = null,
       autofillHints = null,
       maxLength = null,
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
       controller = null,
       hint = null,
       onChanged = null,
       keyboardType = null,
       autofillHints = null,
       maxLength = null,
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
       controller = null,
       hint = null,
       onChanged = null,
       keyboardType = null,
       autofillHints = null,
       maxLength = null,
       _kind = _RowKind.custom;

  /// Serbest metin satırı: [controller] çağıranındır (taslaktan doldurma/sıfırlama orada).
  /// E-posta klavyesinde otomatik düzeltme ve büyük harf kapalıdır.
  const NzFormRow.input({
    required this.label,
    required TextEditingController this.controller,
    this.hint,
    this.onChanged,
    this.keyboardType,
    this.autofillHints,
    this.maxLength,
    this.icon,
    this.leading,
  }) : toggleValue = null,
       onToggle = null,
       value = null,
       valueSet = false,
       valueColor = null,
       content = null,
       onTap = null,
       trailing = null,
       _kind = _RowKind.input;

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

  /// [NzFormRow.input] girdisi.
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final int? maxLength;
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

  /// Etiketin satır içeriğinden (simge hariç) alabileceği en büyük pay: etiket doğal
  /// genişliğindedir, sığmazsa bu payda sarar; değer kalan genişliği alır.
  static const labelMaxFraction = 0.55;

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
            child: _RowLine(
              row: row,
              children: (label) => [
                Expanded(child: label),
                const Gap(NizamioSpacing.space3),
                NzToggle(value: value, onChanged: onChanged),
              ],
            ),
          ),
        );
      case _RowKind.custom:
        return MergeSemantics(
          child: _RowLine(
            row: row,
            children: (label) => [
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
            ],
          ),
        );
      case _RowKind.input:
        return _InputRow(row: row);
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
            // Etiket solda doğal genişliğinde; değer kalan genişlikte sağa yaslı, tek satır.
            child: _RowLine(
              row: row,
              children: (label) => [
                label,
                const Gap(NizamioSpacing.gapMd),
                Expanded(
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
              ],
            ),
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

/// Satır iskeleti (tüm biçimler için tek kap): en az `m-row` 52 yükseklik, `rowPad` yatay
/// iç boşluk, isteğe bağlı solda simge. [children] etiket parçasını alır; etiket satır
/// içeriğinin en çok [NzFormRows.labelMaxFraction]'ı kadar genişler, sığmazsa iki satıra sarar.
class _RowLine extends StatelessWidget {
  const _RowLine({required this.row, required this.children});

  final NzFormRow row;
  final List<Widget> Function(Widget label) children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final icon = row.icon;
    final leading =
        row.leading ??
        (icon == null
            ? null
            : NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.textMuted));
    return ConstrainedBox(
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
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) => Row(
                  children: children(
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: box.maxWidth * NzFormRows.labelMaxFraction,
                      ),
                      child: Text(
                        row.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodyMd,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [NzFormRow.input]: etiket solda, çerçevesiz girdi sağda (sağa yaslı metin). Satıra dokunmak
/// girdiye odaklanır; okuyucuda etiket ile girdi tek düğümdür.
class _InputRow extends StatefulWidget {
  const _InputRow({required this.row});

  final NzFormRow row;

  @override
  State<_InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<_InputRow> {
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final row = widget.row;
    final email = row.keyboardType == TextInputType.emailAddress;
    const none = InputBorder.none;
    return MergeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _focus.requestFocus,
        child: _RowLine(
          row: row,
          children: (label) => [
            label,
            const Gap(NizamioSpacing.gapMd),
            Expanded(
              child: TextField(
                controller: row.controller,
                focusNode: _focus,
                onChanged: row.onChanged,
                keyboardType: row.keyboardType,
                autofillHints: row.autofillHints,
                autocorrect: !email,
                enableSuggestions: !email,
                textCapitalization: email
                    ? TextCapitalization.none
                    : TextCapitalization.sentences,
                maxLength: row.maxLength,
                textAlign: TextAlign.end,
                style: t.bodyMd.copyWith(color: c.text),
                decoration: InputDecoration(
                  hintText: row.hint,
                  hintStyle: t.bodyMd.copyWith(color: c.textMuted),
                  hintMaxLines: 1,
                  filled: false,
                  isDense: true,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: NizamioSpacing.space2,
                  ),
                  border: none,
                  enabledBorder: none,
                  focusedBorder: none,
                  disabledBorder: none,
                  errorBorder: none,
                  focusedErrorBorder: none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
