import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/archive.dart';

part 'archive_providers.g.dart';

/// PORT: records arşiv uçlarının kaynağı (`archive_module.dart`'ta sunucu deposu bağlanır).
@Riverpod(keepAlive: true)
ArchiveRepository archiveRepository(Ref ref) => throw UnimplementedError(
  'archiveRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// Arşiv isteklerinin kapsamı: etkin görünümden (`effectiveAccessProvider`; rol ve
/// koordinatörlük seçimi, yoksa varsayılanı). Departman: Koordinatör/Üye görünümünde seçili
/// koordinatörlük; yönetici görünümünde (tüm koordinatörlükler) programın ilk departmanı, yoksa
/// yöneticinin bu programdaki ilk ekip satırı. Hiçbiri
/// yoksa `client.scope_missing` (istek gönderilmez). Yalnız bu iki değer değişince yeniden
/// hesaplanır (görev yazmaları arşivi yeniden okutmaz).
@Riverpod(keepAlive: true)
Future<ArchiveScope> archiveScope(Ref ref) async {
  final scope = ref.watch(scopeStateProvider);
  final pick = await ref.watch(
    taskCatalogControllerProvider.selectAsync((c) {
      final view = c.viewIn(scope);
      final admin = view.isAdminView;
      final program = scope.programId;
      // Yönetici: programın ilk departmanı; liste boşsa (bağlı departman okunamadı) kendi
      // ekip satırlarından ilki (başlık yalnız yetki çözümü içindir, liste dönem geneli).
      final adminDepartment =
          c.departments.firstOrNull?.id ??
          (program == null
              ? null
              : c.access?.seatsIn(program).firstOrNull?.departmentId);
      return (
        department: view.departmentId ?? (admin ? adminDepartment : null),
        admin: admin,
      );
    }),
  );
  final department = pick.department;
  if (department == null || department.isEmpty) {
    throw ApiError(ClientErrorCode.scopeMissing);
  }
  return ArchiveScope(department: department, admin: pick.admin);
}
