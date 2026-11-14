import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../domain/admin_user_directory.dart';
import '../domain/team_view.dart';
import 'admin_controller.dart';
import 'team_controller.dart';

/// Filtrelenmiş sunucu sorgusu alt gezinmede küresel kullanıcı sayısı diye sunulmaz.
/// Koordinatör/üye görünümünde ("Ekibim") etkin koordinatörlüğün kişi sayısı.
final adminUsersNavCaptionProvider = Provider.autoDispose<String?>((ref) {
  if (ref.watch(teamSourceProvider) != TeamSource.directory) {
    final team = ref.watch(teamRosterProvider).value;
    if (team == null || !team.available) return null;
    final l = lookupAppLocalizations(ref.watch(localeProvider));
    return '${team.people.length} ${l.uiUsersTeamPeople}';
  }
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
