import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/telemetry/report_source.dart';
import '../../../../core/telemetry/unexpected_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/overlays/nz_decision_sheet.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_detail_controller.dart';
import '../../application/task_details_controller.dart';
import '../../application/task_lifecycle_controller.dart';
import '../../application/tasks_providers.dart';
import '../../domain/coordinator_board.dart';
import '../../domain/member_flow.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_writes.dart';
import '../task_texts.dart';
import 'coordinator_texts.dart';

/// Karar akışları: koordinatörde onayla, iade et, süre uzat, üstlen, ata; üyede başla ve
/// onaya sun ([start], [submit]). Görev ayrıntısı, ana sayfa satırları, görev listesi ve onay
/// kuyruğu AYNI akışı kullanır. Yazma ayrıntı
/// denetleyicisinden geçer ([TaskDetailController]; tek yazma kapısı); ekran dışından çağrıda
/// denetleyici işlem boyunca canlı tutulur. Sonuç kısa bildirimle (hata metni koddan).
class TaskDecisionFlows {
  TaskDecisionFlows(this.context, this.ref, this.code);

  final BuildContext context;
  final WidgetRef ref;
  final String code;

  TaskDetailControllerProvider get _p => taskDetailControllerProvider(code);
  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;
  TaskItem? get _task => _catalog?.task(code);

  void _say(String msg) {
    if (context.mounted) NzToast.show(context, msg);
  }

  /// [run] sırasında ayrıntı denetleyicisi canlı tutulur (sayfa dışı çağrı).
  Future<WriteOutcome> _hold(
    Future<WriteOutcome> Function(TaskDetailController c) run,
  ) async {
    final sub = ref.listenManual(_p, (_, _) {});
    try {
      return await run(ref.read(_p.notifier));
    } finally {
      sub.close();
    }
  }

  /// Sonuç bildirimi: başarı → [done]; hata → hata kodunun metni; geçersiz → "yapılamıyor".
  void _report(WriteOutcome r, String done) {
    if (!context.mounted) return;
    final l = context.l10n;
    switch (r.kind) {
      case WriteKind.done:
        _say(done);
      case WriteKind.invalid:
        _say(l.uiTasksTUnavailable);
      case WriteKind.reasonRequired:
        _say(l.uiTasksErrReasonRequired);
      case _:
        if (r.error case final e?) _say(l.writeErrorText(e));
    }
  }

  String _names(TaskItem t) {
    final l = context.l10n;
    final c = _catalog;
    return t.assignees.isEmpty
        ? l.uiTasksUnassignedWaiting
        : t.assignees
              .map((a) => c?.nameOf(a) ?? l.uiTasksUnknownPerson)
              .join(', ');
  }

  /// Ayrıntı okunduysa kanıt dosyası sayısı; okunmadıysa null (bilinmiyor).
  int? get _files {
    final details = ref.read(taskDetailsProvider(code));
    return details.hasValue ? _task?.fileEntries.length : null;
  }

  List<NzDecisionFact> _facts(TaskItem t) {
    final l = context.l10n;
    final files = _files;
    final subs = t.subtaskTotal;
    return [
      NzDecisionFact(l.uiTasksInfoAssignees, _names(t)),
      if (subs > 0)
        NzDecisionFact(
          l.uiTasksInfoSubtasks,
          l.subtaskLine(t.subtaskDoneTotal, subs),
        ),
      if (files != null)
        NzDecisionFact(l.uiTasksInfoEvidence, '$files ${l.uiTasksFilesLc}'),
      NzDecisionFact(
        l.uiTasksCmpEnd,
        TaskDates.full(t.due),
        danger: isTaskLate(t),
      ),
    ];
  }

