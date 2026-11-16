import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/effective_role.dart';
import 'providers.dart';

/// Uygulama ömrünce yaşayan (keepAlive) önbelleğin sahibi: oturum nesli + seçili etkin görünüm
/// (program, koordinatörlük, rol; ADR-0003 karar 20 uzantısı). Rol ya da koordinatörlük
/// değişince kabuk yeniden kurulmaz ama sahibe bağlı önbellekler düşer.
typedef CacheOwner = ({
  int session,
  String? program,
  String? department,
  EffectiveRole? role,
});

/// Önbellek değerinin sahipliği. Değer yalnız okunduğu sahip için gösterilir: çıkış, başka
/// hesap ya da kurulum (oturum nesli), başka program, rol ya da koordinatörlük seçilince önceki
/// değer ekrandan düşer;
/// yeni sahibin okuması sürerken yükleniyor, düşerse yalnız hata görünür ([visible]).
///
/// Controller alanı olarak tutulur: `build` başında [watch] (sahip değişimi yeniden kurulumdur),
/// okuma başarıyla bitince [markLoaded].
final class CacheOwnership {
  CacheOwnership() : _programWide = false;

  /// Rol ve koordinatörlükten bağımsız önbellek: sahip yalnız oturum + program. YALNIZ etkin
  /// görünümün kaynağı olan görev kataloğu içindir (rolü katalog verir; rol değişiminde
  /// yeniden okunması erişimi bir an kaybettirir).
  CacheOwnership.programWide() : _programWide = true;

  final bool _programWide;
  CacheOwner? _loaded;

  /// Şimdiki sahip; `build` içinde çağrılır, sahip değişince sağlayıcı yeniden kurulur.
  CacheOwner watch(Ref ref) => (
    session: ref.watch(sessionGenerationProvider),
    program: ref.watch(scopeStateProvider.select((s) => s.programId)),
    department: _programWide
        ? null
        : ref.watch(scopeStateProvider.select((s) => s.departmentId)),
    role: _programWide
        ? null
        : ref.watch(scopeStateProvider.select((s) => s.role)),
  );

  /// [owner] için okuma bitti. Okuma sürerken sahip değiştiyse (geç gelen eski yanıt) yok sayılır.
  void markLoaded(Ref ref, CacheOwner owner) {
    if (current(ref) == owner) _loaded = owner;
  }

  /// Durumdaki değer şimdiki sahibe mi ait.
  bool owns(Ref ref) => _loaded != null && _loaded == current(ref);

  /// Şimdiki sahip, izlemeden (uçuştaki okumanın bayatlık denetimi).
  CacheOwner current(Ref ref) {
    final scope = ref.read(scopeStateProvider);
    return (
      session: ref.read(sessionGenerationProvider),
      program: scope.programId,
      department: _programWide ? null : scope.departmentId,
      role: _programWide ? null : scope.role,
    );
  }

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
