import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/domain/turkish_collation.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart' show effectiveAccessProvider;
import '../../application/archive_controller.dart';
import '../../application/archive_folder_controller.dart';
import '../../application/archive_folder_sources.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';
import '../person_files.dart';
import 'archive_folder_grid.dart';
import 'archive_folder_parts.dart';

/// Koordinatör ve üyenin görev klasörleri: yöneticiyle aynı klasör yüzü ve ızgara.
/// Kaynak `archiveTasks`; dokunuş görev dosyalarını aynı görünümde veya klasörde açar.
class ArchiveTaskFolderList extends ConsumerWidget {
  const ArchiveTaskFolderList({
    super.key,
    required this.folder,
    this.empty,
    this.onlyTasks,
    this.onOpen,
  });

  /// Koordinatörün koordinatörlük klasörü; üyede sanal "Görevlerim" klasörü.
  final ArchiveFolder folder;

  /// Klasörde hiç görev yokken (arama yokken) gösterilen metin; yoksa arama boş metni.
  final String? empty;

  /// Etiket süzgeci: yalnız bu görevler (seçili etiketli dosyası olanlar); null → hepsi.
  final Set<String>? onlyTasks;

  /// Kök koordinatör görünümünde görevin dosyalarını aynı sayfada açar.
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final code = folder.code;
    final query = ref.watch(archiveControllerProvider.select((v) => v.query));
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
            if ((q.isEmpty || trLower(t.title).contains(q)) &&
                (onlyTasks?.contains(t.workItemId) ?? true))
              t,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzKicker('${l.uiArchiveTaskFolders} · ${list.length}'),
            const Gap(NizamioSpacing.space3),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NizamioSpacing.space6,
                ),
                child: Text(
                  all.isEmpty
                      ? (empty ?? l.uiArchiveEmptyTaskFolders)
                      : l.uiArchiveEmptyTaskFolders,
                  textAlign: TextAlign.center,
                  style: context.text.caption.copyWith(
                    color: context.colors.textMuted,
                  ),
                ),
              )
            else
              ArchiveFolderGrid(
                children: [
                  for (final t in list)
                    ArchiveTaskFolderCard(
                      task: t,
                      onOpen:
                          onOpen ??
                          (id) {
                            ref
                                .read(
                                  archiveFolderControllerProvider(code)
                                      .notifier,
                                )
                                .openTask(id);
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
    final view = ref.watch(effectiveAccessProvider);
    final me = view.access?.accountId;
    final filters = ref.watch(
      archiveControllerProvider.select((s) => (s.tags, s.query)),
    );
    if (me == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(context.l10n.uiArchiveMyFilesCaption),
        const Gap(NizamioSpacing.space3),
        PersonFiles(
          key: ValueKey((me, view.programId, view.departmentId, filters)),
          accountId: me,
          limit: 5,
          filterArchive: true,
        ),
      ],
    );
  }
}
