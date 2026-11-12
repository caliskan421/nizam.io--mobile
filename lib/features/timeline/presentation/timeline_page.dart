import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_reveal.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/timeline_controller.dart';
import '../domain/timeline.dart';

import 'mobile/mobile_timeline_actions.dart';
import 'mobile/mobile_timeline_chart.dart';
import 'timeline_texts.dart';
import 'widgets/timeline_feedback.dart';
import 'widgets/timeline_header.dart';
import 'widgets/timeline_selection_card.dart';
import 'widgets/timeline_sheets.dart';
import 'widgets/timeline_zoom_controls.dart';

/// Zaman çizelgesi (prototip `gantt`; kabuk dışı tam ekran, alt menü yok): kök üst çubuk,
/// "Liste / Zaman çizelgesi" anahtarı, yüzen koordinatörlük/filtre/ölçek, yatay zaman ekseni
/// (yapışkan tarih başlığı, gruplar, bugün çizgisi ve görev çubukları), sezon şeridi ve "bugüne
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
  /// Telefonda boş çizelge alanına dokunmak başlıkları gizler/gösterir.
  /// Tablette ana çizelge kendi sayfasında korunur.
  bool _full = false;
  bool _started = false;
  bool _searchOpen = false;
  bool _hint = false;
  Timer? _hintTimer;
  final _search = TextEditingController();
  final _focus = FocusNode();
  bool get _phone => MediaQuery.sizeOf(context).width < 600;

  /// Telefonda tam ekranken sistem durum çubuğu (saat, ağ, pil) gizlidir; alt sistem
  /// çubuğu (iOS ana ekran çizgisi, Android gezinme) kalır. Üstüne sayfa açılınca (örtülü rota
  /// TickerMode kapalı), tablete geçince ya da ekran kapanınca geri gelir.
  bool _statusHidden = false;

  void _syncStatusBar() {
    final hide = _phone && _full && TickerMode.valuesOf(context).enabled;
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
      if (_phone && _full) {
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
    _syncStatusBar();
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

  /// Bekleyen seçim/diyalog sonucu başka görev ya da kapsama uygulanmaz.
  bool Function() _ownerGuard() {
    final session = ref.read(sessionGenerationProvider);
    final scope = ref.read(scopeStateProvider);
    final selected = ref
        .read(timelineControllerProvider(widget.coordinatorship))
        .selected;
    return () =>
        mounted &&
        ref.read(sessionGenerationProvider) == session &&
        ref.read(scopeStateProvider) == scope &&
        ref.read(timelineControllerProvider(widget.coordinatorship)).selected ==
            selected;
  }

  Future<void> _pick(TimelineView v, {required bool start}) async {
    final sel = v.selection;
    if (sel == null) return;
    final owns = _ownerGuard();
    final day = start ? sel.draft.start : sel.draft.end;
    final initialDate = seasonDate(day, v.year);
    final first = start
        ? DateTime(initialDate.year - 10)
        : seasonDate(sel.draft.start, v.year);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: start
          ? seasonDate(sel.draft.end, v.year)
          : DateTime(initialDate.year + 10, 12, 31),
    );
    if (picked == null || picked == initialDate || !mounted || !owns()) return;
    start ? _ctrl.setDraftStart(picked) : _ctrl.setDraftEnd(picked);
  }

  Future<void> _request() async {
    final l = context.l10n;
    final owns = _ownerGuard();
    try {
      final result = await _ctrl.requestDates();
      if (!mounted || !owns()) return;
      switch (result) {
        case TimelineRequestPending():
          _say(l.uiTimelineRequestPending);
        case TimelineRequestNoChange():
          _say(l.uiTimelineRequestNoChange);
        case TimelineRequestSent(:final end):
          _say(l.requestSentText(end));
      }
    } on Object catch (e) {
      if (mounted && owns()) NzToast.error(context, toApiError(e));
    }
  }

  Future<void> _undo() async {
    final owns = _ownerGuard();
    try {
      final code = await _ctrl.undo();
      if (code != null && mounted && owns()) {
        _say(context.l10n.uiTimelineUndoneTail);
      }
    } on Object catch (e) {
      if (mounted && owns()) NzToast.error(context, toApiError(e));
    }
  }

  Future<void> _save() async {
    final owns = _ownerGuard();
    try {
      await _ctrl.save();
    } on Object catch (e) {
      if (mounted && owns()) NzToast.error(context, toApiError(e));
    }
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
        skeletonOnReload: true,
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
                                onDismiss: () {
                                  if (_searchOpen) {
                                    setState(() => _searchOpen = false);
                                    _search.clear();
                                    ctrl.setQuery('');
                                  }
                                },
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
                          // Tam ekranda durum çubuğu gizlense de kamera boşluğu kalır.
                          top: _phone && _full
                              ? MediaQuery.viewPaddingOf(context).top
                              : 0,
                          child: ClipRect(
                            child: MobileTimelineChart(
                              view: v,
                              onBlankTap: _toggleFull,
                              bottomInset: bottom,
                              onSelect: ctrl.select,
                              onToggleGroup: ctrl.toggleGroup,
                              canDrag:
                                  sel != null &&
                                  TaskPermissions.of(
                                    ref
                                        .read(taskCatalogControllerProvider)
                                        .value
                                        ?.access,
                                    sel.task.item,
                                  ).canManageTask,
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
              child: MobileTimelineActions(
                view: v,
                onScale: () => ctrl.setScale(
                  TimelineScale.values[(v.state.scale.index + 1) %
                      TimelineScale.values.length],
                ),
                onCoord: ctrl.toggleCoordMenu,
                onLegend: () => showTimelineLegendSheet(context),
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
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      l.uiTimelineFullscreenHint,
                      textAlign: TextAlign.center,
                      style: context.text.caption,
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
                onSave: _save,
                onRequest: _request,
                onReset: ctrl.resetDraft,
                canEditDates:
                    TaskPermissions.of(
                      ref.read(taskCatalogControllerProvider).value?.access,
                      sel.task.item,
                    ).canManageTask ||
                    TaskPermissions.of(
                      ref.read(taskCatalogControllerProvider).value?.access,
                      sel.task.item,
                    ).canRequestDate,
                canSave: TaskPermissions.of(
                  ref.read(taskCatalogControllerProvider).value?.access,
                  sel.task.item,
                ).canManageTask,
                canRequest: TaskPermissions.of(
                  ref.read(taskCatalogControllerProvider).value?.access,
                  sel.task.item,
                ).canRequestDate,
                onRemind: null,
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
