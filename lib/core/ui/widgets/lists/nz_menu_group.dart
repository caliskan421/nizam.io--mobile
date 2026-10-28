import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

/// Gruplu menü (README: çekmece grupları `m-r-group`, satır 48): `bg-raised` kart içinde
/// satırlar, aralarında 1 px `border-subtle`. Üstte isteğe bağlı mono grup adı.
class NzMenuGroup extends StatelessWidget {
  const NzMenuGroup({super.key, required this.rows, this.label});

  final List<NzMenuRow> rows;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label = this.label;
    final group = ClipRRect(
      borderRadius: BorderRadius.circular(NizamioRadius.group),
      child: ColoredBox(
        color: c.surfaceRaised,
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0)
                Divider(
                  height: NizamioSize.borderWidth,
                  thickness: NizamioSize.borderWidth,
                  color: c.border,
                ),
              rows[i],
            ],
          ],
        ),
      ),
    );
    if (label == null) return group;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space3,
          ),
          child: Semantics(
            header: true,
            child: Text(
              label,
              style: context.text.monoSm.copyWith(color: c.textMuted),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
        group,
      ],
    );
  }
}

/// Menü satırı: 16 px ikon, etiket (`m-list`), sağda isteğe bağlı rozet/öğe. [current] →
/// bulunulan sayfa (vurgu zemini, kalın, ikon `accentText`). [danger] → çıkış gibi eylemler.
class NzMenuRow extends StatelessWidget {
  const NzMenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.current = false,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool current;
  final bool danger;

  static const _currentAlpha = 0.07;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = danger ? c.danger : c.text;
    final iconColor = danger
        ? c.danger
        : current
        ? c.accentText
        : c.textMuted;
    return Semantics(
      button: true,
      selected: current,
      label: label,
      child: Material(
        color: current
            ? c.text.withValues(alpha: _currentAlpha)
            : c.surfaceRaised,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NizamioSpacing.space12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NizamioSpacing.space3,
                vertical: NizamioSpacing.space2,
              ),
              child: Row(
                children: [
                  Icon(icon, size: NizamioSize.iconSizeSm, color: iconColor),
                  const Gap(NizamioSpacing.space3),
                  Expanded(
                    child: ExcludeSemantics(
                      child: Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.list.copyWith(
                          color: fg,
                          fontWeight: current ? FontWeight.w600 : null,
                        ),
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
