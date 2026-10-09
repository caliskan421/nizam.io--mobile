// Gerçek provider bağlarıyla (lib/core/providers.dart) sahte bağdaştırıcı + bellek deposu.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';

import 'fake_backend.dart';

class Harness {
  Harness({Flavor flavor = Flavor.prod, FakeHandler? handler})
    : backend = FakeBackend(handler ?? discoveryHandler),
      store = MemorySecureStore() {
    container = ProviderContainer(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        secureStoreProvider.overrideWithValue(store),
        httpAdapterProvider.overrideWithValue(backend),
      ],
    );
  }

  final FakeBackend backend;
  final MemorySecureStore store;
  late final ProviderContainer container;

  T read<T>(ProviderListenable<T> p) => container.read(p);

  IdentityService get identity => read(identityServiceProvider);

  void dispose() => container.dispose();
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
