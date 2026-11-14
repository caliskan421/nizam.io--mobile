import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/providers.dart';
import '../domain/coordinator_board.dart';
import '../domain/task_catalog.dart';
import 'effective_access.dart';
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

/// Koordinatör görünümünün panosu (ana sayfa bölümleri, görev listesi bandı): etkin
/// koordinatörlüğün görevlerinden istemcide türetilir ([scopedTasks]). Ekip yükü ucu
/// koordinatöre kapalı olduğundan yük de görünen görevlerden sayılır ([teamLoad]).
@immutable
final class CoordinatorBoard {
  CoordinatorBoard({
    required this.departmentId,
    required this.departmentName,
    required List<TaskItem> tasks,
    required this.truncated,
    List<String> team = const [],
  }) : tasks = List.unmodifiable(tasks),
       summary = summarizeTasks(tasks),
       queue = approvalQueue(tasks),
       unassigned = unassignedTasks(tasks),
       load = teamLoad(tasks, team: team);

  final String departmentId;
  final String departmentName;

  /// Etkin koordinatörlüğün görünen görevleri.
  final List<TaskItem> tasks;

  /// Kaynak katalog sayfa tavanında kesildi (sayılar eksik olabilir).
  final bool truncated;
  final CoordinatorSummary summary;
  final List<TaskItem> queue;
  final List<TaskItem> unassigned;
  final List<TeamLoad> load;
}

/// Koordinatör görünümünde pano; başka görünümde ya da katalog yokken null.
final coordinatorBoardProvider = Provider.autoDispose<CoordinatorBoard?>((ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  final view = ref.watch(effectiveAccessProvider);
  final dept = view.departmentId;
  if (catalog == null || !view.isCoordinatorView || dept == null) return null;
  final coord = catalog.coordinatorship(dept);
  return CoordinatorBoard(
    departmentId: dept,
    departmentName: view.departmentName ?? coord?.name ?? '',
    tasks: scopedTasks(
      catalog.tasks,
      role: view.role,
      departmentId: dept,
      me: catalog.me,
    ),
    truncated: catalog.truncated,
    team: coord?.team ?? const [],
  );
});

/// Çağıranın etkin koordinatörlükteki tarih talepleri (`GET …/date-change-requests/mine`):
/// yalnız talep açabilen görünümde (koordinatör) ve koordinatörlük seçiliyken; diğerlerinde
/// boş liste (istek yok). Oturum, kapsam ya da görev satırları değişince (talep sonrası
/// yeniden okuma dahil) yeniden okunur.
final myDateRequestsProvider =
    FutureProvider.autoDispose<List<DateChangeRequest>>((ref) async {
      ref.watch(sessionGenerationProvider);
      ref.watch(taskCatalogControllerProvider.select((s) => s.value?.tasks));
      final view = ref.watch(effectiveAccessProvider);
      final program = view.programId;
      final dept = view.departmentId;
      if (!view.canRequestDate || program == null || dept == null) {
        return const [];
      }
      return ref
          .read(taskWriteRepositoryProvider)
          .listMyDateRequests(program, dept);
    });
