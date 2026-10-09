// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get errAuditEntryRejected =>
      'İşlem kaydı yazılamadığı için istek tamamlanamadı.';

  @override
  String get errCollaborationAgendaItemNotFound => 'Gündem maddesi bulunamadı.';

  @override
  String get errCollaborationAgendaLimitReached =>
      'Gündem madde sınırına ulaşıldı.';

  @override
  String get errCollaborationInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errCollaborationInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errCollaborationMeetingNotFound => 'Toplantı bulunamadı.';

  @override
  String get errCollaborationMessageNotFound => 'Mesaj bulunamadı.';

  @override
  String get errCollaborationMessageUnread => 'Mesaj henüz okunmadı.';

  @override
  String get errCollaborationNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errCollaborationNotDeleted => 'Kayıt silinmiş durumda değil.';

  @override
  String get errCollaborationNoteConverted => 'Not zaten göreve dönüştürüldü.';

  @override
  String get errCollaborationNoteImmutable => 'Bu not artık değiştirilemez.';

  @override
  String get errCollaborationNoteNotFound => 'Not bulunamadı.';

  @override
  String get errCollaborationParticipantInvalid => 'Katılımcı seçimi geçersiz.';

  @override
  String get errCollaborationPermanentRequiresDeleted =>
      'Kalıcı silme için kayıt önce silinmiş olmalı.';

  @override
  String get errCollaborationScopeInvalid =>
      'Seçili kapsam bu işlem için geçersiz.';

  @override
  String get errCollaborationTargetDepartmentInvalid =>
      'Hedef departman geçersiz.';

  @override
  String get errIdentityAccountEmailDeleted =>
      'Bu e-posta silinmiş bir hesaba ait.';

  @override
  String get errIdentityAccountExists => 'Bu e-postayla bir hesap zaten var.';

  @override
  String get errIdentityAccountNotFound => 'Hesap bulunamadı.';

  @override
  String get errIdentityAccountNotLocked => 'Hesap kilitli değil.';

  @override
  String get errIdentityAccountReferenced =>
      'Hesap başka kayıtlarda kullanıldığı için kalıcı silinemez.';

  @override
  String get errIdentityCaptchaInvalid =>
      'Güvenlik doğrulaması başarısız; yeniden deneyin.';

  @override
  String get errIdentityCaptchaRequired => 'Güvenlik doğrulaması gerekli.';

  @override
  String get errIdentityCredentialsInvalid => 'E-posta veya parola hatalı.';

  @override
  String get errIdentityForcePasswordChangeRequired =>
      'Devam etmek için parolanızı değiştirmelisiniz.';

  @override
  String get errIdentityInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errIdentityInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errIdentityInvalidEmail => 'E-posta adresi geçersiz.';

  @override
  String get errIdentityInvalidFullName => 'Ad soyad geçersiz.';

  @override
  String get errIdentityIpBlocked =>
      'Bu ağdan çok sayıda başarısız deneme yapıldı; bir süre sonra yeniden deneyin.';

  @override
  String get errIdentityLoginLocked =>
      'Çok sayıda başarısız giriş nedeniyle hesap geçici olarak kilitlendi.';

  @override
  String get errIdentityNotDeleted => 'Hesap silinmiş durumda değil.';

  @override
  String get errIdentityPasswordNeedsDigit =>
      'Parola en az bir rakam içermeli.';

  @override
  String get errIdentityPasswordNeedsLower =>
      'Parola en az bir küçük harf içermeli.';

  @override
  String get errIdentityPasswordNeedsUpper =>
      'Parola en az bir büyük harf içermeli.';

  @override
  String get errIdentityPasswordTooShort => 'Parola çok kısa.';

  @override
  String get errIdentityPermanentRequiresDeleted =>
      'Kalıcı silme için hesap önce silinmiş olmalı.';

  @override
  String get errIdentitySessionInvalid =>
      'Oturumunuz geçersiz veya süresi dolmuş; yeniden giriş yapın.';

  @override
  String get errIdentityWeakPassword => 'Parola yeterince güçlü değil.';

  @override
  String get errNotificationsInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errNotificationsInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errNotificationsNotificationNotFound => 'Bildirim bulunamadı.';

  @override
  String get errNotificationsScopeInvalid =>
      'Seçili kapsam bu işlem için geçersiz.';

  @override
  String get errNotificationsSubscriptionNotFound =>
      'Bildirim aboneliği bulunamadı.';

  @override
  String get errNotificationsSubscriptionOwnerConflict =>
      'Bu bildirim aboneliği başka bir hesaba ait.';

  @override
  String get errNotificationsTargetInvalid => 'Bildirim hedefi geçersiz.';

  @override
  String get errOrganizationAccountNotFound => 'Kullanıcı bulunamadı.';

  @override
  String get errOrganizationAssignmentNotFound => 'Atama bulunamadı.';

  @override
  String get errOrganizationAuthorityUnavailable =>
      'Yetki bilgisi şu anda alınamıyor; biraz sonra yeniden deneyin.';

  @override
  String get errOrganizationCompanyExists => 'Şirket kaydı zaten var.';

  @override
  String get errOrganizationCompanyNotFound => 'Şirket kaydı bulunamadı.';

  @override
  String get errOrganizationConfirmationRequired =>
      'Bu değişiklik görevleri etkiliyor; devam etmek için onaylayın.';

  @override
  String get errOrganizationDepartmentCodeConflict =>
      'Bu departman kodu başka bir departmanda kullanılıyor.';

  @override
  String get errOrganizationDepartmentExists =>
      'Bu adla bir departman zaten var.';

  @override
  String get errOrganizationDepartmentInUse =>
      'Departman kullanımda olduğu için silinemez.';

  @override
  String get errOrganizationDepartmentNotFound => 'Departman bulunamadı.';

  @override
  String get errOrganizationInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errOrganizationInvalidCode => 'Departman kodu geçersiz.';

  @override
  String get errOrganizationInvalidKind => 'Departman türü geçersiz.';

  @override
  String get errOrganizationInvalidName => 'Ad geçersiz.';

  @override
  String get errOrganizationInvalidRole => 'Rol geçersiz.';

  @override
  String get errOrganizationInvalidSort => 'Sıralama seçimi geçersiz.';

  @override
  String get errOrganizationLastAdmin => 'Son yönetici kaldırılamaz.';

  @override
  String get errOrganizationMembershipExists =>
      'Kullanıcı bu departmanda zaten üye.';

  @override
  String get errOrganizationMembershipNotFound => 'Üyelik bulunamadı.';

  @override
  String get errOrganizationMembershipRequired =>
      'Bu işlem için departman üyeliği gerekli.';

  @override
  String get errOrganizationNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errOrganizationNotDeleted => 'Kayıt silinmiş durumda değil.';

  @override
  String get errOrganizationPermanentRequiresDeleted =>
      'Kalıcı silme için kayıt önce silinmiş olmalı.';

  @override
  String get errOrganizationTaskTitle => 'Etkilenen görev.';

  @override
  String get errOrganizationTransferAvailable =>
      'Bu hesap başka bir departmandan aktarılabilir.';

  @override
  String get errOrganizationTransferUnavailable => 'Bu hesap aktarılamaz.';

  @override
  String get errPlatformBodyInvalid => 'İstek içeriği geçersiz.';

  @override
  String get errPlatformBodyTooLarge => 'İstek içeriği çok büyük.';

  @override
  String get errPlatformBodyUnknownField =>
      'İstek tanınmayan bir alan içeriyor; uygulamayı güncelleyin.';

  @override
  String get errPlatformConflictRetry =>
      'Eşzamanlı bir değişiklik oldu; yeniden deneyin.';

  @override
  String get errPlatformCsrfHeaderMissing =>
      'İstek güvenlik doğrulamasından geçemedi.';

  @override
  String get errPlatformInternal => 'Beklenmeyen bir sunucu hatası oluştu.';

  @override
  String get errPlatformMethodNotAllowed => 'Bu işlem desteklenmiyor.';

  @override
  String get errPlatformNotReady =>
      'Sunucu şu anda hazır değil; biraz sonra yeniden deneyin.';

  @override
  String get errPlatformPanic => 'Beklenmeyen bir sunucu hatası oluştu.';

  @override
  String get errPlatformRateLimited =>
      'Çok fazla istek gönderildi; biraz bekleyip yeniden deneyin.';

  @override
  String get errPlatformRouteNotFound => 'İstenen kaynak bulunamadı.';

  @override
  String get errPlatformScopeMissing =>
      'Bu işlem için program veya departman seçilmeli.';

  @override
  String get errPlatformUnauthenticated => 'Oturum açmanız gerekiyor.';

  @override
  String get errProgramAlreadyExists => 'Bu program zaten var.';

  @override
  String get errProgramDepartmentNotFound =>
      'Departman bu programda bulunamadı.';

  @override
  String get errProgramDuplicateTransferItem =>
      'Aktarım listesinde aynı kayıt birden fazla kez var.';

  @override
  String get errProgramIdempotencyKeyReused =>
      'Bu istek anahtarı farklı bir istekle kullanılmış.';

  @override
  String get errProgramInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errProgramInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errProgramInvalidDescription => 'Açıklama geçersiz.';

  @override
  String get errProgramInvalidLimit => 'Sayfa boyutu geçersiz.';

  @override
  String get errProgramInvalidName => 'Program adı geçersiz.';

  @override
  String get errProgramInvalidTransfer => 'Aktarım isteği geçersiz.';

  @override
  String get errProgramInvalidYear => 'Yıl geçersiz.';

  @override
  String get errProgramNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errProgramNotFound => 'Program bulunamadı.';

  @override
  String get errProgramPasswordInvalid => 'Parola hatalı.';

  @override
  String get errProgramPasswordRequired => 'Bu işlem için parolanızı girin.';

  @override
  String get errProgramProgramInUse =>
      'Program kullanımda olduğu için silinemez.';

  @override
  String get errProgramRequestKeyInvalid => 'İstek anahtarı geçersiz.';

  @override
  String get errProgramRequestKeyRequired => 'İstek anahtarı gerekli.';

  @override
  String get errProgramTransferAlreadyReversed =>
      'Bu aktarım zaten geri alındı.';

  @override
  String get errProgramTransferBlocked => 'Aktarım engellendi.';

  @override
  String get errProgramTransferConflict =>
      'Aktarım başka bir işlemle çakışıyor.';

  @override
  String get errProgramTransferInputInvalid => 'Aktarım bilgileri geçersiz.';

  @override
  String get errProgramTransferNotFound => 'Aktarım bulunamadı.';

  @override
  String get errProgramTransferNotReversible => 'Bu aktarım geri alınamaz.';

  @override
  String get errProgramTransferPreviewStale =>
      'Aktarım önizlemesi eskidi; yeniden önizleyin.';

  @override
  String get errProvisioningVersionMismatch =>
      'Sunucu sürümleri uyumsuz; yöneticinize başvurun.';

  @override
  String get errProvisioningWriteNotAllowed =>
      'Kurulum şu anda değişikliğe kapalı (salt okunur).';

  @override
  String get errRecordsBusy =>
      'Dosya işlemi şu anda yoğun; biraz sonra yeniden deneyin.';

  @override
  String get errRecordsContentRejected => 'Dosya içeriği kabul edilmedi.';

  @override
  String get errRecordsFileNotFound => 'Dosya bulunamadı.';

  @override
  String get errRecordsInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errRecordsInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errRecordsInvalidFile => 'Dosya geçersiz.';

  @override
  String get errRecordsMoved => 'Dosya taşındı; listeyi yenileyin.';

  @override
  String get errRecordsNameInvalid => 'Dosya adı geçersiz.';

  @override
  String get errRecordsNameTaken => 'Bu adla bir dosya zaten var.';

  @override
  String get errRecordsNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errRecordsTooLarge => 'Dosya çok büyük.';

  @override
  String get errRecordsTooManyFiles => 'Dosya sayısı sınırına ulaşıldı.';

  @override
  String get errRecordsTransferActive =>
      'Devam eden bir aktarım nedeniyle dosya değiştirilemez.';

  @override
  String get errReportingCapacityFull =>
      'Rapor kapasitesi dolu; biraz sonra yeniden deneyin.';

  @override
  String get errReportingExportInProgress =>
      'Devam eden bir dışa aktarım var; tamamlanmasını bekleyin.';

  @override
  String get errReportingInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errReportingNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errReportingNotFound => 'Rapor bulunamadı.';

  @override
  String get errStorageInconsistent =>
      'Dosya deposu tutarsız durumda; yöneticinize başvurun.';

  @override
  String get errStorageInvalidKey => 'Dosya anahtarı geçersiz.';

  @override
  String get errStorageNotFound => 'Dosya bulunamadı.';

  @override
  String get errStoragePermanent => 'Dosya işlemi kalıcı olarak reddedildi.';

  @override
  String get errStorageQuota => 'Depolama kotası doldu.';

  @override
  String get errStorageTransient =>
      'Dosya deposuna geçici olarak erişilemiyor; yeniden deneyin.';

  @override
  String get errWorkAssigneeNotMember =>
      'Atanan kişi bu departmanın üyesi değil.';

  @override
  String get errWorkAssignmentDuplicate => 'Bu kişi zaten atanmış.';

  @override
  String get errWorkAttachmentRequired => 'Bu işlem için ek dosya gerekli.';

  @override
  String get errWorkClaimNotAvailable => 'Bu görev üstlenilemez.';

  @override
  String get errWorkCompletionDateFuture =>
      'Tamamlanma tarihi ileri bir tarih olamaz.';

  @override
  String get errWorkCompletionDateMissing => 'Tamamlanma tarihi gerekli.';

  @override
  String get errWorkCompletionWindow =>
      'Tamamlanma tarihi izin verilen aralığın dışında.';

  @override
  String get errWorkConstraintViolation => 'İşlem bir kısıtı ihlal ediyor.';

  @override
  String get errWorkDateRequestAlreadyReviewed =>
      'Tarih talebi zaten değerlendirildi.';

  @override
  String get errWorkDateRequestInvalid => 'Tarih talebi geçersiz.';

  @override
  String get errWorkDateRequestPendingExists =>
      'Bekleyen bir tarih talebi zaten var.';

  @override
  String get errWorkDateRequestPendingUndeletable =>
      'Bekleyen tarih talebi silinemez.';

  @override
  String get errWorkDepartmentUnavailable =>
      'Departman şu anda kullanılamıyor.';

  @override
  String get errWorkDependencyCycle => 'Bu bağımlılık döngü oluşturur.';

  @override
  String get errWorkDependencyDateOrder =>
      'Bağımlılık tarih sırasıyla çelişiyor.';

  @override
  String get errWorkDependencyDuplicate => 'Bu bağımlılık zaten var.';

  @override
  String get errWorkDependencyNotCompleted =>
      'Bağımlı olunan görev henüz tamamlanmadı.';

  @override
  String get errWorkExtendDaysOutOfRange =>
      'Uzatma gün sayısı izin verilen aralıkta değil.';

  @override
  String get errWorkInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errWorkInvalidInput => 'Alan değeri geçersiz.';

  @override
  String get errWorkItemCompleted => 'Görev zaten tamamlandı.';

  @override
  String get errWorkItemNotCompleted => 'Görev henüz tamamlanmadı.';

  @override
  String get errWorkItemNotFound => 'Görev bulunamadı.';

  @override
  String get errWorkNotAssigned => 'Bu görev size atanmamış.';

  @override
  String get errWorkNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errWorkNotDeleted => 'Görev silinmiş durumda değil.';

  @override
  String get errWorkNoteNotFound => 'Not bulunamadı.';

  @override
  String get errWorkNoteNotYours => 'Bu not size ait değil.';

  @override
  String get errWorkNoteRateLimited =>
      'Çok sık not eklendi; biraz bekleyip yeniden deneyin.';

  @override
  String get errWorkPermanentRequiresDeleted =>
      'Kalıcı silme için görev önce silinmiş olmalı.';

  @override
  String get errWorkProgramScopeInvalid => 'Görev seçili programda bulunamadı.';

  @override
  String get errWorkProtectedField => 'Bu alan değiştirilemez.';

  @override
  String get errWorkRevertReasonRequired => 'Geri alma için gerekçe gerekli.';

  @override
  String get errWorkStaleCompletion =>
      'Görev başka biri tarafından güncellendi; yenileyip yeniden deneyin.';

  @override
  String get errWorkStaleTransition =>
      'Görev durumu değişti; yenileyip yeniden deneyin.';

  @override
  String get errWorkTransferActive =>
      'Devam eden bir aktarım nedeniyle görev değiştirilemez.';

  @override
  String get errWorkTransitionNotAllowed =>
      'Bu durum geçişine izin verilmiyor.';

  @override
  String get errClientInsecureServer =>
      'Sunucu adresi https ile başlamalı; güvenli olmayan bağlantı kurulmaz.';

  @override
  String get errClientInvalidResponse =>
      'Sunucudan beklenmeyen bir yanıt geldi.';

  @override
  String get errClientInvalidServerAddress => 'Sunucu adresi geçersiz.';

  @override
  String get errClientNetworkError =>
      'Sunucuya ulaşılamadı. Bağlantınızı kontrol edip yeniden deneyin.';

  @override
  String get errClientNotSignedIn => 'Bu işlem için giriş yapılmalı.';

  @override
  String get errClientReauthRequired =>
      'Oturum doğrulanamadı. Güvenliğiniz için yeniden giriş yapın.';

  @override
  String get errClientScopeMissing =>
      'Bu işlem için önce program veya departman seçilmeli.';

  @override
  String get errClientSecureStorageError =>
      'Oturum bilgisi cihazda güvenli olarak saklanamadı. Yeniden giriş yapın.';

  @override
  String get errClientServerNotVerified => 'Önce sunucu adresi doğrulanmalı.';

  @override
  String get errClientServerUnrecognized =>
      'Bu adres bir NIZAM.IO sunucusu değil.';

  @override
  String get errClientSessionEnded => 'Oturum sona erdi. Yeniden giriş yapın.';

  @override
  String get errClientTimeout =>
      'Sunucu zamanında yanıt vermedi. Biraz sonra yeniden deneyin.';

  @override
  String get errClientTlsError =>
      'Sunucunun güvenlik sertifikası doğrulanamadı; bağlantı kurulmadı.';

  @override
  String get errClientUnknownOperation =>
      'Bu işlem uygulamanın bu sürümünde tanımlı değil.';

  @override
  String get errClientUnsupportedApiVersion =>
      'Sunucunun API sürümü bu uygulamayla uyumlu değil.';

  @override
  String get errClientUpdateRequired =>
      'Bu sunucuya bağlanmak için uygulamayı güncelleyin.';
}
