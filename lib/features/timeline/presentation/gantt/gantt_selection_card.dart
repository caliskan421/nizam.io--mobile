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
import '../../domain/horizontal_timeline.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import '../widgets/timeline_selection_card.dart';

/// Tablet çizelgesinin yalnız seçili görev yüzü. Çizelgenin süzgeç/ölçek durumuna
/// dokunmadan telefonla aynı tarih taslağı ve sunucu komutlarını kullanır.
class GanttSelectionCard extends ConsumerStatefulWidget {
  const GanttSelectionCard({
    super.key,
    required this.selection,
    required this.year,
    required this.onClose,
    required this.onOpen,
  });

  final GanttSelection selection;
  final int year;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  static const closeKey = ValueKey('gantt-card-close');

  @override
  ConsumerState<GanttSelectionCard> createState() => _GanttSelectionCardState();
}

typedef _SelectionOwner = ({
  String code,
  int session,
  String? program,
  String? department,
  int operation,
});

class _GanttSelectionCardState extends ConsumerState<GanttSelectionCard> {
  static const _scope = timelineAllCoordinatorships;
  bool _busy = false;
  bool _needsSelection = true;
  int _operation = 0;

  _SelectionOwner _owner() {
    final scope = ref.read(scopeControllerProvider).current;
    return (
      code: widget.selection.task.code,
      session: ref.read(sessionControllerProvider).generation,
      program: scope.programId,
      department: scope.departmentId,
      operation: _operation,
    );
  }

  bool _current(_SelectionOwner owner) => mounted && _owner() == owner;

  void _resync() {
    _operation++;
    _busy = false;
    _needsSelection = true;
    _selectAfterFrame();
  }

  TimelineController get _ctrl =>
      ref.read(timelineControllerProvider(_scope).notifier);

  @override
  void initState() {
    super.initState();
    _selectAfterFrame();
  }

  @override
  void didUpdateWidget(GanttSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selection.task.code != widget.selection.task.code) {
      _resync();
    }
  }

  void _selectAfterFrame() {
    final owner = _owner();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_current(owner) || !_needsSelection) return;
      final catalog = ref.read(timelineCatalogProvider);
      if (catalog.isLoading ||
          catalog.hasError ||
          catalog.value?.task(owner.code) == null) {
        return;
      }
      _needsSelection = false;
      _ctrl.select(owner.code);
    });
  }

  void _close() {
    _ctrl.closeSelection();
    widget.onClose();
  }

  Future<void> _pick(TimelineView view, {required bool start}) async {
    final selection = view.selection;
    if (selection == null) return;
    final owner = _owner();
    final code = selection.task.code;
    final session = ref.read(sessionControllerProvider).generation;
    final scope = ref.read(scopeControllerProvider).current;
    final ctrl = _ctrl;
    final date = seasonDate(
      start ? selection.draft.start : selection.draft.end,
      view.year,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: start
          ? DateTime(date.year - 10)
          : seasonDate(selection.draft.start, view.year),
      lastDate: start
          ? seasonDate(selection.draft.end, view.year)
          : DateTime(date.year + 10, 12, 31),
    );
    if (!mounted || picked == null || picked == date || !_current(owner)) {
      return;
    }
    final now = ref.read(scopeControllerProvider).current;
    if (session != ref.read(sessionControllerProvider).generation ||
        scope.programId != now.programId ||
        scope.departmentId != now.departmentId ||
        widget.selection.task.code != code ||
        ref.read(timelineControllerProvider(_scope)).selected != code) {
      return;
    }
    start ? ctrl.setDraftStart(picked) : ctrl.setDraftEnd(picked);
  }

  Future<void> _save() async {
    if (_busy) return;
    final owner = _owner();
    setState(() => _busy = true);
    try {
      final saved = await _ctrl.save();
      if (saved && _current(owner)) {
        widget.onClose();
      }
    } on Object catch (e, st) {
      final api = toReportedApiError(e, st, source: ReportSource.timeline);
      if (mounted && _current(owner)) NzToast.error(context, api);
    } finally {
      if (_current(owner)) setState(() => _busy = false);
    }
  }

  Future<void> _request() async {
    if (_busy) return;
    final owner = _owner();
    setState(() => _busy = true);
    try {
      final result = await _ctrl.requestDates();
      if (!mounted || !_current(owner)) return;
      final l = context.l10n;
      NzToast.show(context, switch (result) {
        TimelineRequestPending() => l.uiTimelineRequestPending,
        TimelineRequestNoChange() => l.uiTimelineRequestNoChange,
        TimelineRequestSent(:final end) => l.requestSentText(end),
      });
    } on Object catch (e, st) {
      final api = toReportedApiError(e, st, source: ReportSource.timeline);
      if (mounted && _current(owner)) NzToast.error(context, api);
    } finally {
      if (_current(owner)) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionGenerationProvider, (_, _) => _resync());
    ref.listen(scopeStateProvider, (previous, next) {
      if (previous?.programId != next.programId ||
          previous?.departmentId != next.departmentId) {
        _resync();
      }
    });
    ref.listen(timelineCatalogProvider, (_, next) {
      if (_needsSelection && next.hasValue) _selectAfterFrame();
    });
    final value = ref.watch(timelineViewProvider(_scope));
    final view = value.value;
    final selection = view?.selection;
    if (selection == null ||
        selection.task.code != widget.selection.task.code ||
        view == null) {
      return const SizedBox.shrink();
    }
    final catalog = ref.watch(timelineCatalogProvider).value;
    final permissions = TaskPermissions.of(
      catalog?.access,
      selection.task.item,
    );
    return TimelineSelectionCard(
      selection: selection,
      year: view.year,
      bottomInset: 0,
      maxHeight: MediaQuery.sizeOf(context).height * .8,
      onOpen: widget.onOpen,
      onClose: _close,
      onNudgeStart: _ctrl.nudgeStart,
      onNudgeEnd: _ctrl.nudgeEnd,
      onPickStart: () => _pick(view, start: true),
      onPickEnd: () => _pick(view, start: false),
      onShift: _ctrl.shiftDraft,
      onReset: _ctrl.resetDraft,
      onSave: _save,
      onRequest: _request,
      onRemind: null,
      canEditDates: permissions.canManageTask || permissions.canRequestDate,
      canSave: permissions.canManageTask,
      canRequest: permissions.canRequestDate,
      busy: _busy,
    );
  }
}
