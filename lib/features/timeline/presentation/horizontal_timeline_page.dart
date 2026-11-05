import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/surfaces/nz_reveal.dart';
import '../../tasks/tasks.dart';
import '../application/horizontal_timeline_controller.dart';
import '../application/horizontal_timeline_view.dart';
import '../domain/horizontal_timeline.dart';
import 'gantt/gantt_chart.dart';
import 'gantt/gantt_controls.dart';
import 'gantt/gantt_geometry.dart';
import 'gantt/gantt_selection_card.dart';
import 'gantt/gantt_sheets.dart';

/// Tablet yatay zaman çizelgesi (prototip `S_hgantt`, "Yatay zaman çizelgesi · tam genişlik"):
/// "Görevler" başlığı (sayı satırı, Liste / Zaman çizelgesi anahtarı, yeni görev), araç satırı
/// (koordinatörlük çipleri, durum süzgeci, ölçek, Bugün), yatay zaman eksenli Gantt (yapışkan tarih başlığı ve etiket sütunu, gruplar, çubuklar,
/// gecikme şeritleri, Teknofest günleri, bugün çizgisi), lejant ve seçili görev kartı.
///
/// Gezinme rayını çizmez (uygulama kabuğunun); güvenli alanı bir kez uygular (dışarıda
/// uygulanmışsa etkisizdir). Veri ortak görev kataloğundan (`taskCatalogControllerProvider`);
/// ekran durumu [HorizontalTimelineController]'da (canlı tutulur; sayfa kapanıp açılınca kalır,
/// sunucuya yazılmaz). Kaydırma ve bugüne ortalama sayfa içindedir. [onBack] / [onOpenTask]
/// verilmezse `Navigator.maybePop` ve `context.appNav.openTask`.
class HorizontalTimelinePage extends ConsumerStatefulWidget {
  const HorizontalTimelinePage({
    super.key,
    this.coordinatorship,
    this.onBack,
    this.onOpenTask,
  });

  /// Gezinme niyeti, sayfa kurulurken bir kez uygulanır (yeniden boyutlanma tekrarlamaz):
  /// null → genel açılış, mevcut durum korunur; kod → yalnız o koordinatörlük, seçim kalkar;
  /// `TimelinePage.allCoordinatorships` → hepsi, seçim kalkar. Ölçek, durum süzgeci ve
  /// kapalı gruplar korunur.
  final String? coordinatorship;
  final VoidCallback? onBack;
  final ValueChanged<String>? onOpenTask;

  static const chartKey = ValueKey('gantt-chart');
  static const cardKey = ValueKey('gantt-card');

  @override
  ConsumerState<HorizontalTimelinePage> createState() =>
      _HorizontalTimelinePageState();
}

