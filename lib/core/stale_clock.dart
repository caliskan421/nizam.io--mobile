import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Bayat veri saati: son başarılı okumadan beri geçen süre ve "yeniden ziyarette bayatsa
/// arka planda tazele" kuralı. Controller alanı olarak tutulur (notifier yeniden kurulumlarda
/// korunur); `build` başarıyla bitince [markFresh] çağrılır.
class StaleClock {
  /// Yeniden ziyarette (sekmeye dönüş, ön plana dönüş) verinin taze sayıldığı süre.
  static const staleAfter = Duration(seconds: 30);

  final _age = Stopwatch();

  /// Başarılı okuma bitti: süre sıfırdan başlar.
  void markFresh() => _age
    ..reset()
    ..start();

  /// Hiç başarılı okuma yoksa ya da son okuma [maxAge]'den eskiyse true.
  bool isStale([Duration maxAge = staleAfter]) =>
      !_age.isRunning || _age.elapsed >= maxAge;

  /// [state] bir değer taşıyor, yüklenmiyor ve veri [maxAge]'den eskiyse [refresh]'i bekler.
  /// Hiç yüklenmemiş (ilk yükleme hatası yalnız dokunuşla yeniden denenir) ya da zaten
  /// yüklenen durumda bir şey yapmaz. Hata yutulur: durumda kalır, önceki veri görünür.
  Future<void> refreshIfStale(
    AsyncValue<Object?> state,
    Future<void> Function() refresh, {
    Duration maxAge = staleAfter,
  }) async {
    if (state.isLoading || !state.hasValue || !isStale(maxAge)) return;
    try {
      await refresh();
    } on Object {
      // Arka plan yenilemesi: hata durumda, veri yerinde.
    }
  }
}
