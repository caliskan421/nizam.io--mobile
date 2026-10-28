import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/activity_log.dart';

part 'activity_providers.g.dart';

/// PORT: işlem geçmişinin kaynağı (`activity_module.dart`'ta bağlanır; bugün geliştirme örneği).
@Riverpod(keepAlive: true)
ActivityLogRepository activityLogRepository(Ref ref) =>
    throw UnimplementedError(
      'activityLogRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
