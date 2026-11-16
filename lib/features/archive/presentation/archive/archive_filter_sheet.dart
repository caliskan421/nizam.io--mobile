import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/inputs/nz_filter_choice.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../tasks/tasks.dart';
import '../../application/archive_files_controller.dart';
import '../../application/archive_folder_controller.dart';
import '../../application/archive_folder_sources.dart';
import '../../domain/records.dart';
import 'archive_texts.dart';

Future<void> showArchiveFilterSheet(BuildContext context, String code) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiTasksFilters,
    actions: (sheet) => [
      Consumer(
        builder: (_, ref, _) => NzButton.secondary(
          label: l.uiTasksClear,
          expand: true,
          onPressed: ref
              .read(archiveFolderControllerProvider(code).notifier)
              .clearFileFilters,
        ),
      ),
      Consumer(
        builder: (_, ref, _) {
          final files = ref.watch(archiveFilesControllerProvider(code));
          final data = files.value;
          final n = files.isLoading || files.hasError || data == null
              ? '—'
              : '${data.hasMore ? '≥' : ''}${data.items.length}';
          return NzButton.primary(
            label: '$n ${l.uiArchiveShowFilesTail}',
            expand: true,
            onPressed: () => Navigator.of(sheet).maybePop(),
          );
        },
      ),
    ],
    builder: (_) => _FilterBody(code: code),
  );
}

class _FilterBody extends ConsumerStatefulWidget {
  const _FilterBody({required this.code});
  final String code;
  @override
  ConsumerState<_FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends ConsumerState<_FilterBody> {
  int? _open;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final code = widget.code;
    final view = ref.watch(archiveFolderControllerProvider(code));
    final ctl = ref.read(archiveFolderControllerProvider(code).notifier);
    final uploaders = ref.watch(archiveFolderUploadersProvider(code));
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    String mime(ArchiveMimeCategory type) => switch (type) {
      ArchiveMimeCategory.belge => l.uiArchiveMimeDocument,
      ArchiveMimeCategory.tablo => l.uiArchiveMimeSpreadsheet,
      ArchiveMimeCategory.gorsel => l.uiArchiveMimeImage,
      ArchiveMimeCategory.arsiv => l.uiArchiveMimeArchive,
      ArchiveMimeCategory.metin => l.uiArchiveMimeText,
    };
    return NzFormRows(
      expandedIndex: _open,
      onToggle: (i) => setState(() => _open = _open == i ? null : i),
      rows: [
        NzFormRow(
          label: l.uiArchiveUploaderFilter,
          icon: NzIcons.person,
          value: view.uploader == null
              ? l.uiTasksAllLc
              : catalog?.nameOf(view.uploader!) ?? l.uiArchiveUploaderUnknown,
          valueSet: view.uploader != null,
          content: NzAsyncView<List<String>>(
            value: uploaders,
            onRetry: () => ref.invalidate(archiveFolderUploadersProvider(code)),
            data: (ids) => NzFilterChoices(
              children: [
                for (final (i, id) in ids.indexed)
                  NzFilterChoice(
                    label:
                        catalog?.nameOf(id) ??
                        '${l.uiArchiveUploaderUnknown} ${i + 1}',
                    selected: view.uploader == id,
                    onTap: () =>
                        ctl.setUploader(view.uploader == id ? null : id),
                  ),
              ],
            ),
          ),
        ),
        NzFormRow(
          label: l.uiArchiveFilterType,
          icon: NzIcons.folder,
          value: view.mimeCategory == null
              ? l.uiTasksAllLc
              : mime(view.mimeCategory!),
          valueSet: view.mimeCategory != null,
          content: NzFilterChoices(
            children: [
              for (final type in ArchiveMimeCategory.values)
                NzFilterChoice(
                  label: mime(type),
                  selected: view.mimeCategory == type,
                  onTap: () => ctl.setMimeCategory(
                    view.mimeCategory == type ? null : type,
                  ),
                ),
            ],
          ),
        ),
        NzFormRow(
          label: l.uiArchiveTagFilter,
          icon: NzIcons.tag,
          value: view.tag == null ? l.uiTasksAllLc : l.tagLabel(view.tag!),
          valueSet: view.tag != null,
          content: NzFilterChoices(
            children: [
              for (final tag in archiveTags)
                NzFilterChoice(
                  label: l.tagLabel(tag),
                  selected: view.tag == tag,
                  onTap: () => ctl.setTag(view.tag == tag ? null : tag),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
