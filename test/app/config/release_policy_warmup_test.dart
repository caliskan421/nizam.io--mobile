import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/config/release_policy_warmup.dart';
import 'package:nizamio/core/config/mobile_release_policy.dart';
import 'package:nizamio/core/config/release_policy_provider.dart';

void main() {
  test(
    'okuma reaktif sağlayıcıda tutulur; tekrar ısıtma yeni ağ isteği yapmaz',
    () async {
      final source = _Source();
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [releasePolicySourceProvider.overrideWithValue(source)],
      );
      addTearDown(container.dispose);
      await warmReleasePolicy(container);
      await warmReleasePolicy(container);
      expect(source.calls, 1);
      expect(container.read(mobileReleasePolicyProvider).hasValue, isTrue);
    },
  );

  test(
    'yavaş okuma başlatılabilir; hata sağlayıcıda kalır ve dışarı fırlamaz',
    () async {
      final source = _Source()..pending = Completer<MobileReleasePolicy>();
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [releasePolicySourceProvider.overrideWithValue(source)],
      );
      addTearDown(container.dispose);
      final warmup = warmReleasePolicy(container);
      expect(container.read(mobileReleasePolicyProvider).isLoading, isTrue);
      source.pending!.completeError(StateError('synthetic SDK failure'));
      await warmup;
      expect(container.read(mobileReleasePolicyProvider).hasError, isTrue);
      expect(source.calls, 1);
    },
  );
}

class _Source implements ReleasePolicySource {
  int calls = 0;
  Completer<MobileReleasePolicy>? pending;

  @override
  Future<MobileReleasePolicy> fetch() async {
    calls++;
    return pending?.future ?? const MobileReleasePolicy.disabled();
  }
}
