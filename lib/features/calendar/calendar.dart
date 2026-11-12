/// calendar özelliğinin açık yüzü: ay/hafta takvimi ve seçili günün kayıtları (toplantı,
/// görev, tarih talebi). Başka feature'lar ve `app/` yalnız bu dosyayı import eder
/// (sınır kuralı B3).
library;

export 'presentation/calendar_page.dart' show CalendarEmptyDetail, CalendarPage;
export 'presentation/coordinatorship_calendar.dart'
    show CoordinatorshipCalendar;
export 'presentation/person_task_calendar.dart' show PersonTaskCalendar;
