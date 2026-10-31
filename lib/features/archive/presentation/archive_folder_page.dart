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
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/archive_folder_contents.dart';
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
    final contents = ref.watch(archiveFolderContentsProvider(code));
    void retry() {
      ref
        ..invalidate(archiveFoldersControllerProvider)
        ..invalidate(taskCatalogControllerProvider);
    }

    final topBar = NzTopBar.detail(
      code: '${l.uiArchiveTitle} / $code',
      actions: [
        NzIconButton(
          icon: NzIcons.download,
          semanticLabel: l.uiArchiveZip,
          onPressed: contents == null
              ? null
              : () => NzToast.show(
                  context,
                  '${contents.folder.name} ${l.uiArchiveZipToast}',
                ),
        ),
      ],
    );
    if (contents == null) {
      // Yükleme / hata: kaynakların durumu (ikisi de hazırsa içerik yukarıda doludur).
      return NzPage.feed(
        // Tablet sağ bölmesi (arşiv klasörü: gap 20, başlık -6).
        paneLead: NizamioSpacing.rowPad,
        onRetry: retry,
        topBar: topBar,
        children: [
          NzAsyncView<List<ArchiveFolder>>(
            value: folders,
            onRetry: retry,
            data: (_) => NzAsyncView<TaskCatalog>(
              value: catalog,
              onRetry: retry,
              data: (_) => const SizedBox.shrink(),
            ),
          ),
        ],
      );
    }
    final view = ref.watch(archiveFolderControllerProvider(code));
    final ctrl = ref.read(archiveFolderControllerProvider(code).notifier);
    final present = view.present(contents.files);
    return NzPage.feed(
      // Tablet sağ bölmesi (arşiv klasörü: gap 20, başlık -6).
      paneLead: NizamioSpacing.rowPad,
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
            NzPillTab(
              label: l.uiArchiveTabTasks,
              count: contents.groups.length,
            ),
            NzPillTab(label: l.uiArchiveTabFiles, count: present.length),
          ],
          selected: view.tab.index,
          onSelected: (i) => ctrl.setTab(ArchiveFolderTab.values[i]),
        ),
      ),
      afterKey: ValueKey(view.tab),
      after: [
        const Gap(NizamioSpacing.space2),
        if (view.tab == ArchiveFolderTab.tasks)
          for (var i = 0; i < contents.groups.length; i += 3)
            _TaskFolderRow(
              key: ValueKey('g$i'),
              groups: contents.groups.sublist(
                i,
                (i + 3).clamp(0, contents.groups.length),
              ),
              onOpen: ctrl.openTask,
            )
        else
          ..._files(context, ref, contents, view),
      ],
      children: [
        _Header(
          folder: contents.folder,
          catalog: catalog.requireValue,
          fileCount: present.length,
        ),
        const Gap(NizamioSpacing.space2),
      ],
    );
  }

  /// Dosyalar sekmesi: etiket rayı, görev süzgeci şeridi ve dosya satırları — satırlar ayrı
  /// akış öğesidir (78 dosyalık klasörde yalnız görünenler kurulur).
  List<Widget> _files(
    BuildContext context,
    WidgetRef ref,
    ArchiveFolderContents contents,
    ArchiveFolderViewState view,
  ) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final ctrl = ref.read(archiveFolderControllerProvider(code).notifier);
    final list = view.visible(contents.files);
    final task = view.task == null
        ? null
        : ref.read(taskCatalogControllerProvider).value?.task(view.task!);
    return [
      _TagRail(selected: view.tag, onSelected: ctrl.setTag),
      const Gap(NizamioSpacing.space3),
      if (task != null) ...[
        _TaskFilter(title: task.title, onClear: ctrl.clearTask),
        const Gap(NizamioSpacing.space3),
      ],
      if (list.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
          child: Text(
            l.uiArchiveEmptyFiles,
            textAlign: TextAlign.center,
            style: t.caption.copyWith(color: c.textMuted),
          ),
        )
      else
        for (var i = 0; i < list.length; i++)
          _FileRow(
            key: ValueKey(list[i].id),
            file: list[i],
            first: i == 0,
            last: i == list.length - 1,
            onTap: () => showArchivePreview(
              context,
              code: code,
              all: contents.files,
              fileId: list[i].id,
            ),
          ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.folder,
    required this.catalog,
    required this.fileCount,
  });

  final ArchiveFolder folder;
  final TaskCatalog catalog;
  final int fileCount;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final leads = folder.leads.isEmpty
        ? l.uiArchiveNoLead
        : folder.leads.map((id) => catalog.person(id)?.name ?? id).join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(header: true, child: Text(folder.name, style: t.titleMd)),
        const Gap(3),
        Text(
          '$leads · ${l.files(fileCount)} · ${l.size(folder.sizeMb, minKb: 12)}',
          style: t.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        Row(
          children: [
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
            Expanded(
              child: NzButton.primary(
                label: l.uiArchiveUploadShort,
                icon: NzIcons.arrowUp,
                expand: true,
                onPressed: () => NzToast.show(context, l.uiArchiveUploadSoon),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Görev klasörleri ızgarasının bir satırı (3 sütun, prototip `gap: 20px 10px`).
class _TaskFolderRow extends StatelessWidget {
  const _TaskFolderRow({super.key, required this.groups, required this.onOpen});

  final List<ArchiveTaskFolder> groups;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var j = 0; j < 3; j++) ...[
            if (j > 0) const Gap(NizamioSpacing.gapMd),
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
    );
  }
}

/// Etiket süzgeci: yatay kaydırılan haplar (prototip `.rp-wheel`, kenardan kenara).
class _TagRail extends StatelessWidget {
  const _TagRail({required this.selected, required this.onSelected});

  final ArchiveTag? selected;
  final ValueChanged<ArchiveTag?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    Widget chip(ArchiveTag? tag) {
      final on = selected == tag;
      final label = tag == null ? l.uiArchiveFilterAll : l.tagShort(tag);
      return Semantics(
        button: true,
        selected: on,
        label: label,
        excludeSemantics: true,
        onTap: () => onSelected(tag),
        child: InkWell(
          onTap: () => onSelected(tag),
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

    return Semantics(
      label: l.uiArchiveTagFilter,
      container: true,
      // Prototip `.rp-wheel`: haplar kenar boşluğunun dışına taşarak kayar.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          spacing: 6,
          children: [chip(null), for (final x in ArchiveTag.values) chip(x)],
        ),
      ),
    );
  }
}

class _TaskFilter extends StatelessWidget {
  const _TaskFilter({required this.title, required this.onClear});

  final String title;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
      ),
      child: Row(
        children: [
          NzIcon(
            NzIcons.folder,
            size: NizamioSize.iconSizeSm,
            color: c.textMuted,
          ),
          const Gap(NizamioSpacing.space2),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodySm,
            ),
          ),
          IconButton(
            tooltip: l.uiArchiveRemoveTaskFilter,
            onPressed: onClear,
            icon: NzIcon(
              NzIcons.close,
              size: NizamioSize.iconSizeSm,
              color: c.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dosya satırı; satırlar birlikte `bg-raised`, 18 köşeli tek kart gibi görünür (ilk/son satır
/// köşeleri yuvarlanır, aradakiler üstte ince çizgiyle ayrılır).
class _FileRow extends StatelessWidget {
  const _FileRow({
    super.key,
    required this.file,
    required this.first,
    required this.last,
    required this.onTap,
  });

  final ArchiveFile file;
  final bool first;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final sub =
        '${l.short(file.taskTitle)} · ${l.size(file.sizeMb, minKb: 12)}';
    const r = Radius.circular(NizamioRadius.row);
    final radius = BorderRadius.vertical(
      top: first ? r : Radius.zero,
      bottom: last ? r : Radius.zero,
    );
    return Semantics(
      button: true,
      label: '${file.name}, $sub, ${l.tagLabel(file.tag)}',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: c.surfaceRaised,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: first ? null : Border(top: BorderSide(color: c.border)),
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
      ),
    );
  }
}
