import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/release_policy_provider.dart';

/// İlk kareden sonra çağrılır; politika okuması giriş/açılış akışını bekletmez.
/// Ham SDK hatası uygulama günlüğüne veya başka bir Firebase servisine taşınmaz.
Future<void> warmReleasePolicy(ProviderContainer container) async {
  final ready = Completer<void>();
  // StreamProvider pauses a stream with no listeners. A read of .future alone
  // does not keep it active; hold a listener until its first data/error event.
  final subscription = container.listen(mobileReleasePolicyProvider, (_, next) {
    if ((next.hasValue || next.hasError) && !ready.isCompleted) {
      ready.complete();
    }
  }, fireImmediately: true);
  try {
    await ready.future;
  } finally {
    subscription.close();
  }
}
