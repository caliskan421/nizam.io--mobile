import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/turkish_collation.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_reveal.dart';
import '../application/archive_actions_controller.dart';
import '../application/archive_controller.dart';
import '../application/archive_files_controller.dart';
import '../application/archive_folder_controller.dart';
import '../application/archive_folder_sources.dart';
import '../application/archive_folders_controller.dart';
import '../domain/archive.dart';
import '../domain/records.dart';
import 'archive/archive_filter_sheet.dart';
import 'archive/archive_folder_grid.dart';
import 'archive/archive_folder_parts.dart';
import 'archive/archive_outcome.dart';
import 'archive/archive_preview_sheet.dart';
import 'archive/archive_texts.dart';
import 'archive/archive_upload.dart';

/// Arşiv klasörü (prototip `afolder`): üst çubuk "Arşiv / KOD" + ZIP indir; ad ve dosya sayısı;
/// Koordinatörlük / Yükle; sekmeler (görev klasörleri · dosyalar), etiket / görev / yükleyen
/// süzgeci ve sıralama (sunucu süzgeçleri), imleçli dosya listesi → önizleme alt sayfası.
/// Kısayol menüsü diğer klasörleri listeler.
class ArchiveFolderPage extends ConsumerWidget {
  const ArchiveFolderPage({super.key, required this.code});

  final String code;

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 2;

  void _shortcuts(BuildContext context, List<ArchiveFolder> folders) {
    final l = context.l10n;
    final nav = context.appNav;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiArchiveShortcuts,
      entries: [
        NzFlyoutSection(l.uiArchiveSectionFolders),
        for (final f in folders)
          NzFlyoutItem(
            label: f.name,
            count: '${f.files}',
            icon: NzIcons.folder,
            accent: f.code == code,
            selected: f.code == code,
            onSelected: () {
              if (f.code != code) nav.openArchiveFolder(f.code);
            },
          ),
        NzFlyoutItem(
          label: l.uiArchiveAllArchive,
          icon: NzIcons.menu,
          onSelected: nav.openArchive,
        ),
      ],
    );
  }

  Future<void> _zip(
    BuildContext context,
    WidgetRef ref,
    ArchiveFolder folder,
  ) async {
    final l = context.l10n;
    final ctrl = ref.read(archiveActionsControllerProvider(code).notifier);
    final filtered = ref.read(archiveFolderControllerProvider(code)).filtered;
    NzToast.show(context, '${folder.name} ${l.uiArchiveZipToast}');
    final r = await ctrl.downloadZip('${folder.name}.zip');
    if (!context.mounted) return;
    if (filtered && r.ok == false && r.error == null) {
      NzToast.show(context, l.uiArchiveZipEmpty);
    }
    showArchiveOutcome(context, r);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(shellReselectEventsProvider, (_, next) {
      final folders = ref.read(archiveFoldersControllerProvider).value;
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != shellTab || folders == null || !visible) return;
      _shortcuts(context, folders);
    });
    final l = context.l10n;
    final ctx = ref.watch(archiveFolderContextProvider(code));
    final view = ref.watch(archiveFolderControllerProvider(code));
    final busy = ref.watch(archiveActionsControllerProvider(code));
    final folder = ctx.value?.folder;
    void retry() => retryArchive(ref);

    final topBar = NzTopBar.detail(
      code: '${l.uiArchiveTitle} / ${folder?.name ?? code}',
      actions: [
        NzIconButton(
          icon: NzIcons.download,
          semanticLabel: view.filtered
              ? l.uiArchiveZipSelection
              : l.uiArchiveZip,
          onPressed: folder == null || busy
              ? null
              : () => _zip(context, ref, folder),
        ),
      ],
    );
    if (folder == null) {
      return NzPage.feed(
        // Tablet sağ bölmesi (arşiv klasörü: gap 20, başlık -6).
        paneLead: NizamioSpacing.rowPad,
        onRefresh: () =>
            ref.read(archiveControllerProvider.notifier).refresh(code: code),
        onRetry: retry,
        topBar: topBar,
        children: [
          NzAsyncView<ArchiveFolderContext?>(
            value: ctx,
            onRetry: retry,
            data: (_) => NzEmptyState(title: l.uiArchiveFolderMissing),
          ),
        ],
      );
    }
    final ctrl = ref.read(archiveFolderControllerProvider(code).notifier);
    final tasks = ref.watch(archiveFolderTasksProvider(code));
    return NzPage.feed(
      paneLead: NizamioSpacing.rowPad,
      onRefresh: () =>
          ref.read(archiveControllerProvider.notifier).refresh(code: code),
      onRetry: retry,
      topBar: topBar,
      // Prototip: sekme hapları üst çubuğun altına yapışır (`position: sticky; top: 64px`).
      pinned: Padding(
        padding: const EdgeInsets.only(
          top: NizamioSpacing.space2,
          bottom: NizamioSpacing.gapMd,
        ),
        child: NzPillTabs(
          semanticLabel: l.uiArchiveTabs,
          tabs: [
            NzPillTab(label: l.uiArchiveTabTasks, count: tasks.value?.length),
            NzPillTab(label: l.uiArchiveTabFiles, count: folder.files),
          ],
          selected: view.tab.index,
          onSelected: (i) => ctrl.setTab(ArchiveFolderTab.values[i]),
        ),
      ),
      afterKey: ValueKey(view.tab),
      after: [
        Gap(
          view.tab == ArchiveFolderTab.tasks
              ? NizamioSpacing.space6
              : NizamioSpacing.space2,
        ),
        if (view.tab == ArchiveFolderTab.tasks)
          NzAsyncView<List<ArchiveTaskSummary>>(
            value: tasks,
            onRetry: () => ref.invalidate(archiveFolderTasksProvider(code)),
            data: (all) {
              final query = trLower(view.query.trim());
              final matches = [
                for (final task in all)
                  if (query.isEmpty || trLower(task.title).contains(query))
                    task,
              ];
              return matches.isEmpty
                  ? _Empty(
                      query.isEmpty
                          ? l.uiArchiveNoFiles
                          : l.uiArchiveEmptySearch,
                    )
                  : ArchiveFolderGrid(
                      children: [
                        for (final task in matches)
                          ArchiveTaskFolderCard(
                            task: task,
                            onOpen: ctrl.openTask,
                          ),
                      ],
                    );
            },
          )
        else ...[
          _Filters(code: code, view: view),
          const Gap(NizamioSpacing.space3),
          _Files(code: code),
        ],
      ],
      children: [
        _Header(code: code, folder: folder),
        const Gap(NizamioSpacing.space2),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: context.text.caption.copyWith(color: context.colors.textMuted),
    ),
  );
}

