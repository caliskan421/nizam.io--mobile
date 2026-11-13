import 'dart:collection';

import '../../../core/domain/stream_reconnect.dart';

export '../../../core/domain/stream_reconnect.dart'
    show StreamErrorAction, nextFailures, reconnectDelay, streamErrorAction;

/// Sohbet akışının (SSE) zamanlama kuralları (istemci akışları §10.5, §10.10; F60 devir).
/// Yeniden bağlanmanın ortak kısmı (geri çekilme, hata kararı, sağlıklı bağlantı) tablo
/// akışıyla paylaşılır: `core/domain/stream_reconnect.dart` (buradan yeniden dışa verilir).
/// Bağlantı döngüsü `application/chat_sync_controller.dart`.
abstract final class ChatStreamPolicy {
  /// Her yeniden bağlanmadan önceki rastgele bekleme üst sınırı (0–5 sn).
  static const jitterMax = StreamReconnect.jitterMax;

  /// Üstel geri çekilmenin tavanı.
  static const backoffMax = StreamReconnect.backoffMax;

  /// Art arda başarısız açılış sınırı: aşılınca akış kapanır, ekran yeniden açılınca ya da
  /// uygulama ön plana dönünce yeniden denenir (kesintisiz döngü aynı hesabın diğer cihazlarını
  /// 12 akış tavanından düşürür).
  static const maxFailures = StreamReconnect.maxFailures;

  /// Bu süreden kısa yaşayan bağlantı başarılı sayılmaz (sayaç sıfırlanmaz).
  static const healthyAfter = StreamReconnect.healthyAfter;

  /// Hiç çerçeve gelmezse bağlantı ölü sayılır (sunucu ~25 sn'de bir `: ping` yazar).
  static const idleTimeout = StreamReconnect.idleTimeout;

  /// Olaylar en az bu kadar birleştirilip sohbet başına tek okuma yapılır.
  static const coalesce = Duration(seconds: 1);

  /// "Yazıyor" sinyali en az bu aralıkla gönderilir (ucuz sinyal kovası 180/dk).
  static const typingInterval = Duration(seconds: 3);

  /// İstemcinin dakikadaki ucuz sinyal (yazıyor + okundu) tavanı. Sunucu kovası hesap başına
  /// 180/dk'dır (ADR-0028); bildirim okundu ve diğer cihazlar da aynı kovadan yer, pay bırakılır.
  static const signalsPerMinute = 120;

  /// Karşı tarafın "yazıyor" bilgisi son olaydan sonra bu kadar görünür.
  static const typingShownFor = Duration(seconds: 6);
}

/// Ucuz sinyal kovası (yazıyor + okundu): son bir dakikada [limit] sinyal gönderildiyse yenisi
/// gönderilmez. Açık sohbetler aynı kovayı paylaşır (tablet izinde birden çok sohbet açık olabilir).
final class SignalBudget {
  SignalBudget({this.limit = ChatStreamPolicy.signalsPerMinute});

  final int limit;
  final _sent = Queue<DateTime>();

  /// [now] anında bir sinyal için yer varsa ayırır ve true döner.
  bool take(DateTime now) {
    while (_sent.isNotEmpty &&
        now.difference(_sent.first) >= const Duration(minutes: 1)) {
      _sent.removeFirst();
    }
    if (_sent.length >= limit) return false;
    _sent.add(now);
    return true;
  }

  /// Kova doluysa [now]'dan ilk yerin açılmasına kalan süre; dolu değilse sıfır.
  Duration retryIn(DateTime now) {
    if (_sent.length < limit) return Duration.zero;
    if (_sent.isEmpty) return const Duration(minutes: 1);
    final left = const Duration(minutes: 1) - now.difference(_sent.first);
    return left.isNegative ? Duration.zero : left;
  }
}
