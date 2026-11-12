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
final mobileReleasePolicyProvider = StreamProvider<MobileReleasePolicy>((ref) {
  final source = ref.watch(releasePolicySourceProvider);
  if (source is CachedReleasePolicySource) return _cachedPolicies(source);
  // Start a one-shot source and attach its error handler in this turn. async*
  // defers its body and could leave an already-started source future unhandled.
  return Stream<MobileReleasePolicy>.fromFuture(source.fetch());
});

Stream<MobileReleasePolicy> _cachedPolicies(
  CachedReleasePolicySource source,
) async* {
  try {
    yield await source.readCached();
  } on Object catch (error, stack) {
    yield* Stream<MobileReleasePolicy>.error(error, stack);
  }
  yield await source.fetch();
}
