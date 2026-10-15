/// scope özelliğinin açık yüzü: program (kapsam) seçimi ve ana sayfa. Başka feature'lar ve
/// `app/` yalnız bu dosyayı import eder (sınır kuralı B3).
library;

export 'application/scope_providers.dart' show scopeServiceProvider;
export 'application/scope_service.dart' show ScopeService;
export 'domain/program.dart' show Program;
export 'presentation/home_page.dart' show HomePage;
export 'presentation/scope_page.dart' show ScopePage;
