import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/timeline_controller.dart';
import '../domain/timeline.dart';
import 'chart/timeline_chart.dart';
import 'timeline_texts.dart';
import 'widgets/timeline_feedback.dart';
import 'widgets/timeline_header.dart';
import 'widgets/timeline_selection_card.dart';
import 'widgets/timeline_sheets.dart';

/// Zaman çizelgesi (prototip `gantt`; kabuk dışı tam ekran, alt menü yok): kök üst çubuk,
/// "Liste / Zaman çizelgesi" anahtarı, koordinatörlük seçici + Filtre, dikey Gantt (yapışkan
/// tarih sütunu, ızgara, bugün çizgisi, görev çubukları, genel bakış), sezon şeridi ve "bugüne
/// dön"; çubuğa dokununca seçili görev kartı (tarih taslağı, kaydet/geri al, tarih talebi,
/// hatırlat). Veri `taskCatalogControllerProvider`; ekran durumu [TimelineController].
class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key, this.coordinatorship});

  final String? coordinatorship;

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  String? _toast;
  var _toastSerial = 0;

  TimelineController get _ctrl =>
      ref.read(timelineControllerProvider(widget.coordinatorship).notifier);

  void _say(String message) => setState(() {
    _toast = message;
    _toastSerial++;
  });

  Future<void> _toList() async {
    final popped = await Navigator.of(context).maybePop();
    if (!popped && mounted) context.appNav.openTasks();
  }

  Future<void> _pick(TimelineView v, {required bool start}) async {
    final sel = v.selection;
    if (sel == null) return;
    final day = start ? sel.draft.start : sel.draft.end;
    final first = start ? 0 : sel.draft.start + 1;
    final picked = await showDatePicker(
      context: context,
      initialDate: seasonDate(day, v.year),
      firstDate: seasonDate(first, v.year),
      lastDate: DateTime(v.year + 1, 12, 31),
    );
    if (picked == null) return;
    start ? _ctrl.setDraftStart(picked) : _ctrl.setDraftEnd(picked);
  }

  void _request() {
    final l = context.l10n;
    switch (_ctrl.requestDates()) {
      case TimelineRequestPending():
        _say(l.uiTimelineRequestPending);
      case TimelineRequestNoChange():
        _say(l.uiTimelineRequestNoChange);
      case TimelineRequestSent(:final end):
        _say(l.requestSentText(end));
    }
  }

  void _undo() {
    final code = _ctrl.undo();
    if (code != null) _say('$code ${context.l10n.uiTimelineUndoneTail}');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final view = ref.watch(timelineViewProvider(widget.coordinatorship));
    return NzPage.fill(
      topBar: const RootTopBar(),
      onRetry: () => ref.invalidate(taskCatalogControllerProvider),
      body: NzAsyncView<TimelineView>(
        value: view,
        onRetry: () => ref.invalidate(taskCatalogControllerProvider),
        data: (v) => _body(context, v, l),
      ),
    );
  }

  Widget _body(BuildContext context, TimelineView v, AppLocalizations l) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final sel = v.selection;
    final undo = v.state.undo;
    final ctrl = _ctrl;
    return LayoutBuilder(
      builder: (context, box) => Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.gutter,
                ),
                child: NzPillTabs(
                  semanticLabel: l.uiTimelineView,
                  selected: 1,
                  onSelected: (i) {
                    if (i == 0) _toList();
                  },
                  tabs: [
                    NzPillTab(
                      label: l.uiTimelineList,
                      icon: Icons.list_rounded,
                    ),
                    NzPillTab(
                      label: l.uiTimelineTitle,
                      icon: Icons.view_timeline_outlined,
                    ),
                  ],
                ),
              ),
              const Gap(NizamioSpacing.space3),
              Expanded(
                child: Semantics(
                  container: true,
                  label: l.uiTimelineTitle,
                  explicitChildNodes: true,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: TimelineChart(
                          view: v,
                          bottomInset: bottom,
                          onSelect: ctrl.select,
                          onOverview: ctrl.openOverviewColumn,
                          onDrag: ctrl.dragTo,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: TimelineHeader(
                          view: v,
                          onCoord: ctrl.toggleCoordMenu,
                          onFilter: () {
                            ctrl.closeCoordMenu();
                            showTimelineFilterSheet(
                              context,
                              coordinatorship: widget.coordinatorship,
                            );
                          },
                        ),
                      ),
                      if (v.state.coordMenuOpen)
                        Positioned.fill(
                          child: TimelineCoordMenu(
                            view: v,
                            onToggle: ctrl.toggleCoordinatorship,
                            onAll: ctrl.toggleAllCoordinatorships,
                            onClose: ctrl.closeCoordMenu,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (sel != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TimelineSelectionCard(
                selection: sel,
                year: v.year,
                bottomInset: bottom,
                maxHeight: box.maxHeight * 0.8,
                onOpen: () => context.appNav.openTask(sel.task.code),
                onClose: ctrl.closeSelection,
                onNudgeStart: ctrl.nudgeStart,
                onNudgeEnd: ctrl.nudgeEnd,
                onPickStart: () => _pick(v, start: true),
                onPickEnd: () => _pick(v, start: false),
                onShift: ctrl.shiftDraft,
                onSave: ctrl.save,
                onRequest: _request,
                onRemind: () => _say(
                  '${l.uiTimelineReminded} · ${sel.assignees.join(', ')}',
                ),
              ),
            ),
          if (undo != null && sel == null)
            Positioned(
              left: NizamioSpacing.gutter,
              right: NizamioSpacing.gutter,
              bottom: 66 + bottom,
              child: TimelineUndoSnack(
                key: ValueKey(undo.serial),
                title: l.undoTitle(undo),
                from: l.rangeText(undo.from, v.year),
                to: l.rangeText(undo.to, v.year),
                delta: l.undoDelta(undo),
                onUndo: _undo,
                onExpired: ctrl.dismissUndo,
              ),
            ),
          if (_toast case final message?)
            Positioned(
              left: NizamioSpacing.gutter,
              right: NizamioSpacing.gutter,
              top: box.maxHeight * 0.3,
              child: TimelineToast(
                key: ValueKey(_toastSerial),
                message: message,
                onDone: () => setState(() => _toast = null),
              ),
            ),
        ],
      ),
    );
  }
}
