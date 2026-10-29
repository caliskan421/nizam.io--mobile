import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/models/coordinatorship_stat.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/coordinatorship_stats_repository.dart';

/// `CoordinatorshipStat` → [CoordinatorshipStats] eşleyicisi ve reporting ucuna erişim.
/// DTO bu katmanda kalır (A1/A2); hatalar [ApiError] olarak fırlar.
class ApiCoordinatorshipStatsRepository
    implements CoordinatorshipStatsRepository {
  ApiCoordinatorshipStatsRepository(Dio dio) : _client = ReportingClient(dio);

  static const truncationHeader = 'X-Result-Truncated';

  final ReportingClient _client;

  @override
  Future<PageSlice<CoordinatorshipStats>> load() async {
    final r = await apiCall(_client.reportDashboardCoordinatorships);
    final values = r.response.headers[truncationHeader];
    return PageSlice(
      items: r.data.coordinatorships.map(_stats).toList(),
      truncated: values != null && values.length == 1 && values[0] == 'true',
    );
  }

  /// Örtüşme: `code` ← `department_id` (kısa kod backend'de yok), `name`, `done` ←
  /// `completed_tasks`, `total` ← `total_tasks`, `late` ← `overdue_tasks`, `leads` ←
  /// `coordinators` (rol [PersonRole.coordinator]). `members` boş: sunucu yalnız
  /// `member_count` verir.
  static CoordinatorshipStats _stats(CoordinatorshipStat s) =>
      CoordinatorshipStats(
        code: s.departmentId,
        name: s.name,
        done: s.completedTasks,
        total: s.totalTasks,
        late: s.overdueTasks,
        leads: [
          for (final p in s.coordinators)
            Person(
              id: p.accountId,
              name: p.fullName,
              role: PersonRole.coordinator,
            ),
        ],
        members: const [],
      );
}
