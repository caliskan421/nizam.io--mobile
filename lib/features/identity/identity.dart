/// identity özelliğinin açık yüzü. Başka feature'lar ve `app/` yalnız bu dosyayı import eder
/// (sınır kuralı B3). MOB-0'da yalnız `data` ve `application` katmanları vardır (ekran yok).
library;

export 'application/identity_providers.dart' show identityServiceProvider;
export 'application/identity_service.dart' show IdentityService;
