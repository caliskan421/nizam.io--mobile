import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../nz_size.dart';

/// Açma/kapama anahtarı satırı: satırın tamamı dokunma alanıdır (en az 48), etiket anahtarla
/// birlikte tek düğümde okunur (açık/kapalı durumu ile). Görsel anahtar [NzToggle] (tasarım
/// `Switch`). Denetimli bileşendir ([value] çağıranındır).
class NzSwitch extends StatelessWidget {
  const NzSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.leading,
    this.size = NzSize.md,
  });

  final String label;
  final bool value;

  /// `null` → devre dışı.
  final ValueChanged<bool>? onChanged;
  final String? description;

  /// Satırın başında (ör. simge).
  final Widget? leading;
  final NzSize size;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final description = this.description;
    final leading = this.leading;
    final tap = enabled ? () => onChanged(!value) : null;
    return Semantics(
      container: true,
      toggled: value,
      enabled: enabled,
      label: description == null ? label : '$label\n$description',
      onTap: tap,
      excludeSemantics: true,
      child: InkWell(
        onTap: tap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSpacing.space12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space1,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading,
                  const Gap(NizamioSpacing.space4),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: _resolveStyle(context, size)),
                      if (description != null)
                        Text(
                          description,
                          style: context.text.bodySm.copyWith(
                            color: context.colors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                const Gap(NizamioSpacing.space3),
                NzToggle(value: value, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Yalnız görsel anahtar (tasarım `Switch`, bundle.css `.m-switch`): 50×30 hap; açıkken `accent`
/// ray, kapalıyken `bg-overlay`; 24 px beyaz baş (`switch-knob`, `m-sh-knob`) `easeSpring` ile
/// kayar. Dokunma alanı en az 48. [semanticLabel] verilmezse okuyucudan gizlenir (etiket
/// satırda; ör. `NzSwitch`, `NzFormRow.toggle`).
class NzToggle extends StatelessWidget {
  const NzToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;

  /// `null` → devre dışı.
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  // `.m-switch` geometrisi: 50×30 ray, 24 baş, 3 px pay; tasarım token'ı yok.
  static const width = 50.0;
  static const height = 30.0;
  static const _knob = 24.0;
  static const _pad = 3.0;
  static const _disabledAlpha = 0.38;
  static const _knobDuration = Duration(milliseconds: 380);
  static const _fillDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final track = AnimatedContainer(
      duration: NzMotion.of(context, _fillDuration),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: value ? c.primary : c.surfaceOverlay,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: AnimatedAlign(
        duration: NzMotion.of(context, _knobDuration),
        curve: NizamioMotion.easeSpring,
        alignment: value
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.all(_pad),
          child: SizedBox.square(
            dimension: _knob,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.switchKnob,
                shape: BoxShape.circle,
                boxShadow: context.shadows.knob,
              ),
            ),
          ),
        ),
      ),
    );
    final Widget body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => onChanged(!value) : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: NizamioSpacing.space12,
          minHeight: NizamioSpacing.space12,
        ),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Opacity(opacity: enabled ? 1 : _disabledAlpha, child: track),
        ),
      ),
    );
    final label = semanticLabel;
    if (label == null) return ExcludeSemantics(child: body);
    return Semantics(
      container: true,
      toggled: value,
      enabled: enabled,
      label: label,
      onTap: enabled ? () => onChanged(!value) : null,
      excludeSemantics: true,
      child: body,
    );
  }
}

/// Boyuta göre etiket yazı rolü (tek görünüm fark noktası).
TextStyle _resolveStyle(BuildContext context, NzSize size) => size.pick(
  sm: context.text.bodySm,
  md: context.text.bodyMd,
  lg: context.text.bodyLg,
);
