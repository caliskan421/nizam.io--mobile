import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_reveal.dart';
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
import 'widgets/timeline_zoom_controls.dart';

/// Zaman çizelgesi (prototip `gantt`; kabuk dışı tam ekran, alt menü yok): kök üst çubuk,
/// "Liste / Zaman çizelgesi" anahtarı, koordinatörlük seçici + Filtre, dikey Gantt (yapışkan
/// tarih sütunu, ızgara, bugün çizgisi, görev çubukları, genel bakış), sezon şeridi ve "bugüne
/// dön"; çubuğa dokununca seçili görev kartı (tarih taslağı, kaydet/geri al, tarih talebi,
/// hatırlat). Veri `taskCatalogControllerProvider`; ekran durumu [TimelineController].
class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key, this.coordinatorship});

  final String? coordinatorship;

  /// Rotada bütün koordinatörlükleri seçili açar (`openTimeline(coordinatorship: …)`).
  static const allCoordinatorships = timelineAllCoordinatorships;

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  /// Telefonda ekran tam ekran başlar (üst çubuk, başlık satırı ve arama kapalı; yalnız
  /// çizelge); boş alana dokunmak açar/kapatır. Tablette kullanılmaz.
  bool _full = true;
  bool _started = false;
  bool _searchOpen = false;
  bool _hint = false;
  Timer? _hintTimer;
  final _search = TextEditingController();
  final _focus = FocusNode();
  bool get _phone => MediaQuery.sizeOf(context).width < 600;

  /// Telefonda bu ekran görünürken sistem durum çubuğu (saat, ağ, pil) gizlidir; alt sistem
  /// çubuğu (iOS ana ekran çizgisi, Android gezinme) kalır. Üstüne sayfa açılınca (örtülü rota
  /// TickerMode kapalı), tablete geçince ya da ekran kapanınca geri gelir.
  bool _statusHidden = false;

  void _syncStatusBar() {
    final hide = _phone && TickerMode.valuesOf(context).enabled;
    if (hide == _statusHidden) return;
    _statusHidden = hide;
    _applyStatusBar(hidden: hide);
  }

  static void _applyStatusBar({required bool hidden}) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: hidden
          ? const [SystemUiOverlay.bottom]
          : SystemUiOverlay.values,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncStatusBar();
    // İlk açılışta "çıkmak için boş alana dokun" ipucu bir kez görünür (yalnız telefonda).
    if (!_started) {
      _started = true;
      if (_phone) {
        _hint = true;
        _hideHintLater();
      }
    }
  }

  void _hideHintLater() {
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) setState(() => _hint = false);
    });
  }

  void _toggleFull() {
    if (!_phone) return;
    setState(() {
      _full = !_full;
      _hint = _full;
    });
    _focus.unfocus();
    _hintTimer?.cancel();
    if (_full) _hideHintLater();
  }

  @override
  void dispose() {
    if (_statusHidden) _applyStatusBar(hidden: false);
    _hintTimer?.cancel();
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  Widget _collapse(Widget child) => TweenAnimationBuilder<double>(
    tween: Tween(end: _full ? 0 : 1),
    duration: const Duration(milliseconds: 210),
    curve: Curves.easeInOutCubic,
    builder: (context, value, child) => ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: value,
        child: Opacity(opacity: value, child: child),
      ),
    ),
    child: child,
  );
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
      animateContent: !_phone,
      // Telefon dışında gövdede cam süzgeç düğmeleri (TimelineHeader) var.
      fadeContent: false,
      topBar: _phone
          ? SliverToBoxAdapter(
              child: _collapse(
                SizedBox(
                  height:
                      MediaQuery.paddingOf(context).top +
                      NizamioSize.appbar +
                      NizamioSpacing.space2,
                  child: const CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [RootTopBar()],
                  ),
                ),
              ),
            )
          : const RootTopBar(),
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
              if (_phone)
                _collapse(
                  ColoredBox(
                    color: context.colors.background,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        NizamioSpacing.gutter,
                        NizamioSpacing.gapXl,
                        NizamioSpacing.gutter,
                        NizamioSpacing.space3,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NzPageHeader(
                            title: l.uiTasksTitle,
                            actions: [
                              TasksModeToggle(
                                selected: 1,
                                onSelected: (i) {
                                  if (i == 0) _toList();
                                },
                              ),
                              NzIconButton.circle(
                                icon: NzIcons.search,
                                semanticLabel: l.uiTasksSearch,
                                onPressed: () {
                                  setState(() => _searchOpen = !_searchOpen);
                                  if (!_searchOpen) {
                                    _search.clear();
                                    _focus.unfocus();
                                    ctrl.setQuery('');
                                  }
                                },
                              ),
                              if (ref.watch(canCreateTaskProvider))
                                NzIconButton.circleAccent(
                                  icon: NzIcons.add,
                                  semanticLabel: l.uiTasksNewTask,
                                  onPressed: () => showNewTaskSheet(
                                    context,
                                    resetTarget: true,
                                  ),
                                ),
                            ],
                          ),
                          NzReveal(
                            open: _searchOpen,
                            onOpened: _focus.requestFocus,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: NizamioSpacing.space5,
                              ),
                              child: NzSearchField(
                                controller: _search,
                                focusNode: _focus,
                                label: l.uiTasksSearchHint,
                                hint: l.uiTasksSearchHint,
                                onChanged: ctrl.setQuery,
                                onClear: () => ctrl.setQuery(''),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
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
                      NzPillTab(label: l.uiTimelineList, icon: NzIcons.list),
                      NzPillTab(
                        label: l.uiTimelineTitle,
                        icon: NzIcons.timeline,
                      ),
                    ],
                  ),
                ),
                const Gap(NizamioSpacing.space3),
              ],
              // Kesik katalog (sayfa tavanı/imleç tekrarı): çizelge eksik olabilir.
              if (ref.watch(
                taskCatalogControllerProvider.select(
                  (c) => c.value?.truncated ?? false,
                ),
              )) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.gutter,
                  ),
                  child: Text(
                    l.uiListsTruncated,
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
              ],
              Expanded(
                child: PageContentEntrance(
                  fade: _phone,
                  child: Semantics(
                    container: true,
                    label: l.uiTimelineTitle,
                    explicitChildNodes: true,
                    child: Stack(
                      children: [
                        // Tarih sütunu etiketleri görünür alanın 40 px üstüne de
                        // çizilir; kırpılmazsa "Görevler" satırının üstüne taşar.
                        Positioned.fill(
                          child: ClipRect(
                            child: TimelineChart(
                              view: v,
                              onBlankTap: _toggleFull,
                              bottomInset: bottom,
                              onSelect: ctrl.select,
                              onOverview: ctrl.openOverviewColumn,
                              onDrag: ctrl.dragTo,
                            ),
                          ),
                        ),
                        if (!_phone)
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_phone && sel == null)
            Positioned(
              right: 12,
              bottom: 74 + bottom,
              child: TimelineFloatingFilters(
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
          if (_hint)
            Positioned(
              left: 72,
              right: 12,
              bottom: 66 + bottom,
              child: IgnorePointer(
                child: Material(
                  color: context.colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Tam ekran · çıkmak için boş alana dokun',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
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
          if (!_phone && sel == null && !v.state.coordMenuOpen)
            Positioned(
              right: NizamioSpacing.space3,
              // Prototip `ctrlB`: 152, geri alma bildirimi varken 250.
              bottom: (undo != null ? 250 : 152) + bottom,
              child: TimelineZoomControls(
                scale: v.state.scale,
                overview: v.state.overview,
                onZoomIn: ctrl.zoomIn,
                onZoomOut: ctrl.zoomOut,
                onOverview: () => ctrl.setOverview(!v.state.overview),
                onLegend: () {
                  ctrl.closeCoordMenu();
                  showTimelineLegendSheet(context);
                },
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
