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

  /// organization.transfer_unavailable
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap aktarılamaz.'**
  String get errOrganizationTransferUnavailable;

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
