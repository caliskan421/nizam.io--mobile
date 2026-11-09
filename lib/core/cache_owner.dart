import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// Uygulama ömrünce yaşayan (keepAlive) önbelleğin sahibi: oturum nesli + seçili program.
typedef CacheOwner = ({int session, String? program});

/// Önbellek değerinin sahipliği. Değer yalnız okunduğu sahip için gösterilir: çıkış, başka
/// hesap ya da kurulum (oturum nesli) veya başka program seçilince önceki değer ekrandan düşer;
/// yeni sahibin okuması sürerken yükleniyor, düşerse yalnız hata görünür ([visible]).
///
/// Controller alanı olarak tutulur: `build` başında [watch] (sahip değişimi yeniden kurulumdur),
/// okuma başarıyla bitince [markLoaded].
final class CacheOwnership {
  CacheOwner? _loaded;

  /// Şimdiki sahip; `build` içinde çağrılır, sahip değişince sağlayıcı yeniden kurulur.
  CacheOwner watch(Ref ref) => (
    session: ref.watch(sessionGenerationProvider),
    program: ref.watch(scopeStateProvider.select((s) => s.programId)),
  );

  /// [owner] için okuma bitti. Okuma sürerken sahip değiştiyse (geç gelen eski yanıt) yok sayılır.
  void markLoaded(Ref ref, CacheOwner owner) {
    if (_current(ref) == owner) _loaded = owner;
  }

  /// Durumdaki değer şimdiki sahibe mi ait.
  bool owns(Ref ref) => _loaded != null && _loaded == _current(ref);

  static CacheOwner _current(Ref ref) => (
    session: ref.read(sessionGenerationProvider),
    program: ref.read(scopeStateProvider).programId,
  );

  /// Ekranın gösterebileceği durum (bkz. [ownedOnly]).
  AsyncValue<T> visible<T>(Ref ref, AsyncValue<T> state) =>
      ownedOnly(state, owned: owns(ref));

  /// [owned] değilse önceki değer düşülür: hata varsa yalnız hata, yoksa yükleniyor.
  static AsyncValue<T> ownedOnly<T>(
    AsyncValue<T> state, {
    required bool owned,
  }) {
    if (owned) return state;
    if (state case AsyncError(:final error, :final stackTrace)
        when !state.isLoading) {
      return AsyncError<T>(error, stackTrace);
    }
    return AsyncLoading<T>();
  }
}
