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
import '../../scope/scope.dart';
import '../application/archive_controller.dart';
import '../application/archive_folders_controller.dart';
import '../domain/archive.dart';
import 'archive/archive_texts.dart';

/// Arşiv (prototip `archive`): başlık + ara + yükle, genişleyebilir etiket paneli, depolama
/// kartı, sıralanabilir 3 sütunlu koordinatörlük klasörleri → klasör ayrıntısı. Alt menüde
/// modül sekmesine yeniden dokunmak kısayol menüsünü açar.
class ArchivePage extends ConsumerStatefulWidget {
  const ArchivePage({super.key});

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 2;

  @override
  ConsumerState<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends ConsumerState<ArchivePage> {
  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  ArchiveController get _ctrl => ref.read(archiveControllerProvider.notifier);

  void _toast(String m) => NzToast.show(context, m);

  void _toggleSearch() {
    final opening = !ref.read(archiveControllerProvider).searchOpen;
    _ctrl.toggleSearch();
    if (opening) {
      _searchFocus.requestFocus();
    } else {
      _search.clear();
      _searchFocus.unfocus();
    }
  }

  void _shortcuts() {
    final l = context.l10n;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiArchiveShortcuts,
      entries: [
        NzFlyoutSection(l.uiArchiveSectionArchive),
        NzFlyoutItem(
          label: l.uiArchiveUpload,
          icon: Icons.upload_rounded,
          accent: true,
          onSelected: () => _toast(l.uiArchiveUploadSoon),
        ),
        NzFlyoutItem(
          label: l.uiArchiveDownloadAll,
          icon: Icons.download_rounded,
          onSelected: () => _toast(l.uiArchiveDownloadAllToast),
        ),
        NzFlyoutItem(
          label: l.uiArchiveSearch,
          icon: Icons.search_rounded,
          onSelected: _toggleSearch,
        ),
        NzFlyoutItem(
          label: l.uiArchiveCreateFolder,
          icon: Icons.create_new_folder_outlined,
          onSelected: () => _toast(l.uiArchiveCreateFolderSoon),
        ),
        NzFlyoutSection(l.uiArchiveSectionGo),
        NzFlyoutItem(
          label: l.uiArchiveGoCoordinatorships,
          icon: Icons.apartment_rounded,
          onSelected: context.appNav.openCoordinatorships,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != ArchivePage.shellTab || !visible) return;
      _shortcuts();
    });
    final l = context.l10n;
    final view = ref.watch(archiveControllerProvider);
    final folders = ref.watch(archiveFoldersControllerProvider);
    return NzPage.feed(
      onRetry: () => ref.invalidate(archiveFoldersControllerProvider),
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiArchiveTitle,
          actions: [
            Semantics(
              selected: view.searchOpen,
              child: NzIconButton.circle(
                icon: Icons.search_rounded,
                semanticLabel: l.uiArchiveSearch,
                onPressed: _toggleSearch,
              ),
            ),
            NzIconButton.circleAccent(
              icon: Icons.arrow_upward_rounded,
              semanticLabel: l.uiArchiveUpload,
              onPressed: () => _toast(l.uiArchiveUploadSoon),
            ),
          ],
        ),
        NzReveal(
          open: view.searchOpen,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space5),
            child: NzSearchField(
              controller: _search,
              focusNode: _searchFocus,
              label: l.uiArchiveSearchHint,
              hint: l.uiArchiveSearchHint,
              onChanged: _ctrl.setQuery,
              onClear: () => _ctrl.setQuery(''),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space3),
        _TagsPanel(view: view, onToast: _toast),
        const Gap(NizamioSpacing.space5),
        NzAsyncView<List<ArchiveFolder>>(
          value: folders,
          onRetry: () => ref.invalidate(archiveFoldersControllerProvider),
          data: (all) => _Folders(all: all, view: view),
        ),
      ],
    );
  }
}

class _TagsPanel extends ConsumerStatefulWidget {
  const _TagsPanel({required this.view, required this.onToast});

  final ArchiveViewState view;
  final ValueChanged<String> onToast;

