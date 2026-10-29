import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';

/// Boş liste/sonuç. Feature'a özgü isimli yapıcı core'da yoktur; feature kendi metniyle çağırır.
class NzEmptyState extends StatelessWidget {
  const NzEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel ve onAction birlikte verilir',
       );

  final String title;
  final String? message;

  /// null → nötr "boş kutu" simgesi.
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: NzIcon(
                icon ?? Icons.inbox_outlined,
                size: NizamioSpacing.space12,
                color: colors.textMuted,
              ),
            ),
            const Gap(NizamioSpacing.space4),
            Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: text.titleSm,
              ),
            ),
            if (message != null) ...[
              const Gap(NizamioSpacing.space2),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: text.bodyMd.copyWith(color: colors.textMuted),
              ),
            ],
            if (onAction != null) ...[
              const Gap(NizamioSpacing.space6),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
