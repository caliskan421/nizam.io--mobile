import 'package:meta/meta.dart';

// Görüntülü görüşme odası (istemci tarafı). Sağlayıcı (LiveKit) bu dosyada geçmez: oda bağı
// [ConferenceLink] portunun arkasındadır (gerçekleştirme `data/livekit_conference_link.dart`,
// testte sahte). Katılım token'ı ve oda adresi `joinConference`'tan gelir
// ([ConferenceJoinToken]); burada saklanmaz.

/// Görüşme oda kapasitesi (ürün metni "en çok 25 kişi"; kart ve görüşme üst satırı "3 / 25").
const conferenceCapacity = 25;

/// Ekran durumu: boşta → bağlanıyor → bağlı ⇄ yeniden bağlanıyor → bitti; katılım ya da bağlantı
/// kurulamazsa hata.
enum ConferencePhase {
  idle,
  connecting,
  connected,
  reconnecting,
  ended,
  failed,
}

/// Mikrofon/kamera açılamadı: izin verilmedi ya da cihazda yok (simülatörde kamera yoktur).
enum MediaIssue { denied, unavailable }

/// Odadan çıkış nedeni.
enum ConferenceEnd {
  /// Kullanıcı ayrıldı.
  left,

  /// Kullanıcı konferansı herkes için bitirdi.
  endedForAll,

  /// Oda kapandı (başka bir yönetici bitirdi ya da toplantı silindi).
  closed,

  /// Sunucu odadan çıkardı (toplantıya erişim kalktı, COLLABORATION-K60).
  removed,

  /// Aynı hesapla başka cihazdan katılındı (katılımcı kimliği hesaptır, K45).
  replaced,

  /// Bağlantı koptu ve yeniden kurulamadı.
  lost,
}

/// Odadaki bir kişi (anlık görüntü). [video] sağlayıcının görüntü izidir; yalnız sunum
/// katmanındaki çizici tanır (domain için opak).
@immutable
final class ConferencePeer {
  const ConferencePeer({
    required this.id,
    required this.name,
    required this.isLocal,
    this.micOn = false,
    this.cameraOn = false,
    this.speaking = false,
    this.video,
  });

  /// Katılımcı kimliği = NIZAM hesap kimliği.
  final String id;

  /// Token'daki görünen ad (boş olabilir; sunum katılımcı listesinden tamamlar).
  final String name;
  final bool isLocal;
  final bool micOn;
  final bool cameraOn;
  final bool speaking;
  final Object? video;
}

/// Oda bağından gelen olay.
sealed class ConferenceSignal {
  const ConferenceSignal();
}

/// Kişi, iz ya da konuşan değişti ([ConferenceLink.peers] yeniden okunur).
final class ConferencePeersChanged extends ConferenceSignal {
  const ConferencePeersChanged();
}

/// Bağlantı koptu; sağlayıcı kendiliğinden yeniden deniyor.
final class ConferenceReconnecting extends ConferenceSignal {
  const ConferenceReconnecting();
}

final class ConferenceReconnected extends ConferenceSignal {
  const ConferenceReconnected();
}

/// Oda bağı kalıcı olarak kapandı.
final class ConferenceDropped extends ConferenceSignal {
  const ConferenceDropped(this.end);
  final ConferenceEnd end;
}

/// PORT: tek oda bağı (her katılım yeni nesne). Token yalnız [connect]'e verilir; gerçekleştirme
/// onu saklamaz, log'a ve hata metnine yazmaz (COLLABORATION-K49).
abstract interface class ConferenceLink {
  Stream<ConferenceSignal> get signals;

  /// Güncel kişiler (yerel kişi önce).
  List<ConferencePeer> get peers;

  /// Hata `ApiError` (`client.conference_connect_failed`) olarak fırlar.
  Future<void> connect(String url, String token);

  /// null → istenen duruma geçildi.
  Future<MediaIssue?> setMicrophone(bool on);

  /// null → istenen duruma geçildi.
  Future<MediaIssue?> setCamera(bool on);

  /// Ön/arka kamera (kamera açıkken).
  Future<void> flipCamera();

  /// Odadan ayrılır, kaynakları bırakır; tekrar çağrılabilir, hata fırlatmaz.
  Future<void> leave();
}

/// Yeni oda bağı üretir (bileşim kökünde bağlanır).
typedef ConferenceLinkFactory = ConferenceLink Function();