  /// Onayla: özet, kanıt uyarısı, erken bitişte "bitişi bugüne çek", isteğe bağlı not.
  Future<void> approve() async {
    final t = _task;
    final today = _catalog?.today;
    if (t == null || today == null) return;
    final l = context.l10n;
    final early = _day(today).isBefore(_day(t.due));
    final res = await NzDecisionSheet.show(
      context,
      title: l.uiTasksApprove,
      description: t.title,
      facts: _facts(t),
      warning: _files == 0 ? l.uiTasksApproveNoEvidence : null,
      toggleLabel: early ? l.uiTasksApprovePull : null,
      toggleDescription: early ? l.uiTasksApprovePullDesc : null,
      toggleInitial: early,
      comparison: (pull) => [
        NzDecisionFact(l.uiTasksCmpPlan, TaskDates.full(t.due)),
        NzDecisionFact(
          l.uiTasksCmpEnd,
          TaskDates.full(early && !pull ? t.due : today),
        ),
        NzDecisionFact(
          l.uiTasksCmpResult,
          l.completionResult(due: t.due, done: today, pulled: pull),
          danger: _day(today).isAfter(_day(t.due)),
        ),
      ],
      noteLabel: l.uiTasksApproveNoteLabel,
      noteHint: l.uiTasksApproveNoteHint,
      noteMaxLength: decisionReasonMaxLength,
      info: l.uiTasksApproveInfo,
      cancelLabel: l.uiTasksCancel,
      okLabel: l.uiTasksApprove,
    );
    if (res == null || !context.mounted) return;
    final note = res.note.isEmpty
        ? null
        : '${l.uiTasksApproveNoteHead}: ${res.note}';
    var r = await _hold(
      (c) => c.approve(pullEndDate: early && res.toggled, note: note),
    );
    if (r.kind == WriteKind.subtasksOpen && context.mounted) {
      if (!await _confirmCloseSubtasks()) return;
      r = await _hold(
        (c) => c.approve(
          pullEndDate: early && res.toggled,
          closeSubtasks: true,
          note: note,
        ),
      );
    }
    _report(r, '“${t.title}” ${l.uiTasksTApprovedTail}');
  }

  /// İade et: zorunlu sebep (en çok [decisionReasonMaxLength]); sebep görev notu olur.
  Future<void> returnTask() async {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    final res = await NzDecisionSheet.show(
      context,
      title: l.uiTasksReturn,
      description: t.title,
      facts: _facts(t),
      noteLabel: l.uiTasksReturnReasonLabel,
      noteHint: l.uiTasksReturnReasonHint,
      noteRequired: true,
      noteMaxLength: decisionReasonMaxLength,
      info: l.uiTasksReturnInfo,
      cancelLabel: l.uiTasksCancel,
      okLabel: l.uiTasksReturn,
      danger: true,
    );
    if (res == null || !context.mounted) return;
    final r = await _hold(
      (c) => c.returnTask(
        reason: res.note,
        asNote: (why) => '${l.uiTasksReturnNoteHead}: $why',
      ),
    );
    _report(r, '“${t.title}” ${l.uiTasksTReturnedTail}');
  }

  /// Atamasız görevi üstlen.
  Future<void> claim() async {
    final l = context.l10n;
    _report(await _hold((c) => c.claim()), l.uiTasksTClaimed);
  }

