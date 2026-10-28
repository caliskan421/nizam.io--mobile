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

  /// ui.activity.title
  ///
  /// In tr, this message translates to:
  /// **'İşlem geçmişi'**
  String get uiActivityTitle;

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

  /// ui.buttons.busy
  ///
  /// In tr, this message translates to:
  /// **'Meşgul'**
  String get uiButtonsBusy;

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
  /// **'görevden'**
  String get uiHomeKpiDoneOf;

  /// ui.home.kpi_done_tail
  ///
  /// In tr, this message translates to:
  /// **'tanesi bitti'**
  String get uiHomeKpiDoneTail;

  /// ui.home.kpi_doing_tail
  ///
  /// In tr, this message translates to:
  /// **'tanesi zamanında'**
  String get uiHomeKpiDoingTail;

  /// ui.home.kpi_late_lead
  ///
  /// In tr, this message translates to:
  /// **'Açık görevlerde'**
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
  /// **'Parola'**
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

  /// ui.inputs.password_show
  ///
  /// In tr, this message translates to:
  /// **'Parolayı göster'**
  String get uiInputsPasswordShow;

  /// ui.inputs.password_hide
  ///
  /// In tr, this message translates to:
  /// **'Parolayı gizle'**
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

  /// ui.router.dev_catalog_open
  ///
  /// In tr, this message translates to:
  /// **'Bileşen kataloğunu aç'**
  String get uiRouterDevCatalogOpen;

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
  /// **'Asistan mobilde sonraki adımda eklenecek'**
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

  /// ui.timeline.title
  ///
  /// In tr, this message translates to:
  /// **'Zaman çizelgesi'**
  String get uiTimelineTitle;
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
