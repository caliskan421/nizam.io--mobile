/// activity özelliğinin açık yüzü: işlem geçmişi (değiştirilemez kayıt listesi, filtre). Başka feature'lar ve `app/` yalnız bu dosyayı
/// import eder (sınır kuralı B3).
library;

export 'application/activity_nav_caption.dart' show activityNavCaptionProvider;
export 'application/activity_providers.dart' show activityLogRepositoryProvider;
export 'presentation/activity_page.dart' show ActivityPage;
