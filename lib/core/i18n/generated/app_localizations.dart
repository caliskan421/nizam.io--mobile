import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// assistant.busy
  ///
  /// In tr, this message translates to:
  /// **'Asistan şu anda meşgul; biraz sonra yeniden deneyin.'**
  String get errAssistantBusy;

  /// assistant.capacity_full
  ///
  /// In tr, this message translates to:
  /// **'Asistan kapasitesi dolu; biraz sonra yeniden deneyin.'**
  String get errAssistantCapacityFull;

  /// assistant.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errAssistantInputInvalid;

  /// assistant.limit_exceeded
  ///
  /// In tr, this message translates to:
  /// **'Asistan kullanım sınırına ulaşıldı.'**
  String get errAssistantLimitExceeded;

  /// assistant.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errAssistantNotAuthorized;

  /// assistant.not_found
  ///
  /// In tr, this message translates to:
  /// **'Asistan kaydı bulunamadı.'**
  String get errAssistantNotFound;

  /// assistant.provider_unavailable
  ///
  /// In tr, this message translates to:
  /// **'Asistan hizmeti şu anda kullanılamıyor.'**
  String get errAssistantProviderUnavailable;

  /// assistant.quota_exceeded
  ///
  /// In tr, this message translates to:
  /// **'Asistan kullanım kotası doldu.'**
  String get errAssistantQuotaExceeded;

  /// assistant.refused
  ///
  /// In tr, this message translates to:
  /// **'Asistan bu isteği yanıtlayamadı.'**
  String get errAssistantRefused;

  /// audit.entry_rejected
  ///
  /// In tr, this message translates to:
  /// **'İşlem kaydı yazılamadığı için istek tamamlanamadı.'**
  String get errAuditEntryRejected;

  /// collaboration.agenda_item_not_found
  ///
  /// In tr, this message translates to:
  /// **'Gündem maddesi bulunamadı.'**
  String get errCollaborationAgendaItemNotFound;

  /// collaboration.agenda_limit_reached
  ///
  /// In tr, this message translates to:
  /// **'Gündem madde sınırına ulaşıldı.'**
  String get errCollaborationAgendaLimitReached;

  /// collaboration.conference_disabled
  ///
  /// In tr, this message translates to:
  /// **'Görüntülü görüşme bu kurulumda kapalı.'**
  String get errCollaborationConferenceDisabled;

  /// collaboration.conference_not_active
  ///
  /// In tr, this message translates to:
  /// **'Görüşme etkin değil.'**
  String get errCollaborationConferenceNotActive;

  /// collaboration.conference_provider_unavailable
  ///
  /// In tr, this message translates to:
  /// **'Görüşme hizmeti şu anda kullanılamıyor.'**
  String get errCollaborationConferenceProviderUnavailable;

  /// collaboration.conference_webhook_invalid
  ///
  /// In tr, this message translates to:
  /// **'Görüşme bildirimi geçersiz.'**
  String get errCollaborationConferenceWebhookInvalid;

  /// collaboration.conference_webhook_unauthorized
  ///
  /// In tr, this message translates to:
  /// **'Görüşme bildirimi doğrulanamadı.'**
  String get errCollaborationConferenceWebhookUnauthorized;

  /// collaboration.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errCollaborationInputInvalid;

  /// collaboration.invalid_cursor
  ///
  /// In tr, this message translates to:
  /// **'Liste konumu geçersiz; listeyi yenileyin.'**
  String get errCollaborationInvalidCursor;

  /// collaboration.meeting_not_found
  ///
  /// In tr, this message translates to:
  /// **'Toplantı bulunamadı.'**
  String get errCollaborationMeetingNotFound;

  /// collaboration.message_not_found
  ///
  /// In tr, this message translates to:
  /// **'Mesaj bulunamadı.'**
  String get errCollaborationMessageNotFound;

  /// collaboration.message_unread
  ///
  /// In tr, this message translates to:
  /// **'Mesaj henüz okunmadı.'**
  String get errCollaborationMessageUnread;

  /// collaboration.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errCollaborationNotAuthorized;

  /// collaboration.not_deleted
  ///
  /// In tr, this message translates to:
  /// **'Kayıt silinmiş durumda değil.'**
  String get errCollaborationNotDeleted;

  /// collaboration.note_converted
  ///
  /// In tr, this message translates to:
  /// **'Not zaten göreve dönüştürüldü.'**
  String get errCollaborationNoteConverted;

  /// collaboration.note_immutable
  ///
  /// In tr, this message translates to:
  /// **'Bu not artık değiştirilemez.'**
  String get errCollaborationNoteImmutable;

  /// collaboration.note_not_found
  ///
  /// In tr, this message translates to:
  /// **'Not bulunamadı.'**
  String get errCollaborationNoteNotFound;

  /// collaboration.participant_invalid
  ///
  /// In tr, this message translates to:
  /// **'Katılımcı seçimi geçersiz.'**
  String get errCollaborationParticipantInvalid;

  /// collaboration.permanent_requires_deleted
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı silme için kayıt önce silinmiş olmalı.'**
  String get errCollaborationPermanentRequiresDeleted;

  /// collaboration.scope_invalid
  ///
  /// In tr, this message translates to:
  /// **'Seçili kapsam bu işlem için geçersiz.'**
  String get errCollaborationScopeInvalid;

  /// collaboration.target_department_invalid
  ///
  /// In tr, this message translates to:
  /// **'Hedef departman geçersiz.'**
  String get errCollaborationTargetDepartmentInvalid;

  /// identity.account_email_deleted
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta silinmiş bir hesaba ait.'**
  String get errIdentityAccountEmailDeleted;

  /// identity.account_exists
  ///
  /// In tr, this message translates to:
  /// **'Bu e-postayla bir hesap zaten var.'**
  String get errIdentityAccountExists;

  /// identity.account_not_found
  ///
  /// In tr, this message translates to:
  /// **'Hesap bulunamadı.'**
  String get errIdentityAccountNotFound;

  /// identity.account_not_locked
  ///
  /// In tr, this message translates to:
  /// **'Hesap kilitli değil.'**
  String get errIdentityAccountNotLocked;

  /// identity.account_referenced
  ///
  /// In tr, this message translates to:
  /// **'Hesap başka kayıtlarda kullanıldığı için kalıcı silinemez.'**
  String get errIdentityAccountReferenced;

  /// identity.capacity_full
  ///
  /// In tr, this message translates to:
  /// **'Sistem şu anda yoğun; biraz sonra yeniden deneyin.'**
  String get errIdentityCapacityFull;

  /// identity.captcha_invalid
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik doğrulaması başarısız; yeniden deneyin.'**
  String get errIdentityCaptchaInvalid;

  /// identity.captcha_required
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik doğrulaması gerekli.'**
  String get errIdentityCaptchaRequired;

  /// identity.credentials_invalid
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya parola hatalı.'**
  String get errIdentityCredentialsInvalid;

  /// identity.download_target_invalid
  ///
  /// In tr, this message translates to:
  /// **'İndirme hedefi geçersiz.'**
  String get errIdentityDownloadTargetInvalid;

  /// identity.download_ticket_invalid
  ///
  /// In tr, this message translates to:
  /// **'İndirme bağlantısı geçersiz veya süresi dolmuş.'**
  String get errIdentityDownloadTicketInvalid;

  /// identity.force_password_change_required
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için parolanızı değiştirmelisiniz.'**
  String get errIdentityForcePasswordChangeRequired;

  /// identity.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errIdentityInputInvalid;

  /// identity.invalid_cursor
  ///
  /// In tr, this message translates to:
  /// **'Liste konumu geçersiz; listeyi yenileyin.'**
  String get errIdentityInvalidCursor;

  /// identity.invalid_email
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi geçersiz.'**
  String get errIdentityInvalidEmail;

  /// identity.invalid_full_name
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad geçersiz.'**
  String get errIdentityInvalidFullName;

  /// identity.ip_blocked
  ///
  /// In tr, this message translates to:
  /// **'Bu ağdan çok sayıda başarısız deneme yapıldı; bir süre sonra yeniden deneyin.'**
  String get errIdentityIpBlocked;

  /// identity.login_locked
  ///
  /// In tr, this message translates to:
  /// **'Çok sayıda başarısız giriş nedeniyle hesap geçici olarak kilitlendi.'**
  String get errIdentityLoginLocked;

  /// identity.not_deleted
  ///
  /// In tr, this message translates to:
  /// **'Hesap silinmiş durumda değil.'**
  String get errIdentityNotDeleted;

  /// identity.password_needs_digit
  ///
  /// In tr, this message translates to:
  /// **'Parola en az bir rakam içermeli.'**
  String get errIdentityPasswordNeedsDigit;

  /// identity.password_needs_lower
  ///
  /// In tr, this message translates to:
  /// **'Parola en az bir küçük harf içermeli.'**
  String get errIdentityPasswordNeedsLower;

  /// identity.password_needs_upper
  ///
  /// In tr, this message translates to:
  /// **'Parola en az bir büyük harf içermeli.'**
  String get errIdentityPasswordNeedsUpper;

  /// identity.password_too_short
  ///
  /// In tr, this message translates to:
  /// **'Parola çok kısa.'**
  String get errIdentityPasswordTooShort;

  /// identity.permanent_requires_deleted
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı silme için hesap önce silinmiş olmalı.'**
  String get errIdentityPermanentRequiresDeleted;

  /// identity.session_invalid
  ///
  /// In tr, this message translates to:
  /// **'Oturumunuz geçersiz veya süresi dolmuş; yeniden giriş yapın.'**
  String get errIdentitySessionInvalid;

  /// identity.unavailable
  ///
  /// In tr, this message translates to:
  /// **'Kimlik hizmeti şu anda kullanılamıyor; yeniden deneyin.'**
  String get errIdentityUnavailable;

  /// identity.weak_password
  ///
  /// In tr, this message translates to:
  /// **'Parola yeterince güçlü değil.'**
  String get errIdentityWeakPassword;

  /// notifications.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errNotificationsInputInvalid;

  /// notifications.invalid_cursor
  ///
  /// In tr, this message translates to:
  /// **'Liste konumu geçersiz; listeyi yenileyin.'**
  String get errNotificationsInvalidCursor;

  /// notifications.notification_not_found
  ///
  /// In tr, this message translates to:
  /// **'Bildirim bulunamadı.'**
  String get errNotificationsNotificationNotFound;

  /// notifications.scope_invalid
  ///
  /// In tr, this message translates to:
  /// **'Seçili kapsam bu işlem için geçersiz.'**
  String get errNotificationsScopeInvalid;

  /// notifications.subscription_not_found
  ///
  /// In tr, this message translates to:
  /// **'Bildirim aboneliği bulunamadı.'**
  String get errNotificationsSubscriptionNotFound;

  /// notifications.subscription_owner_conflict
  ///
  /// In tr, this message translates to:
  /// **'Bu bildirim aboneliği başka bir hesaba ait.'**
  String get errNotificationsSubscriptionOwnerConflict;

  /// notifications.target_invalid
  ///
  /// In tr, this message translates to:
  /// **'Bildirim hedefi geçersiz.'**
  String get errNotificationsTargetInvalid;

  /// organization.account_not_found
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı bulunamadı.'**
  String get errOrganizationAccountNotFound;

  /// organization.assignment_not_found
  ///
  /// In tr, this message translates to:
  /// **'Atama bulunamadı.'**
  String get errOrganizationAssignmentNotFound;

  /// organization.authority_unavailable
  ///
  /// In tr, this message translates to:
  /// **'Yetki bilgisi şu anda alınamıyor; biraz sonra yeniden deneyin.'**
  String get errOrganizationAuthorityUnavailable;

  /// organization.company_exists
  ///
  /// In tr, this message translates to:
  /// **'Şirket kaydı zaten var.'**
  String get errOrganizationCompanyExists;

  /// organization.company_not_found
  ///
  /// In tr, this message translates to:
  /// **'Şirket kaydı bulunamadı.'**
  String get errOrganizationCompanyNotFound;

  /// organization.confirmation_required
  ///
  /// In tr, this message translates to:
  /// **'Bu değişiklik görevleri etkiliyor; devam etmek için onaylayın.'**
  String get errOrganizationConfirmationRequired;

  /// organization.department_code_conflict
  ///
  /// In tr, this message translates to:
  /// **'Bu departman kodu başka bir departmanda kullanılıyor.'**
  String get errOrganizationDepartmentCodeConflict;

  /// organization.department_exists
  ///
  /// In tr, this message translates to:
  /// **'Bu adla bir departman zaten var.'**
  String get errOrganizationDepartmentExists;

  /// organization.department_in_use
  ///
  /// In tr, this message translates to:
  /// **'Departman kullanımda olduğu için silinemez.'**
  String get errOrganizationDepartmentInUse;

  /// organization.department_not_found
  ///
  /// In tr, this message translates to:
  /// **'Departman bulunamadı.'**
  String get errOrganizationDepartmentNotFound;

  /// organization.department_not_linked
  ///
  /// In tr, this message translates to:
  /// **'Departman bu programa bağlı değil.'**
  String get errOrganizationDepartmentNotLinked;

  /// organization.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errOrganizationInputInvalid;

  /// organization.invalid_code
  ///
  /// In tr, this message translates to:
  /// **'Departman kodu geçersiz.'**
  String get errOrganizationInvalidCode;

  /// organization.invalid_kind
  ///
  /// In tr, this message translates to:
  /// **'Departman türü geçersiz.'**
  String get errOrganizationInvalidKind;

  /// organization.invalid_name
  ///
  /// In tr, this message translates to:
  /// **'Ad geçersiz.'**
  String get errOrganizationInvalidName;

  /// organization.invalid_role
  ///
  /// In tr, this message translates to:
  /// **'Rol geçersiz.'**
  String get errOrganizationInvalidRole;

  /// organization.invalid_sort
  ///
  /// In tr, this message translates to:
  /// **'Sıralama seçimi geçersiz.'**
  String get errOrganizationInvalidSort;

  /// organization.last_admin
  ///
  /// In tr, this message translates to:
  /// **'Son yönetici kaldırılamaz.'**
  String get errOrganizationLastAdmin;

  /// organization.membership_exists
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı bu departmanda zaten üye.'**
  String get errOrganizationMembershipExists;

  /// organization.membership_not_found
  ///
  /// In tr, this message translates to:
  /// **'Üyelik bulunamadı.'**
  String get errOrganizationMembershipNotFound;

  /// organization.membership_required
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için departman üyeliği gerekli.'**
  String get errOrganizationMembershipRequired;

  /// organization.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errOrganizationNotAuthorized;

  /// organization.not_deleted
  ///
  /// In tr, this message translates to:
  /// **'Kayıt silinmiş durumda değil.'**
  String get errOrganizationNotDeleted;

  /// organization.permanent_requires_deleted
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı silme için kayıt önce silinmiş olmalı.'**
  String get errOrganizationPermanentRequiresDeleted;

  /// organization.program_required
  ///
  /// In tr, this message translates to:
  /// **'Program seçimi gerekli.'**
  String get errOrganizationProgramRequired;

  /// organization.task_title
  ///
  /// In tr, this message translates to:
  /// **'Etkilenen görev.'**
  String get errOrganizationTaskTitle;

  /// organization.transfer_available
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap başka bir departmandan aktarılabilir.'**
  String get errOrganizationTransferAvailable;

  /// platform.body_invalid
  ///
  /// In tr, this message translates to:
  /// **'İstek içeriği geçersiz.'**
  String get errPlatformBodyInvalid;

  /// platform.body_too_large
  ///
  /// In tr, this message translates to:
  /// **'İstek içeriği çok büyük.'**
  String get errPlatformBodyTooLarge;

  /// platform.body_unknown_field
  ///
  /// In tr, this message translates to:
  /// **'İstek tanınmayan bir alan içeriyor; uygulamayı güncelleyin.'**
  String get errPlatformBodyUnknownField;

  /// platform.conflict_retry
  ///
  /// In tr, this message translates to:
  /// **'Eşzamanlı bir değişiklik oldu; yeniden deneyin.'**
  String get errPlatformConflictRetry;

  /// platform.csrf_header_missing
  ///
  /// In tr, this message translates to:
  /// **'İstek güvenlik doğrulamasından geçemedi.'**
  String get errPlatformCsrfHeaderMissing;

  /// platform.internal
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir sunucu hatası oluştu.'**
  String get errPlatformInternal;

  /// platform.method_not_allowed
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem desteklenmiyor.'**
  String get errPlatformMethodNotAllowed;

  /// platform.not_ready
  ///
  /// In tr, this message translates to:
  /// **'Sunucu şu anda hazır değil; biraz sonra yeniden deneyin.'**
  String get errPlatformNotReady;

  /// platform.panic
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir sunucu hatası oluştu.'**
  String get errPlatformPanic;

  /// platform.rate_limited
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla istek gönderildi; biraz bekleyip yeniden deneyin.'**
  String get errPlatformRateLimited;

  /// platform.route_not_found
  ///
  /// In tr, this message translates to:
  /// **'İstenen kaynak bulunamadı.'**
  String get errPlatformRouteNotFound;

  /// platform.scope_missing
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için program veya departman seçilmeli.'**
  String get errPlatformScopeMissing;

  /// platform.unauthenticated
  ///
  /// In tr, this message translates to:
  /// **'Oturum açmanız gerekiyor.'**
  String get errPlatformUnauthenticated;

  /// program.already_exists
  ///
  /// In tr, this message translates to:
  /// **'Bu program zaten var.'**
  String get errProgramAlreadyExists;

  /// program.copy_source_not_linked
  ///
  /// In tr, this message translates to:
  /// **'Ekip kopyalanacak programda bu departman bağlı değil.'**
  String get errProgramCopySourceNotLinked;

  /// program.department_link_in_use
  ///
  /// In tr, this message translates to:
  /// **'Departmanın programda canlı görevleri olduğu için bağı kaldırılamaz.'**
  String get errProgramDepartmentLinkInUse;

  /// program.department_link_name_exists
  ///
  /// In tr, this message translates to:
  /// **'Bu programda aynı adla bir departman zaten var.'**
  String get errProgramDepartmentLinkNameExists;

  /// program.department_not_found
  ///
  /// In tr, this message translates to:
  /// **'Departman bu programda bulunamadı.'**
  String get errProgramDepartmentNotFound;

  /// program.duplicate_transfer_item
  ///
  /// In tr, this message translates to:
  /// **'Aktarım listesinde aynı kayıt birden fazla kez var.'**
  String get errProgramDuplicateTransferItem;

  /// program.idempotency_key_reused
  ///
  /// In tr, this message translates to:
  /// **'Bu istek anahtarı farklı bir istekle kullanılmış.'**
  String get errProgramIdempotencyKeyReused;

  /// program.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errProgramInputInvalid;

  /// program.invalid_copy_source
  ///
  /// In tr, this message translates to:
  /// **'Ekip kopyası için kaynak program geçersiz.'**
  String get errProgramInvalidCopySource;

  /// program.invalid_cursor
  ///
  /// In tr, this message translates to:
  /// **'Liste konumu geçersiz; listeyi yenileyin.'**
  String get errProgramInvalidCursor;

  /// program.invalid_description
  ///
  /// In tr, this message translates to:
  /// **'Açıklama geçersiz.'**
  String get errProgramInvalidDescription;

  /// program.invalid_limit
  ///
  /// In tr, this message translates to:
  /// **'Sayfa boyutu geçersiz.'**
  String get errProgramInvalidLimit;

  /// program.invalid_name
  ///
  /// In tr, this message translates to:
  /// **'Program adı geçersiz.'**
  String get errProgramInvalidName;

  /// program.invalid_transfer
  ///
  /// In tr, this message translates to:
  /// **'Aktarım isteği geçersiz.'**
  String get errProgramInvalidTransfer;

  /// program.invalid_year
  ///
  /// In tr, this message translates to:
  /// **'Yıl geçersiz.'**
  String get errProgramInvalidYear;

  /// program.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errProgramNotAuthorized;

  /// program.not_found
  ///
  /// In tr, this message translates to:
  /// **'Program bulunamadı.'**
  String get errProgramNotFound;

  /// program.password_invalid
  ///
  /// In tr, this message translates to:
  /// **'Parola hatalı.'**
  String get errProgramPasswordInvalid;

  /// program.password_required
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için parolanızı girin.'**
  String get errProgramPasswordRequired;

  /// program.program_in_use
  ///
  /// In tr, this message translates to:
  /// **'Program kullanımda olduğu için silinemez.'**
  String get errProgramProgramInUse;

  /// program.request_key_invalid
  ///
  /// In tr, this message translates to:
  /// **'İstek anahtarı geçersiz.'**
  String get errProgramRequestKeyInvalid;

  /// program.request_key_required
  ///
  /// In tr, this message translates to:
  /// **'İstek anahtarı gerekli.'**
  String get errProgramRequestKeyRequired;

  /// program.transfer_already_reversed
  ///
  /// In tr, this message translates to:
  /// **'Bu aktarım zaten geri alındı.'**
  String get errProgramTransferAlreadyReversed;

  /// program.transfer_blocked
  ///
  /// In tr, this message translates to:
  /// **'Aktarım engellendi.'**
  String get errProgramTransferBlocked;

  /// program.transfer_conflict
  ///
  /// In tr, this message translates to:
  /// **'Aktarım başka bir işlemle çakışıyor.'**
  String get errProgramTransferConflict;

  /// program.transfer_input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Aktarım bilgileri geçersiz.'**
  String get errProgramTransferInputInvalid;

  /// program.transfer_not_found
  ///
  /// In tr, this message translates to:
  /// **'Aktarım bulunamadı.'**
  String get errProgramTransferNotFound;

  /// program.transfer_not_reversible
  ///
  /// In tr, this message translates to:
  /// **'Bu aktarım geri alınamaz.'**
  String get errProgramTransferNotReversible;

  /// program.transfer_preview_stale
  ///
  /// In tr, this message translates to:
  /// **'Aktarım önizlemesi eskidi; yeniden önizleyin.'**
  String get errProgramTransferPreviewStale;

  /// provisioning.version_mismatch
  ///
  /// In tr, this message translates to:
  /// **'Sunucu sürümleri uyumsuz; yöneticinize başvurun.'**
  String get errProvisioningVersionMismatch;

  /// provisioning.write_not_allowed
  ///
  /// In tr, this message translates to:
  /// **'Kurulum şu anda değişikliğe kapalı (salt okunur).'**
  String get errProvisioningWriteNotAllowed;

  /// records.busy
  ///
  /// In tr, this message translates to:
  /// **'Dosya işlemi şu anda yoğun; biraz sonra yeniden deneyin.'**
  String get errRecordsBusy;

  /// records.content_rejected
  ///
  /// In tr, this message translates to:
  /// **'Dosya içeriği kabul edilmedi.'**
  String get errRecordsContentRejected;

  /// records.file_not_found
  ///
  /// In tr, this message translates to:
  /// **'Dosya bulunamadı.'**
  String get errRecordsFileNotFound;

  /// records.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errRecordsInputInvalid;

  /// records.invalid_cursor
  ///
  /// In tr, this message translates to:
  /// **'Liste konumu geçersiz; listeyi yenileyin.'**
  String get errRecordsInvalidCursor;

  /// records.invalid_file
  ///
  /// In tr, this message translates to:
  /// **'Dosya geçersiz.'**
  String get errRecordsInvalidFile;

  /// records.moved
  ///
  /// In tr, this message translates to:
  /// **'Dosya taşındı; listeyi yenileyin.'**
  String get errRecordsMoved;

  /// records.name_invalid
  ///
  /// In tr, this message translates to:
  /// **'Dosya adı geçersiz.'**
  String get errRecordsNameInvalid;

  /// records.name_taken
  ///
  /// In tr, this message translates to:
  /// **'Bu adla bir dosya zaten var.'**
  String get errRecordsNameTaken;

  /// records.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errRecordsNotAuthorized;

  /// records.tag_invalid
  ///
  /// In tr, this message translates to:
  /// **'Dosya etiketi geçersiz.'**
  String get errRecordsTagInvalid;

  /// records.tag_required
  ///
  /// In tr, this message translates to:
  /// **'Dosya etiketi gerekli.'**
  String get errRecordsTagRequired;

  /// records.too_large
  ///
  /// In tr, this message translates to:
  /// **'Dosya çok büyük.'**
  String get errRecordsTooLarge;

  /// records.too_many_files
  ///
  /// In tr, this message translates to:
  /// **'Dosya sayısı sınırına ulaşıldı.'**
  String get errRecordsTooManyFiles;

  /// records.transfer_active
  ///
  /// In tr, this message translates to:
  /// **'Devam eden bir aktarım nedeniyle dosya değiştirilemez.'**
  String get errRecordsTransferActive;

  /// reporting.capacity_full
  ///
  /// In tr, this message translates to:
  /// **'Rapor kapasitesi dolu; biraz sonra yeniden deneyin.'**
  String get errReportingCapacityFull;

  /// reporting.export_in_progress
  ///
  /// In tr, this message translates to:
  /// **'Devam eden bir dışa aktarım var; tamamlanmasını bekleyin.'**
  String get errReportingExportInProgress;

  /// reporting.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errReportingInputInvalid;

  /// reporting.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errReportingNotAuthorized;

  /// reporting.not_found
  ///
  /// In tr, this message translates to:
  /// **'Rapor bulunamadı.'**
  String get errReportingNotFound;

  /// storage.inconsistent
  ///
  /// In tr, this message translates to:
  /// **'Dosya deposu tutarsız durumda; yöneticinize başvurun.'**
  String get errStorageInconsistent;

  /// storage.invalid_key
  ///
  /// In tr, this message translates to:
  /// **'Dosya anahtarı geçersiz.'**
  String get errStorageInvalidKey;

  /// storage.not_found
  ///
  /// In tr, this message translates to:
  /// **'Dosya bulunamadı.'**
  String get errStorageNotFound;

  /// storage.permanent
  ///
  /// In tr, this message translates to:
  /// **'Dosya işlemi kalıcı olarak reddedildi.'**
  String get errStoragePermanent;

  /// storage.quota
  ///
  /// In tr, this message translates to:
  /// **'Depolama kotası doldu.'**
  String get errStorageQuota;

  /// storage.transient
  ///
  /// In tr, this message translates to:
  /// **'Dosya deposuna geçici olarak erişilemiyor; yeniden deneyin.'**
  String get errStorageTransient;

  /// work.assignee_not_member
  ///
  /// In tr, this message translates to:
  /// **'Atanan kişi bu departmanın üyesi değil.'**
  String get errWorkAssigneeNotMember;

  /// work.assignment_duplicate
  ///
  /// In tr, this message translates to:
  /// **'Bu kişi zaten atanmış.'**
  String get errWorkAssignmentDuplicate;

  /// work.attachment_required
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için ek dosya gerekli.'**
  String get errWorkAttachmentRequired;

  /// work.claim_not_available
  ///
  /// In tr, this message translates to:
  /// **'Bu görev üstlenilemez.'**
  String get errWorkClaimNotAvailable;

  /// work.completion_date_future
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanma tarihi ileri bir tarih olamaz.'**
  String get errWorkCompletionDateFuture;

  /// work.completion_date_missing
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanma tarihi gerekli.'**
  String get errWorkCompletionDateMissing;

  /// work.completion_window
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanma tarihi izin verilen aralığın dışında.'**
  String get errWorkCompletionWindow;

  /// work.constraint_violation
  ///
  /// In tr, this message translates to:
  /// **'İşlem bir kısıtı ihlal ediyor.'**
  String get errWorkConstraintViolation;

  /// work.date_request_already_reviewed
  ///
  /// In tr, this message translates to:
  /// **'Tarih talebi zaten değerlendirildi.'**
  String get errWorkDateRequestAlreadyReviewed;

  /// work.date_request_invalid
  ///
  /// In tr, this message translates to:
  /// **'Tarih talebi geçersiz.'**
  String get errWorkDateRequestInvalid;

  /// work.date_request_pending_exists
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen bir tarih talebi zaten var.'**
  String get errWorkDateRequestPendingExists;

  /// work.date_request_pending_undeletable
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen tarih talebi silinemez.'**
  String get errWorkDateRequestPendingUndeletable;

  /// work.department_unavailable
  ///
  /// In tr, this message translates to:
  /// **'Departman şu anda kullanılamıyor.'**
  String get errWorkDepartmentUnavailable;

  /// work.dependency_cycle
  ///
  /// In tr, this message translates to:
  /// **'Bu bağımlılık döngü oluşturur.'**
  String get errWorkDependencyCycle;

  /// work.dependency_date_order
  ///
  /// In tr, this message translates to:
  /// **'Bağımlılık tarih sırasıyla çelişiyor.'**
  String get errWorkDependencyDateOrder;

  /// work.dependency_duplicate
  ///
  /// In tr, this message translates to:
  /// **'Bu bağımlılık zaten var.'**
  String get errWorkDependencyDuplicate;

  /// work.dependency_not_completed
  ///
  /// In tr, this message translates to:
  /// **'Bağımlı olunan görev henüz tamamlanmadı.'**
  String get errWorkDependencyNotCompleted;

  /// work.extend_days_out_of_range
  ///
  /// In tr, this message translates to:
  /// **'Uzatma gün sayısı izin verilen aralıkta değil.'**
  String get errWorkExtendDaysOutOfRange;

  /// work.input_invalid
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgiler geçersiz.'**
  String get errWorkInputInvalid;

  /// work.invalid_input
  ///
  /// In tr, this message translates to:
  /// **'Alan değeri geçersiz.'**
  String get errWorkInvalidInput;

  /// work.item_completed
  ///
  /// In tr, this message translates to:
  /// **'Görev zaten tamamlandı.'**
  String get errWorkItemCompleted;

  /// work.item_not_completed
  ///
  /// In tr, this message translates to:
  /// **'Görev henüz tamamlanmadı.'**
  String get errWorkItemNotCompleted;

  /// work.item_not_found
  ///
  /// In tr, this message translates to:
  /// **'Görev bulunamadı.'**
  String get errWorkItemNotFound;

  /// work.not_assigned
  ///
  /// In tr, this message translates to:
  /// **'Bu görev size atanmamış.'**
  String get errWorkNotAssigned;

  /// work.not_authorized
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get errWorkNotAuthorized;

  /// work.not_deleted
  ///
  /// In tr, this message translates to:
  /// **'Görev silinmiş durumda değil.'**
  String get errWorkNotDeleted;

  /// work.note_not_found
  ///
  /// In tr, this message translates to:
  /// **'Not bulunamadı.'**
  String get errWorkNoteNotFound;

  /// work.note_not_yours
  ///
  /// In tr, this message translates to:
  /// **'Bu not size ait değil.'**
  String get errWorkNoteNotYours;

  /// work.note_rate_limited
  ///
  /// In tr, this message translates to:
  /// **'Çok sık not eklendi; biraz bekleyip yeniden deneyin.'**
  String get errWorkNoteRateLimited;

  /// work.permanent_requires_deleted
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı silme için görev önce silinmiş olmalı.'**
  String get errWorkPermanentRequiresDeleted;

  /// work.program_scope_invalid
  ///
  /// In tr, this message translates to:
  /// **'Görev seçili programda bulunamadı.'**
  String get errWorkProgramScopeInvalid;

  /// work.protected_field
  ///
  /// In tr, this message translates to:
  /// **'Bu alan değiştirilemez.'**
  String get errWorkProtectedField;

  /// work.revert_reason_required
  ///
  /// In tr, this message translates to:
  /// **'Geri alma için gerekçe gerekli.'**
  String get errWorkRevertReasonRequired;

  /// work.stale_completion
  ///
  /// In tr, this message translates to:
  /// **'Görev başka biri tarafından güncellendi; yenileyip yeniden deneyin.'**
  String get errWorkStaleCompletion;

  /// work.stale_transition
  ///
  /// In tr, this message translates to:
  /// **'Görev durumu değişti; yenileyip yeniden deneyin.'**
  String get errWorkStaleTransition;

  /// work.subtask_assignee_not_assigned
  ///
  /// In tr, this message translates to:
  /// **'Alt görevin sorumlusu görevin atanmış kişilerinden biri olmalı.'**
  String get errWorkSubtaskAssigneeNotAssigned;

  /// work.subtask_limit_reached
  ///
  /// In tr, this message translates to:
  /// **'Alt görev sınırına ulaşıldı.'**
  String get errWorkSubtaskLimitReached;

  /// work.subtask_not_found
  ///
  /// In tr, this message translates to:
  /// **'Alt görev bulunamadı.'**
  String get errWorkSubtaskNotFound;

  /// work.subtasks_open
  ///
  /// In tr, this message translates to:
  /// **'Açık alt görevler var; önce bunları tamamlayın ya da kapatın.'**
  String get errWorkSubtasksOpen;

  /// work.transfer_active
  ///
  /// In tr, this message translates to:
  /// **'Devam eden bir aktarım nedeniyle görev değiştirilemez.'**
  String get errWorkTransferActive;

  /// work.transition_not_allowed
  ///
  /// In tr, this message translates to:
  /// **'Bu durum geçişine izin verilmiyor.'**
  String get errWorkTransitionNotAllowed;

  /// client.insecure_server
  ///
  /// In tr, this message translates to:
  /// **'Sunucu adresi https ile başlamalı; güvenli olmayan bağlantı kurulmaz.'**
  String get errClientInsecureServer;

  /// client.invalid_response
  ///
  /// In tr, this message translates to:
  /// **'Sunucudan beklenmeyen bir yanıt geldi.'**
  String get errClientInvalidResponse;

  /// client.invalid_server_address
  ///
  /// In tr, this message translates to:
  /// **'Sunucu adresi geçersiz.'**
  String get errClientInvalidServerAddress;

  /// client.network_error
  ///
  /// In tr, this message translates to:
  /// **'Sunucuya ulaşılamadı. Bağlantınızı kontrol edip yeniden deneyin.'**
  String get errClientNetworkError;

  /// client.not_signed_in
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için giriş yapılmalı.'**
  String get errClientNotSignedIn;

  /// client.reauth_required
  ///
  /// In tr, this message translates to:
  /// **'Oturum doğrulanamadı. Güvenliğiniz için yeniden giriş yapın.'**
  String get errClientReauthRequired;

  /// client.scope_missing
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için önce program veya departman seçilmeli.'**
  String get errClientScopeMissing;

  /// client.secure_storage_error
  ///
  /// In tr, this message translates to:
  /// **'Oturum bilgisi cihazda güvenli olarak saklanamadı. Yeniden giriş yapın.'**
  String get errClientSecureStorageError;

  /// client.server_not_verified
  ///
  /// In tr, this message translates to:
  /// **'Önce sunucu adresi doğrulanmalı.'**
  String get errClientServerNotVerified;

  /// client.server_unrecognized
  ///
  /// In tr, this message translates to:
  /// **'Bu adres bir NIZAM.IO sunucusu değil.'**
  String get errClientServerUnrecognized;

  /// client.session_ended
  ///
  /// In tr, this message translates to:
  /// **'Oturum sona erdi. Yeniden giriş yapın.'**
  String get errClientSessionEnded;

  /// client.session_refreshed
  ///
  /// In tr, this message translates to:
  /// **'Oturum yenilendi; dosya gönderilmedi. Yüklemeyi yeniden deneyin.'**
  String get errClientSessionRefreshed;

  /// client.timeout
  ///
  /// In tr, this message translates to:
  /// **'Sunucu zamanında yanıt vermedi. Biraz sonra yeniden deneyin.'**
  String get errClientTimeout;

  /// client.tls_error
  ///
  /// In tr, this message translates to:
  /// **'Sunucunun güvenlik sertifikası doğrulanamadı; bağlantı kurulmadı.'**
  String get errClientTlsError;

  /// client.unknown_operation
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem uygulamanın bu sürümünde tanımlı değil.'**
  String get errClientUnknownOperation;

  /// client.unsupported_api_version
  ///
  /// In tr, this message translates to:
  /// **'Sunucunun API sürümü bu uygulamayla uyumlu değil.'**
  String get errClientUnsupportedApiVersion;

  /// client.update_required
  ///
  /// In tr, this message translates to:
  /// **'Bu sunucuya bağlanmak için uygulamayı güncelleyin.'**
  String get errClientUpdateRequired;

  /// ui.activity.title
  ///
  /// In tr, this message translates to:
  /// **'İşlem geçmişi'**
  String get uiActivityTitle;

  /// ui.activity.intro
  ///
  /// In tr, this message translates to:
  /// **'Portaldaki tüm işlemler değiştirilemez biçimde saklanır.'**
  String get uiActivityIntro;

  /// ui.activity.csv
  ///
  /// In tr, this message translates to:
  /// **'CSV olarak indir'**
  String get uiActivityCsv;

  /// ui.activity.csv_export
  ///
  /// In tr, this message translates to:
  /// **'CSV indirme'**
  String get uiActivityCsvExport;

  /// ui.activity.search_hint
  ///
  /// In tr, this message translates to:
  /// **'İşlem, hedef veya kişi ara'**
  String get uiActivitySearchHint;

  /// ui.activity.filters
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get uiActivityFilters;

  /// ui.activity.filters_label
  ///
  /// In tr, this message translates to:
  /// **'Filtreler · yapan, koordinatörlük'**
  String get uiActivityFiltersLabel;

  /// ui.activity.type_label
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get uiActivityTypeLabel;

  /// ui.activity.type_all
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get uiActivityTypeAll;

  /// ui.activity.type_task
  ///
  /// In tr, this message translates to:
  /// **'Görev'**
  String get uiActivityTypeTask;

  /// ui.activity.type_file
  ///
  /// In tr, this message translates to:
  /// **'Dosya'**
  String get uiActivityTypeFile;

  /// ui.activity.type_meeting
  ///
  /// In tr, this message translates to:
  /// **'Toplantı'**
  String get uiActivityTypeMeeting;

  /// ui.activity.type_message
  ///
  /// In tr, this message translates to:
  /// **'Mesaj'**
  String get uiActivityTypeMessage;

  /// ui.activity.type_account
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get uiActivityTypeAccount;

  /// ui.activity.chip_type
  ///
  /// In tr, this message translates to:
  /// **'Tür:'**
  String get uiActivityChipType;

  /// ui.activity.remove_type
  ///
  /// In tr, this message translates to:
  /// **'Tür filtresini kaldır'**
  String get uiActivityRemoveType;

  /// ui.activity.remove_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük filtresini kaldır'**
  String get uiActivityRemoveCoord;

  /// ui.activity.remove_tail
  ///
  /// In tr, this message translates to:
  /// **'filtresini kaldır'**
  String get uiActivityRemoveTail;

  /// ui.activity.clear_all
  ///
  /// In tr, this message translates to:
  /// **'Tümünü temizle'**
  String get uiActivityClearAll;

  /// ui.activity.records
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlar'**
  String get uiActivityRecords;

  /// ui.activity.today
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get uiActivityToday;

  /// ui.activity.yesterday
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get uiActivityYesterday;

  /// ui.activity.empty
  ///
  /// In tr, this message translates to:
  /// **'Bu filtrelerle eşleşen kayıt yok.'**
  String get uiActivityEmpty;

  /// ui.activity.clear_filters
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri temizle'**
  String get uiActivityClearFilters;

  /// ui.activity.more
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla göster'**
  String get uiActivityMore;

  /// ui.activity.shown_tail
  ///
  /// In tr, this message translates to:
  /// **'kayıt gösteriliyor'**
  String get uiActivityShownTail;

  /// ui.activity.footer
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlar değiştirilemez ve silinemez; denetim için saklanır.'**
  String get uiActivityFooter;

  /// ui.activity.clear
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get uiActivityClear;

  /// ui.activity.by_role
  ///
  /// In tr, this message translates to:
  /// **'yapan · rolüne göre'**
  String get uiActivityByRole;

  /// ui.activity.coordinatorship
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlük'**
  String get uiActivityCoordinatorship;

  /// ui.activity.apply_tail
  ///
  /// In tr, this message translates to:
  /// **'kaydı göster'**
  String get uiActivityApplyTail;

  /// ui.activity.role_admin
  ///
  /// In tr, this message translates to:
  /// **'Admin'**
  String get uiActivityRoleAdmin;

  /// ui.activity.role_coordinator
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör'**
  String get uiActivityRoleCoordinator;

  /// ui.activity.role_member
  ///
  /// In tr, this message translates to:
  /// **'Üye'**
  String get uiActivityRoleMember;

  /// ui.activity.count_tail
  ///
  /// In tr, this message translates to:
  /// **'kayıt'**
  String get uiActivityCountTail;

  /// ui.activity.shortcuts
  ///
  /// In tr, this message translates to:
  /// **'İşlem geçmişi kısayolları'**
  String get uiActivityShortcuts;

  /// ui.activity.section_type
  ///
  /// In tr, this message translates to:
  /// **'kayıt türü'**
  String get uiActivitySectionType;

  /// ui.activity.section_history
  ///
  /// In tr, this message translates to:
  /// **'işlem geçmişi'**
  String get uiActivitySectionHistory;

  /// ui.activity.fly_filter
  ///
  /// In tr, this message translates to:
  /// **'Kişi ve koordinatörlük filtresi'**
  String get uiActivityFlyFilter;

  /// ui.activity.fly_home
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfaya dön'**
  String get uiActivityFlyHome;

  /// ui.activity.soon_tail
  ///
  /// In tr, this message translates to:
  /// **'mobilde sonraki adımda eklenecek'**
  String get uiActivitySoonTail;

  /// ui.archive.title
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get uiArchiveTitle;

  /// ui.archive.folder_title
  ///
  /// In tr, this message translates to:
  /// **'Klasör'**
  String get uiArchiveFolderTitle;

  /// ui.archive.search
  ///
  /// In tr, this message translates to:
  /// **'Arşivde ara'**
  String get uiArchiveSearch;

  /// ui.archive.search_hint
  ///
  /// In tr, this message translates to:
  /// **'Dosya, görev, kişi veya etiket'**
  String get uiArchiveSearchHint;

  /// ui.archive.upload
  ///
  /// In tr, this message translates to:
  /// **'Dosya yükle'**
  String get uiArchiveUpload;

  /// ui.archive.upload_short
  ///
  /// In tr, this message translates to:
  /// **'Yükle'**
  String get uiArchiveUploadShort;

  /// ui.archive.upload_soon
  ///
  /// In tr, this message translates to:
  /// **'Dosya yükleme sonraki adımda tasarlanacak'**
  String get uiArchiveUploadSoon;

  /// ui.archive.tags
  ///
  /// In tr, this message translates to:
  /// **'Etiketler'**
  String get uiArchiveTags;

  /// ui.archive.tags_clear
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get uiArchiveTagsClear;

  /// ui.archive.new_tag
  ///
  /// In tr, this message translates to:
  /// **'Yeni etiket'**
  String get uiArchiveNewTag;

  /// ui.archive.tag_color
  ///
  /// In tr, this message translates to:
  /// **'Etiket rengi'**
  String get uiArchiveTagColor;

  /// ui.archive.add_tag
  ///
  /// In tr, this message translates to:
  /// **'Etiketi ekle'**
  String get uiArchiveAddTag;

  /// ui.archive.tag_added
  ///
  /// In tr, this message translates to:
  /// **'etiketi eklendi'**
  String get uiArchiveTagAdded;

  /// ui.archive.color_violet
  ///
  /// In tr, this message translates to:
  /// **'Mor'**
  String get uiArchiveColorViolet;

  /// ui.archive.color_gold
  ///
  /// In tr, this message translates to:
  /// **'Sarı'**
  String get uiArchiveColorGold;

  /// ui.archive.color_green
  ///
  /// In tr, this message translates to:
  /// **'Yeşil'**
  String get uiArchiveColorGreen;

  /// ui.archive.color_red
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı'**
  String get uiArchiveColorRed;

  /// ui.archive.color_gray
  ///
  /// In tr, this message translates to:
  /// **'Gri'**
  String get uiArchiveColorGray;

  /// ui.archive.tag_field
  ///
  /// In tr, this message translates to:
  /// **'Saha görselleri'**
  String get uiArchiveTagField;

  /// ui.archive.tag_result
  ///
  /// In tr, this message translates to:
  /// **'Sonuç dosyası'**
  String get uiArchiveTagResult;

  /// ui.archive.tag_data
  ///
  /// In tr, this message translates to:
  /// **'Güncel durum verisi'**
  String get uiArchiveTagData;

  /// ui.archive.tag_field_short
  ///
  /// In tr, this message translates to:
  /// **'Saha'**
  String get uiArchiveTagFieldShort;

  /// ui.archive.tag_result_short
  ///
  /// In tr, this message translates to:
  /// **'Sonuç'**
  String get uiArchiveTagResultShort;

  /// ui.archive.tag_data_short
  ///
  /// In tr, this message translates to:
  /// **'Güncel'**
  String get uiArchiveTagDataShort;

  /// ui.archive.storage
  ///
  /// In tr, this message translates to:
  /// **'Depolama'**
  String get uiArchiveStorage;

  /// ui.archive.mb
  ///
  /// In tr, this message translates to:
  /// **'MB'**
  String get uiArchiveMb;

  /// ui.archive.kb
  ///
  /// In tr, this message translates to:
  /// **'KB'**
  String get uiArchiveKb;

  /// ui.archive.files_lc
  ///
  /// In tr, this message translates to:
  /// **'dosya'**
  String get uiArchiveFilesLc;

  /// ui.archive.folders_lc
  ///
  /// In tr, this message translates to:
  /// **'klasör'**
  String get uiArchiveFoldersLc;

  /// ui.archive.coordinatorships_lc
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlükler'**
  String get uiArchiveCoordinatorshipsLc;

  /// ui.archive.sort_recent
  ///
  /// In tr, this message translates to:
  /// **'Son yükleme'**
  String get uiArchiveSortRecent;

  /// ui.archive.sort_name
  ///
  /// In tr, this message translates to:
  /// **'Ada göre'**
  String get uiArchiveSortName;

  /// ui.archive.sort_size
  ///
  /// In tr, this message translates to:
  /// **'Boyuta göre'**
  String get uiArchiveSortSize;

  /// ui.archive.sort_hint
  ///
  /// In tr, this message translates to:
  /// **'Sıralamayı değiştir'**
  String get uiArchiveSortHint;

  /// ui.archive.no_files
  ///
  /// In tr, this message translates to:
  /// **'Dosya yok'**
  String get uiArchiveNoFiles;

  /// ui.archive.empty_search
  ///
  /// In tr, this message translates to:
  /// **'Bu aramayla eşleşen klasör yok.'**
  String get uiArchiveEmptySearch;

  /// ui.archive.download_all
  ///
  /// In tr, this message translates to:
  /// **'Tümünü indir'**
  String get uiArchiveDownloadAll;

  /// ui.archive.download_all_toast
  ///
  /// In tr, this message translates to:
  /// **'Tüm arşiv hazırlanıyor · bitince bildirim gelir'**
  String get uiArchiveDownloadAllToast;

  /// ui.archive.create_folder
  ///
  /// In tr, this message translates to:
  /// **'Klasör oluştur'**
  String get uiArchiveCreateFolder;

  /// ui.archive.create_folder_soon
  ///
  /// In tr, this message translates to:
  /// **'Klasör oluşturma sonraki adımda tasarlanacak'**
  String get uiArchiveCreateFolderSoon;

  /// ui.archive.shortcuts
  ///
  /// In tr, this message translates to:
  /// **'Arşiv kısayolları'**
  String get uiArchiveShortcuts;

  /// ui.archive.section_archive
  ///
  /// In tr, this message translates to:
  /// **'arşiv'**
  String get uiArchiveSectionArchive;

  /// ui.archive.section_go
  ///
  /// In tr, this message translates to:
  /// **'git'**
  String get uiArchiveSectionGo;

  /// ui.archive.go_coordinatorships
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlükler'**
  String get uiArchiveGoCoordinatorships;

  /// ui.archive.section_folders
  ///
  /// In tr, this message translates to:
  /// **'arşiv klasörleri'**
  String get uiArchiveSectionFolders;

  /// ui.archive.all_archive
  ///
  /// In tr, this message translates to:
  /// **'Tüm arşiv'**
  String get uiArchiveAllArchive;

  /// ui.archive.zip
  ///
  /// In tr, this message translates to:
  /// **'Klasörü ZIP olarak indir'**
  String get uiArchiveZip;

  /// ui.archive.zip_toast
  ///
  /// In tr, this message translates to:
  /// **'klasörü ZIP olarak hazırlanıyor'**
  String get uiArchiveZipToast;

  /// ui.archive.coordinatorship
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiArchiveCoordinatorship;

  /// ui.archive.no_lead
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör yok'**
  String get uiArchiveNoLead;

  /// ui.archive.tabs
  ///
  /// In tr, this message translates to:
  /// **'Klasör'**
  String get uiArchiveTabs;

  /// ui.archive.tab_tasks
  ///
  /// In tr, this message translates to:
  /// **'Görev klasörleri'**
  String get uiArchiveTabTasks;

  /// ui.archive.tab_files
  ///
  /// In tr, this message translates to:
  /// **'Dosyalar'**
  String get uiArchiveTabFiles;

  /// ui.archive.filter_all
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get uiArchiveFilterAll;

  /// ui.archive.tag_filter
  ///
  /// In tr, this message translates to:
  /// **'Etiket süzgeci'**
  String get uiArchiveTagFilter;

  /// ui.archive.remove_task_filter
  ///
  /// In tr, this message translates to:
  /// **'Görev filtresini kaldır'**
  String get uiArchiveRemoveTaskFilter;

  /// ui.archive.empty_files
  ///
  /// In tr, this message translates to:
  /// **'Bu filtreyle eşleşen dosya yok.'**
  String get uiArchiveEmptyFiles;

  /// ui.archive.preview
  ///
  /// In tr, this message translates to:
  /// **'Dosya önizleme'**
  String get uiArchivePreview;

  /// ui.archive.prev
  ///
  /// In tr, this message translates to:
  /// **'Önceki dosya'**
  String get uiArchivePrev;

  /// ui.archive.next
  ///
  /// In tr, this message translates to:
  /// **'Sonraki dosya'**
  String get uiArchiveNext;

  /// ui.archive.preview_area
  ///
  /// In tr, this message translates to:
  /// **'Önizleme alanı'**
  String get uiArchivePreviewArea;

  /// ui.archive.fact_task
  ///
  /// In tr, this message translates to:
  /// **'Görev'**
  String get uiArchiveFactTask;

  /// ui.archive.fact_tag
  ///
  /// In tr, this message translates to:
  /// **'Etiket'**
  String get uiArchiveFactTag;

  /// ui.archive.fact_by
  ///
  /// In tr, this message translates to:
  /// **'Yükleyen'**
  String get uiArchiveFactBy;

  /// ui.archive.fact_date
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get uiArchiveFactDate;

  /// ui.archive.uploader_unknown
  ///
  /// In tr, this message translates to:
  /// **'Admin'**
  String get uiArchiveUploaderUnknown;

  /// ui.archive.download
  ///
  /// In tr, this message translates to:
  /// **'İndir'**
  String get uiArchiveDownload;

  /// ui.archive.downloading
  ///
  /// In tr, this message translates to:
  /// **'indiriliyor'**
  String get uiArchiveDownloading;

  /// ui.archive.retag
  ///
  /// In tr, this message translates to:
  /// **'Etiketi değiştir'**
  String get uiArchiveRetag;

  /// ui.archive.move
  ///
  /// In tr, this message translates to:
  /// **'Başka klasöre taşı'**
  String get uiArchiveMove;

  /// ui.archive.delete
  ///
  /// In tr, this message translates to:
  /// **'Dosyayı sil'**
  String get uiArchiveDelete;

  /// ui.archive.retag_soon
  ///
  /// In tr, this message translates to:
  /// **'Etiket seçimi sonraki adımda tasarlanacak'**
  String get uiArchiveRetagSoon;

  /// ui.archive.move_soon
  ///
  /// In tr, this message translates to:
  /// **'Klasör seçimi sonraki adımda tasarlanacak'**
  String get uiArchiveMoveSoon;

  /// ui.archive.deleted
  ///
  /// In tr, this message translates to:
  /// **'Dosya silinen kayıtlara taşındı'**
  String get uiArchiveDeleted;

  /// ui.archive.kind_image
  ///
  /// In tr, this message translates to:
  /// **'Resim'**
  String get uiArchiveKindImage;

  /// ui.archive.kind_document
  ///
  /// In tr, this message translates to:
  /// **'Belge'**
  String get uiArchiveKindDocument;

  /// ui.archive.kind_pdf
  ///
  /// In tr, this message translates to:
  /// **'PDF'**
  String get uiArchiveKindPdf;

  /// ui.archive.kind_image_short
  ///
  /// In tr, this message translates to:
  /// **'IMG'**
  String get uiArchiveKindImageShort;

  /// ui.archive.kind_document_short
  ///
  /// In tr, this message translates to:
  /// **'DOC'**
  String get uiArchiveKindDocumentShort;

  /// ui.archive.kind_pdf_short
  ///
  /// In tr, this message translates to:
  /// **'PDF'**
  String get uiArchiveKindPdfShort;

  /// ui.buttons.busy
  ///
  /// In tr, this message translates to:
  /// **'Meşgul'**
  String get uiButtonsBusy;

  /// ui.calendar.title
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get uiCalendarTitle;

  /// ui.calendar.today
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get uiCalendarToday;

  /// ui.calendar.plan_meeting
  ///
  /// In tr, this message translates to:
  /// **'Seçili güne toplantı planla'**
  String get uiCalendarPlanMeeting;

  /// ui.calendar.grid
  ///
  /// In tr, this message translates to:
  /// **'Takvim ızgarası'**
  String get uiCalendarGrid;

  /// ui.calendar.collapse
  ///
  /// In tr, this message translates to:
  /// **'Haftaya daralt'**
  String get uiCalendarCollapse;

  /// ui.calendar.expand
  ///
  /// In tr, this message translates to:
  /// **'Aya genişlet'**
  String get uiCalendarExpand;

  /// ui.calendar.prev_month
  ///
  /// In tr, this message translates to:
  /// **'Önceki ay'**
  String get uiCalendarPrevMonth;

  /// ui.calendar.next_month
  ///
  /// In tr, this message translates to:
  /// **'Sonraki ay'**
  String get uiCalendarNextMonth;

  /// ui.calendar.prev_week
  ///
  /// In tr, this message translates to:
  /// **'Önceki hafta'**
  String get uiCalendarPrevWeek;

  /// ui.calendar.next_week
  ///
  /// In tr, this message translates to:
  /// **'Sonraki hafta'**
  String get uiCalendarNextWeek;

  /// ui.calendar.week_lc
  ///
  /// In tr, this message translates to:
  /// **'hafta'**
  String get uiCalendarWeekLc;

  /// ui.calendar.weekdays_short
  ///
  /// In tr, this message translates to:
  /// **'Pt Sa Ça Pe Cu Ct Pz'**
  String get uiCalendarWeekdaysShort;

  /// ui.calendar.rel_today
  ///
  /// In tr, this message translates to:
  /// **'bugün'**
  String get uiCalendarRelToday;

  /// ui.calendar.rel_tomorrow
  ///
  /// In tr, this message translates to:
  /// **'yarın'**
  String get uiCalendarRelTomorrow;

  /// ui.calendar.rel_yesterday
  ///
  /// In tr, this message translates to:
  /// **'dün'**
  String get uiCalendarRelYesterday;

  /// ui.calendar.rel_after
  ///
  /// In tr, this message translates to:
  /// **'gün sonra'**
  String get uiCalendarRelAfter;

  /// ui.calendar.rel_before
  ///
  /// In tr, this message translates to:
  /// **'gün önce'**
  String get uiCalendarRelBefore;

  /// ui.calendar.records_lc
  ///
  /// In tr, this message translates to:
  /// **'kayıt'**
  String get uiCalendarRecordsLc;

  /// ui.calendar.season_lc
  ///
  /// In tr, this message translates to:
  /// **'sezon'**
  String get uiCalendarSeasonLc;

  /// ui.calendar.group_meetings
  ///
  /// In tr, this message translates to:
  /// **'toplantılar'**
  String get uiCalendarGroupMeetings;

  /// ui.calendar.group_tasks
  ///
  /// In tr, this message translates to:
  /// **'görevler'**
  String get uiCalendarGroupTasks;

  /// ui.calendar.group_requests
  ///
  /// In tr, this message translates to:
  /// **'talepler'**
  String get uiCalendarGroupRequests;

  /// ui.calendar.group_sheets
  ///
  /// In tr, this message translates to:
  /// **'tablo kayıtları'**
  String get uiCalendarGroupSheets;

  /// ui.calendar.participants_lc
  ///
  /// In tr, this message translates to:
  /// **'katılımcı'**
  String get uiCalendarParticipantsLc;

  /// ui.calendar.agenda_lc
  ///
  /// In tr, this message translates to:
  /// **'gündem'**
  String get uiCalendarAgendaLc;

  /// ui.calendar.people_lc
  ///
  /// In tr, this message translates to:
  /// **'kişi'**
  String get uiCalendarPeopleLc;

  /// ui.calendar.task_ends
  ///
  /// In tr, this message translates to:
  /// **'Bitiyor'**
  String get uiCalendarTaskEnds;

  /// ui.calendar.task_starts
  ///
  /// In tr, this message translates to:
  /// **'Başlıyor'**
  String get uiCalendarTaskStarts;

  /// ui.calendar.late_lc
  ///
  /// In tr, this message translates to:
  /// **'gecikti'**
  String get uiCalendarLateLc;

  /// ui.calendar.done_lc
  ///
  /// In tr, this message translates to:
  /// **'yapıldı'**
  String get uiCalendarDoneLc;

  /// ui.calendar.req_purchase
  ///
  /// In tr, this message translates to:
  /// **'Satın alma'**
  String get uiCalendarReqPurchase;

  /// ui.calendar.req_quote
  ///
  /// In tr, this message translates to:
  /// **'Fiyat teklifi'**
  String get uiCalendarReqQuote;

  /// ui.calendar.req_expense
  ///
  /// In tr, this message translates to:
  /// **'Masraf'**
  String get uiCalendarReqExpense;

  /// ui.calendar.req_budget
  ///
  /// In tr, this message translates to:
  /// **'Ek bütçe'**
  String get uiCalendarReqBudget;

  /// ui.calendar.state_pending
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get uiCalendarStatePending;

  /// ui.calendar.state_approved
  ///
  /// In tr, this message translates to:
  /// **'Onaylandı'**
  String get uiCalendarStateApproved;

  /// ui.calendar.state_ordered
  ///
  /// In tr, this message translates to:
  /// **'Sipariş verildi'**
  String get uiCalendarStateOrdered;

  /// ui.calendar.state_delivered
  ///
  /// In tr, this message translates to:
  /// **'Teslim alındı'**
  String get uiCalendarStateDelivered;

  /// ui.calendar.empty
  ///
  /// In tr, this message translates to:
  /// **'Bu gün için planlanmış bir şey yok.'**
  String get uiCalendarEmpty;

  /// ui.calendar.plan
  ///
  /// In tr, this message translates to:
  /// **'Toplantı planla'**
  String get uiCalendarPlan;

  /// ui.calendar.all_coordinatorships
  ///
  /// In tr, this message translates to:
  /// **'Tüm koordinatörlükler'**
  String get uiCalendarAllCoordinatorships;

  /// ui.calendar.preview
  ///
  /// In tr, this message translates to:
  /// **'Kayıt önizleme'**
  String get uiCalendarPreview;

  /// ui.calendar.kicker_meeting
  ///
  /// In tr, this message translates to:
  /// **'toplantı'**
  String get uiCalendarKickerMeeting;

  /// ui.calendar.kicker_request
  ///
  /// In tr, this message translates to:
  /// **'talep'**
  String get uiCalendarKickerRequest;

  /// ui.calendar.kicker_sheet
  ///
  /// In tr, this message translates to:
  /// **'tablo kaydı'**
  String get uiCalendarKickerSheet;

  /// ui.calendar.fact_time
  ///
  /// In tr, this message translates to:
  /// **'Zaman'**
  String get uiCalendarFactTime;

  /// ui.calendar.fact_place
  ///
  /// In tr, this message translates to:
  /// **'Yer'**
  String get uiCalendarFactPlace;

  /// ui.calendar.fact_invited
  ///
  /// In tr, this message translates to:
  /// **'Davetli'**
  String get uiCalendarFactInvited;

  /// ui.calendar.fact_type
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get uiCalendarFactType;

  /// ui.calendar.fact_coordinatorship
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiCalendarFactCoordinatorship;

  /// ui.calendar.fact_amount
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get uiCalendarFactAmount;

  /// ui.calendar.fact_state
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get uiCalendarFactState;

  /// ui.calendar.fact_need
  ///
  /// In tr, this message translates to:
  /// **'İhtiyaç tarihi'**
  String get uiCalendarFactNeed;

  /// ui.calendar.fact_task
  ///
  /// In tr, this message translates to:
  /// **'Bağlı görev'**
  String get uiCalendarFactTask;

  /// ui.calendar.fact_table
  ///
  /// In tr, this message translates to:
  /// **'Tablo'**
  String get uiCalendarFactTable;

  /// ui.calendar.fact_date
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get uiCalendarFactDate;

  /// ui.calendar.fact_person
  ///
  /// In tr, this message translates to:
  /// **'Kişi'**
  String get uiCalendarFactPerson;

  /// ui.calendar.quote_pending
  ///
  /// In tr, this message translates to:
  /// **'Teklif bekleniyor'**
  String get uiCalendarQuotePending;

  /// ui.calendar.sheet_done
  ///
  /// In tr, this message translates to:
  /// **'Yapıldı'**
  String get uiCalendarSheetDone;

  /// ui.calendar.sheet_waiting
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get uiCalendarSheetWaiting;

  /// ui.calendar.remind
  ///
  /// In tr, this message translates to:
  /// **'Hatırlat'**
  String get uiCalendarRemind;

  /// ui.calendar.reminded
  ///
  /// In tr, this message translates to:
  /// **'Katılımcılara hatırlatma gönderildi'**
  String get uiCalendarReminded;

  /// ui.calendar.write_group
  ///
  /// In tr, this message translates to:
  /// **'Gruba yaz'**
  String get uiCalendarWriteGroup;

  /// ui.calendar.close
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get uiCalendarClose;

  /// ui.calendar.go_task
  ///
  /// In tr, this message translates to:
  /// **'Bağlı göreve git'**
  String get uiCalendarGoTask;

  /// ui.calendar.go_coordinatorship
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlüğe git'**
  String get uiCalendarGoCoordinatorship;

  /// ui.calendar.pick_title
  ///
  /// In tr, this message translates to:
  /// **'Bir kayıt seç'**
  String get uiCalendarPickTitle;

  /// ui.calendar.pick_body
  ///
  /// In tr, this message translates to:
  /// **'Soldaki listeden bir göreve dokun, ayrıntısı burada açılır. Toplantı ve talepler önizleme penceresinde açılır.'**
  String get uiCalendarPickBody;

  /// ui.common.retry
  ///
  /// In tr, this message translates to:
  /// **'Yeniden dene'**
  String get uiCommonRetry;

  /// ui.common.cancel
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get uiCommonCancel;

  /// ui.common.ok
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get uiCommonOk;

  /// ui.common.close
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get uiCommonClose;

  /// ui.coord.title
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlükler'**
  String get uiCoordTitle;

  /// ui.coord.detail_title
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiCoordDetailTitle;

  /// ui.coord.count_tail
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlük'**
  String get uiCoordCountTail;

  /// ui.coord.tasks_tail
  ///
  /// In tr, this message translates to:
  /// **'görev'**
  String get uiCoordTasksTail;

  /// ui.coord.late_coords_tail
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlükte gecikme'**
  String get uiCoordLateCoordsTail;

  /// ui.coord.done_tail
  ///
  /// In tr, this message translates to:
  /// **'bitti'**
  String get uiCoordDoneTail;

  /// ui.coord.late_tail
  ///
  /// In tr, this message translates to:
  /// **'gecikmede'**
  String get uiCoordLateTail;

  /// ui.coord.no_lead
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör yok'**
  String get uiCoordNoLead;

  /// ui.coord.member_suffix
  ///
  /// In tr, this message translates to:
  /// **'(üye)'**
  String get uiCoordMemberSuffix;

  /// ui.coord.list_label
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük listesi'**
  String get uiCoordListLabel;

  /// ui.coord.sort_name
  ///
  /// In tr, this message translates to:
  /// **'Ada göre'**
  String get uiCoordSortName;

  /// ui.coord.sort_late
  ///
  /// In tr, this message translates to:
  /// **'Gecikmeye göre'**
  String get uiCoordSortLate;

  /// ui.coord.sort_progress
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeye göre'**
  String get uiCoordSortProgress;

  /// ui.coord.shortcuts
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük kısayolları'**
  String get uiCoordShortcuts;

  /// ui.coord.fly_section_list
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlükler'**
  String get uiCoordFlySectionList;

  /// ui.coord.fly_section_sort
  ///
  /// In tr, this message translates to:
  /// **'sıralama'**
  String get uiCoordFlySectionSort;

  /// ui.coord.fly_timeline_all
  ///
  /// In tr, this message translates to:
  /// **'Tümünü zaman çizelgesinde gör'**
  String get uiCoordFlyTimelineAll;

  /// ui.coord.fly_add
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük ekle'**
  String get uiCoordFlyAdd;

  /// ui.coord.toast_add_form
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük formu açılır'**
  String get uiCoordToastAddForm;

  /// ui.coord.fly_all_list
  ///
  /// In tr, this message translates to:
  /// **'Tüm liste'**
  String get uiCoordFlyAllList;

  /// ui.coord.sub_units_tail
  ///
  /// In tr, this message translates to:
  /// **'alt birim'**
  String get uiCoordSubUnitsTail;

  /// ui.coord.people_tail
  ///
  /// In tr, this message translates to:
  /// **'kişi'**
  String get uiCoordPeopleTail;

  /// ui.coord.state_active
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get uiCoordStateActive;

  /// ui.coord.message_team
  ///
  /// In tr, this message translates to:
  /// **'Ekibe mesaj'**
  String get uiCoordMessageTeam;

  /// ui.coord.assign_task
  ///
  /// In tr, this message translates to:
  /// **'Görev ata'**
  String get uiCoordAssignTask;

  /// ui.coord.tabs_label
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük bölümleri'**
  String get uiCoordTabsLabel;

  /// ui.coord.tab_general
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get uiCoordTabGeneral;

  /// ui.coord.tab_units
  ///
  /// In tr, this message translates to:
  /// **'Birimler'**
  String get uiCoordTabUnits;

  /// ui.coord.tab_team
  ///
  /// In tr, this message translates to:
  /// **'Ekip'**
  String get uiCoordTabTeam;

  /// ui.coord.tab_about
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get uiCoordTabAbout;

  /// ui.coord.summary
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get uiCoordSummary;

  /// ui.coord.kpi_open
  ///
  /// In tr, this message translates to:
  /// **'açık görev'**
  String get uiCoordKpiOpen;

  /// ui.coord.kpi_late
  ///
  /// In tr, this message translates to:
  /// **'geciken'**
  String get uiCoordKpiLate;

  /// ui.coord.kpi_done
  ///
  /// In tr, this message translates to:
  /// **'tamamlanma'**
  String get uiCoordKpiDone;

  /// ui.coord.pct_note_of
  ///
  /// In tr, this message translates to:
  /// **'görevden'**
  String get uiCoordPctNoteOf;

  /// ui.coord.pct_note_done
  ///
  /// In tr, this message translates to:
  /// **'tamamlandı'**
  String get uiCoordPctNoteDone;

  /// ui.coord.season_average
  ///
  /// In tr, this message translates to:
  /// **'sezon ortalaması'**
  String get uiCoordSeasonAverage;

  /// ui.coord.attention
  ///
  /// In tr, this message translates to:
  /// **'dikkat gerektirenler'**
  String get uiCoordAttention;

  /// ui.coord.all_tasks
  ///
  /// In tr, this message translates to:
  /// **'Tüm görevler'**
  String get uiCoordAllTasks;

  /// ui.coord.days_late_tail
  ///
  /// In tr, this message translates to:
  /// **'gün gecikti'**
  String get uiCoordDaysLateTail;

  /// ui.coord.shortcuts_label
  ///
  /// In tr, this message translates to:
  /// **'Kısayollar'**
  String get uiCoordShortcutsLabel;

  /// ui.coord.link_timeline
  ///
  /// In tr, this message translates to:
  /// **'Zaman çizelgesinde gör'**
  String get uiCoordLinkTimeline;

  /// ui.coord.link_archive
  ///
  /// In tr, this message translates to:
  /// **'Arşiv klasörü'**
  String get uiCoordLinkArchive;

  /// ui.coord.link_meetings
  ///
  /// In tr, this message translates to:
  /// **'Toplantılar'**
  String get uiCoordLinkMeetings;

  /// ui.coord.link_report
  ///
  /// In tr, this message translates to:
  /// **'Birim raporu'**
  String get uiCoordLinkReport;

  /// ui.coord.files_tail
  ///
  /// In tr, this message translates to:
  /// **'dosya'**
  String get uiCoordFilesTail;

  /// ui.coord.planned_tail
  ///
  /// In tr, this message translates to:
  /// **'planlı'**
  String get uiCoordPlannedTail;

  /// ui.coord.none
  ///
  /// In tr, this message translates to:
  /// **'yok'**
  String get uiCoordNone;

  /// ui.coord.report_format
  ///
  /// In tr, this message translates to:
  /// **'PDF'**
  String get uiCoordReportFormat;

  /// ui.coord.toast_meetings_tail
  ///
  /// In tr, this message translates to:
  /// **'toplantıları açılır'**
  String get uiCoordToastMeetingsTail;

  /// ui.coord.toast_report_tail
  ///
  /// In tr, this message translates to:
  /// **'raporu hazırlanıyor'**
  String get uiCoordToastReportTail;

  /// ui.coord.units
  ///
  /// In tr, this message translates to:
  /// **'alt birimler'**
  String get uiCoordUnits;

  /// ui.coord.add
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get uiCoordAdd;

  /// ui.coord.toast_add_unit_tail
  ///
  /// In tr, this message translates to:
  /// **'altına alt birim ekleme formu açılır'**
  String get uiCoordToastAddUnitTail;

  /// ui.coord.toast_unit_tail
  ///
  /// In tr, this message translates to:
  /// **'alt birimi açılır'**
  String get uiCoordToastUnitTail;

  /// ui.coord.team
  ///
  /// In tr, this message translates to:
  /// **'ekip'**
  String get uiCoordTeam;

  /// ui.coord.add_member
  ///
  /// In tr, this message translates to:
  /// **'Üye ekle'**
  String get uiCoordAddMember;

  /// ui.coord.role_lead
  ///
  /// In tr, this message translates to:
  /// **'koordinatör'**
  String get uiCoordRoleLead;

  /// ui.coord.role_member
  ///
  /// In tr, this message translates to:
  /// **'üye'**
  String get uiCoordRoleMember;

  /// ui.coord.unassigned
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör atanmamış'**
  String get uiCoordUnassigned;

  /// ui.coord.unassigned_hint
  ///
  /// In tr, this message translates to:
  /// **'Görev atanabilmesi için bir sorumlu seç'**
  String get uiCoordUnassignedHint;

  /// ui.coord.role_assign
  ///
  /// In tr, this message translates to:
  /// **'ata'**
  String get uiCoordRoleAssign;

  /// ui.coord.toast_pick_lead_tail
  ///
  /// In tr, this message translates to:
  /// **'için koordinatör seçimi açılır'**
  String get uiCoordToastPickLeadTail;

  /// ui.coord.toast_person_tail
  ///
  /// In tr, this message translates to:
  /// **'kişisel takip açılır'**
  String get uiCoordToastPersonTail;

  /// ui.coord.more_members_tail
  ///
  /// In tr, this message translates to:
  /// **'üye daha'**
  String get uiCoordMoreMembersTail;

  /// ui.coord.collapse
  ///
  /// In tr, this message translates to:
  /// **'Daralt'**
  String get uiCoordCollapse;

  /// ui.coord.about
  ///
  /// In tr, this message translates to:
  /// **'hakkında'**
  String get uiCoordAbout;

  /// ui.coord.fact_parent
  ///
  /// In tr, this message translates to:
  /// **'Üst birim'**
  String get uiCoordFactParent;

  /// ui.coord.fact_founded
  ///
  /// In tr, this message translates to:
  /// **'Kuruluş'**
  String get uiCoordFactFounded;

  /// ui.coord.fact_visibility
  ///
  /// In tr, this message translates to:
  /// **'Görünürlük'**
  String get uiCoordFactVisibility;

  /// ui.coord.visibility_all
  ///
  /// In tr, this message translates to:
  /// **'Tüm koordinatörler'**
  String get uiCoordVisibilityAll;

  /// ui.coord.feed
  ///
  /// In tr, this message translates to:
  /// **'son etkinlik'**
  String get uiCoordFeed;

  /// ui.coord.more_actions
  ///
  /// In tr, this message translates to:
  /// **'Diğer işlemler'**
  String get uiCoordMoreActions;

  /// ui.coord.menu_title_tail
  ///
  /// In tr, this message translates to:
  /// **'işlemleri'**
  String get uiCoordMenuTitleTail;

  /// ui.coord.menu_edit
  ///
  /// In tr, this message translates to:
  /// **'Bilgileri düzenle'**
  String get uiCoordMenuEdit;

  /// ui.coord.toast_edit_tail
  ///
  /// In tr, this message translates to:
  /// **'düzenleme formu açılır'**
  String get uiCoordToastEditTail;

  /// ui.coord.menu_meeting
  ///
  /// In tr, this message translates to:
  /// **'Toplantı planla'**
  String get uiCoordMenuMeeting;

  /// ui.coord.menu_parent
  ///
  /// In tr, this message translates to:
  /// **'Üst birimi değiştir'**
  String get uiCoordMenuParent;

  /// ui.coord.toast_parent
  ///
  /// In tr, this message translates to:
  /// **'Üst birim seçimi açılır'**
  String get uiCoordToastParent;

  /// ui.coord.menu_merge
  ///
  /// In tr, this message translates to:
  /// **'Başka koordinatörlükle birleştir'**
  String get uiCoordMenuMerge;

  /// ui.coord.toast_merge
  ///
  /// In tr, this message translates to:
  /// **'Birleştirme önizlemesi açılır'**
  String get uiCoordToastMerge;

  /// ui.coord.menu_deactivate
  ///
  /// In tr, this message translates to:
  /// **'Pasifleştir'**
  String get uiCoordMenuDeactivate;

  /// ui.coord.toast_deactivated_tail
  ///
  /// In tr, this message translates to:
  /// **'pasifleştirildi · görevler arşivde kalır'**
  String get uiCoordToastDeactivatedTail;

  /// ui.coord.not_found
  ///
  /// In tr, this message translates to:
  /// **'Bu koordinatörlük bulunamadı.'**
  String get uiCoordNotFound;

  /// ui.feedback.loading
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get uiFeedbackLoading;

  /// ui.feedback.offline
  ///
  /// In tr, this message translates to:
  /// **'Çevrimdışısınız. Sunucuya ulaşılamıyor.'**
  String get uiFeedbackOffline;

  /// ui.feedback.error_title
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun oluştu'**
  String get uiFeedbackErrorTitle;

  /// ui.feedback.retry_wait
  ///
  /// In tr, this message translates to:
  /// **'Yeniden denemek için bekleyin'**
  String get uiFeedbackRetryWait;

  /// ui.feedback.seconds_unit
  ///
  /// In tr, this message translates to:
  /// **'sn'**
  String get uiFeedbackSecondsUnit;

  /// ui.home.greeting
  ///
  /// In tr, this message translates to:
  /// **'Merhaba'**
  String get uiHomeGreeting;

  /// ui.home.summary_label
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get uiHomeSummaryLabel;

  /// ui.home.kpi_done
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanma'**
  String get uiHomeKpiDone;

  /// ui.home.kpi_doing
  ///
  /// In tr, this message translates to:
  /// **'Devam eden'**
  String get uiHomeKpiDoing;

  /// ui.home.kpi_late
  ///
  /// In tr, this message translates to:
  /// **'Gecikmede'**
  String get uiHomeKpiLate;

  /// ui.home.kpi_review
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleyen'**
  String get uiHomeKpiReview;

  /// ui.home.kpi_done_of
  ///
  /// In tr, this message translates to:
  /// **'görevin'**
  String get uiHomeKpiDoneOf;

  /// ui.home.kpi_done_tail
  ///
  /// In tr, this message translates to:
  /// **'bitti'**
  String get uiHomeKpiDoneTail;

  /// ui.home.kpi_doing_tail
  ///
  /// In tr, this message translates to:
  /// **'tanesi zamanında'**
  String get uiHomeKpiDoingTail;

  /// ui.home.kpi_late_lead
  ///
  /// In tr, this message translates to:
  /// **'Açık görevlerin'**
  String get uiHomeKpiLateLead;

  /// ui.home.kpi_review_caption
  ///
  /// In tr, this message translates to:
  /// **'Kanıt yüklendi, onayda'**
  String get uiHomeKpiReviewCaption;

  /// ui.home.open_list
  ///
  /// In tr, this message translates to:
  /// **'listeyi aç'**
  String get uiHomeOpenList;

  /// ui.home.quick_actions
  ///
  /// In tr, this message translates to:
  /// **'hızlı işlemler'**
  String get uiHomeQuickActions;

  /// ui.home.qa_task
  ///
  /// In tr, this message translates to:
  /// **'Yeni görev'**
  String get uiHomeQaTask;

  /// ui.home.qa_meeting
  ///
  /// In tr, this message translates to:
  /// **'Toplantı'**
  String get uiHomeQaMeeting;

  /// ui.home.qa_invite
  ///
  /// In tr, this message translates to:
  /// **'Davet et'**
  String get uiHomeQaInvite;

  /// ui.home.qa_report
  ///
  /// In tr, this message translates to:
  /// **'Rapor'**
  String get uiHomeQaReport;

  /// ui.home.qa_task_long
  ///
  /// In tr, this message translates to:
  /// **'Yeni görev'**
  String get uiHomeQaTaskLong;

  /// ui.home.qa_meeting_long
  ///
  /// In tr, this message translates to:
  /// **'Toplantı oluştur'**
  String get uiHomeQaMeetingLong;

  /// ui.home.qa_invite_long
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı davet et'**
  String get uiHomeQaInviteLong;

  /// ui.home.qa_report_long
  ///
  /// In tr, this message translates to:
  /// **'Rapor oluştur'**
  String get uiHomeQaReportLong;

  /// ui.home.form_soon
  ///
  /// In tr, this message translates to:
  /// **'Bu form mobilde sonraki adımda eklenecek; şimdilik web portalını kullanabilirsin.'**
  String get uiHomeFormSoon;

  /// ui.home.team
  ///
  /// In tr, this message translates to:
  /// **'ekip'**
  String get uiHomeTeam;

  /// ui.home.users
  ///
  /// In tr, this message translates to:
  /// **'kullanıcı'**
  String get uiHomeUsers;

  /// ui.home.coordinatorships_lc
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlük'**
  String get uiHomeCoordinatorshipsLc;

  /// ui.home.role_admin
  ///
  /// In tr, this message translates to:
  /// **'Admin'**
  String get uiHomeRoleAdmin;

  /// ui.home.role_coordinator
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör'**
  String get uiHomeRoleCoordinator;

  /// ui.home.role_member
  ///
  /// In tr, this message translates to:
  /// **'Üye'**
  String get uiHomeRoleMember;

  /// ui.home.role_admin_lc
  ///
  /// In tr, this message translates to:
  /// **'admin'**
  String get uiHomeRoleAdminLc;

  /// ui.home.role_coordinator_lc
  ///
  /// In tr, this message translates to:
  /// **'koordinatör'**
  String get uiHomeRoleCoordinatorLc;

  /// ui.home.role_member_lc
  ///
  /// In tr, this message translates to:
  /// **'üye'**
  String get uiHomeRoleMemberLc;

  /// ui.home.history_title
  ///
  /// In tr, this message translates to:
  /// **'İşlem geçmişi'**
  String get uiHomeHistoryTitle;

  /// ui.home.history_last
  ///
  /// In tr, this message translates to:
  /// **'Son işlem'**
  String get uiHomeHistoryLast;

  /// ui.home.history_today
  ///
  /// In tr, this message translates to:
  /// **'bugün'**
  String get uiHomeHistoryToday;

  /// ui.home.history_open
  ///
  /// In tr, this message translates to:
  /// **'İşlem geçmişini aç'**
  String get uiHomeHistoryOpen;

  /// ui.home.coordinatorships
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlükler'**
  String get uiHomeCoordinatorships;

  /// ui.home.sort_late
  ///
  /// In tr, this message translates to:
  /// **'Gecikme'**
  String get uiHomeSortLate;

  /// ui.home.sort_progress
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get uiHomeSortProgress;

  /// ui.home.sort_name
  ///
  /// In tr, this message translates to:
  /// **'Ada göre'**
  String get uiHomeSortName;

  /// ui.home.sort_change
  ///
  /// In tr, this message translates to:
  /// **'Sıralama ölçütünü değiştir'**
  String get uiHomeSortChange;

  /// ui.home.sort_flip
  ///
  /// In tr, this message translates to:
  /// **'Sırayı ters çevir'**
  String get uiHomeSortFlip;

  /// ui.home.sort_descending
  ///
  /// In tr, this message translates to:
  /// **'büyükten küçüğe'**
  String get uiHomeSortDescending;

  /// ui.home.sort_ascending
  ///
  /// In tr, this message translates to:
  /// **'küçükten büyüğe'**
  String get uiHomeSortAscending;

  /// ui.home.filter_label
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük durumu'**
  String get uiHomeFilterLabel;

  /// ui.home.filter_all
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get uiHomeFilterAll;

  /// ui.home.filter_late
  ///
  /// In tr, this message translates to:
  /// **'Gecikmesi olan'**
  String get uiHomeFilterLate;

  /// ui.home.filter_on_track
  ///
  /// In tr, this message translates to:
  /// **'Yolunda'**
  String get uiHomeFilterOnTrack;

  /// ui.home.filter_unassigned
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörsüz'**
  String get uiHomeFilterUnassigned;

  /// ui.home.filter_empty
  ///
  /// In tr, this message translates to:
  /// **'Bu filtreye uyan koordinatörlük yok.'**
  String get uiHomeFilterEmpty;

  /// ui.home.unassigned
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör atanmamış'**
  String get uiHomeUnassigned;

  /// ui.home.tasks_lc
  ///
  /// In tr, this message translates to:
  /// **'görev'**
  String get uiHomeTasksLc;

  /// ui.home.late_lc
  ///
  /// In tr, this message translates to:
  /// **'geciken'**
  String get uiHomeLateLc;

  /// ui.home.no_late
  ///
  /// In tr, this message translates to:
  /// **'gecikme yok'**
  String get uiHomeNoLate;

  /// ui.home.show_all
  ///
  /// In tr, this message translates to:
  /// **'Tümünü göster'**
  String get uiHomeShowAll;

  /// ui.home.collapse
  ///
  /// In tr, this message translates to:
  /// **'Daralt'**
  String get uiHomeCollapse;

  /// ui.home.notifications
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get uiHomeNotifications;

  /// ui.home.waiting_tail
  ///
  /// In tr, this message translates to:
  /// **'iş seni bekliyor'**
  String get uiHomeWaitingTail;

  /// ui.home.menu
  ///
  /// In tr, this message translates to:
  /// **'Menü'**
  String get uiHomeMenu;

  /// ui.home.shortcuts
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa kısayolları'**
  String get uiHomeShortcuts;

  /// ui.home.waiting_for_you
  ///
  /// In tr, this message translates to:
  /// **'seni bekleyenler'**
  String get uiHomeWaitingForYou;

  /// ui.home.date_request
  ///
  /// In tr, this message translates to:
  /// **'Tarih talebi'**
  String get uiHomeDateRequest;

  /// ui.home.awaiting_approval
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get uiHomeAwaitingApproval;

  /// ui.home.go
  ///
  /// In tr, this message translates to:
  /// **'git'**
  String get uiHomeGo;

  /// ui.home.group_tracking
  ///
  /// In tr, this message translates to:
  /// **'takip'**
  String get uiHomeGroupTracking;

  /// ui.home.group_content
  ///
  /// In tr, this message translates to:
  /// **'içerik'**
  String get uiHomeGroupContent;

  /// ui.home.group_admin
  ///
  /// In tr, this message translates to:
  /// **'yönetim'**
  String get uiHomeGroupAdmin;

  /// ui.home.group_lab
  ///
  /// In tr, this message translates to:
  /// **'deneysel'**
  String get uiHomeGroupLab;

  /// ui.home.module_home
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get uiHomeModuleHome;

  /// ui.home.module_tracking
  ///
  /// In tr, this message translates to:
  /// **'İş takibi'**
  String get uiHomeModuleTracking;

  /// ui.home.module_tasks
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get uiHomeModuleTasks;

  /// ui.home.module_calendar
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get uiHomeModuleCalendar;

  /// ui.home.module_memory
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal hafıza'**
  String get uiHomeModuleMemory;

  /// ui.home.module_archive
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get uiHomeModuleArchive;

  /// ui.home.module_meetings
  ///
  /// In tr, this message translates to:
  /// **'Toplantılar'**
  String get uiHomeModuleMeetings;

  /// ui.home.module_messages
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get uiHomeModuleMessages;

  /// ui.home.module_sheets
  ///
  /// In tr, this message translates to:
  /// **'Tablolar'**
  String get uiHomeModuleSheets;

  /// ui.home.module_requests
  ///
  /// In tr, this message translates to:
  /// **'Talepler'**
  String get uiHomeModuleRequests;

  /// ui.home.module_budget
  ///
  /// In tr, this message translates to:
  /// **'Bütçe'**
  String get uiHomeModuleBudget;

  /// ui.home.module_users
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcılar'**
  String get uiHomeModuleUsers;

  /// ui.home.module_season
  ///
  /// In tr, this message translates to:
  /// **'Teknofest ve sezon'**
  String get uiHomeModuleSeason;

  /// ui.home.module_simulation
  ///
  /// In tr, this message translates to:
  /// **'Simülasyon'**
  String get uiHomeModuleSimulation;

  /// ui.home.beta
  ///
  /// In tr, this message translates to:
  /// **'beta'**
  String get uiHomeBeta;

  /// ui.home.deleted_records
  ///
  /// In tr, this message translates to:
  /// **'Silinen kayıtlar'**
  String get uiHomeDeletedRecords;

  /// ui.home.help
  ///
  /// In tr, this message translates to:
  /// **'Yardım ve rehberler'**
  String get uiHomeHelp;

  /// ui.home.profile
  ///
  /// In tr, this message translates to:
  /// **'Profil ve hesap'**
  String get uiHomeProfile;

  /// ui.home.soon_tail
  ///
  /// In tr, this message translates to:
  /// **'mobilde sonraki adımda eklenecek'**
  String get uiHomeSoonTail;

  /// ui.home.app_name
  ///
  /// In tr, this message translates to:
  /// **'NIZAM.IO'**
  String get uiHomeAppName;

  /// ui.home.shift_days_tail
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get uiHomeShiftDaysTail;

  /// ui.home.notify_date_requests
  ///
  /// In tr, this message translates to:
  /// **'tarih talebi'**
  String get uiHomeNotifyDateRequests;

  /// ui.home.notify_approvals
  ///
  /// In tr, this message translates to:
  /// **'onay'**
  String get uiHomeNotifyApprovals;

  /// ui.home.notify_and
  ///
  /// In tr, this message translates to:
  /// **'ve'**
  String get uiHomeNotifyAnd;

  /// ui.home.notify_tail
  ///
  /// In tr, this message translates to:
  /// **'seni bekliyor'**
  String get uiHomeNotifyTail;

  /// ui.home.season_tail
  ///
  /// In tr, this message translates to:
  /// **'sezonu'**
  String get uiHomeSeasonTail;

  /// ui.home.version_prefix
  ///
  /// In tr, this message translates to:
  /// **'v'**
  String get uiHomeVersionPrefix;

  /// ui.identity.login_title
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get uiIdentityLoginTitle;

  /// ui.identity.login_server
  ///
  /// In tr, this message translates to:
  /// **'Sunucu'**
  String get uiIdentityLoginServer;

  /// ui.identity.login_email
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get uiIdentityLoginEmail;

  /// ui.identity.login_password
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get uiIdentityLoginPassword;

  /// ui.identity.login_submit
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get uiIdentityLoginSubmit;

  /// ui.identity.password_title
  ///
  /// In tr, this message translates to:
  /// **'Parola değiştir'**
  String get uiIdentityPasswordTitle;

  /// ui.identity.password_intro
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için parolanızı değiştirmeniz gerekiyor. Parola değişince diğer cihazlardaki oturumlarınız kapanır.'**
  String get uiIdentityPasswordIntro;

  /// ui.identity.password_current
  ///
  /// In tr, this message translates to:
  /// **'Mevcut parola'**
  String get uiIdentityPasswordCurrent;

  /// ui.identity.password_new
  ///
  /// In tr, this message translates to:
  /// **'Yeni parola'**
  String get uiIdentityPasswordNew;

  /// ui.identity.password_confirm
  ///
  /// In tr, this message translates to:
  /// **'Yeni parola (tekrar)'**
  String get uiIdentityPasswordConfirm;

  /// ui.identity.password_submit
  ///
  /// In tr, this message translates to:
  /// **'Parolayı değiştir'**
  String get uiIdentityPasswordSubmit;

  /// ui.identity.profile_title
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get uiIdentityProfileTitle;

  /// ui.identity.profile_email
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get uiIdentityProfileEmail;

  /// ui.identity.sign_out
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get uiIdentitySignOut;

  /// ui.identity.sign_out_confirm_title
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapılsın mı?'**
  String get uiIdentitySignOutConfirmTitle;

  /// ui.identity.sign_out_confirm_message
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazdaki oturum kapatılır.'**
  String get uiIdentitySignOutConfirmMessage;

  /// ui.identity.login_intro
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresin ve şifrenle devam et.'**
  String get uiIdentityLoginIntro;

  /// ui.identity.login_submitting
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılıyor…'**
  String get uiIdentityLoginSubmitting;

  /// ui.identity.login_email_hint
  ///
  /// In tr, this message translates to:
  /// **'ad@alan.com'**
  String get uiIdentityLoginEmailHint;

  /// ui.identity.login_password_hint
  ///
  /// In tr, this message translates to:
  /// **'Şifren'**
  String get uiIdentityLoginPasswordHint;

  /// ui.identity.login_version_prefix
  ///
  /// In tr, this message translates to:
  /// **'v'**
  String get uiIdentityLoginVersionPrefix;

  /// ui.identity.login_footer
  ///
  /// In tr, this message translates to:
  /// **'Developed by KAYACAN, COSMAN, CALISKAN'**
  String get uiIdentityLoginFooter;

  /// ui.inputs.password_show
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get uiInputsPasswordShow;

  /// ui.inputs.password_hide
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get uiInputsPasswordHide;

  /// ui.inputs.search
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get uiInputsSearch;

  /// ui.inputs.search_clear
  ///
  /// In tr, this message translates to:
  /// **'Aramayı temizle'**
  String get uiInputsSearchClear;

  /// ui.inputs.select_placeholder
  ///
  /// In tr, this message translates to:
  /// **'Seçin'**
  String get uiInputsSelectPlaceholder;

  /// ui.inputs.invalid_value
  ///
  /// In tr, this message translates to:
  /// **'Değer geçersiz.'**
  String get uiInputsInvalidValue;

  /// ui.inputs.validation_required
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunludur.'**
  String get uiInputsValidationRequired;

  /// ui.inputs.validation_email
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin.'**
  String get uiInputsValidationEmail;

  /// ui.inputs.validation_too_short
  ///
  /// In tr, this message translates to:
  /// **'Değer çok kısa.'**
  String get uiInputsValidationTooShort;

  /// ui.inputs.validation_too_long
  ///
  /// In tr, this message translates to:
  /// **'Değer çok uzun.'**
  String get uiInputsValidationTooLong;

  /// ui.inputs.validation_mismatch
  ///
  /// In tr, this message translates to:
  /// **'Değerler eşleşmiyor.'**
  String get uiInputsValidationMismatch;

  /// ui.inputs.validation_must_accept
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için onaylamanız gerekir.'**
  String get uiInputsValidationMustAccept;

  /// ui.inputs.validation_must_choose
  ///
  /// In tr, this message translates to:
  /// **'Bir seçim yapın.'**
  String get uiInputsValidationMustChoose;

  /// ui.lists.empty_title
  ///
  /// In tr, this message translates to:
  /// **'Gösterilecek kayıt yok'**
  String get uiListsEmptyTitle;

  /// ui.lists.truncated
  ///
  /// In tr, this message translates to:
  /// **'Liste kısaltıldı; yalnız ilk kayıtlar gösteriliyor.'**
  String get uiListsTruncated;

  /// ui.messages.title
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get uiMessagesTitle;

  /// ui.messages.chat_title
  ///
  /// In tr, this message translates to:
  /// **'Sohbet'**
  String get uiMessagesChatTitle;

  /// ui.messages.search
  ///
  /// In tr, this message translates to:
  /// **'Sohbetlerde ara'**
  String get uiMessagesSearch;

  /// ui.messages.search_hint
  ///
  /// In tr, this message translates to:
  /// **'Kişi, grup veya mesaj'**
  String get uiMessagesSearchHint;

  /// ui.messages.new_message
  ///
  /// In tr, this message translates to:
  /// **'Yeni mesaj'**
  String get uiMessagesNewMessage;

  /// ui.messages.new_chat_soon
  ///
  /// In tr, this message translates to:
  /// **'Yeni sohbet sonraki adımda tasarlanacak'**
  String get uiMessagesNewChatSoon;

  /// ui.messages.filters
  ///
  /// In tr, this message translates to:
  /// **'Sohbet süzgeci'**
  String get uiMessagesFilters;

  /// ui.messages.filter_all
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get uiMessagesFilterAll;

  /// ui.messages.filter_unread
  ///
  /// In tr, this message translates to:
  /// **'Okunmamış'**
  String get uiMessagesFilterUnread;

  /// ui.messages.filter_groups
  ///
  /// In tr, this message translates to:
  /// **'Gruplar'**
  String get uiMessagesFilterGroups;

  /// ui.messages.filter_people
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get uiMessagesFilterPeople;

  /// ui.messages.you
  ///
  /// In tr, this message translates to:
  /// **'Sen'**
  String get uiMessagesYou;

  /// ui.messages.empty
  ///
  /// In tr, this message translates to:
  /// **'Eşleşen sohbet yok.'**
  String get uiMessagesEmpty;

  /// ui.messages.unread_lc
  ///
  /// In tr, this message translates to:
  /// **'okunmamış'**
  String get uiMessagesUnreadLc;

  /// ui.messages.shortcuts
  ///
  /// In tr, this message translates to:
  /// **'Mesaj kısayolları'**
  String get uiMessagesShortcuts;

  /// ui.messages.section_messages
  ///
  /// In tr, this message translates to:
  /// **'mesajlar'**
  String get uiMessagesSectionMessages;

  /// ui.messages.unread_only
  ///
  /// In tr, this message translates to:
  /// **'Okunmamışlar'**
  String get uiMessagesUnreadOnly;

  /// ui.messages.mark_all_read
  ///
  /// In tr, this message translates to:
  /// **'Tümünü okundu say'**
  String get uiMessagesMarkAllRead;

  /// ui.messages.today
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get uiMessagesToday;

  /// ui.messages.yesterday
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get uiMessagesYesterday;

  /// ui.messages.members_lc
  ///
  /// In tr, this message translates to:
  /// **'üye'**
  String get uiMessagesMembersLc;

  /// ui.messages.typing
  ///
  /// In tr, this message translates to:
  /// **'yazıyor…'**
  String get uiMessagesTyping;

  /// ui.messages.online
  ///
  /// In tr, this message translates to:
  /// **'çevrimiçi'**
  String get uiMessagesOnline;

  /// ui.messages.last_seen
  ///
  /// In tr, this message translates to:
  /// **'son görülme'**
  String get uiMessagesLastSeen;

  /// ui.messages.yesterday_lc
  ///
  /// In tr, this message translates to:
  /// **'dün'**
  String get uiMessagesYesterdayLc;

  /// ui.messages.search_chat
  ///
  /// In tr, this message translates to:
  /// **'Sohbette ara'**
  String get uiMessagesSearchChat;

  /// ui.messages.search_chat_soon
  ///
  /// In tr, this message translates to:
  /// **'Sohbette arama sonraki adımda tasarlanacak'**
  String get uiMessagesSearchChatSoon;

  /// ui.messages.pinned
  ///
  /// In tr, this message translates to:
  /// **'Sabitlenen mesaj'**
  String get uiMessagesPinned;

  /// ui.messages.new_messages
  ///
  /// In tr, this message translates to:
  /// **'okunmamış mesajlar'**
  String get uiMessagesNewMessages;

  /// ui.messages.edited
  ///
  /// In tr, this message translates to:
  /// **'düzenlendi'**
  String get uiMessagesEdited;

  /// ui.messages.to_bottom
  ///
  /// In tr, this message translates to:
  /// **'En alta in'**
  String get uiMessagesToBottom;

  /// ui.messages.message_hint
  ///
  /// In tr, this message translates to:
  /// **'Mesaj'**
  String get uiMessagesMessageHint;

  /// ui.messages.send
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get uiMessagesSend;

  /// ui.messages.attach
  ///
  /// In tr, this message translates to:
  /// **'Görev, koordinatörlük veya arşiv ekle'**
  String get uiMessagesAttach;

  /// ui.messages.photo_video
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf ve video'**
  String get uiMessagesPhotoVideo;

  /// ui.messages.file
  ///
  /// In tr, this message translates to:
  /// **'Dosya'**
  String get uiMessagesFile;

  /// ui.messages.portal_refs
  ///
  /// In tr, this message translates to:
  /// **'portaldan atıf'**
  String get uiMessagesPortalRefs;

  /// ui.messages.ref_task
  ///
  /// In tr, this message translates to:
  /// **'Görev'**
  String get uiMessagesRefTask;

  /// ui.messages.ref_coordinatorship
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiMessagesRefCoordinatorship;

  /// ui.messages.ref_archive
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get uiMessagesRefArchive;

  /// ui.messages.search_task
  ///
  /// In tr, this message translates to:
  /// **'Görev ara'**
  String get uiMessagesSearchTask;

  /// ui.messages.search_coordinatorship
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük ara'**
  String get uiMessagesSearchCoordinatorship;

  /// ui.messages.search_file
  ///
  /// In tr, this message translates to:
  /// **'Arşivde dosya ara'**
  String get uiMessagesSearchFile;

  /// ui.messages.remove
  ///
  /// In tr, this message translates to:
  /// **'Kaldır'**
  String get uiMessagesRemove;

  /// ui.messages.cancel
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get uiMessagesCancel;

  /// ui.messages.edit_message
  ///
  /// In tr, this message translates to:
  /// **'Mesajı düzenle'**
  String get uiMessagesEditMessage;

  /// ui.messages.reply_self
  ///
  /// In tr, this message translates to:
  /// **'Kendine yanıt'**
  String get uiMessagesReplySelf;

  /// ui.messages.reply_to
  ///
  /// In tr, this message translates to:
  /// **'kişisine yanıt'**
  String get uiMessagesReplyTo;

  /// ui.messages.voted_tail
  ///
  /// In tr, this message translates to:
  /// **'kişi oy verdi'**
  String get uiMessagesVotedTail;

  /// ui.messages.votes_lc
  ///
  /// In tr, this message translates to:
  /// **'oy'**
  String get uiMessagesVotesLc;

  /// ui.messages.react_like
  ///
  /// In tr, this message translates to:
  /// **'Beğen'**
  String get uiMessagesReactLike;

  /// ui.messages.react_heart
  ///
  /// In tr, this message translates to:
  /// **'Kalp'**
  String get uiMessagesReactHeart;

  /// ui.messages.react_check
  ///
  /// In tr, this message translates to:
  /// **'Onay'**
  String get uiMessagesReactCheck;

  /// ui.messages.react_star
  ///
  /// In tr, this message translates to:
  /// **'Yıldız'**
  String get uiMessagesReactStar;

  /// ui.messages.message_actions
  ///
  /// In tr, this message translates to:
  /// **'Mesaj işlemleri'**
  String get uiMessagesMessageActions;

  /// ui.messages.message
  ///
  /// In tr, this message translates to:
  /// **'Mesaj'**
  String get uiMessagesMessage;

  /// ui.messages.quote_jump
  ///
  /// In tr, this message translates to:
  /// **'Alıntılanan mesaja git'**
  String get uiMessagesQuoteJump;

  /// ui.messages.reply
  ///
  /// In tr, this message translates to:
  /// **'Yanıtla'**
  String get uiMessagesReply;

  /// ui.messages.copy
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get uiMessagesCopy;

  /// ui.messages.pin
  ///
  /// In tr, this message translates to:
  /// **'Sabitle'**
  String get uiMessagesPin;

  /// ui.messages.unpin
  ///
  /// In tr, this message translates to:
  /// **'Sabiti kaldır'**
  String get uiMessagesUnpin;

  /// ui.messages.edit
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get uiMessagesEdit;

  /// ui.messages.copied
  ///
  /// In tr, this message translates to:
  /// **'Mesaj kopyalandı'**
  String get uiMessagesCopied;

  /// ui.messages.pinned_toast
  ///
  /// In tr, this message translates to:
  /// **'Mesaj sabitlendi'**
  String get uiMessagesPinnedToast;

  /// ui.messages.unpinned_toast
  ///
  /// In tr, this message translates to:
  /// **'Sabitleme kaldırıldı'**
  String get uiMessagesUnpinnedToast;

  /// ui.messages.poll_results
  ///
  /// In tr, this message translates to:
  /// **'Anket sonuçları'**
  String get uiMessagesPollResults;

  /// ui.messages.poll_results_lc
  ///
  /// In tr, this message translates to:
  /// **'anket sonuçları'**
  String get uiMessagesPollResultsLc;

  /// ui.messages.to_task
  ///
  /// In tr, this message translates to:
  /// **'Göreve dönüştür'**
  String get uiMessagesToTask;

  /// ui.messages.delete
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get uiMessagesDelete;

  /// ui.messages.deleted
  ///
  /// In tr, this message translates to:
  /// **'Mesaj silindi'**
  String get uiMessagesDeleted;

  /// ui.messages.not_voted
  ///
  /// In tr, this message translates to:
  /// **'Henüz oy vermeyenler'**
  String get uiMessagesNotVoted;

  /// ui.messages.not_voted_none
  ///
  /// In tr, this message translates to:
  /// **'Grubun diğer üyeleri henüz oy vermedi'**
  String get uiMessagesNotVotedNone;

  /// ui.messages.remind
  ///
  /// In tr, this message translates to:
  /// **'Hatırlat'**
  String get uiMessagesRemind;

  /// ui.messages.reminded
  ///
  /// In tr, this message translates to:
  /// **'Oy vermeyenlere hatırlatma gönderildi'**
  String get uiMessagesReminded;

  /// ui.messages.end_poll
  ///
  /// In tr, this message translates to:
  /// **'Anketi bitir'**
  String get uiMessagesEndPoll;

  /// ui.messages.poll_ended
  ///
  /// In tr, this message translates to:
  /// **'Anket bitti'**
  String get uiMessagesPollEnded;

  /// ui.messages.poll_concluded
  ///
  /// In tr, this message translates to:
  /// **'Anket sonuçlandı'**
  String get uiMessagesPollConcluded;

  /// ui.messages.concluded
  ///
  /// In tr, this message translates to:
  /// **'sonuçlandı'**
  String get uiMessagesConcluded;

  /// ui.messages.group_info
  ///
  /// In tr, this message translates to:
  /// **'grup bilgisi'**
  String get uiMessagesGroupInfo;

  /// ui.messages.person_info
  ///
  /// In tr, this message translates to:
  /// **'kişi bilgisi'**
  String get uiMessagesPersonInfo;

  /// ui.messages.info
  ///
  /// In tr, this message translates to:
  /// **'bilgisi'**
  String get uiMessagesInfo;

  /// ui.messages.mute
  ///
  /// In tr, this message translates to:
  /// **'Sessize al'**
  String get uiMessagesMute;

  /// ui.messages.muted_tail
  ///
  /// In tr, this message translates to:
  /// **'sessize alındı'**
  String get uiMessagesMutedTail;

  /// ui.messages.leave_group
  ///
  /// In tr, this message translates to:
  /// **'Gruptan çık'**
  String get uiMessagesLeaveGroup;

  /// ui.messages.block
  ///
  /// In tr, this message translates to:
  /// **'Engelle'**
  String get uiMessagesBlock;

  /// ui.messages.action_soon
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem sonraki adımda tasarlanacak'**
  String get uiMessagesActionSoon;

  /// ui.messages.shared
  ///
  /// In tr, this message translates to:
  /// **'paylaşılanlar'**
  String get uiMessagesShared;

  /// ui.messages.members
  ///
  /// In tr, this message translates to:
  /// **'üyeler'**
  String get uiMessagesMembers;

  /// ui.messages.all_users
  ///
  /// In tr, this message translates to:
  /// **'Tüm kullanıcılar'**
  String get uiMessagesAllUsers;

  /// ui.messages.group
  ///
  /// In tr, this message translates to:
  /// **'Grup'**
  String get uiMessagesGroup;

  /// ui.messages.wrote_here
  ///
  /// In tr, this message translates to:
  /// **'bu sohbette yazdı'**
  String get uiMessagesWroteHere;

  /// ui.messages.member
  ///
  /// In tr, this message translates to:
  /// **'üye'**
  String get uiMessagesMember;

  /// ui.messages.manager
  ///
  /// In tr, this message translates to:
  /// **'yönetici'**
  String get uiMessagesManager;

  /// ui.messages.photo
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf'**
  String get uiMessagesPhoto;

  /// ui.messages.downloading
  ///
  /// In tr, this message translates to:
  /// **'indiriliyor'**
  String get uiMessagesDownloading;

  /// ui.messages.role_admin
  ///
  /// In tr, this message translates to:
  /// **'Admin'**
  String get uiMessagesRoleAdmin;

  /// ui.messages.role_coordinator
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör'**
  String get uiMessagesRoleCoordinator;

  /// ui.messages.role_member
  ///
  /// In tr, this message translates to:
  /// **'Üye'**
  String get uiMessagesRoleMember;

  /// ui.messages.new_chat_hint
  ///
  /// In tr, this message translates to:
  /// **'Kişi seç'**
  String get uiMessagesNewChatHint;

  /// ui.router.tab_home
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get uiRouterTabHome;

  /// ui.router.nav_label
  ///
  /// In tr, this message translates to:
  /// **'Ana gezinme'**
  String get uiRouterNavLabel;

  /// ui.router.page_server
  ///
  /// In tr, this message translates to:
  /// **'Sunucu'**
  String get uiRouterPageServer;

  /// ui.router.page_update_required
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme gerekli'**
  String get uiRouterPageUpdateRequired;

  /// ui.router.page_login
  ///
  /// In tr, this message translates to:
  /// **'Giriş'**
  String get uiRouterPageLogin;

  /// ui.router.page_password
  ///
  /// In tr, this message translates to:
  /// **'Parola değiştir'**
  String get uiRouterPagePassword;

  /// ui.router.page_scope
  ///
  /// In tr, this message translates to:
  /// **'Kapsam seçimi'**
  String get uiRouterPageScope;

  /// ui.router.placeholder
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran henüz hazır değil.'**
  String get uiRouterPlaceholder;

  /// ui.router.not_found_title
  ///
  /// In tr, this message translates to:
  /// **'Sayfa bulunamadı'**
  String get uiRouterNotFoundTitle;

  /// ui.router.not_found_message
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız sayfa yok ya da kaldırılmış.'**
  String get uiRouterNotFoundMessage;

  /// ui.router.not_found_action
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfaya dön'**
  String get uiRouterNotFoundAction;

  /// ui.router.tab_home_caption
  ///
  /// In tr, this message translates to:
  /// **'bugün'**
  String get uiRouterTabHomeCaption;

  /// ui.router.assistant
  ///
  /// In tr, this message translates to:
  /// **'Asistana sor'**
  String get uiRouterAssistant;

  /// ui.router.assistant_soon
  ///
  /// In tr, this message translates to:
  /// **'Asistan sonraki adımda eklenecek'**
  String get uiRouterAssistantSoon;

  /// ui.router.tab_history
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get uiRouterTabHistory;

  /// ui.router.tab_tasks
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get uiRouterTabTasks;

  /// ui.router.tab_coordinatorships
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlükler'**
  String get uiRouterTabCoordinatorships;

  /// ui.router.tab_archive
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get uiRouterTabArchive;

  /// ui.router.tab_messages
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get uiRouterTabMessages;

  /// ui.router.pick_title
  ///
  /// In tr, this message translates to:
  /// **'Bir kayıt seç'**
  String get uiRouterPickTitle;

  /// ui.router.pick_body
  ///
  /// In tr, this message translates to:
  /// **'Soldaki listeden bir kayıt seç, ayrıntısı burada açılır.'**
  String get uiRouterPickBody;

  /// ui.router.all_modules
  ///
  /// In tr, this message translates to:
  /// **'Tüm modüller'**
  String get uiRouterAllModules;

  /// ui.scope.title
  ///
  /// In tr, this message translates to:
  /// **'Program seçimi'**
  String get uiScopeTitle;

  /// ui.scope.intro
  ///
  /// In tr, this message translates to:
  /// **'Çalışacağınız programı seçin.'**
  String get uiScopeIntro;

  /// ui.scope.empty_title
  ///
  /// In tr, this message translates to:
  /// **'Program yok'**
  String get uiScopeEmptyTitle;

  /// ui.scope.empty_message
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza atanmış bir program bulunmuyor. Yöneticinizle görüşün.'**
  String get uiScopeEmptyMessage;

  /// ui.scope.continue_with_sample
  ///
  /// In tr, this message translates to:
  /// **'Örnek verilerle devam et'**
  String get uiScopeContinueWithSample;

  /// ui.scope.truncated
  ///
  /// In tr, this message translates to:
  /// **'Liste en çok 200 programı gösterir; bazı programlar görünmüyor olabilir.'**
  String get uiScopeTruncated;

  /// ui.scope.home_change
  ///
  /// In tr, this message translates to:
  /// **'Kapsamı değiştir'**
  String get uiScopeHomeChange;

  /// ui.server.title
  ///
  /// In tr, this message translates to:
  /// **'Sunucuya bağlan'**
  String get uiServerTitle;

  /// ui.server.intro
  ///
  /// In tr, this message translates to:
  /// **'Şirketinizin NIZAM.IO sunucu adresini girin.'**
  String get uiServerIntro;

  /// ui.server.url_label
  ///
  /// In tr, this message translates to:
  /// **'Sunucu adresi'**
  String get uiServerUrlLabel;

  /// ui.server.url_hint
  ///
  /// In tr, this message translates to:
  /// **'https://nizam.sirketiniz.com'**
  String get uiServerUrlHint;

  /// ui.server.connect
  ///
  /// In tr, this message translates to:
  /// **'Bağlan'**
  String get uiServerConnect;

  /// ui.server.update_title
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme gerekli'**
  String get uiServerUpdateTitle;

  /// ui.server.update_message
  ///
  /// In tr, this message translates to:
  /// **'Bu sunucu uygulamanın daha yeni bir sürümünü gerektiriyor. Giriş yapabilmek için uygulamayı güncelleyin.'**
  String get uiServerUpdateMessage;

  /// ui.server.update_api_message
  ///
  /// In tr, this message translates to:
  /// **'Bu sunucunun API sürümü uygulamayla uyumlu değil. Giriş yapabilmek için uygulamayı güncelleyin ya da sunucu yöneticinize başvurun.'**
  String get uiServerUpdateApiMessage;

  /// ui.server.update_server
  ///
  /// In tr, this message translates to:
  /// **'Sunucu'**
  String get uiServerUpdateServer;

  /// ui.server.update_required_version
  ///
  /// In tr, this message translates to:
  /// **'Gerekli sürüm'**
  String get uiServerUpdateRequiredVersion;

  /// ui.server.update_installed_version
  ///
  /// In tr, this message translates to:
  /// **'Kurulu sürüm'**
  String get uiServerUpdateInstalledVersion;

  /// ui.server.update_recheck
  ///
  /// In tr, this message translates to:
  /// **'Yeniden denetle'**
  String get uiServerUpdateRecheck;

  /// ui.tasks.title
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get uiTasksTitle;

  /// ui.tasks.detail_title
  ///
  /// In tr, this message translates to:
  /// **'Görev'**
  String get uiTasksDetailTitle;

  /// ui.tasks.tasks_lc
  ///
  /// In tr, this message translates to:
  /// **'görev'**
  String get uiTasksTasksLc;

  /// ui.tasks.search
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get uiTasksSearch;

  /// ui.tasks.search_hint
  ///
  /// In tr, this message translates to:
  /// **'Başlık, kimlik veya kişi'**
  String get uiTasksSearchHint;

  /// ui.tasks.filters_button
  ///
  /// In tr, this message translates to:
  /// **'Filtreler · kişi, koordinatörlük, öncelik'**
  String get uiTasksFiltersButton;

  /// ui.tasks.new_task
  ///
  /// In tr, this message translates to:
  /// **'Yeni görev'**
  String get uiTasksNewTask;

  /// ui.tasks.mode
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get uiTasksMode;

  /// ui.tasks.mode_list
  ///
  /// In tr, this message translates to:
  /// **'Liste'**
  String get uiTasksModeList;

  /// ui.tasks.mode_timeline
  ///
  /// In tr, this message translates to:
  /// **'Zaman çizelgesi'**
  String get uiTasksModeTimeline;

  /// ui.tasks.views
  ///
  /// In tr, this message translates to:
  /// **'Görünümler'**
  String get uiTasksViews;

  /// ui.tasks.view_all
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get uiTasksViewAll;

  /// ui.tasks.view_late
  ///
  /// In tr, this message translates to:
  /// **'Geciken'**
  String get uiTasksViewLate;

  /// ui.tasks.view_doing
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get uiTasksViewDoing;

  /// ui.tasks.view_review
  ///
  /// In tr, this message translates to:
  /// **'Onayda'**
  String get uiTasksViewReview;

  /// ui.tasks.view_request
  ///
  /// In tr, this message translates to:
  /// **'Tarih talebi'**
  String get uiTasksViewRequest;

  /// ui.tasks.view_todo
  ///
  /// In tr, this message translates to:
  /// **'Başlamadı'**
  String get uiTasksViewTodo;

  /// ui.tasks.view_done
  ///
  /// In tr, this message translates to:
  /// **'Biten'**
  String get uiTasksViewDone;

  /// ui.tasks.list_all
  ///
  /// In tr, this message translates to:
  /// **'tüm görevler'**
  String get uiTasksListAll;

  /// ui.tasks.list_late
  ///
  /// In tr, this message translates to:
  /// **'geciken görevler'**
  String get uiTasksListLate;

  /// ui.tasks.list_doing
  ///
  /// In tr, this message translates to:
  /// **'devam eden görevler'**
  String get uiTasksListDoing;

  /// ui.tasks.list_review
  ///
  /// In tr, this message translates to:
  /// **'onay bekleyenler'**
  String get uiTasksListReview;

  /// ui.tasks.list_request
  ///
  /// In tr, this message translates to:
  /// **'tarih talebi olanlar'**
  String get uiTasksListRequest;

  /// ui.tasks.list_todo
  ///
  /// In tr, this message translates to:
  /// **'başlamayanlar'**
  String get uiTasksListTodo;

  /// ui.tasks.list_done
  ///
  /// In tr, this message translates to:
  /// **'tamamlananlar'**
  String get uiTasksListDone;

  /// ui.tasks.task_list
  ///
  /// In tr, this message translates to:
  /// **'Görev listesi'**
  String get uiTasksTaskList;

  /// ui.tasks.sort_menu
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get uiTasksSortMenu;

  /// ui.tasks.sort_created
  ///
  /// In tr, this message translates to:
  /// **'Tanımlanma tarihine göre'**
  String get uiTasksSortCreated;

  /// ui.tasks.sort_due
  ///
  /// In tr, this message translates to:
  /// **'Bitiş tarihine göre'**
  String get uiTasksSortDue;

  /// ui.tasks.sort_start
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tarihine göre'**
  String get uiTasksSortStart;

  /// ui.tasks.sort_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlüğe göre'**
  String get uiTasksSortCoord;

  /// ui.tasks.sort_created_short
  ///
  /// In tr, this message translates to:
  /// **'Tanımlanma tarihi'**
  String get uiTasksSortCreatedShort;

  /// ui.tasks.sort_due_short
  ///
  /// In tr, this message translates to:
  /// **'Bitiş tarihi'**
  String get uiTasksSortDueShort;

  /// ui.tasks.sort_start_short
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tarihi'**
  String get uiTasksSortStartShort;

  /// ui.tasks.sort_coord_short
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiTasksSortCoordShort;

  /// ui.tasks.dir_created_asc
  ///
  /// In tr, this message translates to:
  /// **'eskiden yeniye'**
  String get uiTasksDirCreatedAsc;

  /// ui.tasks.dir_created_desc
  ///
  /// In tr, this message translates to:
  /// **'yeniden eskiye'**
  String get uiTasksDirCreatedDesc;

  /// ui.tasks.dir_due_asc
  ///
  /// In tr, this message translates to:
  /// **'yakından uzağa'**
  String get uiTasksDirDueAsc;

  /// ui.tasks.dir_due_desc
  ///
  /// In tr, this message translates to:
  /// **'uzaktan yakına'**
  String get uiTasksDirDueDesc;

  /// ui.tasks.dir_start_asc
  ///
  /// In tr, this message translates to:
  /// **'erkenden geçe'**
  String get uiTasksDirStartAsc;

  /// ui.tasks.dir_start_desc
  ///
  /// In tr, this message translates to:
  /// **'geçten erkene'**
  String get uiTasksDirStartDesc;

  /// ui.tasks.dir_tap
  ///
  /// In tr, this message translates to:
  /// **'yönü değiştirmek için dokun'**
  String get uiTasksDirTap;

  /// ui.tasks.status_todo
  ///
  /// In tr, this message translates to:
  /// **'Başlamadı'**
  String get uiTasksStatusTodo;

  /// ui.tasks.status_doing
  ///
  /// In tr, this message translates to:
  /// **'Devam ediyor'**
  String get uiTasksStatusDoing;

  /// ui.tasks.status_review
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get uiTasksStatusReview;

  /// ui.tasks.status_returned
  ///
  /// In tr, this message translates to:
  /// **'Geri gönderildi'**
  String get uiTasksStatusReturned;

  /// ui.tasks.status_done
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get uiTasksStatusDone;

  /// ui.tasks.prio_high
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get uiTasksPrioHigh;

  /// ui.tasks.prio_medium
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get uiTasksPrioMedium;

  /// ui.tasks.prio_low
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get uiTasksPrioLow;

  /// ui.tasks.card_start
  ///
  /// In tr, this message translates to:
  /// **'başlangıç'**
  String get uiTasksCardStart;

  /// ui.tasks.card_due
  ///
  /// In tr, this message translates to:
  /// **'bitiş'**
  String get uiTasksCardDue;

  /// ui.tasks.card_priority
  ///
  /// In tr, this message translates to:
  /// **'öncelik'**
  String get uiTasksCardPriority;

  /// ui.tasks.subtasks_tail
  ///
  /// In tr, this message translates to:
  /// **'alt görev'**
  String get uiTasksSubtasksTail;

  /// ui.tasks.late_tail
  ///
  /// In tr, this message translates to:
  /// **'gün gecikti'**
  String get uiTasksLateTail;

  /// ui.tasks.request_badge
  ///
  /// In tr, this message translates to:
  /// **'Talep'**
  String get uiTasksRequestBadge;

  /// ui.tasks.files_tail
  ///
  /// In tr, this message translates to:
  /// **'kanıt dosyası'**
  String get uiTasksFilesTail;

  /// ui.tasks.notes_tail
  ///
  /// In tr, this message translates to:
  /// **'not'**
  String get uiTasksNotesTail;

  /// ui.tasks.empty
  ///
  /// In tr, this message translates to:
  /// **'Bu görünümde görev yok.'**
  String get uiTasksEmpty;

  /// ui.tasks.clear_filters
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri temizle'**
  String get uiTasksClearFilters;

  /// ui.tasks.show_more
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla göster'**
  String get uiTasksShowMore;

  /// ui.tasks.coords_lc
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlük'**
  String get uiTasksCoordsLc;

  /// ui.tasks.clear
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get uiTasksClear;

  /// ui.tasks.remove_filter_tail
  ///
  /// In tr, this message translates to:
  /// **'filtresini kaldır'**
  String get uiTasksRemoveFilterTail;

  /// ui.tasks.priority
  ///
  /// In tr, this message translates to:
  /// **'Öncelik'**
  String get uiTasksPriority;

  /// ui.tasks.priority_filter_remove
  ///
  /// In tr, this message translates to:
  /// **'Öncelik filtresini kaldır'**
  String get uiTasksPriorityFilterRemove;

  /// ui.tasks.filters
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get uiTasksFilters;

  /// ui.tasks.clear_all
  ///
  /// In tr, this message translates to:
  /// **'Tümünü temizle'**
  String get uiTasksClearAll;

  /// ui.tasks.group_people
  ///
  /// In tr, this message translates to:
  /// **'Kişi'**
  String get uiTasksGroupPeople;

  /// ui.tasks.group_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiTasksGroupCoord;

  /// ui.tasks.selected_tail
  ///
  /// In tr, this message translates to:
  /// **'seçili'**
  String get uiTasksSelectedTail;

  /// ui.tasks.all_lc
  ///
  /// In tr, this message translates to:
  /// **'tümü'**
  String get uiTasksAllLc;

  /// ui.tasks.filter_hint
  ///
  /// In tr, this message translates to:
  /// **'Aynı grupta seçenekler “veya”, gruplar arası “ve” ile birleşir.'**
  String get uiTasksFilterHint;

  /// ui.tasks.show_tasks_tail
  ///
  /// In tr, this message translates to:
  /// **'görevi göster'**
  String get uiTasksShowTasksTail;

  /// ui.tasks.shortcuts
  ///
  /// In tr, this message translates to:
  /// **'Görevler kısayolları'**
  String get uiTasksShortcuts;

  /// ui.tasks.fly_view
  ///
  /// In tr, this message translates to:
  /// **'görünüm'**
  String get uiTasksFlyView;

  /// ui.tasks.fly_sort
  ///
  /// In tr, this message translates to:
  /// **'sıralama'**
  String get uiTasksFlySort;

  /// ui.tasks.fly_tasks
  ///
  /// In tr, this message translates to:
  /// **'görevler'**
  String get uiTasksFlyTasks;

  /// ui.tasks.fly_timeline_caption
  ///
  /// In tr, this message translates to:
  /// **'Dikey Gantt'**
  String get uiTasksFlyTimelineCaption;

  /// ui.tasks.fly_search
  ///
  /// In tr, this message translates to:
  /// **'Görev ara'**
  String get uiTasksFlySearch;

  /// ui.tasks.fly_filter
  ///
  /// In tr, this message translates to:
  /// **'Kişi, koordinatörlük, öncelik'**
  String get uiTasksFlyFilter;

  /// ui.tasks.fly_this_task
  ///
  /// In tr, this message translates to:
  /// **'bu görev'**
  String get uiTasksFlyThisTask;

  /// ui.tasks.fly_status
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get uiTasksFlyStatus;

  /// ui.tasks.fly_go
  ///
  /// In tr, this message translates to:
  /// **'git'**
  String get uiTasksFlyGo;

  /// ui.tasks.fly_timeline
  ///
  /// In tr, this message translates to:
  /// **'Zaman çizelgesinde gör'**
  String get uiTasksFlyTimeline;

  /// ui.tasks.edit_task
  ///
  /// In tr, this message translates to:
  /// **'Görevi düzenle'**
  String get uiTasksEditTask;

  /// ui.tasks.more_actions
  ///
  /// In tr, this message translates to:
  /// **'Diğer işlemler'**
  String get uiTasksMoreActions;

  /// ui.tasks.not_found
  ///
  /// In tr, this message translates to:
  /// **'Görev bulunamadı'**
  String get uiTasksNotFound;

  /// ui.tasks.deleted_tail
  ///
  /// In tr, this message translates to:
  /// **'silinen kayıtlara taşındı'**
  String get uiTasksDeletedTail;

  /// ui.tasks.deleted_files_kept
  ///
  /// In tr, this message translates to:
  /// **'Kanıt dosyaları arşivde kaldı.'**
  String get uiTasksDeletedFilesKept;

  /// ui.tasks.undo
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get uiTasksUndo;

  /// ui.tasks.request_date
  ///
  /// In tr, this message translates to:
  /// **'Tarih değişikliği iste'**
  String get uiTasksRequestDate;

  /// ui.tasks.remind
  ///
  /// In tr, this message translates to:
  /// **'Atanana hatırlat'**
  String get uiTasksRemind;

  /// ui.tasks.upload
  ///
  /// In tr, this message translates to:
  /// **'Kanıt yükle'**
  String get uiTasksUpload;

  /// ui.tasks.request_title
  ///
  /// In tr, this message translates to:
  /// **'Tarih değişikliği talebi'**
  String get uiTasksRequestTitle;

  /// ui.tasks.reject
  ///
  /// In tr, this message translates to:
  /// **'Reddet'**
  String get uiTasksReject;

  /// ui.tasks.approve
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get uiTasksApprove;

  /// ui.tasks.days_lc
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get uiTasksDaysLc;

  /// ui.tasks.no_reason
  ///
  /// In tr, this message translates to:
  /// **'Gerekçe yazılmamış'**
  String get uiTasksNoReason;

  /// ui.tasks.detail_tabs
  ///
  /// In tr, this message translates to:
  /// **'Görev ayrıntısı'**
  String get uiTasksDetailTabs;

  /// ui.tasks.tab_summary
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get uiTasksTabSummary;

  /// ui.tasks.tab_subtasks
  ///
  /// In tr, this message translates to:
  /// **'Alt görev'**
  String get uiTasksTabSubtasks;

  /// ui.tasks.tab_files
  ///
  /// In tr, this message translates to:
  /// **'Dosya'**
  String get uiTasksTabFiles;

  /// ui.tasks.tab_notes
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get uiTasksTabNotes;

  /// ui.tasks.assignee
  ///
  /// In tr, this message translates to:
  /// **'Atanan'**
  String get uiTasksAssignee;

  /// ui.tasks.creator
  ///
  /// In tr, this message translates to:
  /// **'Oluşturan'**
  String get uiTasksCreator;

  /// ui.tasks.created
  ///
  /// In tr, this message translates to:
  /// **'Tanımlandı'**
  String get uiTasksCreated;

  /// ui.tasks.date_range
  ///
  /// In tr, this message translates to:
  /// **'Tarih aralığı'**
  String get uiTasksDateRange;

  /// ui.tasks.evidence_file
  ///
  /// In tr, this message translates to:
  /// **'Kanıt dosyası'**
  String get uiTasksEvidenceFile;

  /// ui.tasks.none
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get uiTasksNone;

  /// ui.tasks.progress
  ///
  /// In tr, this message translates to:
  /// **'ilerleme'**
  String get uiTasksProgress;

  /// ui.tasks.ev_created
  ///
  /// In tr, this message translates to:
  /// **'Görev tanımlandı'**
  String get uiTasksEvCreated;

  /// ui.tasks.ev_started
  ///
  /// In tr, this message translates to:
  /// **'Planlanan başlangıç'**
  String get uiTasksEvStarted;

  /// ui.tasks.ev_will_start
  ///
  /// In tr, this message translates to:
  /// **'Başlayacak'**
  String get uiTasksEvWillStart;

  /// ui.tasks.ev_done
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get uiTasksEvDone;

  /// ui.tasks.ev_done_late
  ///
  /// In tr, this message translates to:
  /// **'(geç)'**
  String get uiTasksEvDoneLate;

  /// ui.tasks.ev_due_passed
  ///
  /// In tr, this message translates to:
  /// **'Plan bitişi geçti'**
  String get uiTasksEvDuePassed;

  /// ui.tasks.ev_late_tail
  ///
  /// In tr, this message translates to:
  /// **'gündür gecikmede'**
  String get uiTasksEvLateTail;

  /// ui.tasks.ev_today
  ///
  /// In tr, this message translates to:
  /// **'bugün'**
  String get uiTasksEvToday;

  /// ui.tasks.ev_due
  ///
  /// In tr, this message translates to:
  /// **'Planlanan bitiş'**
  String get uiTasksEvDue;

  /// ui.tasks.subs_hint
  ///
  /// In tr, this message translates to:
  /// **'Kişi ve tarih isteğe bağlıdır; kanıtı zorunlu olan alt görev, kanıt yüklenmeden bitirilemez. Görev, tüm alt görevler bitmeden tamamlanamaz.'**
  String get uiTasksSubsHint;

  /// ui.tasks.done_lc
  ///
  /// In tr, this message translates to:
  /// **'tamamlandı'**
  String get uiTasksDoneLc;

  /// ui.tasks.sub_untitled
  ///
  /// In tr, this message translates to:
  /// **'Adsız alt görev'**
  String get uiTasksSubUntitled;

  /// ui.tasks.sub_name
  ///
  /// In tr, this message translates to:
  /// **'Alt görev adı'**
  String get uiTasksSubName;

  /// ui.tasks.sub_person
  ///
  /// In tr, this message translates to:
  /// **'Kişi'**
  String get uiTasksSubPerson;

  /// ui.tasks.sub_date
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get uiTasksSubDate;

  /// ui.tasks.sub_evidence
  ///
  /// In tr, this message translates to:
  /// **'Kanıt'**
  String get uiTasksSubEvidence;

  /// ui.tasks.sub_file
  ///
  /// In tr, this message translates to:
  /// **'Dosya'**
  String get uiTasksSubFile;

  /// ui.tasks.required
  ///
  /// In tr, this message translates to:
  /// **'Zorunlu'**
  String get uiTasksRequired;

  /// ui.tasks.optional
  ///
  /// In tr, this message translates to:
  /// **'Opsiyonel'**
  String get uiTasksOptional;

  /// ui.tasks.pick_person
  ///
  /// In tr, this message translates to:
  /// **'Kişi seç'**
  String get uiTasksPickPerson;

  /// ui.tasks.no_person
  ///
  /// In tr, this message translates to:
  /// **'Kişi yok'**
  String get uiTasksNoPerson;

  /// ui.tasks.clear_date
  ///
  /// In tr, this message translates to:
  /// **'Tarihi kaldır'**
  String get uiTasksClearDate;

  /// ui.tasks.sub_delete
  ///
  /// In tr, this message translates to:
  /// **'Alt görevi sil'**
  String get uiTasksSubDelete;

  /// ui.tasks.sub_add
  ///
  /// In tr, this message translates to:
  /// **'Alt görev ekle'**
  String get uiTasksSubAdd;

  /// ui.tasks.needs_person
  ///
  /// In tr, this message translates to:
  /// **'kişi atanmalı'**
  String get uiTasksNeedsPerson;

  /// ui.tasks.evidence_required_lc
  ///
  /// In tr, this message translates to:
  /// **'kanıt zorunlu'**
  String get uiTasksEvidenceRequiredLc;

  /// ui.tasks.one_evidence
  ///
  /// In tr, this message translates to:
  /// **'1 kanıt'**
  String get uiTasksOneEvidence;

  /// ui.tasks.start
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get uiTasksStart;

  /// ui.tasks.due
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get uiTasksDue;

  /// ui.tasks.no_files
  ///
  /// In tr, this message translates to:
  /// **'Henüz kanıt dosyası yok.'**
  String get uiTasksNoFiles;

  /// ui.tasks.subtask_prefix
  ///
  /// In tr, this message translates to:
  /// **'Alt görev:'**
  String get uiTasksSubtaskPrefix;

  /// ui.tasks.deleted_lc
  ///
  /// In tr, this message translates to:
  /// **'silinmiş'**
  String get uiTasksDeletedLc;

  /// ui.tasks.kb
  ///
  /// In tr, this message translates to:
  /// **'KB'**
  String get uiTasksKb;

  /// ui.tasks.no_notes
  ///
  /// In tr, this message translates to:
  /// **'Henüz not yok.'**
  String get uiTasksNoNotes;

  /// ui.tasks.note_hint
  ///
  /// In tr, this message translates to:
  /// **'Not yaz…'**
  String get uiTasksNoteHint;

  /// ui.tasks.send
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get uiTasksSend;

  /// ui.tasks.in_memory
  ///
  /// In tr, this message translates to:
  /// **'✓ Hafızada'**
  String get uiTasksInMemory;

  /// ui.tasks.to_memory
  ///
  /// In tr, this message translates to:
  /// **'Hafızaya ekle'**
  String get uiTasksToMemory;

  /// ui.tasks.sheet_status
  ///
  /// In tr, this message translates to:
  /// **'durum'**
  String get uiTasksSheetStatus;

  /// ui.tasks.sheet_priority
  ///
  /// In tr, this message translates to:
  /// **'öncelik'**
  String get uiTasksSheetPriority;

  /// ui.tasks.open_subs_tail
  ///
  /// In tr, this message translates to:
  /// **'alt görev açık'**
  String get uiTasksOpenSubsTail;

  /// ui.tasks.copy
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get uiTasksCopy;

  /// ui.tasks.copy_suffix
  ///
  /// In tr, this message translates to:
  /// **'(kopya)'**
  String get uiTasksCopySuffix;

  /// ui.tasks.delete_task
  ///
  /// In tr, this message translates to:
  /// **'Görevi sil'**
  String get uiTasksDeleteTask;

  /// ui.tasks.edit_desc_tail
  ///
  /// In tr, this message translates to:
  /// **'değişiklikler işlem geçmişine yazılır'**
  String get uiTasksEditDescTail;

  /// ui.tasks.field_title
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get uiTasksFieldTitle;

  /// ui.tasks.field_title_hint
  ///
  /// In tr, this message translates to:
  /// **'Görev başlığı'**
  String get uiTasksFieldTitleHint;

  /// ui.tasks.err_title_empty
  ///
  /// In tr, this message translates to:
  /// **'Başlık boş bırakılamaz'**
  String get uiTasksErrTitleEmpty;

  /// ui.tasks.field_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiTasksFieldCoord;

  /// ui.tasks.coordinators_lc
  ///
  /// In tr, this message translates to:
  /// **'koordinatörler'**
  String get uiTasksCoordinatorsLc;

  /// ui.tasks.members_lc
  ///
  /// In tr, this message translates to:
  /// **'üyeler'**
  String get uiTasksMembersLc;

  /// ui.tasks.no_coordinators
  ///
  /// In tr, this message translates to:
  /// **'Bu koordinatörlükte koordinatör yok.'**
  String get uiTasksNoCoordinators;

  /// ui.tasks.no_members
  ///
  /// In tr, this message translates to:
  /// **'Bu koordinatörlükte üye yok.'**
  String get uiTasksNoMembers;

  /// ui.tasks.err_assign_one
  ///
  /// In tr, this message translates to:
  /// **'En az bir kişi ata'**
  String get uiTasksErrAssignOne;

  /// ui.tasks.err_dates
  ///
  /// In tr, this message translates to:
  /// **'Bitiş, başlangıçtan önce olamaz'**
  String get uiTasksErrDates;

  /// ui.tasks.save
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get uiTasksSave;

  /// ui.tasks.cancel
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get uiTasksCancel;

  /// ui.tasks.date_desc
  ///
  /// In tr, this message translates to:
  /// **'Onaylanınca yeni tarihler göreve uygulanır'**
  String get uiTasksDateDesc;

  /// ui.tasks.now_lc
  ///
  /// In tr, this message translates to:
  /// **'şu an'**
  String get uiTasksNowLc;

  /// ui.tasks.new_start
  ///
  /// In tr, this message translates to:
  /// **'Yeni başlangıç'**
  String get uiTasksNewStart;

  /// ui.tasks.new_due
  ///
  /// In tr, this message translates to:
  /// **'Yeni bitiş'**
  String get uiTasksNewDue;

  /// ui.tasks.reason
  ///
  /// In tr, this message translates to:
  /// **'Gerekçe'**
  String get uiTasksReason;

  /// ui.tasks.reason_hint
  ///
  /// In tr, this message translates to:
  /// **'Örn. malzeme tedariki gecikti'**
  String get uiTasksReasonHint;

  /// ui.tasks.send_request
  ///
  /// In tr, this message translates to:
  /// **'Talep gönder'**
  String get uiTasksSendRequest;

  /// ui.tasks.upload_title
  ///
  /// In tr, this message translates to:
  /// **'Kanıt dosyası yükle'**
  String get uiTasksUploadTitle;

  /// ui.tasks.upload_desc
  ///
  /// In tr, this message translates to:
  /// **'Dosya görevin arşiv klasörüne kaydedilir'**
  String get uiTasksUploadDesc;

  /// ui.tasks.task_folder
  ///
  /// In tr, this message translates to:
  /// **'görev klasörü'**
  String get uiTasksTaskFolder;

  /// ui.tasks.task_itself
  ///
  /// In tr, this message translates to:
  /// **'Görevin kendisi'**
  String get uiTasksTaskItself;

  /// ui.tasks.tag
  ///
  /// In tr, this message translates to:
  /// **'Etiket'**
  String get uiTasksTag;

  /// ui.tasks.tag_site
  ///
  /// In tr, this message translates to:
  /// **'Saha görselleri'**
  String get uiTasksTagSite;

  /// ui.tasks.tag_result
  ///
  /// In tr, this message translates to:
  /// **'Sonuç dosyası'**
  String get uiTasksTagResult;

  /// ui.tasks.tag_status
  ///
  /// In tr, this message translates to:
  /// **'Güncel durum verisi'**
  String get uiTasksTagStatus;

  /// ui.tasks.tag_requirement
  ///
  /// In tr, this message translates to:
  /// **'İster'**
  String get uiTasksTagRequirement;

  /// ui.tasks.tag_plan
  ///
  /// In tr, this message translates to:
  /// **'Plan'**
  String get uiTasksTagPlan;

  /// ui.tasks.tag_input
  ///
  /// In tr, this message translates to:
  /// **'Girdi'**
  String get uiTasksTagInput;

  /// ui.tasks.tag_analysis
  ///
  /// In tr, this message translates to:
  /// **'Analiz'**
  String get uiTasksTagAnalysis;

  /// ui.tasks.tag_output
  ///
  /// In tr, this message translates to:
  /// **'Çıktı'**
  String get uiTasksTagOutput;

  /// ui.tasks.tag_outcome
  ///
  /// In tr, this message translates to:
  /// **'Sonuç'**
  String get uiTasksTagOutcome;

  /// ui.tasks.tag_unknown
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get uiTasksTagUnknown;

  /// ui.tasks.file_name
  ///
  /// In tr, this message translates to:
  /// **'Dosya adı'**
  String get uiTasksFileName;

  /// ui.tasks.err_file_name
  ///
  /// In tr, this message translates to:
  /// **'Dosya adı gerekli'**
  String get uiTasksErrFileName;

  /// ui.tasks.pick_file
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çek ya da dosya seç'**
  String get uiTasksPickFile;

  /// ui.tasks.proto_only
  ///
  /// In tr, this message translates to:
  /// **'Prototipte yalnızca kayıt oluşturulur.'**
  String get uiTasksProtoOnly;

  /// ui.tasks.upload_ok
  ///
  /// In tr, this message translates to:
  /// **'Yükle'**
  String get uiTasksUploadOk;

  /// ui.tasks.delete_q_tail
  ///
  /// In tr, this message translates to:
  /// **'silinsin mi?'**
  String get uiTasksDeleteQTail;

  /// ui.tasks.delete_desc
  ///
  /// In tr, this message translates to:
  /// **'Silinen kayıtlardan geri alınabilir'**
  String get uiTasksDeleteDesc;

  /// ui.tasks.delete_body_tail
  ///
  /// In tr, this message translates to:
  /// **'silinen kayıtlara taşınır. Kanıt dosyaları arşivde kalır.'**
  String get uiTasksDeleteBodyTail;

  /// ui.tasks.delete_ok
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get uiTasksDeleteOk;

  /// ui.tasks.t_subs_block
  ///
  /// In tr, this message translates to:
  /// **'Alt görevler bitmeden görev tamamlanamaz'**
  String get uiTasksTSubsBlock;

  /// ui.tasks.t_finished_lc
  ///
  /// In tr, this message translates to:
  /// **'bitti'**
  String get uiTasksTFinishedLc;

  /// ui.tasks.t_evidence_block
  ///
  /// In tr, this message translates to:
  /// **'Kanıt dosyası olmadan görev tamamlanamaz'**
  String get uiTasksTEvidenceBlock;

  /// ui.tasks.t_created_tail
  ///
  /// In tr, this message translates to:
  /// **'oluşturuldu'**
  String get uiTasksTCreatedTail;

  /// ui.tasks.t_deleted
  ///
  /// In tr, this message translates to:
  /// **'Görev silinen kayıtlara taşındı'**
  String get uiTasksTDeleted;

  /// ui.tasks.t_restored_tail
  ///
  /// In tr, this message translates to:
  /// **'geri alındı'**
  String get uiTasksTRestoredTail;

  /// ui.tasks.t_updated_tail
  ///
  /// In tr, this message translates to:
  /// **'güncellendi'**
  String get uiTasksTUpdatedTail;

  /// ui.tasks.t_request_sent
  ///
  /// In tr, this message translates to:
  /// **'Tarih değişikliği talebi gönderildi · onay bekliyor'**
  String get uiTasksTRequestSent;

  /// ui.tasks.t_uploaded
  ///
  /// In tr, this message translates to:
  /// **'Kanıt dosyası yüklendi · görevin arşiv klasörüne eklendi'**
  String get uiTasksTUploaded;

  /// ui.tasks.t_pending_exists
  ///
  /// In tr, this message translates to:
  /// **'Bu görev için zaten bekleyen bir talep var'**
  String get uiTasksTPendingExists;

  /// ui.tasks.t_reminded
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma gönderildi'**
  String get uiTasksTReminded;

  /// ui.tasks.t_approved
  ///
  /// In tr, this message translates to:
  /// **'Talep onaylandı'**
  String get uiTasksTApproved;

  /// ui.tasks.t_new_due
  ///
  /// In tr, this message translates to:
  /// **'yeni bitiş'**
  String get uiTasksTNewDue;

  /// ui.tasks.t_rejected
  ///
  /// In tr, this message translates to:
  /// **'Talep reddedildi'**
  String get uiTasksTRejected;

  /// ui.tasks.t_informed
  ///
  /// In tr, this message translates to:
  /// **'bilgilendirildi'**
  String get uiTasksTInformed;

  /// ui.tasks.t_sub_evidence
  ///
  /// In tr, this message translates to:
  /// **'Bu alt görev için kanıt zorunlu · önce kanıt yükle'**
  String get uiTasksTSubEvidence;

  /// ui.tasks.t_sub_removed_tail
  ///
  /// In tr, this message translates to:
  /// **'görevinden kaldırıldı'**
  String get uiTasksTSubRemovedTail;

  /// ui.tasks.t_sub_file_kept
  ///
  /// In tr, this message translates to:
  /// **'kanıt dosyası arşivde kaldı'**
  String get uiTasksTSubFileKept;

  /// ui.tasks.t_note_memory
  ///
  /// In tr, this message translates to:
  /// **'Not kurumsal hafızaya deneyim olarak eklendi'**
  String get uiTasksTNoteMemory;

  /// ui.tasks.revert_title
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanmış görevi yeniden aç'**
  String get uiTasksRevertTitle;

  /// ui.tasks.revert_desc
  ///
  /// In tr, this message translates to:
  /// **'Gerekçe işlem geçmişine yazılır'**
  String get uiTasksRevertDesc;

  /// ui.tasks.revert_hint
  ///
  /// In tr, this message translates to:
  /// **'Neden yeniden açılıyor?'**
  String get uiTasksRevertHint;

  /// ui.tasks.revert_min
  ///
  /// In tr, this message translates to:
  /// **'En az 3 karakter'**
  String get uiTasksRevertMin;

  /// ui.tasks.revert_ok
  ///
  /// In tr, this message translates to:
  /// **'Yeniden aç'**
  String get uiTasksRevertOk;

  /// ui.tasks.close_subs_title
  ///
  /// In tr, this message translates to:
  /// **'Açık alt görevler var'**
  String get uiTasksCloseSubsTitle;

  /// ui.tasks.close_subs_desc
  ///
  /// In tr, this message translates to:
  /// **'Görev tamamlanırken açık alt görevler de senin adına kapatılır.'**
  String get uiTasksCloseSubsDesc;

  /// ui.tasks.close_subs_ok
  ///
  /// In tr, this message translates to:
  /// **'Alt görevleri de kapat'**
  String get uiTasksCloseSubsOk;

  /// ui.tasks.note_edit
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get uiTasksNoteEdit;

  /// ui.tasks.note_delete
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get uiTasksNoteDelete;

  /// ui.tasks.note_edit_title
  ///
  /// In tr, this message translates to:
  /// **'Notu düzenle'**
  String get uiTasksNoteEditTitle;

  /// ui.tasks.note_delete_q
  ///
  /// In tr, this message translates to:
  /// **'Not silinsin mi?'**
  String get uiTasksNoteDeleteQ;

  /// ui.tasks.note_delete_desc
  ///
  /// In tr, this message translates to:
  /// **'Silinen not geri alınamaz'**
  String get uiTasksNoteDeleteDesc;

  /// ui.tasks.t_note_saved
  ///
  /// In tr, this message translates to:
  /// **'Not güncellendi'**
  String get uiTasksTNoteSaved;

  /// ui.tasks.t_note_deleted
  ///
  /// In tr, this message translates to:
  /// **'Not silindi'**
  String get uiTasksTNoteDeleted;

  /// ui.tasks.sub_rename
  ///
  /// In tr, this message translates to:
  /// **'Başlığı düzenle'**
  String get uiTasksSubRename;

  /// ui.tasks.t_sub_added
  ///
  /// In tr, this message translates to:
  /// **'Alt görev eklendi'**
  String get uiTasksTSubAdded;

  /// ui.tasks.t_notified_tail
  ///
  /// In tr, this message translates to:
  /// **'kişiye bildirim gitti'**
  String get uiTasksTNotifiedTail;

  /// ui.tasks.nt_desc
  ///
  /// In tr, this message translates to:
  /// **'Görev oluşturulduğunda atanan kişiye bildirim gider.'**
  String get uiTasksNtDesc;

  /// ui.tasks.create
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get uiTasksCreate;

  /// ui.tasks.nt_title_hint
  ///
  /// In tr, this message translates to:
  /// **'Ne yapılması gerekiyor?'**
  String get uiTasksNtTitleHint;

  /// ui.tasks.row_date
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get uiTasksRowDate;

  /// ui.tasks.evidence_required
  ///
  /// In tr, this message translates to:
  /// **'Kanıt dosyası zorunlu'**
  String get uiTasksEvidenceRequired;

  /// ui.tasks.pick
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get uiTasksPick;

  /// ui.tasks.coord_first
  ///
  /// In tr, this message translates to:
  /// **'Önce koordinatörlük'**
  String get uiTasksCoordFirst;

  /// ui.tasks.nobody_here
  ///
  /// In tr, this message translates to:
  /// **'Bu koordinatörlükte kimse yok.'**
  String get uiTasksNobodyHere;

  /// ui.tasks.people_lc
  ///
  /// In tr, this message translates to:
  /// **'kişi'**
  String get uiTasksPeopleLc;

  /// ui.tasks.role_coordinator_lc
  ///
  /// In tr, this message translates to:
  /// **'koordinatör'**
  String get uiTasksRoleCoordinatorLc;

  /// ui.tasks.role_member_lc
  ///
  /// In tr, this message translates to:
  /// **'üye'**
  String get uiTasksRoleMemberLc;

  /// ui.tasks.weeks_lc
  ///
  /// In tr, this message translates to:
  /// **'hafta'**
  String get uiTasksWeeksLc;

  /// ui.tasks.one_month
  ///
  /// In tr, this message translates to:
  /// **'1 ay'**
  String get uiTasksOneMonth;

  /// ui.tasks.err_title
  ///
  /// In tr, this message translates to:
  /// **'Başlık gerekli.'**
  String get uiTasksErrTitle;

  /// ui.tasks.err_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük seç.'**
  String get uiTasksErrCoord;

  /// ui.tasks.err_assignee
  ///
  /// In tr, this message translates to:
  /// **'En az bir kişi ata.'**
  String get uiTasksErrAssignee;

  /// ui.tasks.err_dates_full
  ///
  /// In tr, this message translates to:
  /// **'Bitiş, başlangıçtan önce olamaz.'**
  String get uiTasksErrDatesFull;

  /// ui.tasks.mt_title
  ///
  /// In tr, this message translates to:
  /// **'Toplantı oluştur'**
  String get uiTasksMtTitle;

  /// ui.tasks.mt_desc
  ///
  /// In tr, this message translates to:
  /// **'Toplantı sahibi sensin. Davetlilere bildirim gider.'**
  String get uiTasksMtDesc;

  /// ui.tasks.mt_title_hint
  ///
  /// In tr, this message translates to:
  /// **'Toplantının konusu ne?'**
  String get uiTasksMtTitleHint;

  /// ui.tasks.row_time
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get uiTasksRowTime;

  /// ui.tasks.row_invitees
  ///
  /// In tr, this message translates to:
  /// **'Davetliler'**
  String get uiTasksRowInvitees;

  /// ui.tasks.row_agenda
  ///
  /// In tr, this message translates to:
  /// **'Gündem'**
  String get uiTasksRowAgenda;

  /// ui.tasks.items_lc
  ///
  /// In tr, this message translates to:
  /// **'madde'**
  String get uiTasksItemsLc;

  /// ui.tasks.add_item
  ///
  /// In tr, this message translates to:
  /// **'Madde ekle'**
  String get uiTasksAddItem;

  /// ui.tasks.agenda_item
  ///
  /// In tr, this message translates to:
  /// **'Gündem maddesi'**
  String get uiTasksAgendaItem;

  /// ui.tasks.add_item_label
  ///
  /// In tr, this message translates to:
  /// **'Maddeyi ekle'**
  String get uiTasksAddItemLabel;

  /// ui.tasks.remove_item_tail
  ///
  /// In tr, this message translates to:
  /// **'. maddeyi kaldır'**
  String get uiTasksRemoveItemTail;

  /// ui.tasks.item_tail
  ///
  /// In tr, this message translates to:
  /// **'. madde'**
  String get uiTasksItemTail;

  /// ui.tasks.mode_people
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get uiTasksModePeople;

  /// ui.tasks.invite_members
  ///
  /// In tr, this message translates to:
  /// **'Üyeleri de davet et'**
  String get uiTasksInviteMembers;

  /// ui.tasks.with_members
  ///
  /// In tr, this message translates to:
  /// **'üyelerle'**
  String get uiTasksWithMembers;

  /// ui.tasks.coord_abbr
  ///
  /// In tr, this message translates to:
  /// **'koord.'**
  String get uiTasksCoordAbbr;

  /// ui.tasks.err_past
  ///
  /// In tr, this message translates to:
  /// **'Tarih geçmişe çekilemez.'**
  String get uiTasksErrPast;

  /// ui.tasks.err_mt_coords
  ///
  /// In tr, this message translates to:
  /// **'Davetli olarak en az bir koordinatörlük seç.'**
  String get uiTasksErrMtCoords;

  /// ui.tasks.err_mt_people
  ///
  /// In tr, this message translates to:
  /// **'En az bir kişi seç.'**
  String get uiTasksErrMtPeople;

  /// ui.tasks.t_meeting
  ///
  /// In tr, this message translates to:
  /// **'Toplantı oluşturuldu'**
  String get uiTasksTMeeting;

  /// ui.tasks.t_coords_invited
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlük davetli'**
  String get uiTasksTCoordsInvited;

  /// ui.tasks.t_people_invited
  ///
  /// In tr, this message translates to:
  /// **'kişi davetli'**
  String get uiTasksTPeopleInvited;

  /// ui.tasks.iv_title
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı davet et'**
  String get uiTasksIvTitle;

  /// ui.tasks.iv_desc
  ///
  /// In tr, this message translates to:
  /// **'Davet e-postası gönderilir; kullanıcı ilk girişte şifresini belirler.'**
  String get uiTasksIvDesc;

  /// ui.tasks.iv_send
  ///
  /// In tr, this message translates to:
  /// **'Davet gönder'**
  String get uiTasksIvSend;

  /// ui.tasks.iv_name
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad'**
  String get uiTasksIvName;

  /// ui.tasks.iv_name_hint
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get uiTasksIvNameHint;

  /// ui.tasks.iv_email
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get uiTasksIvEmail;

  /// ui.tasks.iv_email_hint
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi'**
  String get uiTasksIvEmailHint;

  /// ui.tasks.iv_role
  ///
  /// In tr, this message translates to:
  /// **'Rol'**
  String get uiTasksIvRole;

  /// ui.tasks.role_member
  ///
  /// In tr, this message translates to:
  /// **'Üye'**
  String get uiTasksRoleMember;

  /// ui.tasks.role_coordinator
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör'**
  String get uiTasksRoleCoordinator;

  /// ui.tasks.role_admin
  ///
  /// In tr, this message translates to:
  /// **'Admin'**
  String get uiTasksRoleAdmin;

  /// ui.tasks.optional_any
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı'**
  String get uiTasksOptionalAny;

  /// ui.tasks.rd_admin
  ///
  /// In tr, this message translates to:
  /// **'Tüm koordinatörlükleri, kullanıcıları ve sezonu yönetir.'**
  String get uiTasksRdAdmin;

  /// ui.tasks.rd_coordinator
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin koordinatörlüklerde görev atar ve dosyaları onaylar.'**
  String get uiTasksRdCoordinator;

  /// ui.tasks.rd_member
  ///
  /// In tr, this message translates to:
  /// **'Atanan görevleri yürütür, kanıt dosyası yükler.'**
  String get uiTasksRdMember;

  /// ui.tasks.err_name
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad gerekli.'**
  String get uiTasksErrName;

  /// ui.tasks.err_email
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta gir.'**
  String get uiTasksErrEmail;

  /// ui.tasks.err_iv_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatör için en az bir koordinatörlük seç.'**
  String get uiTasksErrIvCoord;

  /// ui.tasks.t_invited
  ///
  /// In tr, this message translates to:
  /// **'Davet gönderildi:'**
  String get uiTasksTInvited;

  /// ui.tasks.expand_sheet
  ///
  /// In tr, this message translates to:
  /// **'Sayfayı büyüt'**
  String get uiTasksExpandSheet;

  /// ui.tasks.collapse_sheet
  ///
  /// In tr, this message translates to:
  /// **'Sayfayı küçült'**
  String get uiTasksCollapseSheet;

  /// ui.tasks.claim
  ///
  /// In tr, this message translates to:
  /// **'Üstlen'**
  String get uiTasksClaim;

  /// ui.tasks.unclaim
  ///
  /// In tr, this message translates to:
  /// **'Üstlenmeyi bırak'**
  String get uiTasksUnclaim;

  /// ui.tasks.t_claimed
  ///
  /// In tr, this message translates to:
  /// **'Görevi üstlendin'**
  String get uiTasksTClaimed;

  /// ui.tasks.t_unclaimed
  ///
  /// In tr, this message translates to:
  /// **'Görevi bıraktın'**
  String get uiTasksTUnclaimed;

  /// ui.tasks.file_download
  ///
  /// In tr, this message translates to:
  /// **'İndir'**
  String get uiTasksFileDownload;

  /// ui.tasks.file_rename
  ///
  /// In tr, this message translates to:
  /// **'Adı değiştir'**
  String get uiTasksFileRename;

  /// ui.tasks.file_delete
  ///
  /// In tr, this message translates to:
  /// **'Dosyayı sil'**
  String get uiTasksFileDelete;

  /// ui.tasks.file_delete_q
  ///
  /// In tr, this message translates to:
  /// **'Dosya silinsin mi?'**
  String get uiTasksFileDeleteQ;

  /// ui.tasks.file_delete_desc
  ///
  /// In tr, this message translates to:
  /// **'Silinen dosya geri alınamaz'**
  String get uiTasksFileDeleteDesc;

  /// ui.tasks.file_name_label
  ///
  /// In tr, this message translates to:
  /// **'Dosya adı'**
  String get uiTasksFileNameLabel;

  /// ui.tasks.t_file_saved
  ///
  /// In tr, this message translates to:
  /// **'Dosya kaydedildi'**
  String get uiTasksTFileSaved;

  /// ui.tasks.t_file_renamed
  ///
  /// In tr, this message translates to:
  /// **'Dosya adı güncellendi'**
  String get uiTasksTFileRenamed;

  /// ui.tasks.t_file_deleted
  ///
  /// In tr, this message translates to:
  /// **'Dosya silindi'**
  String get uiTasksTFileDeleted;

  /// ui.tasks.pick_file_action
  ///
  /// In tr, this message translates to:
  /// **'Dosya seç'**
  String get uiTasksPickFileAction;

  /// ui.tasks.picker_missing
  ///
  /// In tr, this message translates to:
  /// **'Bu sürümde dosya seçici yok'**
  String get uiTasksPickerMissing;

  /// ui.tasks.err_pick_file
  ///
  /// In tr, this message translates to:
  /// **'Yüklemek için bir dosya seç'**
  String get uiTasksErrPickFile;

  /// ui.tasks.upload_types
  ///
  /// In tr, this message translates to:
  /// **'PDF, PNG, JPG, CSV, Word, Excel, PowerPoint, Pages · 90 MB altı'**
  String get uiTasksUploadTypes;

  /// ui.tasks.team_empty
  ///
  /// In tr, this message translates to:
  /// **'Bu departmanda atanabilir kişi yok'**
  String get uiTasksTeamEmpty;

  /// ui.tasks.unassigned
  ///
  /// In tr, this message translates to:
  /// **'Atanmamış'**
  String get uiTasksUnassigned;

  /// ui.tasks.t_unavailable
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem bu görevde şu an yapılamıyor.'**
  String get uiTasksTUnavailable;

  /// ui.tasks.unknown_person
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen kişi'**
  String get uiTasksUnknownPerson;

  /// ui.tasks.description
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get uiTasksDescription;

  /// ui.tasks.department
  ///
  /// In tr, this message translates to:
  /// **'Departman'**
  String get uiTasksDepartment;

  /// ui.timeline.title
  ///
  /// In tr, this message translates to:
  /// **'Zaman çizelgesi'**
  String get uiTimelineTitle;

  /// ui.timeline.view
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get uiTimelineView;

  /// ui.timeline.list
  ///
  /// In tr, this message translates to:
  /// **'Liste'**
  String get uiTimelineList;

  /// ui.timeline.coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük'**
  String get uiTimelineCoord;

  /// ui.timeline.coord_all
  ///
  /// In tr, this message translates to:
  /// **'tümü'**
  String get uiTimelineCoordAll;

  /// ui.timeline.coord_none
  ///
  /// In tr, this message translates to:
  /// **'seçilmedi'**
  String get uiTimelineCoordNone;

  /// ui.timeline.coord_selected
  ///
  /// In tr, this message translates to:
  /// **'seçili'**
  String get uiTimelineCoordSelected;

  /// ui.timeline.coord_open_tail
  ///
  /// In tr, this message translates to:
  /// **'açık'**
  String get uiTimelineCoordOpenTail;

  /// ui.timeline.coord_clear
  ///
  /// In tr, this message translates to:
  /// **'Seçimi kaldır'**
  String get uiTimelineCoordClear;

  /// ui.timeline.coord_select_all
  ///
  /// In tr, this message translates to:
  /// **'Tümünü seç'**
  String get uiTimelineCoordSelectAll;

  /// ui.timeline.filter
  ///
  /// In tr, this message translates to:
  /// **'Filtre'**
  String get uiTimelineFilter;

  /// ui.timeline.filter_label
  ///
  /// In tr, this message translates to:
  /// **'Filtreler · durum, kişi, öncelik'**
  String get uiTimelineFilterLabel;

  /// ui.timeline.filters
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get uiTimelineFilters;

  /// ui.timeline.clear
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get uiTimelineClear;

  /// ui.timeline.status
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get uiTimelineStatus;

  /// ui.timeline.status_all
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get uiTimelineStatusAll;

  /// ui.timeline.status_open
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get uiTimelineStatusOpen;

  /// ui.timeline.status_late
  ///
  /// In tr, this message translates to:
  /// **'Geciken'**
  String get uiTimelineStatusLate;

  /// ui.timeline.status_done
  ///
  /// In tr, this message translates to:
  /// **'Biten'**
  String get uiTimelineStatusDone;

  /// ui.timeline.person
  ///
  /// In tr, this message translates to:
  /// **'Kişi'**
  String get uiTimelinePerson;

  /// ui.timeline.priority
  ///
  /// In tr, this message translates to:
  /// **'Öncelik'**
  String get uiTimelinePriority;

  /// ui.timeline.prio_high
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get uiTimelinePrioHigh;

  /// ui.timeline.prio_mid
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get uiTimelinePrioMid;

  /// ui.timeline.prio_low
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get uiTimelinePrioLow;

  /// ui.timeline.scale
  ///
  /// In tr, this message translates to:
  /// **'Ölçek'**
  String get uiTimelineScale;

  /// ui.timeline.scale_day
  ///
  /// In tr, this message translates to:
  /// **'Gün'**
  String get uiTimelineScaleDay;

  /// ui.timeline.scale_week
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get uiTimelineScaleWeek;

  /// ui.timeline.scale_month
  ///
  /// In tr, this message translates to:
  /// **'Ay'**
  String get uiTimelineScaleMonth;

  /// ui.timeline.zoom_in
  ///
  /// In tr, this message translates to:
  /// **'Yakınlaştır'**
  String get uiTimelineZoomIn;

  /// ui.timeline.zoom_out
  ///
  /// In tr, this message translates to:
  /// **'Uzaklaştır'**
  String get uiTimelineZoomOut;

  /// ui.timeline.overview
  ///
  /// In tr, this message translates to:
  /// **'Genel bakış'**
  String get uiTimelineOverview;

  /// ui.timeline.overview_hint
  ///
  /// In tr, this message translates to:
  /// **'Her koordinatörlük bir sütun; sütuna dokununca o koordinatörlük açılır.'**
  String get uiTimelineOverviewHint;

  /// ui.timeline.coord_hint
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük, çizelgenin üstündeki menüden seçilir.'**
  String get uiTimelineCoordHint;

  /// ui.timeline.show_tasks_tail
  ///
  /// In tr, this message translates to:
  /// **'görevi göster'**
  String get uiTimelineShowTasksTail;

  /// ui.timeline.legend
  ///
  /// In tr, this message translates to:
  /// **'Lejant'**
  String get uiTimelineLegend;

  /// ui.timeline.legend_open
  ///
  /// In tr, this message translates to:
  /// **'Lejantı göster'**
  String get uiTimelineLegendOpen;

  /// ui.timeline.st_todo
  ///
  /// In tr, this message translates to:
  /// **'Başlamadı'**
  String get uiTimelineStTodo;

  /// ui.timeline.st_doing
  ///
  /// In tr, this message translates to:
  /// **'Devam ediyor'**
  String get uiTimelineStDoing;

  /// ui.timeline.st_review
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get uiTimelineStReview;

  /// ui.timeline.st_back
  ///
  /// In tr, this message translates to:
  /// **'Geri gönderildi'**
  String get uiTimelineStBack;

  /// ui.timeline.st_done
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get uiTimelineStDone;

  /// ui.timeline.st_done_late
  ///
  /// In tr, this message translates to:
  /// **'Geç bitti'**
  String get uiTimelineStDoneLate;

  /// ui.timeline.st_late
  ///
  /// In tr, this message translates to:
  /// **'Gecikmede'**
  String get uiTimelineStLate;

  /// ui.timeline.st_request
  ///
  /// In tr, this message translates to:
  /// **'Tarih talebi'**
  String get uiTimelineStRequest;

  /// ui.timeline.legend_today
  ///
  /// In tr, this message translates to:
  /// **'Yeşil çizgi bugünü gösterir; soldaki kutu bugünün tarihi.'**
  String get uiTimelineLegendToday;

  /// ui.timeline.legend_strip
  ///
  /// In tr, this message translates to:
  /// **'Alttaki şerit sezonun haritası: çerçeve baktığın aralık, kırmızı hafta gecikmenin başladığı hafta. Dokunarak ya da sürükleyerek o haftaya git.'**
  String get uiTimelineLegendStrip;

  /// ui.timeline.legend_bar
  ///
  /// In tr, this message translates to:
  /// **'Çubuğa dokun: tarihleri − / + ile ya da tarih alanından değiştir, çubuk anında güncellenir. Seçili çubuğu basılı tutup sürükleyerek de kaydırabilirsin.'**
  String get uiTimelineLegendBar;

  /// ui.timeline.today
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get uiTimelineToday;

  /// ui.timeline.season_map
  ///
  /// In tr, this message translates to:
  /// **'Sezon haritası · parmağını kaydırarak çizelgede gez'**
  String get uiTimelineSeasonMap;

  /// ui.timeline.empty
  ///
  /// In tr, this message translates to:
  /// **'Bu filtrede görev yok.'**
  String get uiTimelineEmpty;

  /// ui.timeline.empty_no_coord
  ///
  /// In tr, this message translates to:
  /// **'Koordinatörlük seç.'**
  String get uiTimelineEmptyNoCoord;

  /// ui.timeline.dependent
  ///
  /// In tr, this message translates to:
  /// **'bağımlı'**
  String get uiTimelineDependent;

  /// ui.timeline.days_late
  ///
  /// In tr, this message translates to:
  /// **'gün gecikmede'**
  String get uiTimelineDaysLate;

  /// ui.timeline.days_late_done
  ///
  /// In tr, this message translates to:
  /// **'gün geç bitti'**
  String get uiTimelineDaysLateDone;

  /// ui.timeline.selected_task
  ///
  /// In tr, this message translates to:
  /// **'Seçili görev'**
  String get uiTimelineSelectedTask;

  /// ui.timeline.open_task
  ///
  /// In tr, this message translates to:
  /// **'Görev ayrıntısında aç'**
  String get uiTimelineOpenTask;

  /// ui.timeline.evidence_tail
  ///
  /// In tr, this message translates to:
  /// **'kanıt dosyası'**
  String get uiTimelineEvidenceTail;

  /// ui.timeline.no_evidence
  ///
  /// In tr, this message translates to:
  /// **'kanıt yok'**
  String get uiTimelineNoEvidence;

  /// ui.timeline.start
  ///
  /// In tr, this message translates to:
  /// **'başlangıç'**
  String get uiTimelineStart;

  /// ui.timeline.end
  ///
  /// In tr, this message translates to:
  /// **'bitiş'**
  String get uiTimelineEnd;

  /// ui.timeline.day_back
  ///
  /// In tr, this message translates to:
  /// **'bir gün geri'**
  String get uiTimelineDayBack;

  /// ui.timeline.day_forward
  ///
  /// In tr, this message translates to:
  /// **'bir gün ileri'**
  String get uiTimelineDayForward;

  /// ui.timeline.shift_all
  ///
  /// In tr, this message translates to:
  /// **'tümünü kaydır'**
  String get uiTimelineShiftAll;

  /// ui.timeline.shift_week_back
  ///
  /// In tr, this message translates to:
  /// **'−1 hf'**
  String get uiTimelineShiftWeekBack;

  /// ui.timeline.shift_day_back
  ///
  /// In tr, this message translates to:
  /// **'−1 g'**
  String get uiTimelineShiftDayBack;

  /// ui.timeline.shift_day_forward
  ///
  /// In tr, this message translates to:
  /// **'+1 g'**
  String get uiTimelineShiftDayForward;

  /// ui.timeline.shift_week_forward
  ///
  /// In tr, this message translates to:
  /// **'+1 hf'**
  String get uiTimelineShiftWeekForward;

  /// ui.timeline.day
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get uiTimelineDay;

  /// ui.timeline.duration
  ///
  /// In tr, this message translates to:
  /// **'süre'**
  String get uiTimelineDuration;

  /// ui.timeline.week_short
  ///
  /// In tr, this message translates to:
  /// **'hf'**
  String get uiTimelineWeekShort;

  /// ui.timeline.save
  ///
  /// In tr, this message translates to:
  /// **'Tarihleri kaydet'**
  String get uiTimelineSave;

  /// ui.timeline.send_request
  ///
  /// In tr, this message translates to:
  /// **'Talep olarak gönder'**
  String get uiTimelineSendRequest;

  /// ui.timeline.remind
  ///
  /// In tr, this message translates to:
  /// **'Atanana hatırlat'**
  String get uiTimelineRemind;

  /// ui.timeline.request_pending
  ///
  /// In tr, this message translates to:
  /// **'Bu görev için zaten bekleyen bir talep var'**
  String get uiTimelineRequestPending;

  /// ui.timeline.request_no_change
  ///
  /// In tr, this message translates to:
  /// **'Önce tarihleri değiştir, sonra talep gönder'**
  String get uiTimelineRequestNoChange;

  /// ui.timeline.request_sent
  ///
  /// In tr, this message translates to:
  /// **'Tarih talebi gönderildi · yeni bitiş'**
  String get uiTimelineRequestSent;

  /// ui.timeline.request_sent_tail
  ///
  /// In tr, this message translates to:
  /// **'onay bekliyor'**
  String get uiTimelineRequestSentTail;

  /// ui.timeline.reminded
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma gönderildi'**
  String get uiTimelineReminded;

  /// ui.timeline.undone_tail
  ///
  /// In tr, this message translates to:
  /// **'tarihleri geri alındı'**
  String get uiTimelineUndoneTail;

  /// ui.timeline.shifted_forward
  ///
  /// In tr, this message translates to:
  /// **'gün ileri kaydırıldı'**
  String get uiTimelineShiftedForward;

  /// ui.timeline.shifted_back
  ///
  /// In tr, this message translates to:
  /// **'gün geri kaydırıldı'**
  String get uiTimelineShiftedBack;

  /// ui.timeline.duration_of
  ///
  /// In tr, this message translates to:
  /// **'süresi'**
  String get uiTimelineDurationOf;

  /// ui.timeline.extended
  ///
  /// In tr, this message translates to:
  /// **'gün uzatıldı'**
  String get uiTimelineExtended;

  /// ui.timeline.shortened
  ///
  /// In tr, this message translates to:
  /// **'gün kısaltıldı'**
  String get uiTimelineShortened;

  /// ui.timeline.undo
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get uiTimelineUndo;

  /// ui.timeline.tasks_lc
  ///
  /// In tr, this message translates to:
  /// **'görev'**
  String get uiTimelineTasksLc;

  /// ui.timeline.done_lc
  ///
  /// In tr, this message translates to:
  /// **'bitti'**
  String get uiTimelineDoneLc;

  /// ui.timeline.late_lc
  ///
  /// In tr, this message translates to:
  /// **'gecikmede'**
  String get uiTimelineLateLc;

  /// ui.timeline.open
  ///
  /// In tr, this message translates to:
  /// **'aç'**
  String get uiTimelineOpen;

  /// ui.timeline.gantt_back
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get uiTimelineGanttBack;

  /// ui.timeline.gantt_back_label
  ///
  /// In tr, this message translates to:
  /// **'Geri: Görevler'**
  String get uiTimelineGanttBackLabel;

  /// ui.timeline.gantt_filter
  ///
  /// In tr, this message translates to:
  /// **'Görev filtresi'**
  String get uiTimelineGanttFilter;

  /// ui.timeline.gantt_scale_season
  ///
  /// In tr, this message translates to:
  /// **'Sezon'**
  String get uiTimelineGanttScaleSeason;

  /// ui.timeline.gantt_all_coords
  ///
  /// In tr, this message translates to:
  /// **'Tüm koordinatörlükler'**
  String get uiTimelineGanttAllCoords;

  /// ui.timeline.gantt_all_coords_lc
  ///
  /// In tr, this message translates to:
  /// **'tüm koordinatörlükler'**
  String get uiTimelineGanttAllCoordsLc;

  /// ui.timeline.gantt_label_head
  ///
  /// In tr, this message translates to:
  /// **'koordinatörlük · görev'**
  String get uiTimelineGanttLabelHead;

  /// ui.timeline.gantt_late_tail
  ///
  /// In tr, this message translates to:
  /// **'gecikme'**
  String get uiTimelineGanttLateTail;

  /// ui.timeline.gantt_today_pill
  ///
  /// In tr, this message translates to:
  /// **'bugün'**
  String get uiTimelineGanttTodayPill;

  /// ui.timeline.gantt_empty
  ///
  /// In tr, this message translates to:
  /// **'Bu filtreyle eşleşen görev yok.'**
  String get uiTimelineGanttEmpty;

  /// ui.timeline.gantt_legend_late
  ///
  /// In tr, this message translates to:
  /// **'Gecikme'**
  String get uiTimelineGanttLegendLate;

  /// ui.timeline.gantt_legend_fest
  ///
  /// In tr, this message translates to:
  /// **'Teknofest günleri'**
  String get uiTimelineGanttLegendFest;

  /// ui.timeline.gantt_card_status
  ///
  /// In tr, this message translates to:
  /// **'durum'**
  String get uiTimelineGanttCardStatus;

  /// ui.timeline.gantt_card_date
  ///
  /// In tr, this message translates to:
  /// **'tarih'**
  String get uiTimelineGanttCardDate;

  /// ui.timeline.gantt_card_assignee
  ///
  /// In tr, this message translates to:
  /// **'atanan'**
  String get uiTimelineGanttCardAssignee;

  /// ui.timeline.gantt_unassigned
  ///
  /// In tr, this message translates to:
  /// **'Atanmamış'**
  String get uiTimelineGanttUnassigned;

  /// ui.timeline.gantt_days_late
  ///
  /// In tr, this message translates to:
  /// **'gün gecikti'**
  String get uiTimelineGanttDaysLate;

  /// ui.timeline.gantt_open_task
  ///
  /// In tr, this message translates to:
  /// **'Görev ayrıntısını aç'**
  String get uiTimelineGanttOpenTask;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
