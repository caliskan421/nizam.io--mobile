import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../tasks/tasks.dart';
import '../domain/department_delete.dart';
import 'coordinatorship_detail_controller.dart';
import 'coordinatorship_profiles_controller.dart';
import 'coordinatorships_providers.dart';

/// Silme onayının etki önizlemesi (`GET /v1/departments/{id}/delete-impact`). Onay sayfası
/// açıkken yaşar; oturum değişince yeniden okunur. Hata [ApiError]'dır.
final departmentDeleteImpactProvider = FutureProvider.autoDispose
    .family<DepartmentDeleteImpact, String>((ref, departmentId) {
      ref.watch(sessionGenerationProvider);
      return ref.read(departmentRepositoryProvider).deleteImpact(departmentId);
    });

/// Silme sonucu ya da hata (biri dolu).
typedef DeleteOutcome<T> = ({T? result, ApiError? error});

/// Koordinatörlüğü geri alınabilir siler (`DELETE /v1/departments/{id}`): görevler bütün
/// programlarda "Silinenler"e taşınır. Başarıda koordinatörlük kataloğu, ayrıntı kaydı ve
/// görev kataloğu (sayaçlar) yeniden okunur. Hata yakalanır, raporlanır ve döner (E1).
/// Oturum yazma sırasında değişirse yenileme yapılmaz.
Future<DeleteOutcome<DepartmentDeleteResult>> deleteCoordinatorship(
  ProviderContainer ref,
  String departmentId,
) async {
  final session = ref.read(sessionGenerationProvider);
  final DepartmentDeleteResult result;
  try {
    result = await ref
        .read(departmentRepositoryProvider)
        .deleteDepartment(departmentId);
  } on Object catch (e, st) {
    final error = toReportedApiError(
      e,
      st,
      source: ReportSource.coordinatorships,
    );
    return (result: null, error: error);
  }
  if (ref.read(sessionGenerationProvider) != session) {
    return (result: result, error: null);
  }
  ref
    ..invalidate(coordinatorshipProfilesControllerProvider)
    ..invalidate(programDepartmentProvider);
  try {
    await ref.read(taskCatalogControllerProvider.notifier).reload();
  } on Object catch (e, st) {
    reportUnexpected(e, st, source: ReportSource.coordinatorships);
    /* Okuma durumu kendi sağlayıcısında görünür. */
  }
  return (result: result, error: null);
}
