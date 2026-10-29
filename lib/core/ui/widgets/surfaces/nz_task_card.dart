import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../feedback/nz_progress_bar.dart';
import 'nz_avatar.dart';
import 'nz_avatar_stack.dart';
import 'nz_card.dart';
import 'nz_status_label.dart';

/// Kartın tarih/öncelik döşemesindeki bir hücre: küçük harfli mono [caption] (ör. "bitiş") ve
/// mono [value] (ör. "15.07.2026"). [overdue] → değer `danger`.
@immutable
class NzTaskCardDate {
  const NzTaskCardDate({
    required this.caption,
    required this.value,
    this.overdue = false,
  });

  final String caption;
  final String value;
  final bool overdue;
}

/// Görev kartı (tasarım `TaskCard`, bundle.css `.m-taskcard`; prototip Görevler listesi).
/// Tamamen veri parametrelidir — hangi görevin gecikmiş/öncelikli olduğu ekranın kararıdır.
///
/// Üst satır: mono [code] + [group] (caption, kesilir) + sağda durum ([statusLabel] +
/// [statusTone]). Başlık `m-card-title` en çok 2 satır. İç döşeme (`bg-raised`, köşe 12):
/// [start], [end] (geçmişse `danger`), sağda öncelik ([priorityCaption] + çubuk + [priority]).
/// İsteğe bağlı alt görev çubuğu ([subtaskProgress] 0–1 + [subtaskText] "2/3 alt görev").
/// Alt satır: avatar yığını ([assignees]) + [assigneeText] + sağda rozet ([badge],
/// [badgeTone]; ör. "98 gün gecikti"). Kart `NzCard.outlined`, iç boşluk `m-card-pad`, basınca
/// `.985`. Okuyucu etiketi [semanticLabel] (verilmezse görünen metinler).
class NzTaskCard extends StatelessWidget {
  const NzTaskCard({
    super.key,
    required this.code,
    required this.title,
    required this.statusLabel,
    required this.statusTone,
    this.group,
    this.start,
    this.end,
    this.priorityCaption,
    this.priority,
    this.priorityLevel = 0,
    this.subtaskProgress,
    this.subtaskText,
    this.assignees = const [],
    this.assigneeText,
    this.badge,
    this.badgeTone = NzTone.danger,
    this.onTap,
    this.semanticLabel,
    this.trailing = const [],
  });

  final String code;
  final String? group;
  final String title;
  final String statusLabel;
  final NzTone statusTone;
  final NzTaskCardDate? start;
  final NzTaskCardDate? end;
  final String? priorityCaption;
  final String? priority;

