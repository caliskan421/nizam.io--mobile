import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Arşiv isteklerinin kapsamı: rol görev kataloğunun erişim bilgisinden (`/v1/me` +
/// `/v1/me/departments`) okunur. Departman: programdaki ilk koordinatörlük, yoksa ilk ekip
/// satırı; ekip satırı olmayan yöneticide programın ilk departmanı. Hiçbiri yoksa
/// `client.scope_missing` (istek gönderilmez). Katalog yalnız bu iki değer değişince yeniden
/// hesaplatır (görev yazmaları arşivi yeniden okutmaz).
@Riverpod(keepAlive: true)
Future<ArchiveScope> archiveScope(Ref ref) async {
  final program = ref.watch(scopeStateProvider.select((s) => s.programId));
  final pick = await ref.watch(
    taskCatalogControllerProvider.selectAsync((c) {
      final access = c.access;
      final admin = access?.companyAdmin ?? false;
      final seat = program == null
          ? null
          : access?.primaryDepartmentIn(program);
      return (
        department: seat ?? (admin ? c.departments.firstOrNull?.id : null),
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
