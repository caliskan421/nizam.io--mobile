import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'push_notifications.dart';

/// Platform portu; somut örneğin ve yaşam döngüsünün sahibi bileşim köküdür.
final pushNotificationsProvider = Provider<PushNotifications>(
  (ref) => throw UnimplementedError(
    'pushNotificationsProvider bileşim kökünde bağlanır',
  ),
);
