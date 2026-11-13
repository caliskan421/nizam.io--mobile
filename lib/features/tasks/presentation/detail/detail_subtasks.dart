import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/domain/person_name.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/motion/nz_check_motion.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_detail_controller.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'detail_actions.dart';

/// Alt görev sekmesi: ipucu, ilerleme (genişliği .35 sn'de güncellenir), tek kart içinde
/// çizgiyle ayrılmış alt görev satırları ve ekleme. İşaret hareketi toplantı gündemiyle aynıdır
/// ([NzCheckHold], [NzStrikeText], [NzFlipSlot]): işaret anında görünür (iyimser; sunucu yanıtı
/// gelene dek), madde 360 ms yerinde kalıp tamamlananların arasına kayar; işaret kaldırma
/// beklemesiz açıklardaki yerine döner. Sıra: açıklar, sonra tamamlananlar (sunucu sırasıyla;
/// alt görevde tamamlanma anı yoktur).
class DetailSubtasks extends ConsumerStatefulWidget {
  const DetailSubtasks({
    super.key,
    required this.task,
    required this.catalog,
    required this.actions,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final TaskDetailActions actions;

  @override
  ConsumerState<DetailSubtasks> createState() => _DetailSubtasksState();
}

class _DetailSubtasksState extends ConsumerState<DetailSubtasks> {
  late final _hold = NzCheckHold(() {
    if (mounted) setState(() {});
  });

  /// Yazması uçuştaki işaretler: görünen durum sunucununkinin tersidir.
  final _pending = <String>{};

  /// FLIP ölçüm kabı.
  final _area = GlobalKey();

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  bool _done(Subtask u) => u.done != _pending.contains(u.id);

  Future<void> _toggle(Subtask u) async {
    // Uçuştaki işarete ikinci dokunuş beklenir (çift yazma yok).
    if (_pending.contains(u.id)) return;
    final was = _done(u);
    setState(() {
      _pending.add(u.id);
      _hold.toggle(u.id, wasDone: was, reduced: NzMotion.reduced(context));
    });
    await widget.actions.toggleSubtask(u.id);
    if (mounted) setState(() => _pending.remove(u.id));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final task = widget.task;
    final catalog = widget.catalog;
    final p = taskDetailControllerProvider(task.code);
    final ctl = ref.read(p.notifier);
    final openSubs = ref.watch(p.select((s) => s.openSubtasks));
    final subs = task.subtasks;
    final done = subs.where(_done).length;
    final perms = ctl.permissions;
    final manage = perms.canManageSubtasks;
    // Alt görev adayı ana görevin atananlarıdır.
    final team = perms.subtaskAssignees(task);
    bool open(Subtask u) => !_done(u) || _hold.held.contains(u.id);
    final ordered = [...subs.where(open), ...subs.where((u) => !open(u))];
    String name(String id) => catalog.nameOf(id) ?? l.uiTasksUnknownPerson;
    final actions = widget.actions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.uiTasksSubsHint, style: t.caption.copyWith(color: c.textMuted)),
        const Gap(NizamioSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: subs.isEmpty ? 0 : done / subs.length),
                duration: NzMotion.of(
                  context,
                  const Duration(milliseconds: 350),
                ),
                curve: Curves.ease,
                builder: (_, v, _) =>
                    NzProgressBar(value: v, color: c.taskDone),
              ),
            ),
            const Gap(NizamioSpacing.gapMd),
            Text(
              '$done / ${subs.length} ${l.uiTasksDoneLc}',
              style: t.monoSm.copyWith(
                color: subs.isNotEmpty && done == subs.length
                    ? c.accentText
                    : c.textMuted,
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        if (subs.isNotEmpty) ...[
          NzCard.outlined(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              key: _area,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, u) in ordered.indexed)
                  NzFlipSlot(
                    key: ValueKey(u.id),
                    order: _hold.order,
                    area: _area,
                    child: _SwipeDelete(
                      id: u.id,
                      enabled: manage,
                      label: l.uiTasksSubDelete,
                      onDelete: () => actions.removeSubtask(u.id),
                      child: _SubtaskRow(
                        sub: u,
                        done: _done(u),
                        // Uçuştaki işarette tamamlayan: oturumdaki hesap.
                        doneBy: !_done(u)
                            ? null
                            : _pending.contains(u.id)
                            ? name(catalog.me)
                            : u.doneBy == null
                            ? null
                            : name(u.doneBy!),
                        first: i == 0,
                        taskStart: task.start,
                        catalog: catalog,
                        team: team,
                        open: openSubs.contains(u.id),
                        manage: manage,
                        onCheck: perms.canToggleSubtask(u)
                            ? () => _toggle(u)
                            : null,
                        onCheckBlocked: () =>
                            NzToast.show(context, l.uiTasksSubCheckBlocked),
                        onOpen: () => ctl.toggleSubtaskOpen(u.id),
                        onRename: () => actions.renameSubtask(u),
                        onAssignee: (v) => actions.setSubtaskAssignee(u.id, v),
                        onStart: (v) => actions.setSubtaskStart(u.id, v),
                        onEnd: (v) => actions.setSubtaskEnd(u.id, v),
                        onClearDates: () => actions.clearSubtaskDates(u.id),
                        onDelete: () => actions.removeSubtask(u.id),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(NizamioSpacing.space3),
        ],
        if (manage)
          NzButton.secondary(
            label: l.uiTasksSubAdd,
            icon: NzIcons.add,
            expand: true,
            onPressed: actions.addSubtask,
          ),
      ],
    );
  }
}

/// Alt görev satırı (gündem satırının biçimi): yuvarlak işaret, üstü çekilen başlık + kişi/tarih
/// özeti, tamamlayanın adı; dokunuşla altında düzenleme alanları açılır.
class _SubtaskRow extends StatelessWidget {
  const _SubtaskRow({
    required this.sub,
    required this.done,
    required this.doneBy,
    required this.first,
    required this.taskStart,
    required this.catalog,
    required this.team,
    required this.open,
    required this.manage,
    required this.onCheck,
    required this.onCheckBlocked,
    required this.onOpen,
    required this.onRename,
    required this.onAssignee,
    required this.onStart,
    required this.onEnd,
    required this.onClearDates,
    required this.onDelete,
  });

