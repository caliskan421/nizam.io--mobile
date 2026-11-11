import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import 'nz_check_circle.dart';

/// Filtrelerde ortak, sayılı çoklu seçim satırı.
class NzFilterChoice extends StatelessWidget {
  const NzFilterChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });
  final String label;
  final String? count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NizamioSpacing.space3,
        vertical: NizamioSpacing.space2,
      ),
      child: Row(
        children: [
          NzCheckCircle(value: selected, label: label, onChanged: onTap),
          const Gap(NizamioSpacing.space2),
          Expanded(child: Text(label, style: context.text.list)),
          if (count != null)
            Text(
              count!,
              style: context.text.monoSm.copyWith(
                color: context.colors.textMuted,
              ),
            ),
        ],
      ),
    ),
  );
}

class NzFilterChoices extends StatelessWidget {
  const NzFilterChoices({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      NizamioSpacing.gapMd,
      0,
      NizamioSpacing.gapMd,
      NizamioSpacing.gapMd,
    ),
    child: Column(children: children),
  );
}