  /// Sorumlu ata: koordinatörlüğün ekibinden kişi seçilir (`listMembers`).
  Future<void> assign() async {
    final t = _task;
    final dept = t?.departmentId;
    if (t == null || dept == null) return;
    final l = context.l10n;
    final picked = await NzBottomSheet.show<String>(
      context,
      title: l.uiTasksAssignTitle,
      description: l.uiTasksAssignNote,
      builder: (sheet) => Consumer(
        builder: (context, ref, _) => NzAsyncView<List<TeamMember>>(
          value: ref.watch(taskTeamProvider(dept)),
          onRetry: () => ref.invalidate(taskTeamProvider(dept)),
          data: (team) => team.isEmpty
              ? NzEmptyState(title: l.uiTasksAssignEmpty)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final m in team)
                      NzListTile.navigation(
                        title: m.name,
                        onTap: () => Navigator.of(sheet).pop(m.accountId),
                      ),
                  ],
                ),
        ),
      ),
    );
    if (picked == null || !context.mounted) return;
    final name = _catalog?.nameOf(picked) ?? '';
    _report(
      await _hold((c) => c.assign(picked)),
      '“${t.title}” $name ${l.uiTasksTAssignedTail}',
    );
  }

  /// Süre uzat (7 güne kadar, onay gerekmez); [onRequestDate] verilirse "daha fazlası için
  /// tarih talebi" bağlantısı onu açar.
  Future<void> extend({VoidCallback? onRequestDate}) async {
    final t = _task;
    final today = _catalog?.today;
    if (t == null || today == null) return;
    final l = context.l10n;
    final days = ValueNotifier(extendDayOptions.last);
    var go = false;
    var toRequest = false;
    await NzBottomSheet.show<void>(
      context,
      title: l.uiTasksExtend,
      description: t.title,
      actions: (sheet) => nzSheetActions(
        sheet,
        cancel: l.uiTasksCancel,
        ok: l.uiTasksExtendOk,
        onOk: () {
          go = true;
          Navigator.of(sheet).pop();
        },
      ),
      builder: (sheet) => ValueListenableBuilder<int>(
        valueListenable: days,
        builder: (context, n, _) {
          final c = context.colors;
          final txt = context.text;
          final end = _day(t.due).add(Duration(days: n));
          final late = _day(today).difference(end).inDays;
          Widget cell(String label, String value, {bool danger = false}) =>
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: txt.caption.copyWith(color: c.textMuted),
                    ),
                    Text(
                      value,
                      style: txt.bodySm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: danger ? c.danger : c.text,
                      ),
                    ),
                  ],
                ),
              );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NzPillTabs(
                semanticLabel: l.uiTasksExtend,
                selected: extendDayOptions.indexOf(n),
                onSelected: (i) => days.value = extendDayOptions[i],
                tabs: [
                  for (final d in extendDayOptions)
                    NzPillTab(label: l.plusDays(d)),
                ],
              ),
              const Gap(NizamioSpacing.space4),
              Row(
                spacing: NizamioSpacing.space2,
                children: [
                  cell(l.uiTasksCmpNow, TaskDates.full(t.due)),
                  cell(l.uiTasksCmpNewEnd, TaskDates.full(end)),
                  cell(
                    l.uiTasksCmpResult,
                    late > 0
                        ? '$late ${l.uiTasksResultLateTail}'
                        : l.uiTasksResultOnTime,
                    danger: late > 0,
                  ),
                ],
              ),
              const Gap(NizamioSpacing.space3),
              Text(
                l.uiTasksExtendInfo,
                style: txt.caption.copyWith(color: c.textMuted),
              ),
              if (onRequestDate != null) ...[
                const Gap(NizamioSpacing.space2),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: NzButton.ghost(
                    label: l.uiTasksExtendMore,
                    size: NzSize.sm,
                    onPressed: () {
                      toRequest = true;
                      Navigator.of(sheet).pop();
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
    final n = days.value;
    WidgetsBinding.instance.addPostFrameCallback((_) => days.dispose());
    if (!context.mounted) return;
    if (toRequest) {
      onRequestDate?.call();
      return;
    }
    if (!go) return;
    _report(
      await _hold((c) => c.extend(n)),
      '${l.uiTasksTExtended} · ${l.plusDays(n)}',
    );
  }

  /// Başla / düzeltmeye başla (üye): başlamadı ya da iade → devam (`own-status`). Bitmemiş ön
  /// görev biliniyorsa istek gönderilmez (kilit bandı ayrıntıda).
  Future<void> start() async {
    final t = _task;
    final c = _catalog;
    if (t == null || c == null) return;
    final l = context.l10n;
    final links = ref.read(taskDependenciesProvider(code)).value;
    final blocking = links == null
        ? 0
        : blockingPrerequisites(links, (id) {
            for (final x in c.tasks) {
              if (x.id == id) return x;
            }
            return null;
          }).length;
    if (blocking > 0) {
      _say(l.uiTasksStartLocked);
      return;
    }
    _report(
      await _hold((d) => d.setStatus(TaskStatus.inProgress)),
      '“${t.title}” ${l.uiTasksTStartedTail}',
    );
  }

  /// Tamamlandı bildir (üye; prototip YH:11138): kanıt ön denetimi → karar kaplaması (kanıt,
  /// alt görev, bitiş; gecikme uyarısı; isteğe bağlı not) → onaya sun + not → bildirim.
  /// Kanıt istenip dosya yoksa kaplama açılmaz: uyarı + [onUpload] (yükleme önerisi). Açık alt
  /// görev engel değildir (sunucu alt görev kapatmayı yalnız `tamamlandi` hedefinde ister).
  Future<void> submit({VoidCallback? onUpload}) async {
    final t = _task;
    final today = _catalog?.today;
    if (t == null || today == null) return;
    final l = context.l10n;
    var files = _files;
    if (t.evidenceRequired && files == null) files = await _readFiles();
    if (!context.mounted) return;
    if (evidenceMissing(t, files: files)) {
      _say(l.uiTasksSubmitNeedEvidence);
      onUpload?.call();
      return;
    }
    final leads = [
      for (final id
          in _catalog?.coordinatorship(t.coordinatorship)?.leads ??
              const <String>[])
        ?_catalog?.nameOf(id),
    ];
    final late = _day(today).difference(_day(t.due)).inDays;
    final subs = t.subtaskTotal;
    final res = await NzDecisionSheet.show(
      context,
      title: l.uiTasksSubmitTitle,
      description: [
        l.uiTasksSubmitDescHead,
        leads.isEmpty ? l.uiTasksSubmitDescFallback : leads.join(', '),
        l.uiTasksSubmitDescTail,
      ].join(' '),
      facts: [
        if (files != null)
          NzDecisionFact(l.uiTasksInfoEvidence, '$files ${l.uiTasksFilesLc}'),
        if (subs > 0)
          NzDecisionFact(
            l.uiTasksInfoSubtasks,
            l.subtaskLine(t.subtaskDoneTotal, subs),
          ),
        NzDecisionFact(
          l.uiTasksCmpEnd,
          TaskDates.full(t.due),
          danger: late > 0,
        ),
      ],
      warning: late > 0
          ? '${l.uiTasksCmpEnd} ${TaskDates.short(t.due)}, $late '
                '${l.uiTasksSubmitLateTail}'
          : null,
      noteLabel: l.uiTasksSubmitNoteLabel,
      noteHint: l.uiTasksSubmitNoteHint,
      noteMaxLength: decisionReasonMaxLength,
      info: l.uiTasksSubmitInfo,
      cancelLabel: l.uiTasksCancel,
      okLabel: l.uiTasksSubmitOk,
    );
    if (res == null || !context.mounted) return;
    final note = res.note.isEmpty
        ? null
        : '${l.uiTasksSubmitNoteHead}: ${res.note}';
    _report(
      await _hold((c) => c.submitForReview(note: note)),
      '“${t.title}” ${l.uiTasksTSubmittedTail}',
    );
  }

  /// Ayrıntıyı okuyup kanıt dosyası sayısını döndürür (okunamazsa null: karar sunucuda).
  Future<int?> _readFiles() async {
    final p = taskDetailsProvider(code);
    final sub = ref.listenManual(p, (_, _) {});
    try {
      await ref.read(p.future);
      return _task?.fileEntries.length;
    } on Object catch (e, st) {
      // Okuma hatası raporlanır; karar sunucuya kalır (409 toast olarak görünür).
      toReportedApiError(e, st, source: ReportSource.tasks);
      return null;
    } finally {
      sub.close();
    }
  }

  Future<bool> _confirmCloseSubtasks() async {
    final l = context.l10n;
    var yes = false;
    await NzBottomSheet.show<void>(
      context,
      title: l.uiTasksCloseSubsTitle,
      description: l.uiTasksCloseSubsDesc,
      actions: (sheet) => nzSheetActions(
        sheet,
        cancel: l.uiTasksCancel,
        ok: l.uiTasksCloseSubsOk,
        onOk: () {
          yes = true;
          Navigator.of(sheet).pop();
        },
      ),
      builder: (_) => const SizedBox.shrink(),
    );
    return yes;
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
}