  final Subtask sub;

  /// Görünen durum (iyimser işaret dahil).
  final bool done;

  /// Tamamlayanın adı (tamamlanmamışsa ya da bilinmiyorsa null).
  final String? doneBy;

  /// İlk satır (üst çizgi yok).
  final bool first;

  /// Ana görevin başlangıcı: alt görev tarihi bundan önce seçilemez.
  final DateTime taskStart;
  final TaskCatalog catalog;
  final List<String> team;
  final bool open;

  /// Başlık/kişi/tarih düzenleme ve silme açık mı (yönetici ya da koordinatör).
  final bool manage;

  /// null → işaretleme bu hesaba kapalı (kutu soluk; dokunuş [onCheckBlocked]).
  final VoidCallback? onCheck;
  final VoidCallback onCheckBlocked;
  final VoidCallback onOpen;

  /// Başlık düzenleme alt sayfası.
  final VoidCallback onRename;
  final ValueChanged<String?> onAssignee;
  final ValueChanged<DateTime?> onStart;
  final ValueChanged<DateTime?> onEnd;
  final VoidCallback onClearDates;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final u = sub;
    String name(String id) => catalog.nameOf(id) ?? l.uiTasksUnknownPerson;
    final title = u.title.isEmpty ? l.uiTasksSubUntitled : u.title;
    final dates = u.start != null && u.end != null
        ? '${TaskDates.dayMonth(u.start!)} – ${TaskDates.dayMonth(u.end!)}'
        : u.start != null
        ? '${TaskDates.dayMonth(u.start!)} –'
        : '';
    final bits = [
      if (u.assignee case final a?) name(a).split(' ').first,
      if (dates.isNotEmpty) dates,
      if (u.evidence != null) l.uiTasksOneEvidence,
      if (u.missingAssignee) l.uiTasksNeedsPerson,
    ];
    final missing = u.missingAssignee;

