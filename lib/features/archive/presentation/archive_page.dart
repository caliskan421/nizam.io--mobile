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
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../application/archive_controller.dart';
import '../application/archive_folders_controller.dart';
import '../application/archive_providers.dart';
import '../domain/archive.dart';
import 'archive/archive_outcome.dart';
import 'archive/archive_texts.dart';

/// Arşiv (prototip `archive`): başlık + ara + yükle, dosya/klasör özeti, 3 sütunlu klasörler
/// (sunucunun klasör özeti) → klasör ayrıntısı. Alt menüde modül sekmesine yeniden dokunmak
/// kısayol menüsünü açar. Görev bağlamı olmayan yükleme "yakında"dır.
class ArchivePage extends ConsumerStatefulWidget {
  const ArchivePage({super.key});

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 2;

  @override
  ConsumerState<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends ConsumerState<ArchivePage> {
  // Denetleyici durumu sayfadan uzun yaşar (keepAlive): geri dönüşte sorgu kutuda kalır.
  late final _search = TextEditingController(
    text: ref.read(archiveControllerProvider).query,
  );
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
    // Odak (klavye) açılış hareketi bitince NzReveal.onOpened ile gelir.
    if (!opening) {
      _search.clear();
      _searchFocus.unfocus();
    }
  }

  Future<void> _downloadAll() async {
    final l = context.l10n;
    _toast(l.uiArchiveDownloadAllToast);
    final r = await _ctrl.downloadAll('${l.uiArchiveTitle}.zip');
    if (mounted) showArchiveOutcome(context, r);
  }

  void _shortcuts() {
    final l = context.l10n;
    final admin = ref.read(archiveScopeProvider).value?.admin ?? false;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiArchiveShortcuts,
      entries: [
        NzFlyoutSection(l.uiArchiveSectionArchive),
        NzFlyoutItem(
          label: l.uiArchiveUpload,
          icon: NzIcons.upload,
          accent: true,
          onSelected: () => _toast(l.uiArchiveUploadSoon),
        ),
        // Dönemin tam arşivi yalnız şirket yöneticisine açıktır (RECORDS-K24).
        if (admin)
          NzFlyoutItem(
            label: l.uiArchiveDownloadAll,
            icon: NzIcons.download,
            onSelected: _downloadAll,
          ),
        NzFlyoutItem(
          label: l.uiArchiveSearch,
          icon: NzIcons.search,
          onSelected: _toggleSearch,
        ),
        NzFlyoutSection(l.uiArchiveSectionGo),
        NzFlyoutItem(
          label: l.uiArchiveGoCoordinatorships,
          icon: NzIcons.coordinatorships,
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
    // Kök yalnız arama açıklığını izler; klasörler kendi dilimini izler (aramada her tuş
    // vuruşu yalnız klasör ızgarasını yeniden kurar).
    final searchOpen = ref.watch(
      archiveControllerProvider.select((v) => v.searchOpen),
    );
    final folders = ref.watch(archiveFoldersControllerProvider);
    void retry() => retryArchive(ref);
    return NzPage.feed(
      // Klasör ön yüzü cam (NzFolder): giriş yalnız yükselir.
      fadeContent: false,
      onRetry: retry,
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiArchiveTitle,
          actions: [
            Semantics(
              selected: searchOpen,
              child: NzIconButton.circle(
                icon: NzIcons.search,
                semanticLabel: l.uiArchiveSearch,
                onPressed: _toggleSearch,
              ),
            ),
            NzIconButton.circleAccent(
              icon: NzIcons.arrowUp,
              semanticLabel: l.uiArchiveUpload,
              onPressed: () => _toast(l.uiArchiveUploadSoon),
            ),
          ],
        ),
        NzReveal(
          open: searchOpen,
          onOpened: _searchFocus.requestFocus,
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
        const Gap(NizamioSpacing.space5),
        NzAsyncView<List<ArchiveFolder>>(
          value: folders,
          onRetry: retry,
          data: (all) => _Folders(all: all),
        ),
      ],
    );
  }
}

class _Folders extends ConsumerWidget {
  const _Folders({required this.all});

  final List<ArchiveFolder> all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(archiveControllerProvider.select((v) => v.query));
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final files = all.fold<int>(0, (s, f) => s + f.files);
    final list = visibleFolders(all, query: query);
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
            child: Text(
              l.storageCaption(files, all.length),
              style: t.bodyMd.copyWith(color: c.textMuted),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space5),
        NzKicker('${l.uiArchiveFoldersTitle} · ${list.length}'),
        const Gap(NizamioSpacing.space1),
        for (final row in rows) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const Gap(NizamioSpacing.space3),
                Expanded(
                  child: i < row.length
                      ? NzFolder(
                          name: row[i].name,
                          caption: row[i].files > 0
                              ? l.files(row[i].files)
                              : l.uiArchiveNoFiles,
                          onTap: () =>
                              context.appNav.openArchiveFolder(row[i].code),
                        )
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
}
