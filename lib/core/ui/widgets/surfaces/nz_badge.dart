import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

enum _BadgeTone { neutral, info, success, warning, danger }

/// Durum rozeti (etiket). Tonlar isimli yapıcıdır; [leading] küçük bir simge yuvasıdır.
/// Dokunulamaz; yalnız bilgi taşır.
class NzBadge extends StatelessWidget {
  const NzBadge.neutral({
    super.key,
    required this.label,
    this.leading,
    this.size = NzSize.md,
  }) : _tone = _BadgeTone.neutral;

  const NzBadge.info({
    super.key,
    required this.label,
    this.leading,
    this.size = NzSize.md,
  }) : _tone = _BadgeTone.info;

  const NzBadge.success({
    super.key,
    required this.label,
    this.leading,
    this.size = NzSize.md,
  }) : _tone = _BadgeTone.success;

  const NzBadge.warning({
    super.key,
    required this.label,
    this.leading,
    this.size = NzSize.md,
  }) : _tone = _BadgeTone.warning;

  const NzBadge.danger({
    super.key,
    required this.label,
    this.leading,
    this.size = NzSize.md,
  }) : _tone = _BadgeTone.danger;

  final String label;

  /// Etiketin önündeki simge.
  final IconData? leading;
  final NzSize size;
  final _BadgeTone _tone;

  static const _tintAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.tone.withValues(alpha: _tintAlpha),
          border: Border.all(color: style.tone),
          borderRadius: BorderRadius.circular(NizamioRadius.radiusFull),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: style.hPad,
            vertical: style.vPad,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                Icon(leading, size: style.iconSize, color: style.tone),
                const Gap(NizamioSpacing.space1),
              ],
              Flexible(
                child: Text(
                  label,
                  style: style.textStyle.copyWith(color: style.tone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ton ve boyut görünümünün tek yeri.
  ({Color tone, TextStyle textStyle, double hPad, double vPad, double iconSize})
  _resolveStyle(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return (
      tone: switch (_tone) {
        _BadgeTone.neutral => colors.textMuted,
        _BadgeTone.info => colors.info,
        _BadgeTone.success => colors.success,
        _BadgeTone.warning => colors.warning,
        _BadgeTone.danger => colors.danger,
      },
      textStyle: size.pick(
        sm: text.caption,
        md: text.labelMd,
        lg: text.labelLg,
      ),
      hPad: size.pick(
        sm: NizamioSpacing.space2,
        md: NizamioSpacing.space3,
        lg: NizamioSpacing.space4,
      ),
      vPad: size.pick(
        sm: NizamioSpacing.space1,
        md: NizamioSpacing.space1,
        lg: NizamioSpacing.space2,
      ),
      iconSize: size.pick(
        sm: NizamioSpacing.space3,
        md: NizamioSpacing.space4,
        lg: NizamioSpacing.space5,
      ),
    );
  }
}
