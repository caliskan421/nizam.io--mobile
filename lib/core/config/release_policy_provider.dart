import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mobile_release_policy.dart';

/// Kaynağın yaşam döngüsü bileşim köküne aittir; core Firebase tanımaz.
final releasePolicySourceProvider = Provider<ReleasePolicySource>(
  (ref) => throw UnimplementedError(
    'releasePolicySourceProvider bileşim kökünde bağlanır',
  ),
);

/// Geçerli süreçte tek politika okuması; UI bağlantısı bu reaktif yüzü izler.
/// Başarısız istek kendiliğinden tekrarlanmaz (container retry politikası).
final mobileReleasePolicyProvider = FutureProvider<MobileReleasePolicy>(
  (ref) => ref.watch(releasePolicySourceProvider).fetch(),
);