  /// 0–3 dolu çubuk ([NzPriorityBars]).
  final int priorityLevel;
  final double? subtaskProgress;
  final String? subtaskText;
  final List<String> assignees;
  final String? assigneeText;
  final String? badge;
  final NzTone badgeTone;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Alt satırda rozetin ardından ek işaretler (ör. ikinci rozet, dosya/not sayaçları).
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final group = this.group;
    final priority = this.priority;
    final subtaskProgress = this.subtaskProgress;
    final subtaskText = this.subtaskText;
    final assigneeText = this.assigneeText;
    final badge = this.badge;
    final hasTile = start != null || end != null || priority != null;
    final hasFoot =
        assignees.isNotEmpty ||
        assigneeText != null ||
        badge != null ||
        trailing.isNotEmpty;

    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.cardPad),
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NizamioSpacing.space3,
        children: [
          Row(
            children: [
              Text(code, style: _mono12(context, c.textMuted)),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: group == null
                    ? const SizedBox.shrink()
                    : Text(
                        group,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.caption.copyWith(color: c.textMuted),
                      ),
              ),
              const Gap(NizamioSpacing.space2),
              Flexible(
                child: NzStatusLabel(label: statusLabel, tone: statusTone),
              ),
            ],
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.labelLg,
          ),
          if (hasTile)
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceRaised,
                borderRadius: BorderRadius.circular(NizamioRadius.tile),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.space3,
                  vertical: NizamioSpacing.gapMd,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (start case final s?) ...[
                      // Tarih tam görünmeli (dd.MM.yyyy); öncelik sütunu daralır.
                      Flexible(flex: 3, child: _DateCell(date: s)),
                      const Gap(NizamioSpacing.space5),
                    ],
                    if (end case final e?)
                      Flexible(flex: 3, child: _DateCell(date: e)),
                    const Spacer(),
                    if (priority != null)
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (priorityCaption case final pc?)
                              Text(pc, style: _caption(context)),
                            const Gap(NizamioSpacing.space1 / 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                NzPriorityBars(level: priorityLevel),
                                const Gap(
                                  NizamioSpacing.space1 +
                                      NizamioSpacing.space1 / 2,
                                ),
                                Flexible(
                                  child: Text(
                                    priority,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.caption.copyWith(
                                      color: c.textMuted,
                                    ),
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
            ),
          if (subtaskProgress != null)
            Row(
              children: [
                Expanded(
                  child: NzProgressBar(
                    value: subtaskProgress,
                    color: c.accentText,
                  ),
                ),
                if (subtaskText != null) ...[
                  const Gap(NizamioSpacing.gapMd),
                  Text(subtaskText, style: _mono12(context, c.textMuted)),
                ],
              ],
            ),
          if (hasFoot)
            Row(
              children: [
                if (assignees.isNotEmpty) ...[
                  NzAvatarStack(names: assignees, extent: NzAvatarSize.sm),
                  const Gap(NizamioSpacing.gapMd),
                ],
                Expanded(
                  child: assigneeText == null
                      ? const SizedBox.shrink()
                      : Text(
                          assigneeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                ),
                if (badge != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Flexible(
                    child: NzStatusLabel.badge(label: badge, tone: badgeTone),
                  ),
                ],
                for (final w in trailing) ...[
                  const Gap(NizamioSpacing.space2),
                  Flexible(child: w),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

/// Mono 12/16 (prototip kod, tarih, alt görev sayacı): `m-kicker` ailesi/ölçüsü, harf aralığı 0.
TextStyle _mono12(BuildContext context, Color color) =>
    context.text.kicker.copyWith(letterSpacing: 0, color: color);

/// Döşeme etiketi (`.m-taskcard__dates dt`: mono 10/13 500 → `program` rolü + 500).
TextStyle _caption(BuildContext context) => context.text.program.copyWith(
  color: context.colors.textMuted,
  fontWeight: FontWeight.w500,
);

class _DateCell extends StatelessWidget {
  const _DateCell({required this.date});

  final NzTaskCardDate date;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date.caption, style: _caption(context)),
        const Gap(NizamioSpacing.space1 / 2),
        Text(
          date.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _mono12(context, date.overdue ? c.danger : c.text),
        ),
      ],
    );
  }
}

/// Öncelik çubukları (bundle.css `.m-prio__bars`): 3 dikey çubuk (5/8/12 yükseklik, 3 genişlik,
/// arası 2); ilk [level] tanesi `ink`, diğerleri `border-strong`. Görseldir; öncelik kelimesi
/// yanında yazılır.
class NzPriorityBars extends StatelessWidget {
  const NzPriorityBars({super.key, required this.level});

  final int level;

  // `.m-prio__bars` geometrisi (token'ı yok).
  static const _heights = [5.0, 8.0, 12.0];
  static const _barWidth = 3.0;
  static const _gap = 2.0;
  static const _barRadius = Radius.circular(1);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: SizedBox(
        height: _heights.last,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: _gap,
          children: [
            for (var i = 0; i < _heights.length; i++)
              SizedBox(
                width: _barWidth,
                height: _heights[i],
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: i < level ? c.text : c.borderStrong,
                    borderRadius: const BorderRadius.all(_barRadius),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
