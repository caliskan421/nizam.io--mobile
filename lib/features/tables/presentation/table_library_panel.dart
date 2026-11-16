import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_folder_card.dart';
import '../application/table_folder_pages.dart';
import '../application/table_library_view.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';
import 'table_library_controls.dart';
import 'table_library_tools.dart';

/// Table library: folders are organization only; permissions remain on each table.
class TableLibraryPanel extends ConsumerStatefulWidget {
  const TableLibraryPanel({
    super.key,
    required this.location,
    required this.card,
    this.showHeader = true,
  });
  final TableLocation location;
  final bool showHeader;
  final Widget Function(TableDocument) card;
  @override
  ConsumerState<TableLibraryPanel> createState() => _TableLibraryPanelState();
}

class _TableLibraryPanelState extends ConsumerState<TableLibraryPanel> {
  final _cursors = <String?>[null];
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tablesControllerProvider);
    final view = ref.watch(tableLibraryViewProvider(widget.location));
    final controller = ref.read(
      tableLibraryViewProvider(widget.location).notifier,
    );
    final docs = [...state.visible];
    if (view.sort != TableLibrarySort.original) {
      docs.sort((a, b) {
        final result = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        return view.sort == TableLibrarySort.reverseName ? -result : result;
      });
    }
    final folders =
        view.layout == TableLibraryLayout.folders && state.project == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showHeader || state.project != null)
          Row(
            children: [
              if (state.project != null)
                NzIconButton(
                  icon: NzIcons.chevronLeft,
                  semanticLabel: 'Klasörlere dön',
                  onPressed: () {
                    controller.layout(TableLibraryLayout.folders);
                  },
                ),
              Expanded(
                child: Text(
                  state.project == null
                      ? 'Tablolar'
                      : view.folderName ?? 'Tablolar',
                  style: context.text.kicker,
                ),
              ),
              if (widget.showHeader)
                TableLibraryControls(location: widget.location),
            ],
          ),
        const Gap(8),
        const TableLibraryRecovery(),
        if (folders)
          _folders(state)
        else ...[
          if (docs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                state.query.isEmpty
                    ? context.l10n.uiTablesEmpty
                    : context.l10n.uiTablesNoResults,
              ),
            ),
          _grid([for (final doc in docs) widget.card(doc)], folders: false),
        ],
      ],
    );
  }

  Widget _folders(TablesState state) {
    final view = ref.watch(tableLibraryViewProvider(widget.location));
    final key = (location: widget.location, cursor: _cursors.last);
    final page = ref.watch(tableFolderPageProvider(key));
    return page.when(
      loading: () => const Center(child: NzLoader()),
      error: (error, _) => Column(
        children: [
          Text(
            errorText(
              context.l10n,
              error is ApiError ? error : ApiError('platform.internal'),
            ),
          ),
          NzButton.ghost(
            label: 'Yeniden dene',
            onPressed: () => ref.invalidate(tableFolderPageProvider(key)),
          ),
        ],
      ),
      data: (page) {
        final entries = [...page.items];
        if (view.sort != TableLibrarySort.original) {
          entries.sort((a, b) {
            final result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
            return view.sort == TableLibrarySort.reverseName ? -result : result;
          });
        }
        final controller = ref.read(
          tableLibraryViewProvider(widget.location).notifier,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _grid([
              for (final entry in entries)
                NzFolderCard(
                  title: entry.name,
                  summary:
                      '${state.visible.where((d) => d.projectId == entry.id).length} tablo',
                  onTap: () {
                    controller.openFolder(entry);
                  },
                ),
            ], folders: true),
            if (entries.isEmpty) const Text('Henüz klasör yok.'),
            if (_cursors.length > 1 || page.cursor != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NzIconButton(
                    icon: NzIcons.chevronLeft,
                    semanticLabel: 'Önceki klasörler',
                    onPressed: _cursors.length > 1
                        ? () => setState(_cursors.removeLast)
                        : null,
                  ),
                  NzIconButton(
                    icon: NzIcons.chevronRight,
                    semanticLabel: 'Sonraki klasörler',
                    onPressed:
                        page.cursor != null && !_cursors.contains(page.cursor)
                        ? () => setState(() => _cursors.add(page.cursor))
                        : null,
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _grid(List<Widget> children, {required bool folders}) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 860
          ? 3
          : constraints.maxWidth >= 560 || folders
          ? 2
          : 1;
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}
