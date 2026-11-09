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

  /// [state] bir değer taşıyor, yüklenmiyor, son okuma hatasız ve veri [maxAge]'den eskiyse
  /// [refresh]'i bekler. Bu otomatik yoldur (sekmeye/ön plana dönüş): hiç yüklenmemiş, zaten
  /// yüklenen ya da son okuması hatayla bitmiş (429 dahil; `Retry-After` beklemesi) durumda
  /// bir şey yapmaz — hata sonrası yeniden deneme yalnız kullanıcı eylemiyle (aşağı çekme,
  /// "yeniden dene"). Hata yutulur ve bildirilmez: durumda kalır, önceki veri görünür.
  Future<void> refreshIfStale(
    AsyncValue<Object?> state,
    Future<void> Function() refresh, {
    Duration maxAge = staleAfter,
  }) async {
    if (state.isLoading ||
        !state.hasValue ||
        state.hasError ||
        !isStale(maxAge)) {
      return;
    }
    try {
      await refresh();
    } on Object {
      // Otomatik yol sessizdir: hata durumda, veri yerinde; sonraki deneme kullanıcıdan.
    }
  }
}
