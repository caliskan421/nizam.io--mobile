/// meetings özelliğinin açık yüzü: toplantı listesi ve toplantı ayrıntısı. Başka feature'lar ve
/// `app/` yalnız bu dosyayı import eder (sınır kuralı B3).
library;

export 'application/meetings_nav_caption.dart' show meetingsNavCaptionProvider;
export 'application/meetings_providers.dart' show meetingsRepositoryProvider;
export 'presentation/meeting_page.dart' show MeetingPage;
export 'presentation/meetings_page.dart' show MeetingsPage;
