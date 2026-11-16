import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/archive_files_controller.dart';
import '../../application/archive_folder_controller.dart';
import '../../application/archive_folder_sources.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';
import 'archive_folder_parts.dart';
import 'archive_preview_sheet.dart';
import 'archive_texts.dart';

/// Dosyalar sekmesinin süzgeçleri: etiket rayı, seçili görev, yükleyen ve sıralama.
class ArchiveFileFilters extends ConsumerWidget {
  const ArchiveFileFilters({super.key, required this.code, required this.view});

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
    final allLoaded = ref.watch(
      archiveFilesControllerProvider(code)
          .select((f) => f.value?.hasMore == false),
    );
    // Sunucu sırası: ada göre artan, son yükleme ve boyut azalan.
    final ascending =
        (view.sort == ArchiveSort.name) != (view.reversed && allLoaded);
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
            iconTurns: ascending ? 0.5 : 0,
            iconSemanticLabel: ascending
                ? l.uiHomeSortAscending
                : l.uiHomeSortDescending,
            // Sunucu yön almaz: ters çevirme bütün sayfalar yüklüyken istemcide yapılır.
            onIconPressed: allLoaded ? ctrl.toggleDirection : null,
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
class ArchiveFileList extends ConsumerWidget {
  const ArchiveFileList({super.key, required this.code});

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
        final reversed =
            !s.hasMore &&
            ref.watch(
              archiveFolderControllerProvider(code).select((v) => v.reversed),
            );
        final list = reversed ? s.items.reversed.toList() : s.items;
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
