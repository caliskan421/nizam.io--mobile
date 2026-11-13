import 'dart:math';

/// SSE akışlarının (sohbet, tablo) ortak yeniden bağlanma kuralları (istemci akışları §10.5,
/// §10.10). Saf fonksiyonlar; bağlantı döngüleri özelliklerin application katmanındadır
/// (`messages/application/chat_sync_controller.dart`, `tables/application/
/// table_sync_controller.dart`). Sohbete özgü sabitler `messages/domain/chat_stream_policy.dart`.
abstract final class StreamReconnect {
  /// Her yeniden bağlanmadan önceki rastgele bekleme üst sınırı (0–5 sn).
  static const jitterMax = Duration(seconds: 5);

  /// Üstel geri çekilmenin tavanı.
  static const backoffMax = Duration(seconds: 60);

  /// Art arda başarısız açılış sınırı: aşılınca akış kapanır; ekran yeniden açılınca ya da
  /// uygulama ön plana dönünce yeniden denenir (kesintisiz döngü hesabın diğer cihazlarını
  /// hesap başına akış tavanından düşürür).
  static const maxFailures = 6;

  /// Bu süreden kısa yaşayan bağlantı başarılı sayılmaz (sayaç sıfırlanmaz).
  static const healthyAfter = Duration(seconds: 10);

  /// Hiç çerçeve gelmezse bağlantı ölü sayılır (sunucu ~25 sn'de bir `: ping` yazar).
  static const idleTimeout = Duration(seconds: 60);
}

/// [failures] art arda başarısız açılıştan sonraki bekleme: 0–5 sn jitter + (failures > 0 ise)
/// 1, 2, 4, 8 … sn (en çok 60 sn).
Duration reconnectDelay(int failures, Random random) {
  final jitter = Duration(
    milliseconds: random.nextInt(StreamReconnect.jitterMax.inMilliseconds + 1),
  );
  if (failures <= 0) return jitter;
  final seconds = failures >= 7 ? 64 : 1 << (failures - 1);
  final backoff = Duration(seconds: seconds) > StreamReconnect.backoffMax
      ? StreamReconnect.backoffMax
      : Duration(seconds: seconds);
  return backoff + jitter;
}

/// Akış hatasında karar: yeniden dene ya da dur.
enum StreamErrorAction { retry, stop }

/// Akış açılış/okuma hatasının kararı. 401 (kimlik halkası belirteci zaten bir kez yeniledi;
/// oturum düştüyse yeniden giriş akışı devralır), 403 (yetki), 404 ve 422 (kapsam) durur;
/// 429 `Retry-After`'a uyarak, ağ/zaman aşımı/5xx geri çekilmeyle yeniden dener. İstemci
/// kodlarından yalnız ağ, zaman aşımı ve geçersiz yanıt yeniden denenir (oturum, bağ, kapsam,
/// TLS ve sürüm kodları durur).
StreamErrorAction streamErrorAction({
  required int? status,
  required String code,
}) {
  if (code.startsWith('client.')) {
    return const {
          'client.network_error',
          'client.timeout',
          'client.invalid_response',
        }.contains(code)
        ? StreamErrorAction.retry
        : StreamErrorAction.stop;
  }
  return switch (status) {
    401 || 403 || 404 || 422 => StreamErrorAction.stop,
    _ => StreamErrorAction.retry,
  };
}

/// Bağlantı bittikten sonraki ardışık başarısızlık sayısı: [StreamReconnect.healthyAfter]
/// kadar yaşamış açık bağlantı sayacı sıfırlar; açılamayan ya da hemen kapanan bağlantı
/// sayacı artırır.
int nextFailures(int failures, {required Duration? lived}) =>
    lived != null && lived >= StreamReconnect.healthyAfter ? 0 : failures + 1;
