import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator_sections.dart';
import 'home_texts.dart';

/// Odak kartı "sıradaki işin" (tasarım §4.1-2): kicker + koordinatörlük kodu, başlık (dokununca
/// ayrıntı), bitiş rozeti + "Bitiş 15 Kas · Yüksek öncelik", alt görev ilerlemesi; eylemler
/// "Kanıt yükle" (ayrıntıyı açar) ve duruma göre "Başla" (başlamadı) ya da "Tamamlandı bildir"
/// (devam). Düğme yalnız aktörün matrisinde hedef varsa çizilir (K5: başlamadıda onaya sunma
/// yok). [task] null → boş metin.
class HomeMemberFocusCard extends ConsumerWidget {
  const HomeMemberFocusCard({
    super.key,
    required this.task,
    required this.today,
    this.code,
  });

  final TaskItem? task;
  final DateTime today;

  /// Koordinatörlük kısa adı (mono, sağ üst).
  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final task = this.task;
    final kicker = NzKicker(l.uiHomeMemberFocusKicker, trailing: code);
    if (task == null) {
      return NzCard.filled(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            kicker,
            const Gap(NizamioSpacing.space2),
            Text(
              l.uiHomeMemberFocusEmpty,
              style: t.bodyMd.copyWith(color: c.textMuted),
            ),
          ],
        ),
      );
    }
    final nav = context.appNav;
    final flows = TaskDecisionFlows(context, ref, task.code);
    final perms = TaskPermissions.of(
      ref.watch(effectiveAccessProvider).viewAccess,
      task,
    );
    void open() => nav.openTask(task.code);
    final subs = task.subtaskTotal;
    final Widget? second = switch (MemberStep.of(task)) {
      MemberStep.start when canStartTask(perms, task) => NzButton.secondary(
        label: l.uiTasksBandStart,
        expand: true,
        onPressed: flows.start,
      ),
      MemberStep.submit when canSubmitTask(perms, task) => NzButton.secondary(
        label: l.uiTasksSubmitTitle,
        expand: true,
        onPressed: () => flows.submit(onUpload: open),
      ),
      _ => null,
    };
    return NzCard.filled(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          kicker,
          const Gap(NizamioSpacing.space2),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: open,
            child: Text(
              task.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.titleSm,
            ),
          ),
          const Gap(NizamioSpacing.space3),
          Wrap(
            spacing: NizamioSpacing.space2,
            runSpacing: NizamioSpacing.space1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              memberDueBadge(l, task, today),
              Text(
                '${l.uiTasksCmpEnd} ${DateFormat('d MMM', 'tr').format(task.due)}'
                ' · ${_priority(l, task.priority)} ${l.uiHomeMemberPriorityTail}',
                style: t.caption.copyWith(color: c.textMuted),
              ),
            ],
          ),
          if (subs > 0) ...[
            const Gap(NizamioSpacing.space3),
            NzProgressBar(
              value: task.subtaskDoneTotal / subs,
              color: c.taskDone,
            ),
            const Gap(NizamioSpacing.space1),
            Text(
              '${task.subtaskDoneTotal}/$subs ${l.uiTasksSubtasksTail}',
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ],
          const Gap(NizamioSpacing.space4),
          Row(
            children: [
              Expanded(
                child: NzButton.primary(
                  label: l.uiHomeMemberEvidence,
                  expand: true,
                  onPressed: open,
                ),
              ),
              if (second != null) ...[
                const Gap(NizamioSpacing.space2),
                Expanded(child: second),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// İade kartı: kicker "iade edildi" + kod, başlık, koordinatörün son notu (oturumdaki kişinin
/// yazmadığı en yeni not; yoksa blok gizli — B1), yazar · tarih ve "Düzelt" (ayrıntıyı açar).
/// Notlar ayrıntıdan okunur ([taskDetailsProvider]).
class HomeMemberReturnedCard extends ConsumerWidget {
  const HomeMemberReturnedCard({super.key, required this.task, this.code});

  final TaskItem task;
  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    ref.watch(taskDetailsProvider(task.code));
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final notes = catalog?.task(task.code)?.noteEntries ?? const <TaskNote>[];
    final why = catalog == null ? null : lastNote(notes, me: catalog.me);
    final author = why == null
        ? null
        : catalog?.nameOf(why.by) ?? l.uiTasksUnknownPerson;
    return NzCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              NzDot(color: c.danger),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Text(
                  l.uiHomeMemberReturnedKicker,
                  style: t.caption.copyWith(color: c.danger),
                ),
              ),
              if (code case final code?)
                Text(code, style: t.mono.copyWith(color: c.textMuted)),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.titleSm,
          ),
          if (why != null) ...[
            const Gap(NizamioSpacing.space3),
            NzCard.filled(
              size: NzSize.sm,
              child: Text(why.text, maxLines: 4, style: t.bodySm),
            ),
          ],
          const Gap(NizamioSpacing.space3),
          Row(
            children: [
              if (why != null && author != null) ...[
                NzAvatar.initials(name: author, size: NzSize.sm),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: Text(
                    '$author · ${DateFormat('d MMM', 'tr').format(why.at.toLocal())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ] else
                const Spacer(),
              NzButton.secondary(
                label: l.uiHomeMemberFix,
                onPressed: () => context.appNav.openTask(task.code),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Üye özet kutuları (yönetici/koordinatör ana sayfasının dili): gecikme, onayda, iade,
/// tamamlanma (yüzde); her biri görev listesini ilgili görünümle açar.
List<Widget> homeMemberKpis(
  BuildContext context, {
  required CoordinatorSummary stats,
  bool truncated = false,
}) {
  final l = context.l10n;
  final c = context.colors;
  final nav = context.appNav;
  final more = truncated ? '≥' : '';
  final open = stats.total - stats.done;
  double ratio(int a, int b) => b == 0 ? 0 : a / b;
  Widget tile(
    NzGlyph glyph,
    Color tone,
    String label,
    String value,
    double progress,
    NzTaskView view, {
    bool danger = false,
  }) => NzKpiTile(
    glyph: glyph,
    tone: tone,
    label: label,
    value: value,
    valueColor: danger ? c.danger : null,
    progress: progress,
    onTap: () => nav.openTasks(view: view),
    semanticLabel: '$label: $value. ${l.uiHomeOpenList}',
  );
  return [
    tile(
      NzGlyphs.late,
      c.danger,
      l.uiHomeKpiLate,
      '$more${stats.late}',
      ratio(stats.late, open),
      NzTaskView.late,
      danger: true,
    ),
    tile(
      NzGlyphs.review,
      c.warning,
      l.uiHomeKpiReview,
      '$more${stats.review}',
      ratio(stats.review, open),
      NzTaskView.review,
    ),
    tile(
      NzGlyphs.returned,
      c.danger,
      l.uiTasksViewReturned,
      '$more${stats.returned}',
      ratio(stats.returned, open),
      NzTaskView.returned,
    ),
    tile(
      NzGlyphs.done,
      c.taskDone,
      l.uiHomeKpiDone,
      l.percent(ratio(stats.done, stats.total)),
      ratio(stats.done, stats.total),
      NzTaskView.done,
    ),
  ];
}

/// Görevlerim satırı: durum noktası, başlık, "KOD · durum · Bitiş 15 Kas", sağda gecikme.
class HomeMemberTaskRow extends StatelessWidget {
  const HomeMemberTaskRow({super.key, required this.task, this.code});

  final TaskItem task;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final late = isTaskLate(task);
    final days = task.lateness?.daysOverdue ?? task.overdueDays;
    return _Row(
      onTap: () => context.appNav.openTask(task.code),
      leading: NzDot(color: statusTone(task.status).color(c)),
      title: task.title,
      meta: [
        ?code,
        _status(l, task.status),
        '${l.uiTasksCmpEnd} ${DateFormat('d MMM', 'tr').format(task.due)}',
      ].join(' · '),
      trailing: late
          ? Text(
              '$days ${l.uiTasksDaysLc}',
              style: t.bodySm.copyWith(color: c.danger),
            )
          : null,
    );
  }
}

/// Yaklaşanlar: kendi görevinin son tarihi (tarih kutusu "Per 14" / "son", başlık, etiket).
class HomeMemberDueRow extends StatelessWidget {
  const HomeMemberDueRow({
    super.key,
    required this.task,
    required this.today,
    this.code,
  });

  final TaskItem task;
  final DateTime today;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final isToday = DateUtils.isSameDay(task.due, today);
    return _Row(
      onTap: () => context.appNav.openTask(task.code),
      leading: HomeDateBox(
        top: isToday
            ? l.uiMeetingsGroupToday
            : DateFormat('EEE d', 'tr').format(task.due),
        bottom: code ?? '',
        highlight: isToday,
      ),
      title: task.title,
      meta: l.uiHomeMemberTagDue,
      metaColor: c.inProgress,
    );
  }
}

/// Bitiş rozeti: gecikmede "n gün gecikti" (tehlike), bugün "Bugün bitiyor" (uyarı), ileride
/// "n gün kaldı".
Widget memberDueBadge(AppLocalizations l, TaskItem task, DateTime today) {
  if (isTaskLate(task)) {
    final n = task.lateness?.daysOverdue ?? task.overdueDays;
    return NzBadge.danger(label: '$n ${l.uiTasksLateTail}');
  }
  final left = DateUtils.dateOnly(task.due)
      .difference(DateUtils.dateOnly(today))
      .inDays;
  return left <= 0
      ? NzBadge.warning(label: l.uiHomeMemberDueToday)
      : NzBadge.neutral(label: '$left ${l.uiTasksDaysLeftTail}');
}

String _status(AppLocalizations l, TaskStatus s) => switch (s) {
  TaskStatus.todo || TaskStatus.unknown => l.uiTasksStatusTodo,
  TaskStatus.inProgress => l.uiTasksStatusDoing,
  TaskStatus.review => l.uiTasksStatusReview,
  TaskStatus.returned => l.uiTasksStatusReturned,
  TaskStatus.done => l.uiTasksStatusDone,
};

String _priority(AppLocalizations l, TaskPriority p) => switch (p) {
  TaskPriority.high || TaskPriority.urgent => l.uiTasksPrioHigh,
  TaskPriority.low => l.uiTasksPrioLow,
  TaskPriority.medium || TaskPriority.unknown => l.uiTasksPrioMedium,
};

/// Tablo kartı satırı (dolgu kendinde; dokunma alanı en az 48).
class _Row extends StatelessWidget {
  const _Row({
    required this.onTap,
    required this.leading,
    required this.title,
    required this.meta,
    this.metaColor,
    this.trailing,
  });

  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String meta;
  final Color? metaColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final trailing = this.trailing;
    return Semantics(
      button: true,
      // Basma vurgusu yok; geri bildirim küçülmedir.
      child: NzPressable.card(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space4),
            child: Row(
              children: [
                leading,
                const Gap(NizamioSpacing.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyLg.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const Gap(NizamioSpacing.space1),
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySm.copyWith(
                          color: metaColor ?? c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const Gap(NizamioSpacing.space2),
                  trailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
