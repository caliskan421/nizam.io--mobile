import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_pane.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';

/// Görev ekranlarının küçük ortak parçaları (prototip `.rp-seg`, `.rp-chipbtn`,
/// `.rp-linkbtn`, seçim satırları). Kit'e alınacak kadar genel değiller; yalnız bu feature.

/// Bölümlü seçici (prototip `.rp-seg`): `bg-raised` iz, seçili parça `bg-surface`.
class TaskSegmented extends StatelessWidget {
  const TaskSegmented({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.semanticLabel,
    this.icons,
    this.compact = false,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final String? semanticLabel;
  final List<IconData>? icons;

  /// Satır içi küçük seçici (yeni görev önceliği): 32 yükseklik.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final icons = this.icons;
    // Tablet kaynak öncelik seçimi: `bg-overlay` hap, dolgu 2, kenarsız.
    final pill = compact && _tablet(context);
    return Semantics(
      container: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: pill ? c.surfaceOverlay : c.surfaceRaised,
          borderRadius: BorderRadius.circular(
            pill ? NizamioRadius.pill : NizamioRadius.tile,
          ),
          border: pill
              ? null
              : Border.all(color: c.border, width: NizamioSize.borderWidth),
        ),
        child: Padding(
          padding: EdgeInsets.all(pill ? 2 : NizamioSpacing.space1 - 1),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              for (var i = 0; i < labels.length; i++)
                _part(context, i, c, icons == null ? null : icons[i]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _part(BuildContext context, int i, NizamioColors c, IconData? icon) {
    final pill = compact && _tablet(context);
    final on = i == selected;
    final t = context.text;
    final child = Semantics(
      button: true,
      selected: on,
      label: labels[i],
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelected(i),
        child: AnimatedContainer(
          duration: NzMotion.of(context, NizamioMotion.durPress),
          constraints: BoxConstraints(
            minHeight: pill
                ? _pillButton
                : compact
                ? NizamioSize.controlSm - 4
                : NizamioSize.tap - 4,
          ),
          padding:
              EdgeInsets.symmetric(
                horizontal: compact
                    ? NizamioSpacing.space2
                    : NizamioSpacing.space3,
              ).copyWith(
                left: pill ? NizamioSpacing.space3 : null,
                right: pill ? NizamioSpacing.space3 : null,
              ),
          decoration: BoxDecoration(
            color: on ? c.surface : c.surfaceRaised.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(
              pill
                  ? NizamioRadius.pill
                  : NizamioRadius.tile - NizamioSpacing.space1 / 2,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                NzIcon(
                  icon,
                  size: NizamioSize.iconSizeSm,
                  color: on ? c.text : c.textMuted,
                ),
                const Gap(NizamioSpacing.space1 + 2),
              ],
              Flexible(
                child: Text(
                  labels[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (pill
                              ? t.labelMd
                              : compact
                              ? t.caption
                              : t.labelMd)
                          .copyWith(
                            color: on ? c.text : c.textMuted,
                            fontWeight: on
                                ? FontWeight.w600
                                : pill
                                ? FontWeight.w400
                                : FontWeight.w500,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!compact) return Expanded(child: child);
    // Tablette kompakt seçim doğal genişliktedir (kaynak); telefonda dar satıra sığmak için
    // esner.
    return NzTabletMetrics.tabletVisualAt(MediaQuery.sizeOf(context).width)
        ? child
        : Flexible(child: child);
  }
}

/// Seçilebilir hap düğme (prototip `.rp-chipbtn`): seçili → `accent-text` kenar, `bg-overlay`.
class TaskChip extends StatelessWidget {
  const TaskChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.dot,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? dot;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final dot = this.dot;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.controlSm),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? c.surfaceOverlay : null,
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
              border: Border.all(
                color: selected ? c.accentText : c.borderStrong,
                width: NizamioSize.borderWidth,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space3,
                vertical: NizamioSpacing.space1 + 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dot != null) ...[
                    NzDot(color: dot, size: NizamioSize.statusDot),
                    const Gap(NizamioSpacing.space1 + 2),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(
                        color: c.text,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Altı çizili metin düğme (prototip `.rp-linkbtn`), 44 dokunma yüksekliği.
class TaskLink extends StatelessWidget {
  const TaskLink({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.trailing,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = this.color ?? c.textMuted;
    final trailing = this.trailing;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.tap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: context.text.caption.copyWith(
                    color: color,
                    decoration: TextDecoration.underline,
                    decorationColor: color,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Seçim satırı (prototip hızlı işlem listeleri ve filtre): etiket, isteğe bağlı mono yan
/// metin, sağda yuvarlak onay (ya da [square] kutu solda). [radio] → tek seçim anlamı.
class TaskCheckRow extends StatelessWidget {
  const TaskCheckRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.caption,
    this.captionColor,
    this.leading,
    this.count,
    this.square = false,
    this.radio = false,
    this.dimmed = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? caption;
  final Color? captionColor;
  final Widget? leading;

  /// Sağda sayı (filtre).
  final int? count;
  final bool square;
  final bool radio;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final caption = this.caption;
    final leading = this.leading;
    final count = this.count;
    final box = square
        ? AnimatedContainer(
            duration: NzMotion.of(context, NizamioMotion.durPress),
            width: NizamioSize.iconSize,
            height: NizamioSize.iconSize,
            decoration: BoxDecoration(
              color: selected ? c.primary : null,
              borderRadius: BorderRadius.circular(NizamioSpacing.space1 + 1),
              border: selected
                  ? null
                  : Border.all(
                      color: c.borderControl,
                      width: NizamioSize.borderWidth + 0.5,
                    ),
            ),
            child: selected
                ? NzIcon(
                    Icons.check_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.onPrimary,
                  )
                : null,
          )
        : AnimatedContainer(
            duration: NzMotion.of(context, NizamioMotion.durPress),
            width: NizamioSize.iconSize,
            height: NizamioSize.iconSize,
            decoration: BoxDecoration(
              color: selected ? c.primary : null,
              shape: BoxShape.circle,
              border: selected
                  ? null
                  : Border.all(
                      color: c.borderControl,
                      width: NizamioSize.borderWidth + 0.5,
                    ),
            ),
            child: selected
                ? NzIcon(
                    Icons.check_rounded,
                    size: NizamioSize.iconSizeSm - 2,
                    color: c.onPrimary,
                  )
                : null,
          );
    return Semantics(
      container: true,
      checked: radio ? null : selected,
      inMutuallyExclusiveGroup: radio ? true : null,
      selected: radio ? selected : null,
      button: true,
      label: [label, ?caption, if (count != null) '$count'].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: dimmed ? 0.45 : 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NizamioSize.controlMd + 4,
            ),
            child: Row(
              children: [
                if (square) ...[box, const Gap(NizamioSpacing.space3)],
                if (leading != null) ...[
                  leading,
                  const Gap(NizamioSpacing.space3),
                ],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMd.copyWith(
                      fontWeight: selected && !square
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (caption != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Text(
                    caption,
                    style: t.monoSm.copyWith(
                      color: captionColor ?? c.textFaint,
                    ),
                  ),
                ],
                if (count != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Text('$count', style: t.monoSm.copyWith(color: c.textMuted)),
                ],
                if (!square) ...[const Gap(NizamioSpacing.space3), box],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Form hata satırı (prototip `.t-hint--error`, `role=alert`).
class TaskFormError extends StatelessWidget {
  const TaskFormError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Text(
      message,
      style: context.text.caption.copyWith(color: context.colors.danger),
    ),
  );
}

/// Etiketli alan başlığı (prototip `.t-label`).
class TaskFieldLabel extends StatelessWidget {
  const TaskFieldLabel(this.label, {super.key, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
    child: Row(
      children: [
        Flexible(
          child: Text(
            label,
            style: context.text.labelMd.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ),
        if (trailing case final w?) ...[const Gap(NizamioSpacing.space2), w],
      ],
    ),
  );
}

/// Tarih alanı: dokununca tarih seçici açılır (prototip `input type=date`).
class TaskDateField extends StatelessWidget {
  const TaskDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.placeholder = '—',
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final value = this.value;
    final text = value == null
        ? placeholder
        : MaterialLocalizations.of(context).formatCompactDate(value);
    return Semantics(
      button: true,
      label: '$label, $text',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        onTap: () async {
          final now = value ?? DateTime.now();
          final first = firstDate ?? DateTime(now.year - 2);
          final picked = await showDatePicker(
            context: context,
            initialDate: now.isBefore(first) ? first : now,
            firstDate: first,
            lastDate: DateTime(now.year + 3),
          );
          if (picked != null) onChanged(picked);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.controlMd),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.tile),
              border: Border.all(
                color: c.borderControl,
                width: NizamioSize.borderWidth,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space3,
                vertical: NizamioSpacing.space2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: t.mono.copyWith(
                        color: value == null ? c.textFaint : c.text,
                      ),
                    ),
                  ),
                  NzIcon(
                    Icons.calendar_today_outlined,
                    size: NizamioSize.iconSizeSm,
                    color: c.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alt sayfa "Vazgeç / ana eylem" düğme çifti.
List<Widget> sheetActions(
  BuildContext sheet, {
  required String cancel,
  required String ok,
  required VoidCallback onOk,
  bool danger = false,
}) => [
  NzButton.secondary(
    label: cancel,
    expand: true,
    onPressed: () => Navigator.of(sheet).maybePop(),
  ),
  if (danger)
    NzButton.danger(label: ok, expand: true, onPressed: onOk)
  else
    NzButton.primary(label: ok, expand: true, onPressed: onOk),
];

/// Tablet kaynak öncelik düğmesi yüksekliği (30).
const _pillButton = 30.0;

bool _tablet(BuildContext context) =>
    NzTabletMetrics.tabletVisualAt(MediaQuery.sizeOf(context).width);
