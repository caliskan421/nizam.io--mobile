import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/chat.dart';
import '../domain/company_admin_index.dart';
import 'messages_providers.dart';

/// Admin çağıranın grup adayları şirket yöneticilerini de kapsar; çağıran hariçtir.
/// Başka amaçla alınan veya bir sohbetin üyelerini dışlayan listeler kullanılmaz.
final companyAdminIndexProvider = FutureProvider.autoDispose<CompanyAdminIndex>(
  (ref) async {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider.select((s) => s.programId));
    final access = await ref.watch(
      taskCatalogControllerProvider.selectAsync(
        (catalog) => (
          accountId: catalog.access?.accountId,
          admin: catalog.access?.companyAdmin == true,
        ),
      ),
    );
    final accountId = access.accountId;
    if (!access.admin || accountId == null) {
      throw ApiError('organization.not_authorized');
    }
    final candidates = await ref
        .read(chatRepositoryProvider)
        .candidates(ChatCandidatePurpose.group);
    return CompanyAdminIndex([
      accountId,
      for (final candidate in candidates.items)
        if (candidate.role == ChatCandidateRole.companyAdmin)
          candidate.accountId,
    ], complete: !candidates.truncated);
  },
);
