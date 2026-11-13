import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../domain/table_models.dart';
import '../domain/table_reference_sources.dart';
import 'table_controller.dart';
import 'tables_providers.dart';

part 'table_reference_controller.g.dart';

/// Seçici başına en çok kaç sayfa okunur (görev/tablo listeleri imleçli; sayfa 200).
const tableRefMaxPages = 5;

/// Referans sütununun aday listesi (tablonun kendi kapsamıyla). Kişi/departman/görev sahip
/// modülün uçlarından ([TableReferenceSources]), tablo referansı aynı alanın tablo
/// listesinden gelir. Dosya iki adımlıdır: görev seçilir ([tableRefFilesProvider]).
/// Ek sütunu bu seçicide yoktur.
@riverpod
Future<List<TableRefCandidate>> tableRefCandidates(
  Ref ref,
  String tableId,
  TableColumnKind kind,
) async {
  await ref.watch(tableControllerProvider(tableId).future);
  final scope = ref.read(tableControllerProvider(tableId).notifier).scope;
  final sources = ref.read(tableReferenceSourcesProvider);
  Future<List<TableRefCandidate>> walk(
    Future<PageSlice<TableRefCandidate>> Function(PageRequest page) read,
  ) async {
    final out = <TableRefCandidate>[];
    String? cursor;
    for (var i = 0; i < tableRefMaxPages; i++) {
      final page = await read(PageRequest(limit: 200, cursor: cursor));
      out.addAll(page.items);
      cursor = page.nextCursor;
      if (cursor == null) break;
    }
    return out;
  }

  return switch (kind) {
    TableColumnKind.personReference => sources.people(scope),
    TableColumnKind.departmentReference => sources.departments(scope),
    TableColumnKind.taskReference ||
    TableColumnKind.fileReference => walk((p) => sources.tasks(scope, page: p)),
    TableColumnKind.tableReference => walk((p) async {
      final r = await ref.read(tablesRepositoryProvider).list(scope, page: p);
      return r.map((t) => TableRefCandidate(id: t.id, name: t.name));
    }),
    _ => Future.value(const <TableRefCandidate>[]),
  };
}

/// Dosya referansı ikinci adımı: seçilen görevin dosyaları.
@riverpod
Future<List<TableRefCandidate>> tableRefFiles(
  Ref ref,
  String tableId,
  String taskId,
  String taskDepartmentId,
  String taskName,
) async {
  await ref.watch(tableControllerProvider(tableId).future);
  final scope = ref.read(tableControllerProvider(tableId).notifier).scope;
  return ref
      .read(tableReferenceSourcesProvider)
      .files(
        scope,
        TableRefCandidate(
          id: taskId,
          name: taskName,
          departmentId: taskDepartmentId,
        ),
      );
}
