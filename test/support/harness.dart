// Gerçek provider bağlarıyla (lib/core/providers.dart) sahte bağdaştırıcı + bellek deposu.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';

import 'fake_backend.dart';

class Harness {
  Harness({
    Flavor flavor = Flavor.prod,
    FakeHandler? handler,
    MemorySecureStore? store,
  }) : backend = FakeBackend(handler ?? discoveryHandler),
       store = store ?? MemorySecureStore() {
    // Gerçek bileşim kökü (lib/app/di, get_it + Riverpod portları); yalnız depo ve HTTP
    // bağdaştırıcısı sahte.
    composition = Composition.create(
      flavor: flavor,
      secureStore: this.store,
      httpAdapter: backend,
    );
  }

  final FakeBackend backend;
  final MemorySecureStore store;
  late final Composition composition;
  ProviderContainer get container => composition.container;

  T read<T>(ProviderListenable<T> p) => container.read(p);

  IdentityService get identity => read(identityServiceProvider);

  Future<void> dispose() => composition.dispose();
}

const testUrl = 'https://nizam.example.test';

Map<String, Object?> loginBody(String n, {bool force = false}) => {
  'account_id': 'acc-1',
  'access_token': 'access-token-$n',
  'refresh_token': 'refresh-token-$n',
  'expires_at': 4102444800,
  'refresh_expires_at': 4102444800,
  'force_password_change': force,
};
