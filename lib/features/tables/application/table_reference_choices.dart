import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tasks/tasks.dart';
import '../domain/table_document.dart';
import 'tables_controller.dart';

/// Etiketler gerçek katalogdan gelir. Sunucu yazım anında hedef görünürlüğünü
/// yeniden doğrular; görünmeyen kimlik hiçbir seçicide gösterilmez.
final tableReferenceChoicesProvider = FutureProvider.autoDispose
    .family<
      Map<TableStepId, String>,
      ({TableFieldType type, String department})
    >((ref, query) async {
      if (query.type == TableFieldType.link) {
        return {
          for (final table in ref.watch(tablesControllerProvider).documents)
            if (table.unit == query.department)
              TableStepId(table.id): table.title,
        };
      }
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      return switch (query.type) {
        TableFieldType.person => {
          for (final p in catalog.people)
            if (query.department.isEmpty ||
                p.role == PersonRole.admin ||
                catalog.coordinatorships.any(
                  (d) =>
                      d.code == query.department &&
                      (d.leads.contains(p.id) || d.members.contains(p.id)),
                ))
              TableStepId(p.id): p.name,
        },
        TableFieldType.unit => {
          for (final d in catalog.departments) TableStepId(d.id): d.name,
        },
        TableFieldType.task => {
          for (final t in catalog.tasks) TableStepId(t.id): t.title,
        },
        TableFieldType.file => {
          for (final t in catalog.tasks)
            for (final f in t.fileEntries) TableStepId(f.id): f.name,
        },
        _ => {},
      };
    }, dependencies: [taskCatalogControllerProvider, tablesControllerProvider]);

final tableFileReferenceChoicesProvider = FutureProvider.autoDispose
    .family<Map<TableStepId, String>, String>(
      (ref, taskId) async {
        final catalog = await ref.watch(taskCatalogControllerProvider.future);
        final task = catalog.tasks.where((t) => t.id == taskId).firstOrNull;
        if (task == null) return {};
        final detail = await ref
            .read(taskDetailsRepositoryProvider)
            .load(task, access: catalog.access);
        return {for (final f in detail.files) TableStepId(f.id): f.name};
      },
      dependencies: [
        taskCatalogControllerProvider,
        taskDetailsRepositoryProvider,
      ],
    );
