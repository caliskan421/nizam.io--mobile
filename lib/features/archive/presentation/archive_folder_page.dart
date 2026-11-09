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
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../tasks/tasks.dart';
import '../application/archive_actions_controller.dart';
import '../application/archive_controller.dart';
import '../application/archive_files_controller.dart';
import '../application/archive_folder_controller.dart';
import '../application/archive_folder_sources.dart';
import '../application/archive_folders_controller.dart';
import '../domain/archive.dart';
import '../domain/records.dart';
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
      // Görev klasörü satırları cam (NzFolder): giriş yalnız yükselir.
      fadeContent: false,
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
        const Gap(NizamioSpacing.space2),
        if (view.tab == ArchiveFolderTab.tasks)
          NzAsyncView<List<ArchiveTaskSummary>>(
            value: tasks,
            onRetry: () => ref.invalidate(archiveFolderTasksProvider(code)),
            data: (all) => all.isEmpty
                ? _Empty(l.uiArchiveNoFiles)
                : Column(
                    children: [
                      for (var i = 0; i < all.length; i += 3)
                        ArchiveTaskFolderRow(
                          tasks: all.sublist(i, (i + 3).clamp(0, all.length)),
                          onOpen: ctrl.openTask,
                        ),
                    ],
                  ),
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

class _Header extends ConsumerWidget {
  const _Header({required this.code, required this.folder});

  final String code;
  final ArchiveFolder folder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final busy = ref.watch(archiveActionsControllerProvider(code));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(folder.name, style: t.titleMd)),
        const Gap(3),
        Text(
          l.files(folder.files),
          style: t.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        Row(
          children: [
            // Sanal klasör ("Görevlerim") bir koordinatörlük değildir.
            if (!folder.isVirtual) ...[
              Expanded(
                child: NzButton.secondary(
                  label: l.uiArchiveCoordinatorship,
                  icon: NzIcons.coordinatorships,
                  expand: true,
                  onPressed: () =>
                      context.appNav.openCoordinatorship(folder.code),
                ),
              ),
              const Gap(NizamioSpacing.space2),
            ],
            Expanded(
              child: NzButton.primary(
                label: l.uiArchiveUploadShort,
                icon: NzIcons.arrowUp,
                expand: true,
                onPressed: busy
                    ? null
                    : () => startArchiveUpload(context, ref, code),
              ),
            ),
          ],
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

  void _uploaders(BuildContext context, WidgetRef ref, List<String> ids) {
    final l = context.l10n;
    final ctrl = ref.read(archiveFolderControllerProvider(code).notifier);
    final catalog = ref.read(taskCatalogControllerProvider).value;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiArchiveUploaderFilter,
      entries: [
        NzFlyoutSection(l.uiArchiveUploaderFilter),
        NzFlyoutItem(
          label: l.uiArchiveUploaderAll,
          selected: view.uploader == null,
          onSelected: () => ctrl.setUploader(null),
        ),
        for (final id in ids)
          NzFlyoutItem(
            label: catalog?.nameOf(id) ?? l.uiArchiveUploaderUnknown,
            selected: view.uploader == id,
            onSelected: () => ctrl.setUploader(id),
          ),
      ],
    );
  }

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
    final uploaders = ref.watch(archiveFolderUploadersProvider(code)).value;
    final uploader = view.uploader;
    final uploaderLabel = uploader == null
        ? l.uiArchiveUploaderFilter
        : ref.watch(taskCatalogControllerProvider).value?.nameOf(uploader) ??
              l.uiArchiveUploaderUnknown;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ArchiveTagRail(selected: view.tag, onSelected: ctrl.setTag),
        const Gap(NizamioSpacing.space2),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ArchiveChip(
              label: uploaderLabel,
              on: uploader != null,
              icon: NzIcons.chevronDown,
              onTap: uploaders == null
                  ? () {}
                  : () => _uploaders(context, ref, uploaders),
            ),
            ArchiveChip(
              label: l.sortLabel(view.sort),
              on: false,
              icon: NzIcons.swapVertical,
              onTap: ctrl.cycleSort,
            ),
          ],
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
    return NzAsyncView<ArchiveFilesState>(
      value: files,
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
