import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/notification_repository.dart';

part 'notifications_providers.g.dart';

/// PORT: bildirim uçlarının kaynağı (`notifications_module.dart`'ta sunucu gerçekleştirmesi
/// bağlanır).
@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) =>
    throw UnimplementedError(
      'notificationRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
