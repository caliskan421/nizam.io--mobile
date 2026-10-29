import '../../domain/chat.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Mesajlar ekranı backend hazır olmadan kurulsun
/// diye prototipteki 8 sohbeti döner; ağ isteği atmaz. Kişi kimlikleri görev kataloğunun
/// prototip kişileridir (`ma` = oturumdaki kişi); mesajlar prototip `RP_CHAT` içeriğidir. "Bugün"
/// örnek kataloğun günüdür (2026-10-21).
final class SampleChatRepository implements ChatRepository {
  const SampleChatRepository();

  @override
  Future<ChatInbox> load() async => ChatInbox(chats: _chats(), people: _people);
}

const _people = ['yc', 'ko', 'bk', 'rk', 'my', 'av', 'bc', 'aa', 'ss', 'mk'];

DateTime _yesterday(int h, int m) => DateTime(2026, 10, 20, h, m);
DateTime _today(int h, int m) => DateTime(2026, 10, 21, h, m);

List<Chat> _chats() => [
  Chat(
    id: 'gen',
    name: 'Genel',
    group: true,
    members: 18,
    unread: 2,
    pins: const ['m1', 'm3'],
    newBefore: 'm3',
    typing: 'rk',
    messages: [
      ChatMessage(
        id: 'm1',
        from: 'ma',
        at: _yesterday(18, 5),
        text:
            '@herkes Fuar haftası çalışma saatleri: 27 Ekim–2 Kasım, '
            '08:00–20:00. Vardiya çizelgesi #OPE-2 kartında.',
        reactions: const {ChatReaction.like: 8, ChatReaction.check: 3},
        read: true,
      ),
      ChatMessage(
        id: 'm2',
        from: 'yc',
        at: _yesterday(18, 20),
        text: 'Vardiya taslağı arşivde, herkes kendi saatini kontrol etsin.',
        replyTo: 'm1',
        file: const ChatFile(
          kind: 'XLSX',
          name: 'Vardiya_taslak.xlsx',
          size: '48 KB',
          coordinatorship: 'OPE',
        ),
      ),
      ChatMessage(
        id: 'm3',
        from: 'ko',
        at: _today(9, 12),
        text:
            '@Altyapı ve tesisat hidrofor pompaları 28 Ekim’de sahada. Montaj '
            'planı #ALT-7 kartında, sorusu olan buraya yazsın.',
        reactions: const {ChatReaction.like: 6, ChatReaction.heart: 2},
      ),
      ChatMessage(
        id: 'm4',
        from: 'bk',
        at: _today(9, 38),
        text: 'Otel rezervasyonlarının hepsi onaylandı.',
      ),
      ChatMessage(
        id: 'm5',
        from: 'bk',
        at: _today(9, 40),
        text: 'Konaklama listesini güncelledim, eksik olan varsa yazın.',
        file: const ChatFile(
          kind: 'XLSX',
          name: 'Konaklama_listesi_v3.xlsx',
          size: '36 KB',
          coordinatorship: 'İDA',
        ),
        edited: true,
        reactions: const {ChatReaction.like: 3},
      ),
      ChatMessage(
        id: 'm6',
        from: 'ma',
        at: _today(10, 2),
        text:
            'Kapanış yemeği için gün seçelim, 25 Ekim akşamına kadar oy verin.',
        read: true,
        poll: const ChatPoll(
          question: 'Kapanış yemeği için hangi günler uygun?',
          meta: 'Çoklu seçim · isimli',
          deadline: 'son 25 Ekim 18:00',
          options: [
            ChatPollOption('30 Ekim Cuma', 5),
            ChatPollOption('31 Ekim Cumartesi', 3),
            ChatPollOption('2 Kasım Pazartesi', 2),
          ],
        ),
      ),
    ],
  ),
  Chat(
    id: 'koord',
    name: 'Koordinatörler',
    group: true,
    members: 15,
    // Prototip kurucusu varsayılan sağ sohbeti (`chat.load('koord')`) baştan yükler: 1 okunmamış
    // mesaj okunmuş sayılır, anma kalkar, ayırıcı o mesajın önünde kalır (`_newBefore`); ray
    // rozeti 4. Gerçek okuma komutu değişmez.
    unread: 0,
    unreadMarker: 'k2',
    messages: [
      ChatMessage(
        id: 'k1',
        from: 'my',
        at: _today(8, 40),
        text:
            'Bu hafta tüm koordinatörlükler haftalık raporu cuma 17:00’ye '
            'kadar yüklesin.',
      ),
      ChatMessage(
        id: 'k2',
        from: 'rk',
        at: _today(9, 51),
        text:
            '@Muhammet Ali trafo onayı bugün bekleniyor, son durumu #ELE-4 '
            'kartına yazdım.',
      ),
    ],
  ),
  Chat(
    id: 'sis',
    name: 'Sistem koordinatörlüğü',
    group: true,
    members: 3,
    messages: [
      ChatMessage(
        id: 's1',
        from: 'my',
        at: _yesterday(16, 10),
        text:
            'Portal eğitim videoları hazır, arşivde Sistem koordinatörlüğü '
            'klasöründe.',
      ),
      ChatMessage(
        id: 's2',
        from: 'ma',
        at: _yesterday(16, 22),
        text: 'Teşekkürler, yarın koordinatörlere duyururum.',
        read: true,
      ),
    ],
  ),
  Chat(
    id: 'hid',
    name: 'Hidrofor teslim ekibi',
    group: true,
    members: 5,
    unread: 1,
    messages: [
      ChatMessage(
        id: 'h1',
        from: 'ko',
        at: _today(9, 2),
        text: 'Pompalar 28 Ekim sabahı sahada olacak.',
      ),
      ChatMessage(
        id: 'h2',
        from: 'av',
        at: _today(9, 30),
        text: 'Montaj ekibi hazır, vinç için saat 08:00’de kapıda olalım.',
      ),
    ],
  ),
  Chat(
    id: 'kadir',
    name: 'Kadir Özbek',
    person: 'ko',
    online: true,
    messages: [
      ChatMessage(
        id: 'd1',
        from: 'ko',
        at: _today(9, 5),
        text:
            'Hidrofor için yeni tarih talebini gönderdim, #ALT-7 içinde '
            'gerekçe var.',
      ),
      ChatMessage(
        id: 'd2',
        from: 'ma',
        at: _today(9, 14),
        text: 'Planı onayladım, #ALT-7 kartı güncel.',
        read: true,
      ),
    ],
  ),
  Chat(
    id: 'bahar',
    name: 'Bahar Kılıç',
    person: 'bk',
    unread: 1,
    lastSeen: _today(9, 41),
    messages: [
      ChatMessage(
        id: 'b1',
        from: 'ma',
        at: _yesterday(15, 20),
        text: 'Konaklama listesinde son durum ne?',
        read: true,
      ),
      ChatMessage(
        id: 'b2',
        from: 'bk',
        at: _yesterday(17, 48),
        text: 'Konaklama listesini attım',
        file: const ChatFile(
          kind: 'XLSX',
          name: 'Konaklama_listesi_v3.xlsx',
          size: '36 KB',
          coordinatorship: 'İDA',
        ),
      ),
    ],
  ),
  Chat(
    id: 'fuar',
    name: 'Fuar kurulum',
    group: true,
    members: 7,
    unread: 2,
    messages: [
      ChatMessage(
        id: 'f1',
        from: 'ss',
        at: _yesterday(14, 2),
        text: 'Stant yerleşim planı #FUA-3 kartında onay bekliyor.',
      ),
      ChatMessage(
        id: 'f2',
        from: 'bc',
        at: _yesterday(14, 30),
        text:
            'Sponsor alanları için ayrı pafta hazırlayalım, ölçüleri yarın '
            'paylaşırım.',
      ),
    ],
  ),
  Chat(
    id: 'reha',
    name: 'Reha Koçak',
    person: 'rk',
    lastSeen: _yesterday(18, 30),
    messages: [
      ChatMessage(
        id: 'r1',
        from: 'rk',
        at: DateTime(2026, 10, 19, 11, 20),
        text: 'Trafo projesi revizyonu yüklendi.',
      ),
      ChatMessage(
        id: 'r2',
        from: 'ma',
        at: DateTime(2026, 10, 19, 11, 34),
        text: 'Teşekkürler, takipteyim.',
        read: true,
      ),
    ],
  ),
];
