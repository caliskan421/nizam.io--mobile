import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class UpdateStore {
  bool get available;
  Future<bool> open();
}

final class UnavailableUpdateStore implements UpdateStore {
  const UnavailableUpdateStore();
  @override
  bool get available => false;
  @override
  Future<bool> open() async => false;
}

final updateStoreProvider = Provider<UpdateStore>(
  (ref) => const UnavailableUpdateStore(),
);
