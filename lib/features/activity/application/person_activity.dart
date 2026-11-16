import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../domain/activity_log.dart';
import 'activity_providers.dart';

part 'person_activity.g.dart';

/// Kişinin işlem geçmişi (`actor_account_id` süzgeci; kullanıcı ayrıntısı). Yalnız şirket
/// yöneticisi okur; diğerlerinde [ActivityUnavailable].
@riverpod
Future<ActivityLog> personActivity(Ref ref, String accountId) {
  ref.watch(sessionGenerationProvider);
  return ref
      .read(activityLogRepositoryProvider)
      .load(actorAccountId: accountId);
}
