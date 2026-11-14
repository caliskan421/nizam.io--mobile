import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../domain/activity_log.dart';
import 'activity_action_label.dart';
import 'activity_texts.dart';

/// İşlem geçmişi satırı: yapan (baş harf), eylem adı + saat, ayrıntı, tür rozeti, kişi · hedef.
/// [onTap] verilirse (hedef görev) satır görevi açar.
class ActivityEntryRow extends StatelessWidget {
  const ActivityEntryRow({
    super.key,
    required this.entry,
    required this.divided,
    required this.onTap,
  });

  final ActivityEntry entry;
  final bool divided;

  /// Hedef görevse görevi açar; değilse satır dokunulmaz.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = entry;
    final who = [e.actorName, e.target].where((s) => s.isNotEmpty).join(' · ');
    final kind = l.activityKindLabel(e.kind);
    final row = DecoratedBox(
      decoration: BoxDecoration(
        border: divided
            ? Border(
                bottom: BorderSide(
                  color: c.border,
                  width: NizamioSize.borderWidth,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NzAvatar.initials(
              name: e.actorName,
              tone: NzAvatar.neutralTone,
              extent: NzAvatarSize.md,
            ),
            const Gap(NizamioSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: NizamioSpacing.space1 / 2,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l.activityAction(e),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Gap(NizamioSpacing.space3),
                      Text(
                        l.activityTime(e.at),
                        style: t.monoSm.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                  if (e.detail.isNotEmpty)
                    Text(
                      e.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  const Gap(NizamioSpacing.space1 / 2),
                  Row(
                    children: [
                      NzStatusLabel.badge(
                        label: kind,
                        tone: activityTone(e.kind),
                      ),
                      const Gap(NizamioSpacing.space2),
                      Expanded(
                        child: Text(
                          who,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    final label = [
      l.activityAction(e),
      l.activityTime(e.at),
      if (e.detail.isNotEmpty) e.detail,
      kind,
      who,
    ].join('. ');
    final tap = onTap;
    if (tap == null) {
      return Semantics(label: label, excludeSemantics: true, child: row);
    }
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: tap,
      child: InkWell(onTap: tap, child: row),
    );
  }
}