class _HorizontalTimelinePageState
    extends ConsumerState<HorizontalTimelinePage> {
  var _center = const GanttCenterRequest(0);

  // Arama alanı başlığın altında yerinde açılır; metin denetleyici durumundan başlar.
  late final _search = TextEditingController(
    text: ref.read(horizontalTimelineControllerProvider).query,
  );
  final _searchFocus = FocusNode();
  late bool _searchOpen = _search.text.isNotEmpty;

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _searchOpen = !_searchOpen);
    if (!_searchOpen) {
      _search.clear();
      _searchFocus.unfocus();
      _ctrl.setQuery('');
    }
  }

  // Görünüm ve yerleşim yalnız katalog ya da durum değişince kurulur (kaydırma kurmaz).
  TaskCatalog? _catalog;
  GanttState? _builtFor;
  GanttLayout? _layout;

  HorizontalTimelineController get _ctrl =>
      ref.read(horizontalTimelineControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _applyIntent(widget.coordinatorship);
  }

  @override
  void didUpdateWidget(HorizontalTimelinePage old) {
    super.didUpdateWidget(old);
    // Yalnız yeni niyet (başka koordinatörlük); aynı değerle yeniden kurulum etkisiz.
    if (old.coordinatorship != widget.coordinatorship) {
      _applyIntent(widget.coordinatorship);
    }
  }

  /// Sağlayıcı kurulum sırasında değiştirilemez; niyet ilk kareden hemen sonra uygulanır.
  void _applyIntent(String? coordinatorship) {
    if (coordinatorship == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctrl.open(coordinatorship);
    });
  }

  GanttLayout _layoutOf(TaskCatalog catalog, GanttState state) {
    final cached = _layout;
    if (cached != null && identical(_catalog, catalog) && _builtFor == state) {
      return cached;
    }
    _catalog = catalog;
    _builtFor = state;
    return _layout = GanttLayout.of(horizontalTimelineView(catalog, state));
  }

  void _zoom(GanttZoom z) {
    if (z == ref.read(horizontalTimelineControllerProvider).zoom) return;
    _ctrl.setZoom(z);
    setState(() => _center = GanttCenterRequest(_center.serial + 1));
  }

  void _today() => setState(
    () => _center = GanttCenterRequest(_center.serial + 1, smooth: true),
  );

  void _back() {
    final back = widget.onBack;
    if (back != null) {
      back();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  /// Prototip `go`: seçim kalkar, sonra görev açılır.
  void _open(String code) {
    _ctrl.clearSelection();
    final open = widget.onOpenTask;
    if (open != null) {
      open(code);
    } else {
      context.appNav.openTask(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(taskCatalogControllerProvider);
    final state = ref.watch(horizontalTimelineControllerProvider);
    // Sayfa girişi yok: başlık liste bölmesindeki yerinde kalır, eylemler kayar
    // ([TasksHeaderSlide]), araç satırı ve çizelge soldan yumuşakça girer.
    return NzPage.bare(
      animateContent: false,
      body: SafeArea(
        child: NzAsyncView<TaskCatalog>(
          value: catalog,
          onRetry: () => ref.invalidate(taskCatalogControllerProvider),
          data: (c) => _body(context, _layoutOf(c, state), c.truncated),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, GanttLayout layout, bool truncated) {
    final c = context.colors;
    final v = layout.view;
    final sel = v.selection;
    final ctrl = _ctrl;
    return Semantics(
      container: true,
      label: context.l10n.uiTimelineTitle,
      explicitChildNodes: true,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GanttTopBar(
                view: v,
                onList: _back,
                onSearch: _toggleSearch,
                onNewTask: ref.watch(canCreateTaskProvider)
                    ? () => showNewTaskSheet(context, resetTarget: true)
                    : null,
              ),
              NzReveal(
                open: _searchOpen,
                onOpened: _searchFocus.requestFocus,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    GanttGeometry.headerPadRight,
                    0,
                    GanttGeometry.headerPadRight,
                    NizamioSpacing.space3,
                  ),
                  child: NzSearchField(
                    controller: _search,
                    focusNode: _searchFocus,
                    label: context.l10n.uiTasksSearchHint,
                    hint: context.l10n.uiTasksSearchHint,
                    onChanged: ctrl.setQuery,
                    onClear: () => ctrl.setQuery(''),
                  ),
                ),
              ),
              // Araç satırı ve çizelge soldan sağa yumuşakça girer (tablet bölme `pop`
              // hareketi); sayfa sınırına kırpılır (ray üstüne taşmaz).
              Expanded(
                child: ClipRect(
                  child: NzPaneTransition(
                    motion: NzPaneMotion.pop,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GanttToolbar(
                          view: v,
                          onCoord: () => showGanttCoordSheet(context),
                          onFilter: () => showGanttFilterSheet(context),
                          onZoom: _zoom,
                          onToday: _today,
                        ),
                        // Kesik katalog (sayfa tavanı/imleç tekrarı): çizelge eksik olabilir.
                        if (truncated)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: NizamioSpacing.gutter,
                              vertical: NizamioSpacing.space1,
                            ),
                            child: Text(
                              context.l10n.uiListsTruncated,
                              style: context.text.caption.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        Expanded(
                          child: DecoratedBox(
                            position: DecorationPosition.foreground,
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: c.border)),
                            ),
                            child: ClipRect(
                              child: GanttChart(
                                key: HorizontalTimelinePage.chartKey,
                                layout: layout,
                                center: _center,
                                onToggleGroup: ctrl.toggleGroup,
                                onPick: ctrl.pick,
                              ),
                            ),
                          ),
                        ),
                        const GanttLegend(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (sel != null)
            Positioned(
              right: GanttGeometry.cardRight,
              bottom: GanttGeometry.cardBottom,
              width: GanttGeometry.cardWidth,
              child: GanttSelectionCard(
                key: HorizontalTimelinePage.cardKey,
                selection: sel,
                year: v.year,
                onClose: ctrl.clearSelection,
                onOpen: () => _open(sel.task.code),
              ),
            ),
        ],
      ),
    );
  }
}