class _Header extends ConsumerStatefulWidget {
  const _Header({required this.code, required this.folder});
  final String code;
  final ArchiveFolder folder;

  @override
  ConsumerState<_Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  late final _search = TextEditingController(
    text: ref.read(archiveFolderControllerProvider(widget.code)).query,
  );
  final _focus = FocusNode();
  late bool _open = _search.text.isNotEmpty;
  var _submitted = false;

  @override
  void didUpdateWidget(_Header old) {
    super.didUpdateWidget(old);
    if (old.code != widget.code) {
      _focus.unfocus();
      _search.text = ref
          .read(archiveFolderControllerProvider(widget.code))
          .query;
      _open = _search.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
    _search.clear();
    _focus.unfocus();
    ref
        .read(archiveFolderControllerProvider(widget.code).notifier)
        .setQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final busy = ref.watch(archiveActionsControllerProvider(widget.code));
    final view = ref.watch(archiveFolderControllerProvider(widget.code));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      widget.folder.name,
                      style: context.text.titleMd,
                    ),
                  ),
                  const Gap(3),
                  Text(
                    l.files(widget.folder.files),
                    style: context.text.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
            Semantics(
              selected: _open,
              child: NzIconButton.circle(
                icon: NzIcons.search,
                semanticLabel: l.uiArchiveSearch,
                onPressed: () {
                  if (_open) {
                    _close();
                  } else {
                    setState(() => _open = true);
                  }
                },
              ),
            ),
            NzIconButton.circle(
              icon: NzIcons.filter,
              semanticLabel: l.uiTasksFilters,
              dot: view.hasFileFilters ? c.accentText : null,
              onPressed: () {
                if (_open) {
                  _submitted = true;
                  _focus.unfocus();
                }
                ref
                    .read(archiveFolderControllerProvider(widget.code).notifier)
                    .setTab(ArchiveFolderTab.files);
                showArchiveFilterSheet(context, widget.code).whenComplete(() {
                  _submitted = false;
                });
              },
            ),
            NzIconButton.circleAccent(
              icon: NzIcons.arrowUp,
              semanticLabel: l.uiArchiveUploadShort,
              onPressed: busy
                  ? null
                  : () => startArchiveUpload(context, ref, widget.code),
            ),
          ],
        ),
        NzReveal(
          open: _open,
          onOpened: _focus.requestFocus,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space4),
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): _close,
              },
              child: NzSearchField(
                controller: _search,
                focusNode: _focus,
                label: l.uiArchiveSearch,
                onChanged: ref
                    .read(archiveFolderControllerProvider(widget.code).notifier)
                    .setQuery,
                onClear: () => ref
                    .read(archiveFolderControllerProvider(widget.code).notifier)
                    .setQuery(''),
                onSubmitted: (_) => _submitted = true,
                onDismiss: () {
                  if (_submitted) {
                    _submitted = false;
                    return;
                  }
                  _close();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dosyalar sekmesinin süzgeçleri: etiket rayı, seçili görev, yükleyen ve sıralama.
class _Filters extends ConsumerWidget {
  const _Filters({required this.code, required this.view});

  final String code;
  final ArchiveFolderViewState view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ctrl = ref.read(archiveFolderControllerProvider(code).notifier);
    final task = view.task;
    final taskTitle = task == null
        ? null
        : ref
              .watch(archiveFolderTasksProvider(code))
              .value
              ?.where((t) => t.workItemId == task)
              .firstOrNull
              ?.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: NzSplitButton(
            flexibleLabel: true,
            label: l.sortLabel(view.sort),
            semanticLabel: '${l.uiHomeSortChange}: ${l.sortLabel(view.sort)}',
            onPressed: ctrl.cycleSort,
            icon: NzIcons.chevronDown,
            iconTurns: view.sort == ArchiveSort.name ? 0.5 : 0,
            iconSemanticLabel: view.sort == ArchiveSort.name
                ? l.uiHomeSortAscending
                : l.uiHomeSortDescending,
            onIconPressed: null,
          ),
        ),
        if (task != null) ...[
          const Gap(NizamioSpacing.space3),
          ArchiveTaskFilter(
            title: taskTitle ?? l.uiArchiveFactTask,
            onClear: ctrl.clearTask,
          ),
        ],
      ],
    );
  }
}

