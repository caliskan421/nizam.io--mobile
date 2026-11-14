import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/telemetry/report_source.dart';
import '../../../../core/telemetry/unexpected_error.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../tasks/tasks.dart';
import '../../application/gantt_provider.dart';
import '../../application/timeline_controller.dart';
import '../../domain/timeline.dart';
import '../../domain/timeline_rules.dart';
import '../timeline_texts.dart';
import 'timeline_selection_card.dart';

/// Seçili görev kartının ortak sahibi (telefon dikey çizelgesi ve tablet yatay çizelgesi):
/// görev başı yetki etkin görünümden ([TaskCatalogPermissions.permissionsIn]), 7 gün kuralı
/// [timelineLensProvider]'dan, komutlar (kaydet / süre uzat / talep / bitişi bugüne çek)
/// [TimelineController]'dan. İki yüz aynı kuralları buradan alır; konum ve tarih seçici
/// çağıranındır. Sonuç metni [onMessage] ile (verilmezse [NzToast]) gösterilir.
class TimelineSelectionHost extends ConsumerStatefulWidget {
  const TimelineSelectionHost({
    super.key,
    required this.scope,
    required this.selection,
    required this.year,
    required this.bottomInset,
    required this.maxHeight,
    required this.onOpen,
    required this.onClose,
    required this.onPickStart,
    required this.onPickEnd,
    this.onMessage,
    this.onSaved,
  });

  /// [timelineControllerProvider] anahtarı.
  final String? scope;
  final TimelineSelection selection;
  final int year;
  final double bottomInset;
  final double maxHeight;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final ValueChanged<String>? onMessage;

  /// Kayıt/uzatma/çekme başarıyla bitti (tablet kartı kapanır).
  final VoidCallback? onSaved;

  @override
  ConsumerState<TimelineSelectionHost> createState() =>
      _TimelineSelectionHostState();
}

class _TimelineSelectionHostState extends ConsumerState<TimelineSelectionHost> {
  bool _busy = false;

  TimelineController get _ctrl =>
      ref.read(timelineControllerProvider(widget.scope).notifier);

  /// Bekleyen sonuç başka görev, oturum ya da görünüme uygulanmaz.
  bool Function() _guard() {
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    final code = widget.selection.task.code;
    return () =>
        mounted &&
        ref.read(sessionGenerationProvider) == session &&
        ref.read(scopeStateProvider).sameView(scope) &&
        widget.selection.task.code == code;
  }

  void _say(String message) {
    final m = widget.onMessage;
    if (m != null) {
      m(message);
    } else {
      NzToast.show(context, message);
    }
  }

  Future<void> _run(Future<String?> Function() action) async {
    if (_busy) return;
    final owns = _guard();
    setState(() => _busy = true);
    try {
      final message = await action();
      if (message != null && mounted && owns()) _say(message);
    } on Object catch (e, st) {
      // Rapor, bağlam korumasından ÖNCE.
      final api = toReportedApiError(e, st, source: ReportSource.timeline);
      if (mounted && owns()) NzToast.error(context, api);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save(bool directRule) => _run(() async {
    final l = context.l10n;
    final s = widget.selection;
    final change = TimelineDateChange.of(
      s.current,
      s.draft,
      directRule: directRule,
    );
    final saved = await _ctrl.save();
    if (!saved) return null;
    widget.onSaved?.call();
    return change is TimelineExtend ? l.uiTimelineExtendDone : null;
  });

  Future<void> _request(String reason) => _run(() async {
    final l = context.l10n;
    final result = await _ctrl.requestDates(reason: reason);
    return switch (result) {
      TimelineRequestPending() => l.uiTimelineRequestPending,
      TimelineRequestNoChange() => l.uiTimelineRequestNoChange,
      TimelineRequestNeedsReason() => l.uiTimelineReasonNeeded,
      TimelineRequestSent(:final end) => l.requestSentText(end),
    };
  });

  Future<void> _pull() => _run(() async {
    final l = context.l10n;
    final pulled = await _ctrl.pullEndToToday();
    if (!pulled) return null;
    widget.onSaved?.call();
    return l.uiTimelinePulled;
  });

  @override
  Widget build(BuildContext context) {
    final s = widget.selection;
    final catalog = ref.watch(timelineCatalogProvider).value;
    final permissions = catalog.permissionsIn(
      ref.watch(scopeStateProvider),
      s.task.item,
    );
    final directRule = ref.watch(timelineLensProvider).directRule;
    final pull =
        catalog != null && canPullEndToToday(s.task.item, catalog.today);
    final ctrl = _ctrl;
    return TimelineSelectionCard(
      selection: s,
      year: widget.year,
      bottomInset: widget.bottomInset,
      maxHeight: widget.maxHeight,
      onOpen: widget.onOpen,
      onClose: widget.onClose,
      onNudgeStart: ctrl.nudgeStart,
      onNudgeEnd: ctrl.nudgeEnd,
      onPickStart: widget.onPickStart,
      onPickEnd: widget.onPickEnd,
      onShift: ctrl.shiftDraft,
      onReset: ctrl.resetDraft,
      onSave: () => _save(directRule),
      onRequest: _request,
      onExtendDraft: ctrl.extendDraft,
      onPull: pull ? _pull : null,
      onRemind: null,
      directRule: directRule,
      canEditDates: permissions.canManageTask || permissions.canRequestDate,
      canSave: permissions.canManageTask,
      canRequest: permissions.canRequestDate,
      busy: _busy,
    );
  }
}
