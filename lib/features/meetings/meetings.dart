/// meetings özelliğinin açık yüzü: toplantı listesi, toplantı ayrıntısı ve görünür toplantılar
/// (takvim aynı listeyi okur). Başka feature'lar ve `app/` yalnız bu dosyayı import eder
/// (sınır kuralı B3).
library;

export 'application/meetings_controller.dart'
    show meetingsBoardControllerProvider;
export 'application/meetings_nav_caption.dart' show meetingsNavCaptionProvider;
export 'application/meetings_providers.dart' show meetingsRepositoryProvider;
export 'domain/meeting.dart' show Meeting, MeetingDepartment;
export 'domain/meeting_board.dart' show MeetingsBoard;
export 'presentation/meeting_page.dart' show MeetingPage;
export 'presentation/meetings_page.dart' show MeetingsPage;