/// İmleçli dosya listesi + "daha fazla yükle" (otomatik yeniden deneme yok).
class _Files extends ConsumerWidget {
  const _Files({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final files = ref.watch(archiveFilesControllerProvider(code));
    final titles = {
      for (final t
          in ref.watch(archiveFolderTasksProvider(code)).value ??
              const <ArchiveTaskSummary>[])
        t.workItemId: t.title,
    };
    final ctrl = ref.read(archiveFilesControllerProvider(code).notifier);
    if (files.hasError && !files.isLoading) {
      return NzErrorState(
        error: toApiError(files.error!),
        onRetry: () => ref.invalidate(archiveFilesControllerProvider(code)),
      );
    }
    return NzAsyncView<ArchiveFilesState>(
      value: files,
      skeletonOnReload: true,
      onRetry: () => ref.invalidate(archiveFilesControllerProvider(code)),
      data: (s) {
        final list = s.items;
        final moreError = s.moreError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (list.isEmpty && !s.hasMore) _Empty(l.uiArchiveEmptyFiles),
            for (var i = 0; i < list.length; i++)
              ArchiveFileRow(
                key: ValueKey(list[i].id),
                file: list[i],
                taskTitle: titles[list[i].workItemId],
                first: i == 0,
                last: i == list.length - 1,
                onTap: () => showArchivePreview(
                  context,
                  code: code,
                  taskTitle: (id) => titles[id],
                  fileId: list[i].id,
                ),
              ),
            if (moreError != null)
              NzErrorState.inline(error: moreError, onRetry: ctrl.loadMore)
            else if (s.hasMore) ...[
              const Gap(NizamioSpacing.space3),
              NzButton.secondary(
                label: l.uiArchiveLoadMore,
                expand: true,
                onPressed: s.loadingMore ? null : ctrl.loadMore,
              ),
            ],
          ],
        );
      },
    );
  }
}
