import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'tables_controller.dart';

enum TableLibraryLayout { all, folders }

enum TableLibrarySort { original, name, reverseName }

class TableLibraryViewState {
  const TableLibraryViewState({
    this.layout = TableLibraryLayout.all,
    this.sort = TableLibrarySort.original,
    this.folderName,
  });
  final TableLibraryLayout layout;
  final TableLibrarySort sort;
  final String? folderName;
}

/// Header controls and results share a view; scope changes discard local choices.
final tableLibraryViewProvider = NotifierProvider.autoDispose
    .family<TableLibraryView, TableLibraryViewState, TableLocation>(
      TableLibraryView.new,
      dependencies: [
        sessionGenerationProvider,
        scopeStateProvider,
        tablesControllerProvider,
      ],
    );

class TableLibraryView extends Notifier<TableLibraryViewState> {
  TableLibraryView(this.location);
  final TableLocation location;
  @override
  TableLibraryViewState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return const TableLibraryViewState();
  }

  void layout(TableLibraryLayout layout) {
    ref.read(tablesControllerProvider.notifier)
      ..setProject(null)
      ..setTemplatesOnly(false);
    state = TableLibraryViewState(layout: layout, sort: state.sort);
  }

  void sort(TableLibrarySort sort) => state = TableLibraryViewState(
    layout: state.layout,
    sort: sort,
    folderName: state.folderName,
  );
  void openFolder(TableProjectEntry folder) {
    state = TableLibraryViewState(
      layout: TableLibraryLayout.folders,
      sort: state.sort,
      folderName: folder.name,
    );
    ref.read(tablesControllerProvider.notifier).setProject(folder.id);
  }
}
