import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/archive_controller.dart';
import '../../application/archive_folder_controller.dart';
import '../../application/archive_folder_sources.dart';
import '../../domain/archive.dart';
import 'archive_file_list.dart';
import 'archive_filter_sheet.dart';
import 'archive_role_views.dart';
import 'archive_summary_cards.dart';

/// Koordinatörün kök arşivi: klasörler ve dosyalar ayrı sekmelerde, görev seçimi aynı sayfada.
class ArchiveCoordinatorContents extends ConsumerStatefulWidget {
  const ArchiveCoordinatorContents({super.key, required this.folder});

  final ArchiveFolder folder;

  @override
  ConsumerState<ArchiveCoordinatorContents> createState() => _ContentsState();
}

class _ContentsState extends ConsumerState<ArchiveCoordinatorContents> {
  ArchiveFolderTab _tab = ArchiveFolderTab.tasks;

  void _openFiles([String? task]) {
    final controller = ref.read(
      archiveFolderControllerProvider(widget.folder.code).notifier,
    );
    controller.clearTask();
    controller.clearFileFilters();
    if (task != null) {
      ref.read(archiveControllerProvider.notifier).setQuery('');
    }
    controller.setQuery(ref.read(archiveControllerProvider).query);
    if (task == null) {
      controller.setTab(ArchiveFolderTab.files);
    } else {
      controller.openTask(task);
    }
    setState(() => _tab = ArchiveFolderTab.files);
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.folder.code;
    final provider = archiveFolderControllerProvider(code);
    final view = ref.watch(provider);
    final tasks = ref.watch(archiveFolderTasksProvider(code));
    final l = context.l10n;
    ref.listen(archiveControllerProvider.select((s) => s.query), (_, query) {
      if (_tab == ArchiveFolderTab.files) {
        ref.read(provider.notifier).setQuery(query);
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ArchiveSummaryCards(
          files: widget.folder.files,
          folders: tasks.value?.length ?? 0,
        ),
        const Gap(NizamioSpacing.space5),
        NzPillTabs(
          semanticLabel: l.uiArchiveTabs,
          selected: _tab.index,
          tabs: [
            NzPillTab(label: l.uiArchiveTabTasks, count: tasks.value?.length),
            NzPillTab(label: l.uiArchiveTitle, count: widget.folder.files),
          ],
          onSelected: (index) {
            if (index == ArchiveFolderTab.files.index) {
              _openFiles();
            } else {
              setState(() => _tab = ArchiveFolderTab.tasks);
            }
          },
        ),
        const Gap(NizamioSpacing.space4),
        if (_tab == ArchiveFolderTab.tasks)
          ArchiveTaskFolderList(folder: widget.folder, onOpen: _openFiles)
        else ...[
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: NzIconButton.circle(
              icon: NzIcons.filter,
              semanticLabel: l.uiTasksFilters,
              dot: view.hasFileFilters ? context.colors.accentText : null,
              onPressed: () => showArchiveFilterSheet(context, code),
            ),
          ),
          ArchiveFileFilters(code: code, view: view),
          const Gap(NizamioSpacing.space3),
          ArchiveFileList(code: code),
        ],
      ],
    );
  }
}
