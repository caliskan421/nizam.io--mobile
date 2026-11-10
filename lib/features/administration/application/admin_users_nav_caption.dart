import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../domain/admin_user_directory.dart';
import 'admin_controller.dart';

/// Filtrelenmiş sunucu sorgusu alt gezinmede küresel kullanıcı sayısı diye sunulmaz.
final adminUsersNavCaptionProvider = Provider.autoDispose<String?>((ref) {
  final summary = ref.watch(adminUsersSummaryProvider);
  if (summary == null) return null;
  final query = ref.watch(adminUserQueryProvider);
  if (query.search.isNotEmpty ||
      query.role != AdminUserRoleFilter.all ||
      ref.watch(adminUserDepartmentsProvider).isNotEmpty) {
    return null;
  }
  final l = lookupAppLocalizations(ref.watch(localeProvider));
  return '${summary.total.label} ${l.uiUsersNavCountTail}';
});
