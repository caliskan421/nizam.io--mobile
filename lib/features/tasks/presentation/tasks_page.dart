import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../application/task_catalog_controller.dart';
import '../application/tasks_list_controller.dart';
import '../domain/task_catalog.dart';
import '../domain/task_query.dart';
import 'quick_action_sheets.dart';
import 'task_widgets.dart';
import 'tasks/tasks_filter_sheet.dart';
import 'tasks/tasks_list_parts.dart';

/// Görevler listesi (prototip `tasks`): cam üst çubuk, başlık + ara/filtre/yeni görev
/// daireleri, Liste / Zaman çizelgesi anahtarı, yerinde açılan arama, 4×2 görünüm
/// kutucukları, etkin filtre çipleri, sıralama menülü liste başlığı, görev kartları (8'er
/// sayfalı; koordinatörlüğe göre sıralamada açılır gruplar), filtre alt sayfası. [view] ve
/// [people] başlangıç süzgecidir. Alt menüde "Görevler"e yeniden dokunmak kısayol menüsünü
/// açar.
class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key, this.view, this.people = const []});

  final NzTaskView? view;
  final List<String> people;

  /// Kabukta bu sayfanın sekme sırası.
  static const shellTab = 1;

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  // Alan denetleyici durumundan başlar (liste sayfası yeniden kurulsa da arama metni kalır).
  late final _search = TextEditingController(
    text: ref.read(_provider).filter.query,
  );
  final _searchFocus = FocusNode();

  TasksListControllerProvider get _provider => tasksListControllerProvider(
    widget.view == null
        ? TaskView.all
        : TaskView.values.byName(widget.view!.name),
    widget.people.join(','),
  );

  @override
  void didUpdateWidget(TasksPage old) {
    super.didUpdateWidget(old);
    // Başka başlangıç süzgeciyle açıldı (ör. ana sayfa KPI kartından `view=late`): yeni
    // denetleyicinin araması kapalı ve boştur; alandaki eski metin de silinir.
    if (old.view != widget.view ||
        old.people.join(',') != widget.people.join(',')) {
      _search.clear();
      _searchFocus.unfocus();
    }
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final ctl = ref.read(_provider.notifier);
    final opening = !ref.read(_provider).searchOpen;
    ctl.toggleSearch();
    if (opening) {
      _searchFocus.requestFocus();
    } else {
      _search.clear();
      _searchFocus.unfocus();
    }
  }

  void _openFilters() => showTasksFilterSheet(context, provider: _provider);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final nav = context.appNav;
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != TasksPage.shellTab || !visible) return;
      showTasksShortcuts(
        context,
        provider: _provider,
        onNewTask: () => showNewTaskSheet(context, resetTarget: true),
        onTimeline: nav.openTimeline,
        onSearch: () {
          if (!ref.read(_provider).searchOpen) _toggleSearch();
        },
        onFilters: _openFilters,
      );
    });
    final state = ref.watch(_provider);
    final catalog = ref.watch(taskCatalogControllerProvider);
    final result = ref.watch(tasksListResultOf(_provider));
    final data = catalog.value;
    return NzPage.feed(
      onRetry: () => ref.invalidate(taskCatalogControllerProvider),
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiTasksTitle,
          actions: [
            NzIconButton.circle(
              icon: NzIcons.search,
              semanticLabel: l.uiTasksSearch,
              onPressed: _toggleSearch,
            ),
            NzIconButton.circle(
              icon: NzIcons.filter,
              semanticLabel: l.uiTasksFiltersButton,
              dot: state.filter.hasExtra ? context.colors.accentText : null,
              onPressed: _openFilters,
            ),
            NzIconButton.circleAccent(
              icon: NzIcons.add,
              semanticLabel: l.uiTasksNewTask,
              onPressed: () => showNewTaskSheet(context, resetTarget: true),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        TaskSegmented(
          semanticLabel: l.uiTasksMode,
          labels: [l.uiTasksModeList, l.uiTasksModeTimeline],
          icons: const [NzIcons.viewList, NzIcons.timeline],
          selected: 0,
          onSelected: (i) {
            if (i == 1) nav.openTimeline();
          },
        ),
        NzReveal(
          open: state.searchOpen,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space5),
            child: NzSearchField(
              controller: _search,
              focusNode: _searchFocus,
              label: l.uiTasksSearchHint,
              hint: l.uiTasksSearchHint,
              onChanged: ref.read(_provider.notifier).setQuery,
              onClear: () => ref.read(_provider.notifier).setQuery(''),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space5),
        if (data != null && result != null)
          ...tasksListChildren(
            context,
            catalog: data,
            state: state,
            result: result,
            ctl: ref.read(_provider.notifier),
            onClearAll: () {
              _search.clear();
              ref.read(_provider.notifier).clearAll();
            },
            onOpen: nav.openTask,
          )
        else
          NzAsyncView<TaskCatalog>(
            value: catalog,
            onRetry: () => ref.invalidate(taskCatalogControllerProvider),
            data: (_) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}
