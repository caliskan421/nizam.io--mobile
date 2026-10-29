/// identity özelliğinin açık yüzü. Başka feature'lar ve `app/` yalnız bu dosyayı import eder
/// (sınır kuralı B3). Katmanlar: `domain`, `data`, `application` ve giriş / zorunlu parola
/// değişikliği / profil ekranları (`presentation`).
library;

export 'application/identity_providers.dart' show identityServiceProvider;
export 'application/identity_service.dart' show IdentityService;
export 'domain/current_account.dart' show CurrentAccount;
export 'domain/download_ticket.dart' show DownloadTicket;
export 'presentation/login_page.dart' show LoginPage;
export 'presentation/password_change_page.dart' show PasswordChangePage;
export 'presentation/profile_page.dart' show ProfilePage;
export 'presentation/sign_out_button.dart'
    show SignOutButton, confirmSignOut, signOutProvider;
