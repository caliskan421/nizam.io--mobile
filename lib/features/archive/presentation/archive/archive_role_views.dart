import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/domain/turkish_collation.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/archive_controller.dart';
import '../../application/archive_folder_controller.dart';
import '../../application/archive_folder_sources.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';
import '../person_files.dart';
import 'archive_summary_cards.dart';
import 'archive_texts.dart';

/// Koordinatör görünümünün arşivi (prototip `archive` koordinatör dalı): klasör ızgarası
/// yerine etkin koordinatörlüğün DÜZ görev klasörü listesi ("görev klasörleri · n"): klasör
/// çizimi, görev başlığı, "kod · n dosya", durum noktası. Satır klasör ayrıntısını o görevle
/// süzülmüş Dosyalar sekmesinde açar. Kaynak `archiveTasks` (dosyası olan görevler).
class ArchiveTaskFolderList extends ConsumerWidget {
  const ArchiveTaskFolderList({super.key, required this.folder});

  /// Koordinatörün koordinatörlük klasörü.
  final ArchiveFolder folder;

  /// Liste satırındaki küçük klasör çizimi.
  static const _art = Size(32, 27);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final code = folder.code;
    final query = ref.watch(archiveControllerProvider.select((v) => v.query));
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    // Klasör ayrıntısının görünüm durumu bu liste açıkken yaşar: satıra dokunuşta seçilen
    // görev süzgeci ayrıntı açılana dek düşmez.
    ref.listen(archiveFolderControllerProvider(code), (_, _) {});
    return NzAsyncView<List<ArchiveTaskSummary>>(
      value: ref.watch(archiveFolderTasksProvider(code)),
      onRetry: () => ref.invalidate(archiveFolderTasksProvider(code)),
      data: (all) {
        final q = trLower(query.trim());
        final list = [
          for (final t in all)
            if (q.isEmpty || trLower(t.title).contains(q)) t,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ArchiveSummaryCards(files: folder.files, folders: all.length),
            const Gap(NizamioSpacing.space5),
            NzKicker('${l.uiArchiveTaskFolders} · ${list.length}'),
            const Gap(NizamioSpacing.space3),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NizamioSpacing.space6,
                ),
                child: Text(
                  l.uiArchiveEmptyTaskFolders,
                  textAlign: TextAlign.center,
                  style: context.text.caption.copyWith(color: c.textMuted),
                ),
              )
            else
              NzMenuGroup(
                rows: [
                  for (final t in list)
                    NzListTile.navigation(
                      leading: const NzFolderArt(size: _art, frontTop: 9),
                      title: t.title,
                      subtitle: [
                        ?catalog?.task(t.workItemId)?.displayCode,
                        l.files(t.fileCount),
                      ].join(' · '),
                      trailing: switch (catalog?.task(t.workItemId)?.status) {
                        final s? => NzDot(color: statusTone(s).color(c)),
                        null => null,
                      },
                      onTap: () {
                        ref
                            .read(
                              archiveFolderControllerProvider(code).notifier,
                            )
                            .openTask(t.workItemId);
                        context.appNav.openArchiveFolder(code);
                      },
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// Üye görünümünün "Dosyalarım" bölümü: kendi yüklediği dosyalar (`archiveAttachments`
/// `uploader_id` süzgeci; üye yalnız atandığı görevlerin dosyalarını okur, RECORDS README §4).
class ArchiveMyFiles extends ConsumerWidget {
  const ArchiveMyFiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(effectiveAccessProvider).access?.accountId;
    if (me == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(context.l10n.uiArchiveMyFilesCaption),
        const Gap(NizamioSpacing.space3),
        PersonFiles(accountId: me),
      ],
    );
  }
}
