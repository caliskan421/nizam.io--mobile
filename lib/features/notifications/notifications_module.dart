import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/notifications_providers.dart';
import 'data/notification_api_repository.dart';
import 'domain/notification_repository.dart';

/// notifications modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerNotificationsModule(
  GetIt locator, {
  required Dio? Function() apiDio,
}) {
  locator.registerLazySingleton<NotificationRepository>(
    () => ApiNotificationRepository(apiDio),
  );
}

/// notifications'ın Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> notificationsOverrides(GetIt locator) => [
  notificationRepositoryProvider.overrideWith(
    (ref) => locator<NotificationRepository>(),
  ),
];