  @override
  ConsumerState<_TagsPanel> createState() => _TagsPanelState();
}

class _TagsPanelState extends ConsumerState<_TagsPanel> {
  final _draft = TextEditingController();

  @override
  void initState() {
    super.initState();
    _draft.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _add() {
    final l = context.l10n;
    final added = ref
        .read(archiveControllerProvider.notifier)
        .addTag(_draft.text);
    if (added == null) return;
    _draft.clear();
    widget.onToast('“$added” ${l.uiArchiveTagAdded}');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = widget.view;
    final ctrl = ref.read(archiveControllerProvider.notifier);
    final total =
        ref
            .watch(archiveFoldersControllerProvider)
            .value
            ?.fold<int>(0, (s, f) => s + f.files) ??
        0;
    final custom = view.customTags
        .where((x) => x.id == view.customTag)
        .firstOrNull;
    final dots = view.tag != null
        ? [c.tag(view.tag!)]
        : custom != null
        ? [c.custom(custom.color)]
        : [for (final x in ArchiveTag.values) c.tag(x)];
    final pillLabel = view.tag != null
        ? l.tagLabel(view.tag!)
        : custom?.name ?? '${l.uiArchiveTags} · ${view.tagTotal}';
    Widget chip({
      required String label,
      required Color dot,
      required int count,
      required bool on,
      required VoidCallback onTap,
    }) => Semantics(
      button: true,
      selected: on,
      label: '$label $count',
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: on ? c.surfaceOverlay : c.surface,
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
            border: Border.all(color: on ? c.accentText : c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NzDot(color: dot),
              const Gap(NizamioSpacing.space2),
              Flexible(child: Text(label, style: t.bodySm)),
              const Gap(NizamioSpacing.space2),
              Text('$count', style: t.monoSm.copyWith(color: c.textFaint)),
            ],
          ),
        ),
      ),
    );
    final canAdd = _draft.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: NizamioSpacing.space2,
          children: [
            Semantics(
              button: true,
              expanded: view.tagsOpen,
              label: pillLabel,
              excludeSemantics: true,
              onTap: ctrl.toggleTags,
              child: InkWell(
                onTap: ctrl.toggleTags,
                borderRadius: BorderRadius.circular(NizamioRadius.pill),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 32),
                  padding: const EdgeInsets.fromLTRB(12, 4, 10, 4),
                  decoration: BoxDecoration(
                    color: c.surfaceRaised,
                    borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    border: Border.all(
                      color: view.hasTag ? c.accentText : c.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final d in dots)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                            color: d,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.surfaceRaised,
                              width: 1,
                            ),
                          ),
                        ),
                      const Gap(NizamioSpacing.space2),
                      Flexible(child: Text(pillLabel, style: t.bodySm)),
                      const Gap(NizamioSpacing.space1),
                      AnimatedRotation(
                        turns: view.tagsOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 350),
                        curve: NizamioMotion.easeSpring,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: c.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (view.hasTag)
              TextButton(
                onPressed: ctrl.clearTag,
                child: Text(
                  l.uiArchiveTagsClear,
                  style: t.bodySm.copyWith(color: c.accentText),
                ),
              ),
          ],
        ),
        NzReveal(
          open: view.tagsOpen,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.gapMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: NizamioSpacing.space2,
                  runSpacing: NizamioSpacing.space2,
                  children: [
                    for (final x in ArchiveTag.values)
                      chip(
                        label: l.tagLabel(x),
                        dot: c.tag(x),
                        count: tagCount(total, x),
                        on: view.tag == x,
                        onTap: () => ctrl.pickTag(x),
                      ),
                    for (final x in view.customTags)
                      chip(
                        label: x.name,
                        dot: c.custom(x.color),
                        count: 0,
                        on: view.customTag == x.id,
                        onTap: () => ctrl.pickCustomTag(x.id),
                      ),
                  ],
                ),
                const Gap(NizamioSpacing.gapMd),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(NizamioRadius.row),
                    border: Border.all(color: c.borderControl),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    spacing: NizamioSpacing.space2,
                    runSpacing: NizamioSpacing.space1,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NzDot(color: c.custom(view.draftColor), size: 10),
                          const Gap(NizamioSpacing.space2),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: TextField(
                              controller: _draft,
                              maxLength: 32,
                              style: t.bodyMd,
                              onSubmitted: (_) => _add(),
                              decoration: InputDecoration(
                                isDense: true,
                                counterText: '',
                                border: InputBorder.none,
                                hintText: l.uiArchiveNewTag,
                                hintStyle: t.bodyMd.copyWith(
                                  color: c.textFaint,
                                ),
                                labelText: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Semantics(
                        label: l.uiArchiveTagColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final o in ArchiveTagColor.values)
                              Semantics(
                                inMutuallyExclusiveGroup: true,
                                checked: view.draftColor == o,
                                button: true,
                                label: l.colorLabel(o),
                                excludeSemantics: true,
                                onTap: () => ctrl.setDraftColor(o),
                                child: InkResponse(
                                  onTap: () => ctrl.setDraftColor(o),
                                  radius: 14,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: c.custom(o),
                                        shape: BoxShape.circle,
                                        border: view.draftColor == o
                                            ? Border.all(
                                                color: c.text,
                                                width: 1.5,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Semantics(
                        button: true,
                        enabled: canAdd,
                        label: l.uiArchiveAddTag,
                        excludeSemantics: true,
                        onTap: canAdd ? _add : null,
                        child: InkResponse(
                          onTap: canAdd ? _add : null,
                          radius: 22,
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: canAdd ? c.primary : c.surfaceOverlay,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: canAdd ? c.onPrimary : c.textFaint,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _Folders extends ConsumerWidget {
  const _Folders({required this.all, required this.view});

  final List<ArchiveFolder> all;
  final ArchiveViewState view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final totalMb = all.fold<double>(0, (s, f) => s + f.sizeMb);
    final files = all.fold<int>(0, (s, f) => s + f.files);
    final list = visibleFolders(all, sort: view.sort, query: view.query);
    final rows = <List<ArchiveFolder>>[
      for (var i = 0; i < list.length; i += 3)
        list.sublist(i, (i + 3).clamp(0, list.length)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: l.uiArchiveStorage,
          container: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.row),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: NizamioSpacing.space3,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: l.decimal1(totalMb),
                        style: t.numeral.copyWith(fontSize: 22),
                      ),
                      TextSpan(
                        text: ' ${l.uiArchiveMb}',
                        style: t.caption.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    l.storageCaption(files, all.length),
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(NizamioSpacing.space5),
        NzKicker(
          '${l.uiArchiveCoordinatorshipsLc} · ${list.length}',
          action: Semantics(
            button: true,
            label: '${l.sortLabel(view.sort)}, ${l.uiArchiveSortHint}',
            excludeSemantics: true,
            onTap: ref.read(archiveControllerProvider.notifier).cycleSort,
            child: InkWell(
              onTap: ref.read(archiveControllerProvider.notifier).cycleSort,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: NizamioSize.tap),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.sortLabel(view.sort),
                      style: t.bodySm.copyWith(color: c.textMuted),
                    ),
                    const Gap(NizamioSpacing.space1),
                    Icon(
                      Icons.swap_vert_rounded,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space1),
        for (final row in rows) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const Gap(NizamioSpacing.space3),
                Expanded(
                  child: i < row.length
                      ? _folder(context, row[i])
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
          const Gap(NizamioSpacing.space5),
        ],
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space6,
            ),
            child: Text(
              l.uiArchiveEmptySearch,
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ),
      ],
    );
  }

  Widget _folder(BuildContext context, ArchiveFolder f) {
    final l = context.l10n;
    final n = folderFilesFor(
      f,
      tag: view.tag,
      customTag: view.customTag != null,
    );
    return NzFolder(
      name: f.name,
      caption: n > 0 ? l.files(n) : l.uiArchiveNoFiles,
      onTap: () => context.appNav.openArchiveFolder(f.code),
    );
  }
}
