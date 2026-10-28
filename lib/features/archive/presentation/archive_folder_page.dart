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
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/archive_folder_controller.dart';
import '../application/archive_folders_controller.dart';
import '../domain/archive.dart';
import 'archive/archive_preview_sheet.dart';
import 'archive/archive_texts.dart';

/// Arşiv klasörü (prototip `afolder`): üst çubuk "Arşiv / KOD" + ZIP indir; ad, koordinatörler,
/// dosya sayısı ve boyut; Koordinatörlük / Yükle; sekmeler (görev klasörleri · dosyalar),
/// etiket ve görev süzgeci, dosya listesi → önizleme alt sayfası (önceki/sonraki, indir,
/// etiket, taşı, sil). Kısayol menüsü diğer klasörleri listeler.
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
            caption: l.files(f.files),
            icon: Icons.folder_outlined,
            accent: f.code == code,
            onSelected: () {
              if (f.code != code) nav.openArchiveFolder(f.code);
            },
          ),
        NzFlyoutItem(
          label: l.uiArchiveAllArchive,
          icon: Icons.menu_rounded,
          onSelected: nav.openArchive,
        ),
      ],
    );
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
    final folders = ref.watch(archiveFoldersControllerProvider);
    final catalog = ref.watch(taskCatalogControllerProvider);
    final folder = folders.value?.where((f) => f.code == code).firstOrNull;
    void retry() {
      ref
        ..invalidate(archiveFoldersControllerProvider)
        ..invalidate(taskCatalogControllerProvider);
    }

    return NzPage.feed(
      onRetry: retry,
      topBar: NzTopBar.detail(
        code: '${l.uiArchiveTitle} / $code',
        actions: [
          NzIconButton(
            icon: Icons.download_rounded,
            semanticLabel: l.uiArchiveZip,
            onPressed: folder == null
                ? null
                : () => NzToast.show(
                    context,
                    '${folder.name} ${l.uiArchiveZipToast}',
                  ),
          ),
        ],
      ),
      children: [
        NzAsyncView<List<ArchiveFolder>>(
          value: folders,
          onRetry: retry,
          data: (all) => NzAsyncView<TaskCatalog>(
            value: catalog,
            onRetry: retry,
            data: (cat) {
              final f =
                  all.where((x) => x.code == code).firstOrNull ?? all.first;
              return _Body(folder: f, catalog: cat);
            },
          ),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.folder, required this.catalog});

  final ArchiveFolder folder;
  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = ref.watch(archiveFolderControllerProvider(folder.code));
    final ctrl = ref.read(
      archiveFolderControllerProvider(folder.code).notifier,
    );
    final groups = taskFolders(folder, catalog);
    final all = folderFiles(folder, catalog);
    final present = view.present(all);
    final leads = folder.leads.isEmpty
        ? l.uiArchiveNoLead
        : folder.leads.map((id) => catalog.person(id)?.name ?? id).join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(folder.name, style: t.titleMd)),
        const Gap(3),
        Text(
          '$leads · ${l.files(present.length)} · ${l.size(folder.sizeMb, minKb: 12)}',
          style: t.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        Row(
          children: [
            Expanded(
              child: NzButton.secondary(
                label: l.uiArchiveCoordinatorship,
                icon: Icons.apartment_rounded,
                expand: true,
                onPressed: () =>
                    context.appNav.openCoordinatorship(folder.code),
              ),
            ),
            const Gap(NizamioSpacing.space2),
            Expanded(
              child: NzButton.primary(
                label: l.uiArchiveUploadShort,
                icon: Icons.arrow_upward_rounded,
                expand: true,
                onPressed: () => NzToast.show(context, l.uiArchiveUploadSoon),
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space5),
        NzPillTabs(
          semanticLabel: l.uiArchiveTabs,
          tabs: [
            NzPillTab(label: l.uiArchiveTabTasks, count: groups.length),
            NzPillTab(label: l.uiArchiveTabFiles, count: present.length),
          ],
          selected: view.tab.index,
          onSelected: (i) => ctrl.setTab(ArchiveFolderTab.values[i]),
        ),
        const Gap(NizamioSpacing.space5),
        if (view.tab == ArchiveFolderTab.tasks)
          _TaskFolders(groups: groups, onOpen: ctrl.openTask)
        else
          _Files(folder: folder, catalog: catalog, all: all),
      ],
    );
  }
}