    Widget field(String label, Widget child) => Padding(
      padding: const EdgeInsets.only(top: NizamioSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: NizamioSpacing.space16,
            child: Padding(
              padding: const EdgeInsets.only(top: NizamioSpacing.space3),
              child: Text(label, style: t.caption.copyWith(color: c.textMuted)),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          Expanded(child: child),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: first ? null : Border(top: BorderSide(color: c.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedOpacity(
            opacity: done ? .62 : 1,
            duration: NzMotion.of(context, nzCheckFade),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60),
              child: Row(
                children: [
                  NzCheckCircle(
                    value: done,
                    label: '$title ${l.uiTasksDoneLc}',
                    onChanged: onCheck,
                    onBlocked: onCheckBlocked,
                  ),
                  const Gap(NizamioSpacing.space2),
                  Expanded(
                    child: Semantics(
                      button: true,
                      expanded: open,
                      label: [title, ...bits].join(', '),
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: onOpen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NzStrikeText(
                                text: title,
                                done: done,
                                color: done ? c.textMuted : c.text,
                                style: t.bodyLg.copyWith(
                                  fontSize: 15,
                                  height: 22 / 15,
                                ),
                              ),
                              if (bits.isNotEmpty)
                                Text(
                                  bits.join(' · '),
                                  style: t.caption.copyWith(
                                    color: missing ? c.warning : c.textMuted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Tamamlayan: işaretlenince solarak gelir, kaldırılınca hemen kalkar.
                  AnimatedSwitcher(
                    duration: NzMotion.of(context, nzCheckFade),
                    reverseDuration: Duration.zero,
                    child: doneBy == null
                        ? const SizedBox.shrink()
                        : Padding(
                            key: ValueKey('by-${u.id}'),
                            padding: const EdgeInsets.only(
                              left: NizamioSpacing.space2,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 112),
                              child: Text(
                                shortPersonName(doneBy!),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: t.caption.copyWith(color: c.textMuted),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          NzReveal(
            open: open,
            child: Padding(
              padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (manage) ...[
                    field(
                      l.uiTasksSubPerson,
                      // Kişi seçimi görev formlarındaki çiplerle; seçili çipe dokunuş
                      // kaldırır (kişi zorunlu değilse).
                      Wrap(
                        spacing: NizamioSpacing.space2,
                        runSpacing: NizamioSpacing.space2,
                        children: [
                          for (final id in {...team, ?u.assignee})
                            TaskChip(
                              label: name(id),
                              selected: u.assignee == id,
                              onTap: () {
                                if (u.assignee != id) {
                                  onAssignee(id);
                                } else if (!u.assigneeRequired) {
                                  onAssignee(null);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                    field(
                      l.uiTasksSubDate,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: NizamioSpacing.space2,
                        children: [
                          // Prototip: başlangıç ve bitiş yan yana (1fr 1fr).
                          Row(
                            spacing: NizamioSpacing.space2,
                            children: [
                              Expanded(
                                child: TaskDateField(
                                  label: l.uiTasksStart,
                                  value: u.start,
                                  firstDate: taskStart,
                                  onChanged: onStart,
                                ),
                              ),
                              Expanded(
                                child: TaskDateField(
                                  label: l.uiTasksDue,
                                  value: u.end,
                                  firstDate: u.start ?? taskStart,
                                  onChanged: onEnd,
                                ),
                              ),
                            ],
                          ),
                          if (u.start != null || u.end != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TaskLink(
                                label: l.uiTasksClearDate,
                                onTap: onClearDates,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  if (u.evidence case final f?)
                    field(
                      l.uiTasksSubFile,
                      Padding(
                        padding: const EdgeInsets.only(
                          top: NizamioSpacing.space3,
                        ),
                        child: Text(
                          f,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.mono,
                        ),
                      ),
                    ),
                  if (manage)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: NizamioSpacing.space3,
                      children: [
                        TaskLink(label: l.uiTasksSubRename, onTap: onRename),
                        TaskLink(
                          label: l.uiTasksSubDelete,
                          color: c.danger,
                          onTap: onDelete,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Yönetene satırı sola kaydırarak silme. Silme onayı ve yazma [onDelete]'dedir; satır
/// kendisi kapanmaz (liste sunucu yanıtıyla güncellenir, iptal/hata satırı geri getirir).
class _SwipeDelete extends StatelessWidget {
  const _SwipeDelete({
    required this.id,
    required this.enabled,
    required this.label,
    required this.onDelete,
    required this.child,
  });

  final String id;
  final bool enabled;
  final String label;
  final Future<void> Function() onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final c = context.colors;
    return Dismissible(
      key: ValueKey('swipe-$id'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await onDelete();
        return false;
      },
      background: ColoredBox(
        color: c.danger,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: NizamioSpacing.space4),
            child: Semantics(
              label: label,
              child: NzIcon(NzIcons.delete, color: c.onDanger),
            ),
          ),
        ),
      ),
      // Kaydırma eylemi satırın anlamsal düğümlerini tek düğüme katmasın: işaret kutusu ve
      // satır (aç/kapat) ekran okuyucuda ayrı dokunulabilir kalır.
      child: Semantics(container: true, explicitChildNodes: true, child: child),
    );
  }
}
