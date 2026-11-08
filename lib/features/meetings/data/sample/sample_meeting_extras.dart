import '../../domain/meeting.dart';
import '../../domain/meeting_board.dart';
import '../../domain/meeting_status.dart';

/// GEÇİCİ (yalnız dev): backend'in henüz taşımadığı olguları toplantı kimliğinden kararlı biçimde
/// türetir; her kart/konferans durumunun tasarımı gerçek sunucuyla da görülsün diye. Geçmiş
/// toplantıların üçte biri "yapılmadı", kalanı "bitti · N dk"; canlı konferansta 2 kişi bağlı;
/// silinmiş toplantıda örnek bir silen; her toplantıya örnek sohbetlerden biri (mesajlar örnek).
final class SampleMeetingExtras implements MeetingExtrasRepository {
  const SampleMeetingExtras();

  static const _names = ['Abdullah Ateş', 'Reha Koçak', 'Büşra Çiftçioğlu'];
  static const _chats = ['koord', 'gen', 'sis', 'hid'];

  @override
  MeetingExtras of(Meeting m, DateTime today) {
    final h = m.id.codeUnits.fold(7, (a, c) => (a * 31 + c) % 997);
    final past = dayDiff(meetingDay(m), today) < 0;
    return MeetingExtras(
      finishedMinutes: past && h % 3 != 0 ? 40 + h % 30 : null,
      notHeld: past && h % 3 == 0,
      connected: 2,
      deletedBy: m.deletedAt == null ? null : _names[h % _names.length],
      chatId: _chats[h % _chats.length],
    );
  }
}