class _TaskFolders extends StatelessWidget {
  const _TaskFolders({required this.groups, required this.onOpen});

  final List<ArchiveTaskFolder> groups;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        for (var i = 0; i < groups.length; i += 3) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var j = i; j < i + 3; j++) ...[
                if (j > i) const Gap(NizamioSpacing.gapMd),
                Expanded(
                  child: j < groups.length
                      ? NzFolder(
                          small: true,
                          name: groups[j].task.title,
                          caption: l.files(groups[j].files),
                          onTap: () => onOpen(groups[j].task.code),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
          const Gap(NizamioSpacing.space5),
        ],
      ],
    );
  }
}

class _Files extends ConsumerWidget {
  const _Files({
    required this.folder,
    required this.catalog,
    required this.all,
  });

  final ArchiveFolder folder;
  final TaskCatalog catalog;
  final List<ArchiveFile> all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = ref.watch(archiveFolderControllerProvider(folder.code));
    final ctrl = ref.read(
      archiveFolderControllerProvider(folder.code).notifier,
    );
    final list = view.visible(all);
    final task = view.task == null ? null : catalog.task(view.task!);
    Widget tagChip(ArchiveTag? tag) {
      final on = view.tag == tag;
      final label = tag == null ? l.uiArchiveFilterAll : l.tagShort(tag);
      return Semantics(
        button: true,
        selected: on,
        label: label,
        excludeSemantics: true,
        onTap: () => ctrl.setTag(tag),
        child: InkWell(
          onTap: () => ctrl.setTag(tag),
          borderRadius: BorderRadius.circular(NizamioRadius.pill),
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: on ? c.surfaceOverlay : null,
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
              border: Border.all(color: on ? c.accentText : c.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tag != null) ...[
                  NzDot(color: c.tag(tag), size: 7),
                  const Gap(6),
                ],
                Text(label, style: t.bodySm),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: l.uiArchiveTagFilter,
          container: true,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              tagChip(null),
              for (final x in ArchiveTag.values) tagChip(x),
            ],
          ),
        ),
        const Gap(NizamioSpacing.space3),
        if (task != null) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.tile),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: NizamioSize.iconSizeSm,
                  color: c.textMuted,
                ),
                const Gap(NizamioSpacing.space2),
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySm,
                  ),
                ),
                IconButton(
                  tooltip: l.uiArchiveRemoveTaskFilter,
                  onPressed: ctrl.clearTask,
                  icon: Icon(
                    Icons.close_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Gap(NizamioSpacing.space3),
        ],
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space6,
            ),
            child: Text(
              l.uiArchiveEmptyFiles,
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.row),
            child: ColoredBox(
              color: c.surfaceRaised,
              child: Column(
                children: [
                  for (var i = 0; i < list.length; i++)
                    _FileRow(
                      file: list[i],
                      divider: i > 0,
                      onTap: () => showArchivePreview(
                        context,
                        code: folder.code,
                        all: all,
                        fileId: list[i].id,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.file,
    required this.divider,
    required this.onTap,
  });

  final ArchiveFile file;
  final bool divider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final sub =
        '${l.short(file.taskTitle)} · ${l.size(file.sizeMb, minKb: 12)}';
    return Semantics(
      button: true,
      label: '${file.name}, $sub, ${l.tagLabel(file.tag)}',
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: divider ? Border(top: BorderSide(color: c.border)) : null,
          ),
          child: Row(
            children: [
              ArchiveKindTile(kind: file.kind),
              const Gap(NizamioSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.mono.copyWith(fontSize: 12),
                    ),
                    const Gap(2),
                    Text(
                      sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
              const Gap(NizamioSpacing.space3),
              NzDot(color: c.tag(file.tag)),
            ],
          ),
        ),
      ),
    );
  }
}
