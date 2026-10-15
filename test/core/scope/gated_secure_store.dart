// Hata/yarış benzetimli güvenli depo: [gateKey] için yazma [gate] açılana dek bekler;
// [failReads] okumayı düşürür. Yalnız testler.
import 'dart:async';

import 'package:nizamio/core/storage/secure_store.dart';

class GatedSecureStore extends MemorySecureStore {
  String? gateKey;
  Completer<void>? gate;
  bool failReads = false;
  int deleteCalls = 0;

  /// [key] yazımını [gate] tamamlanana dek tutar.
  void holdWrites(String key) {
    gateKey = key;
    gate = Completer<void>();
  }

  void release() => gate?.complete();

  @override
  Future<String?> read(String key) async {
    if (failReads) {
      throw StateError('GatedSecureStore: okuma hatası (benzetim)');
    }
    return super.read(key);
  }

  @override
  Future<void> write(String key, String value) async {
    if (key == gateKey) {
      await gate!.future;
    }
    return super.write(key, value);
  }

  @override
  Future<void> delete(String key) {
    deleteCalls++;
    return super.delete(key);
  }
}
