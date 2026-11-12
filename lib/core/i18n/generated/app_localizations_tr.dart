// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get errAssistantBusy =>
      'Asistan şu anda meşgul; biraz sonra yeniden deneyin.';

  @override
  String get errAssistantCapacityFull =>
      'Asistan kapasitesi dolu; biraz sonra yeniden deneyin.';

  @override
  String get errAssistantInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errAssistantLimitExceeded => 'Asistan kullanım sınırına ulaşıldı.';

  @override
  String get errAssistantNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errAssistantNotFound => 'Asistan kaydı bulunamadı.';

  @override
  String get errAssistantProviderUnavailable =>
      'Asistan hizmeti şu anda kullanılamıyor.';

  @override
  String get errAssistantQuotaExceeded => 'Asistan kullanım kotası doldu.';

  @override
  String get errAssistantRefused => 'Asistan bu isteği yanıtlayamadı.';

  @override
  String get errAuditEntryRejected =>
      'İşlem kaydı yazılamadığı için istek tamamlanamadı.';

  @override
  String get errCollaborationAgendaItemNotFound => 'Gündem maddesi bulunamadı.';

  @override
  String get errCollaborationAgendaLimitReached =>
      'Gündem madde sınırına ulaşıldı.';

  @override
  String get errCollaborationConferenceDisabled =>
      'Görüntülü görüşme bu kurulumda kapalı.';

  @override
  String get errCollaborationConferenceNotActive => 'Görüşme etkin değil.';

  @override
  String get errCollaborationConferenceProviderUnavailable =>
      'Görüşme hizmeti şu anda kullanılamıyor.';

  @override
  String get errCollaborationConferenceWebhookInvalid =>
      'Görüşme bildirimi geçersiz.';

  @override
  String get errCollaborationConferenceWebhookUnauthorized =>
      'Görüşme bildirimi doğrulanamadı.';

  @override
  String get errCollaborationEditConflict =>
      'Not siz düzenlerken başkası tarafından değiştirildi; güncel hâlini görüp yeniden deneyin.';

  @override
  String get errCollaborationIdempotencyKeyReused =>
      'Bu istek anahtarı farklı bir istekle kullanılmış.';

  @override
  String get errCollaborationInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errCollaborationInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errCollaborationMeetingNotFound => 'Toplantı bulunamadı.';

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
  String get errCollaborationRequestKeyInvalid => 'İstek anahtarı geçersiz.';

  @override
  String get errCollaborationRequestKeyRequired => 'İstek anahtarı gerekli.';

  @override
  String get errCollaborationRevisionInvalid =>
      'Düzenleme sürümü geçersiz; kaydı yenileyip yeniden deneyin.';

  @override
  String get errCollaborationRevisionRequired =>
      'Düzenleme sürümü gerekli; uygulamayı güncelleyin.';

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
  String get errIdentityCapacityFull =>
      'Sistem şu anda yoğun; biraz sonra yeniden deneyin.';

  @override
  String get errIdentityCaptchaInvalid =>
      'Güvenlik doğrulaması başarısız; yeniden deneyin.';

  @override
  String get errIdentityCaptchaRequired => 'Güvenlik doğrulaması gerekli.';

  @override
  String get errIdentityCredentialsInvalid => 'E-posta veya parola hatalı.';

  @override
  String get errIdentityDownloadTargetInvalid => 'İndirme hedefi geçersiz.';

  @override
  String get errIdentityDownloadTicketInvalid =>
      'İndirme bağlantısı geçersiz veya süresi dolmuş.';

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
  String get errIdentityUnavailable =>
      'Kimlik hizmeti şu anda kullanılamıyor; yeniden deneyin.';

  @override
  String get errIdentityWeakPassword => 'Parola yeterince güçlü değil.';

  @override
  String get errMessagingChatDeleted => 'Sohbet silinmiş; işlem yapılamaz.';

  @override
  String get errMessagingChatNotFound => 'Sohbet bulunamadı.';

  @override
  String get errMessagingEditConflict =>
      'Mesaj siz düzenlerken değiştirildi; güncel hâlini görüp yeniden deneyin.';

  @override
  String get errMessagingFileRejected => 'Dosya kabul edilmedi.';

  @override
  String get errMessagingFileTooLarge => 'Dosya çok büyük.';

  @override
  String get errMessagingIdempotencyKeyReused =>
      'Bu istek anahtarı farklı bir istekle kullanılmış.';

  @override
  String get errMessagingInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errMessagingInvalidCursor =>
      'Liste konumu geçersiz; listeyi yenileyin.';

  @override
  String get errMessagingMemberNotFound => 'Üye bulunamadı.';

  @override
  String get errMessagingMemberSourceManaged =>
      'Bu üye grubun kaynağından gelir; elle çıkarılamaz.';

  @override
  String get errMessagingMessageDeleted => 'Mesaj silinmiş; işlem yapılamaz.';

  @override
  String get errMessagingMessageNotFound => 'Mesaj bulunamadı.';

  @override
  String get errMessagingNotAuthorized => 'Bu işlem için yetkiniz yok.';

  @override
  String get errMessagingPollClosed => 'Anket kapandı.';

  @override
  String get errMessagingRefNotFound =>
      'Bu öğe artık yok ya da erişiminiz yok.';

  @override
  String get errMessagingRequestKeyInvalid => 'İstek anahtarı geçersiz.';

  @override
  String get errMessagingRequestKeyRequired => 'İstek anahtarı gerekli.';

  @override
  String get errMessagingRevisionInvalid =>
      'Düzenleme sürümü geçersiz; mesajı yenileyip yeniden deneyin.';

  @override
  String get errMessagingRevisionRequired =>
      'Düzenleme sürümü gerekli; uygulamayı güncelleyin.';

  @override
  String get errMessagingScopeInvalid =>
      'Seçili kapsam bu işlem için geçersiz.';

  @override
  String get errMessagingTaskDeleted => 'Görev silinmiş; işlem yapılamaz.';

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
  String get errOrganizationDepartmentNotLinked =>
      'Departman bu programa bağlı değil.';

  @override
  String get errOrganizationExistingDepartment =>
      'Bu adda bir departman zaten var.';

  @override
  String get errOrganizationIdempotencyKeyReused =>
      'Bu işlem anahtarı başka bir istek için kullanılmış. Sayfayı yenileyip yeniden deneyin.';

  @override
  String get errOrganizationInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errOrganizationInvalidCode => 'Departman kodu geçersiz.';

  @override
  String get errOrganizationInvalidKind => 'Departman türü geçersiz.';

  @override
  String get errOrganizationInvalidName => 'Ad geçersiz.';

  @override
  String get errOrganizationInvalidRequestKey => 'İşlem anahtarı geçersiz.';

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
  String get errOrganizationProgramRequired => 'Program seçimi gerekli.';

  @override
  String get errOrganizationTaskTitle => 'Etkilenen görev.';

  @override
  String get errOrganizationTransferAvailable =>
      'Bu hesap başka bir departmandan aktarılabilir.';

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
  String get errProgramCopySourceNotLinked =>
      'Ekip kopyalanacak programda bu departman bağlı değil.';

  @override
  String get errProgramDepartmentLinkInUse =>
      'Departmanın programda canlı görevleri olduğu için bağı kaldırılamaz.';

  @override
  String get errProgramDepartmentLinkNameExists =>
      'Bu programda aynı adla bir departman zaten var.';

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
  String get errProgramInvalidColor => 'Geçersiz renk seçimi.';

  @override
  String get errProgramInvalidCopySource =>
      'Ekip kopyası için kaynak program geçersiz.';

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
  String get errProgramInvalidRequestKey => 'İşlem anahtarı geçersiz.';

  @override
  String get errProgramInvalidShortName =>
      'Kısa ad 1–4 harf ya da rakam olmalıdır.';

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
  String get errRecordsIdempotencyKeyReused =>
      'Bu istek anahtarı farklı bir istekle kullanılmış.';

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
  String get errRecordsRequestKeyInvalid => 'İstek anahtarı geçersiz.';

  @override
  String get errRecordsRequestKeyRequired => 'İstek anahtarı gerekli.';

  @override
  String get errRecordsTagInvalid => 'Dosya etiketi geçersiz.';

  @override
  String get errRecordsTagRequired => 'Dosya etiketi gerekli.';

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
  String get errWorkEditConflict =>
      'Görev siz düzenlerken başkası tarafından değiştirildi; güncel hâlini görüp yeniden deneyin.';

  @override
  String get errWorkExtendDaysOutOfRange =>
      'Uzatma gün sayısı izin verilen aralıkta değil.';

  @override
  String get errWorkIdempotencyKeyReused =>
      'Bu istek anahtarı farklı bir istekle kullanılmış.';

  @override
  String get errWorkInputInvalid => 'Girilen bilgiler geçersiz.';

  @override
  String get errWorkInvalidInput => 'Alan değeri geçersiz.';

  @override
  String get errWorkItemCompleted => 'Görev zaten tamamlandı.';

  @override
  String get errWorkItemDeleted => 'Görev silinmiş; işlem yapılamaz.';

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
  String get errWorkRequestKeyInvalid => 'İstek anahtarı geçersiz.';

  @override
  String get errWorkRequestKeyRequired => 'İstek anahtarı gerekli.';

  @override
  String get errWorkRevertReasonRequired => 'Geri alma için gerekçe gerekli.';

  @override
  String get errWorkRevisionInvalid =>
      'Düzenleme sürümü geçersiz; görevi yenileyip yeniden deneyin.';

  @override
  String get errWorkRevisionRequired =>
      'Düzenleme sürümü gerekli; uygulamayı güncelleyin.';

  @override
  String get errWorkStaleCompletion =>
      'Görev başka biri tarafından güncellendi; yenileyip yeniden deneyin.';

  @override
  String get errWorkStaleTransition =>
      'Görev durumu değişti; yenileyip yeniden deneyin.';

  @override
  String get errWorkSubtaskAssigneeNotAssigned =>
      'Alt görevin sorumlusu görevin atanmış kişilerinden biri olmalı.';

  @override
  String get errWorkSubtaskLimitReached => 'Alt görev sınırına ulaşıldı.';

  @override
  String get errWorkSubtaskNotFound => 'Alt görev bulunamadı.';

  @override
  String get errWorkSubtasksOpen =>
      'Açık alt görevler var; önce bunları tamamlayın ya da kapatın.';

  @override
  String get errWorkTransferActive =>
      'Devam eden bir aktarım nedeniyle görev değiştirilemez.';

  @override
  String get errWorkTransitionNotAllowed =>
      'Bu durum geçişine izin verilmiyor.';

  @override
  String get errClientFileUnreadable =>
      'Dosya okunamadı; silinmiş ya da erişilemiyor olabilir. Dosyayı yeniden seçin.';

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
  String get errClientOutcomeUnknown =>
      'Gönderildi mi bilinmiyor. Aynı isteği yeniden deneyin; kayıt iki kez oluşmaz.';

  @override
  String get errClientReauthRequired =>
      'Oturum doğrulanamadı. Güvenliğiniz için yeniden giriş yapın.';

  @override
  String get errClientRequestNotResent =>
      'İstek tekrar gönderilemedi; işlemi yeniden başlatın.';

  @override
  String get errClientScopeChanged =>
      'Seçili program veya departman işlem sırasında değişti; kalan adımlar gönderilmedi. Görevi yeniden açıp deneyin.';

  @override
  String get errClientScopeMissing =>
      'Bu işlem için önce program veya departman seçilmeli.';

  @override
  String get errClientSecureStorageError =>
      'Oturum bilgisi cihazda güvenli olarak saklanamadı. Yeniden giriş yapın.';

  @override
  String get errClientServerNotVerified => 'Önce sunucu adresi doğrulanmalı.';

  @override
  String get errClientServerOutdated =>
      'Sunucu bu uygulama sürümü için güncellenmeli; değişiklik gönderilmedi.';

  @override
  String get errClientServerUnrecognized =>
      'Bu adres bir NIZAM.IO sunucusu değil.';

  @override
  String get errClientSessionEnded => 'Oturum sona erdi. Yeniden giriş yapın.';

  @override
  String get errClientSessionRefreshed =>
      'Oturum yenilendi; dosya gönderilmedi. Yüklemeyi yeniden deneyin.';

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

  @override
  String get uiActivityTitle => 'İşlem geçmişi';

  @override
  String get uiActivityIntro =>
      'Portaldaki tüm işlemler değiştirilemez biçimde saklanır.';

  @override
  String get uiActivityCsv => 'CSV olarak indir';

  @override
  String get uiActivityCsvExport => 'CSV indirme';

  @override
  String get uiActivitySearchHint => 'İşlem, hedef veya kişi ara';

  @override
  String get uiActivityFilters => 'Filtreler';

  @override
  String get uiActivityFiltersLabel => 'Filtreler · yapan, koordinatörlük';

  @override
  String get uiActivityTypeLabel => 'Tür';

  @override
  String get uiActivityTypeAll => 'Tümü';

  @override
  String get uiActivityTypeTask => 'Görev';

  @override
  String get uiActivityTypeFile => 'Dosya';

  @override
  String get uiActivityTypeMeeting => 'Toplantı';

  @override
  String get uiActivityTypeMessage => 'Mesaj';

  @override
  String get uiActivityTypeAccount => 'Hesap';

  @override
  String get uiActivityChipType => 'Tür:';

  @override
  String get uiActivityRemoveType => 'Tür filtresini kaldır';

  @override
  String get uiActivityRemoveCoord => 'Koordinatörlük filtresini kaldır';

  @override
  String get uiActivityRemoveTail => 'filtresini kaldır';

  @override
  String get uiActivityClearAll => 'Tümünü temizle';

  @override
  String get uiActivityRecords => 'Kayıtlar';

  @override
  String get uiActivityToday => 'Bugün';

  @override
  String get uiActivityYesterday => 'Dün';

  @override
  String get uiActivityEmpty => 'Bu filtrelerle eşleşen kayıt yok.';

  @override
  String get uiActivityClearFilters => 'Filtreleri temizle';

  @override
  String get uiActivityMore => 'Daha fazla göster';

  @override
  String get uiActivityShownTail => 'kayıt gösteriliyor';

  @override
  String get uiActivityFooter =>
      'Kayıtlar değiştirilemez ve silinemez; denetim için saklanır.';

  @override
  String get uiActivityClear => 'Temizle';

  @override
  String get uiActivityByRole => 'yapan · rolüne göre';

  @override
  String get uiActivityCoordinatorship => 'koordinatörlük';

  @override
  String get uiActivityApplyTail => 'kaydı göster';

  @override
  String get uiActivityRoleAdmin => 'Admin';

  @override
  String get uiActivityRoleCoordinator => 'Koordinatör';

  @override
  String get uiActivityRoleMember => 'Üye';

  @override
  String get uiActivityCountTail => 'kayıt';

  @override
  String get uiActivityShortcuts => 'İşlem geçmişi kısayolları';

  @override
  String get uiActivitySectionType => 'kayıt türü';

  @override
  String get uiActivitySectionHistory => 'işlem geçmişi';

  @override
  String get uiActivityFlyFilter => 'Kişi ve koordinatörlük filtresi';

  @override
  String get uiActivityFlyHome => 'Ana sayfaya dön';

  @override
  String get uiActivitySoonTail => 'mobilde sonraki adımda eklenecek';

  @override
  String get uiActivityUnavailable => 'İşlem geçmişi kullanılamıyor';

  @override
  String get uiActivityUnsupported =>
      'Bu sunucu sürümü işlem geçmişi okumayı desteklemiyor.';

  @override
  String get uiArchivePdfPreviewError =>
      'PDF önizlenemedi. Dosya bozuk veya parola korumalı olabilir.';

  @override
  String get uiArchivePdfTooLarge =>
      'Bu PDF önizleme için çok büyük. İndirerek açabilirsiniz.';

  @override
  String get uiArchiveImagePreviewError => 'Görsel önizlenemedi.';

  @override
  String get uiArchiveImageTooLarge =>
      'Bu görsel önizleme için çok büyük. İndirerek açabilirsiniz.';

  @override
  String get uiArchiveTitle => 'Arşiv';

  @override
  String get uiArchiveFolderTitle => 'Klasör';

  @override
  String get uiArchiveSearch => 'Arşivde ara';

  @override
  String get uiArchiveSearchHint => 'Klasör adı';

  @override
  String get uiArchiveUpload => 'Dosya yükle';

  @override
  String get uiArchiveUploadShort => 'Yükle';

  @override
  String get uiArchiveUploadSoon => 'Dosya yükleme sonraki adımda tasarlanacak';

  @override
  String get uiArchiveStorage => 'Depolama';

  @override
  String get uiArchiveMb => 'MB';

  @override
  String get uiArchiveKb => 'KB';

  @override
  String get uiArchiveFilesLc => 'dosya';

  @override
  String get uiArchiveFoldersLc => 'klasör';

  @override
  String get uiArchiveSortRecent => 'Son yükleme';

  @override
  String get uiArchiveSortName => 'Ada göre';

  @override
  String get uiArchiveSortSize => 'Boyuta göre';

  @override
  String get uiArchiveNoFiles => 'Dosya yok';

  @override
  String get uiArchiveEmptySearch => 'Bu aramayla eşleşen klasör yok.';

  @override
  String get uiArchiveDownloadAll => 'Tümünü indir';

  @override
  String get uiArchiveDownloadAllToast => 'Tüm arşiv ZIP olarak hazırlanıyor';

  @override
  String get uiArchiveShortcuts => 'Arşiv kısayolları';

  @override
  String get uiArchiveSectionArchive => 'arşiv';

  @override
  String get uiArchiveSectionGo => 'git';

  @override
  String get uiArchiveGoCoordinatorships => 'Koordinatörlükler';

  @override
  String get uiArchiveSectionFolders => 'arşiv klasörleri';

  @override
  String get uiArchiveAllArchive => 'Tüm arşiv';

  @override
  String get uiArchiveZip => 'Klasörü ZIP olarak indir';

  @override
  String get uiArchiveZipToast => 'klasörü ZIP olarak hazırlanıyor';

  @override
  String get uiArchiveCoordinatorship => 'Koordinatörlük';

  @override
  String get uiArchiveTabs => 'Klasör';

  @override
  String get uiArchiveTabTasks => 'Görev klasörleri';

  @override
  String get uiArchiveTabFiles => 'Dosyalar';

  @override
  String get uiArchiveFilterAll => 'Tümü';

  @override
  String get uiArchiveFilterType => 'Dosya tipi';

  @override
  String get uiArchiveMimeDocument => 'Belge';

  @override
  String get uiArchiveMimeSpreadsheet => 'Tablo';

  @override
  String get uiArchiveMimeImage => 'Görsel';

  @override
  String get uiArchiveMimeArchive => 'Arşiv';

  @override
  String get uiArchiveMimeText => 'Metin';

  @override
  String get uiArchiveShowFilesTail => 'dosyayı göster';

  @override
  String get uiArchiveTagFilter => 'Etiket süzgeci';

  @override
  String get uiArchiveRemoveTaskFilter => 'Görev filtresini kaldır';

  @override
  String get uiArchiveEmptyFiles => 'Bu filtreyle eşleşen dosya yok.';

  @override
  String get uiArchivePreview => 'Dosya önizleme';

  @override
  String get uiArchivePrev => 'Önceki dosya';

  @override
  String get uiArchiveNext => 'Sonraki dosya';

  @override
  String get uiArchivePreviewArea => 'Önizleme alanı';

  @override
  String get uiArchiveFactTask => 'Görev';

  @override
  String get uiArchiveFactTag => 'Etiket';

  @override
  String get uiArchiveFactBy => 'Yükleyen';

  @override
  String get uiArchiveUploaderUnknown => 'Bilinmeyen kişi';

  @override
  String get uiArchiveDownload => 'İndir';

  @override
  String get uiArchiveDownloading => 'indiriliyor';

  @override
  String get uiArchiveRetag => 'Etiketi değiştir';

  @override
  String get uiArchiveMove => 'Başka klasöre taşı';

  @override
  String get uiArchiveDelete => 'Dosyayı sil';

  @override
  String get uiArchiveRetagSoon => 'Etiket seçimi sonraki adımda tasarlanacak';

  @override
  String get uiArchiveMoveSoon => 'Klasör seçimi sonraki adımda tasarlanacak';

  @override
  String get uiArchiveDeleted => 'Dosya silindi';

  @override
  String get uiArchiveKindImage => 'Resim';

  @override
  String get uiArchiveKindDocument => 'Belge';

  @override
  String get uiArchiveKindPdf => 'PDF';

  @override
  String get uiArchiveKindImageShort => 'IMG';

  @override
  String get uiArchiveKindDocumentShort => 'DOC';

  @override
  String get uiArchiveKindPdfShort => 'PDF';

  @override
  String get uiArchiveFoldersTitle => 'klasörler';

  @override
  String get uiArchiveTagIster => 'İster';

  @override
  String get uiArchiveTagPlan => 'Plan';

  @override
  String get uiArchiveTagGirdi => 'Girdi';

  @override
  String get uiArchiveTagAnaliz => 'Analiz';

  @override
  String get uiArchiveTagCikti => 'Çıktı';

  @override
  String get uiArchiveTagSonuc => 'Sonuç';

  @override
  String get uiArchiveTagUnknown => 'Diğer';

  @override
  String get uiArchiveSaved => 'Kaydedildi';

  @override
  String get uiArchiveDeleteConfirm => 'Dosya kalıcı olarak silinsin mi?';

  @override
  String get uiArchiveDeleteOk => 'Sil';

  @override
  String get uiArchiveZipSelection => 'Görünen dosyaları ZIP olarak indir';

  @override
  String get uiArchiveZipEmpty => 'İndirilecek dosya yok';

  @override
  String get uiArchiveLoadMore => 'Daha fazla yükle';

  @override
  String get uiArchiveUploaderFilter => 'Yükleyen';

  @override
  String get uiArchiveUploaderAll => 'Tüm yükleyenler';

  @override
  String get uiArchivePickTask => 'Görev seç';

  @override
  String get uiArchivePickTag => 'Etiket seç';

  @override
  String get uiArchiveUploadNoTask => 'Bu klasörde dosya yüklenecek görev yok';

  @override
  String get uiArchiveUploaded => 'Dosya yüklendi';

  @override
  String get uiArchivePickerMissing => 'Bu sürümde dosya seçici yok';

  @override
  String get uiArchiveFolderMissing => 'Klasör bulunamadı';

  @override
  String get uiButtonsBusy => 'Meşgul';

  @override
  String get uiCalendarTitle => 'Takvim';

  @override
  String get uiCalendarToday => 'Bugün';

  @override
  String get uiCalendarGrid => 'Takvim ızgarası';

  @override
  String get uiCalendarCollapse => 'Haftaya daralt';

  @override
  String get uiCalendarExpand => 'Aya genişlet';

  @override
  String get uiCalendarPrevMonth => 'Önceki ay';

  @override
  String get uiCalendarNextMonth => 'Sonraki ay';

  @override
  String get uiCalendarPrevWeek => 'Önceki hafta';

  @override
  String get uiCalendarNextWeek => 'Sonraki hafta';

  @override
  String get uiCalendarWeekLc => 'hafta';

  @override
  String get uiCalendarWeekdaysShort => 'Pt Sa Ça Pe Cu Ct Pz';

  @override
  String get uiCalendarRelToday => 'bugün';

  @override
  String get uiCalendarRelTomorrow => 'yarın';

  @override
  String get uiCalendarRelYesterday => 'dün';

  @override
  String get uiCalendarRelAfter => 'gün sonra';

  @override
  String get uiCalendarRelBefore => 'gün önce';

  @override
  String get uiCalendarRecordsLc => 'kayıt';

  @override
  String get uiCalendarGroupMeetings => 'toplantılar';

  @override
  String get uiCalendarGroupTasks => 'görevler';

  @override
  String get uiCalendarGroupRequests => 'tarih talepleri';

  @override
  String get uiCalendarTaskEnds => 'Bitiyor';

  @override
  String get uiCalendarTaskStarts => 'Başlıyor';

  @override
  String get uiCalendarTaskOngoing => 'Sürüyor';

  @override
  String get uiCalendarLeadEnd => 'biter';

  @override
  String get uiCalendarLeadStart => 'başlar';

  @override
  String get uiCalendarLeadOngoing => 'sürer';

  @override
  String get uiCalendarLeadRequest => 'talep';

  @override
  String get uiCalendarTaskFilter => 'Gösterilen görevler';

  @override
  String get uiCalendarFilterEnds => 'Bitecek';

  @override
  String get uiCalendarFilterStarts => 'Başlayacak';

  @override
  String get uiCalendarSubEnds => 'bu gün bitecek';

  @override
  String get uiCalendarSubStarts => 'bu gün başlayacak';

  @override
  String get uiCalendarLateLc => 'gecikti';

  @override
  String get uiCalendarRequestedRange => 'İstenen aralık';

  @override
  String get uiCalendarStatePending => 'Onay bekliyor';

  @override
  String get uiCalendarEmpty => 'Bu gün için planlanmış bir şey yok.';

  @override
  String get uiCalendarPlan => 'Toplantı planla';

  @override
  String get uiCalendarThisWeek => 'Bu hafta';

  @override
  String get uiCalendarLastWeek => 'Geçen hafta';

  @override
  String get uiCalendarNextWeekCard => 'Gelecek hafta';

  @override
  String get uiCalendarDoneLc => 'tamamlandı';

  @override
  String get uiCalendarMeetingLc => 'toplantı';

  @override
  String get uiCalendarPeriods => 'Dönem özeti';

  @override
  String get uiCalendarThisWeekEmpty => 'Bu hafta için kayıt yok.';

  @override
  String get uiCalendarStatOngoing => 'Devam';

  @override
  String get uiCalendarStatMeetings => 'Toplantı';

  @override
  String get uiCalendarWeekEnds => 'bitecekler';

  @override
  String get uiCalendarWeekStarts => 'başlayacaklar';

  @override
  String get uiCalendarWeekOngoing => 'devam edenler';

  @override
  String get uiCalendarAdd => 'Seçili güne ekle';

  @override
  String get uiCalendarAddMeetingCaption => 'saat, gündem ve katılımcılar';

  @override
  String get uiCalendarAddTaskStart => 'Bu gün başlayan görev';

  @override
  String get uiCalendarAddTaskDue => 'Bu güne kadar bitecek görev';

  @override
  String get uiCalendarPickTitle => 'Bir kayıt seç';

  @override
  String get uiCalendarPickBody =>
      'Soldaki listeden bir kayda dokun, ayrıntısı burada açılır.';

  @override
  String get uiCommonRetry => 'Yeniden dene';

  @override
  String get uiCommonCancel => 'İptal';

  @override
  String get uiCommonOk => 'Tamam';

  @override
  String get uiCommonClose => 'Kapat';

  @override
  String get uiCoordTitle => 'Koordinatörlükler';

  @override
  String get uiCoordDetailTitle => 'Koordinatörlük';

  @override
  String get uiCoordCountTail => 'koordinatörlük';

  @override
  String get uiCoordTasksTail => 'görev';

  @override
  String get uiCoordLateCoordsTail => 'koordinatörlükte gecikme';

  @override
  String get uiCoordDoneTail => 'bitti';

  @override
  String get uiCoordLateTail => 'gecikmede';

  @override
  String get uiCoordNoLead => 'Koordinatör yok';

  @override
  String get uiCoordMemberSuffix => '(üye)';

  @override
  String get uiCoordListLabel => 'Koordinatörlük listesi';

  @override
  String get uiCoordSortName => 'Ada göre';

  @override
  String get uiCoordSortLate => 'Gecikme';

  @override
  String get uiCoordSortProgress => 'Tamamlanma';

  @override
  String get uiCoordSortTasks => 'Görev sayısı';

  @override
  String get uiCoordSortMembers => 'Üye sayısı';

  @override
  String get uiCoordShortcuts => 'Koordinatörlük kısayolları';

  @override
  String get uiCoordFlySectionList => 'koordinatörlükler';

  @override
  String get uiCoordFlySectionSort => 'sıralama';

  @override
  String get uiCoordFlyTimelineAll => 'Tümünü zaman çizelgesinde gör';

  @override
  String get uiCoordFlyAdd => 'Koordinatörlük ekle';

  @override
  String get uiCoordFormName => 'Ad';

  @override
  String get uiCoordFormNameEditHelper => 'Yalnız bu programdaki ad değişir';

  @override
  String get uiCoordFormKind => 'Tür';

  @override
  String get uiCoordFormDescription => 'Açıklama';

  @override
  String get uiCoordFormDescriptionHint => 'İsteğe bağlı';

  @override
  String get uiCoordFormCreate => 'Oluştur';

  @override
  String get uiCoordFormSave => 'Kaydet';

  @override
  String get uiCoordFormLinkRetry => 'Programa bağlamayı tekrar dene';

  @override
  String get uiCoordFormLinkFailed =>
      'Koordinatörlük oluşturuldu ama seçili programa bağlanamadı. Tekrar denediğinde yeni koordinatörlük açılmaz, aynı kayıt bağlanır.';

  @override
  String get uiCoordFormExisting =>
      'Bu adla bir departman zaten var. Mevcut kayıt kullanılacak; türü ve açıklaması değiştirilmez. Bağlamak istiyor musunuz?';

  @override
  String get uiCoordFormExistingDeleted =>
      'Bu adla silinmiş bir departman var. Mevcut kayıt geri yüklenip bağlanacak; türü ve açıklaması değiştirilmez. Devam etmek istiyor musunuz?';

  @override
  String get uiCoordFormExistingConfirm => 'Mevcut kaydı kullan';

  @override
  String get uiCoordFormOutcomeUnknown =>
      'Önceki işlemin sonucu bilinmiyor. Aynı bilgilerle yeniden deneyerek işlemi tamamlayın.';

  @override
  String get uiCoordToastCreated => 'Koordinatörlük eklendi';

  @override
  String get uiCoordToastSaved => 'Bilgiler kaydedildi';

  @override
  String get uiCoordFlyAllList => 'Tüm liste';

  @override
  String get uiCoordPeopleTail => 'kişi';

  @override
  String get uiCoordMessageTeam => 'Ekibe mesaj';

  @override
  String get uiCoordAssignTask => 'Görev ata';

  @override
  String get uiCoordMessage => 'Mesaj';

  @override
  String get uiCoordDeptKindCoordinatorship => 'Koordinatörlük';

  @override
  String get uiCoordDeptKindWorkingGroup => 'Çalışma grubu';

  @override
  String get uiCoordTabsLabel => 'Koordinatörlük bölümleri';

  @override
  String get uiCoordTabGeneral => 'Genel';

  @override
  String get uiCoordTabUnits => 'Birimler';

  @override
  String get uiCoordTabTeam => 'Ekip';

  @override
  String get uiCoordTabAbout => 'Hakkında';

  @override
  String get uiCoordSummary => 'Özet';

  @override
  String get uiCoordKpiOpen => 'açık görev';

  @override
  String get uiCoordKpiLate => 'geciken';

  @override
  String get uiCoordKpiDone => 'tamamlanma';

  @override
  String get uiCoordAttention => 'dikkat gerektirenler';

  @override
  String get uiCoordAllTasks => 'Tüm görevler';

  @override
  String get uiCoordDaysLateTail => 'gün gecikti';

  @override
  String get uiCoordShortcutsLabel => 'Kısayollar';

  @override
  String get uiCoordLinkTimeline => 'Zaman çizelgesinde gör';

  @override
  String get uiCoordLinkArchive => 'Arşiv klasörü';

  @override
  String get uiCoordLinkMeetings => 'Toplantılar';

  @override
  String get uiCoordLinkReport => 'Birim raporu';

  @override
  String get uiCoordFilesTail => 'dosya';

  @override
  String get uiCoordPlannedTail => 'planlı';

  @override
  String get uiCoordNone => 'yok';

  @override
  String get uiCoordReportFormat => 'PDF';

  @override
  String get uiCoordToastMeetingsTail => 'toplantıları açılır';

  @override
  String get uiCoordToastReportTail => 'raporu hazırlanıyor';

  @override
  String get uiCoordUnits => 'alt birimler';

  @override
  String get uiCoordAdd => 'Ekle';

  @override
  String get uiCoordToastAddUnitTail => 'altına alt birim ekleme formu açılır';

  @override
  String get uiCoordToastUnitTail => 'alt birimi açılır';

  @override
  String get uiCoordTeam => 'ekip';

  @override
  String get uiCoordAddMember => 'Üye ekle';

  @override
  String get uiCoordRoleLead => 'koordinatör';

  @override
  String get uiCoordRoleMember => 'üye';

  @override
  String get uiCoordUnassignedHint => 'Görev atanabilmesi için bir sorumlu seç';

  @override
  String get uiCoordRoleAssign => 'ata';

  @override
  String get uiCoordToastPickLeadTail => 'için koordinatör seçimi açılır';

  @override
  String get uiCoordToastPersonTail => 'kişisel takip açılır';

  @override
  String get uiCoordMoreMembersTail => 'üye daha';

  @override
  String get uiCoordCollapse => 'Daralt';

  @override
  String get uiCoordFeed => 'son etkinlik';

  @override
  String get uiCoordMoreActions => 'Diğer işlemler';

  @override
  String get uiCoordMenuTitleTail => 'işlemleri';

  @override
  String get uiCoordMenuEdit => 'Bilgileri düzenle';

  @override
  String get uiCoordMenuMeeting => 'Toplantı planla';

  @override
  String get uiCoordMenuMerge => 'Başka koordinatörlükle birleştir';

  @override
  String get uiCoordToastMerge => 'Birleştirme önizlemesi açılır';

  @override
  String get uiCoordNotFound => 'Bu koordinatörlük bulunamadı.';

  @override
  String get uiCoordAllInArchive => 'Arşivde tümünü gör';

  @override
  String get uiCoordClear => 'Temizle';

  @override
  String get uiCoordDaysLaterTail => 'gün sonra';

  @override
  String get uiCoordDepartmentsTail => 'birim';

  @override
  String get uiCoordEveryone => 'Herkes';

  @override
  String get uiCoordFilter => 'Görevleri süz';

  @override
  String get uiCoordFilterPerson => 'atanan kişi';

  @override
  String get uiCoordFilterStatus => 'durum';

  @override
  String get uiCoordGroupLeads => 'koordinatörler';

  @override
  String get uiCoordGroupMembers => 'üyeler';

  @override
  String get uiCoordInvited => 'Davetli';

  @override
  String get uiCoordKindDoc => 'Belge';

  @override
  String get uiCoordKindImage => 'Görsel';

  @override
  String get uiCoordKindPdf => 'PDF';

  @override
  String get uiCoordLater => 'sonra';

  @override
  String get uiCoordLeadRole => 'Koordinatör';

  @override
  String get uiCoordLeadsTail => 'koordinatör';

  @override
  String get uiCoordMemberRole => 'Üye';

  @override
  String get uiCoordMembersTail => 'üye';

  @override
  String get uiCoordNext => 'Sıradaki';

  @override
  String get uiCoordNoFiles => 'Bu birimin arşivinde dosya yok.';

  @override
  String get uiCoordNoMeetings =>
      'Bu birimin toplantısı yok. Sağ üstten planlayabilirsin.';

  @override
  String get uiCoordNoMeetingsPlanned => 'planlı toplantı yok';

  @override
  String get uiCoordNoMembers => 'Bu birimde henüz kimse yok.';

  @override
  String get uiCoordNoOpen => 'açık görevi yok';

  @override
  String get uiCoordNoTasks => 'Bu süzgeçte görev yok.';

  @override
  String get uiCoordOpenInTasks => 'Görevler sayfasında aç';

  @override
  String get uiCoordOpenTail => 'açık';

  @override
  String get uiCoordOpenTasksTail => 'açık görev';

  @override
  String get uiCoordOvTeam => 'Ekip';

  @override
  String get uiCoordOwner => 'Sahip';

  @override
  String get uiCoordPastMeetings => 'Geçmiş toplantılar';

  @override
  String get uiCoordPastTail => 'geçmiş';

  @override
  String get uiCoordPersonLateTail => 'görevi gecikmede';

  @override
  String get uiCoordPersonMessage => 'Mesaj gönder';

  @override
  String get uiCoordPersonTasks => 'Görevlerini gör';

  @override
  String get uiCoordRecentFiles => 'son yüklenenler';

  @override
  String get uiCoordStAll => 'Tümü';

  @override
  String get uiCoordStDone => 'Tamamlandı';

  @override
  String get uiCoordStLate => 'Gecikmede';

  @override
  String get uiCoordStOpen => 'Açık';

  @override
  String get uiCoordStRequest => 'Tarih talebi';

  @override
  String get uiCoordStReview => 'Onay bekleyen';

  @override
  String get uiCoordStTodo => 'Başlamadı';

  @override
  String get uiCoordTabArchive => 'Arşiv';

  @override
  String get uiCoordTabMeetings => 'Toplantı';

  @override
  String get uiCoordTabMembers => 'Üyeler';

  @override
  String get uiCoordTabTasks => 'Görevler';

  @override
  String get uiCoordToastUpload => 'Dosya yükleme görev ayrıntısından yapılır';

  @override
  String get uiCoordToday => 'bugün';

  @override
  String get uiCoordTomorrow => 'yarın';

  @override
  String get uiCoordUpcomingTail => 'yaklaşan';

  @override
  String get uiCoordUpload => 'Dosya yükle';

  @override
  String get uiCoordFlow => 'Akış';

  @override
  String get uiCoordFlowSub => 'teslimler ve toplantılar';

  @override
  String get uiCoordTodayPill => 'Bugün';

  @override
  String get uiCoordDaysAgoTail => 'gün geçti';

  @override
  String get uiCoordDaysTail => 'gün';

  @override
  String get uiCoordMeetingTag => 'toplantı';

  @override
  String get uiCoordDeadlineTag => 'teslim';

  @override
  String get uiCoordNobody => 'atanmamış';

  @override
  String get uiCoordLoad => 'İş yükü';

  @override
  String get uiCoordLoadDone => 'biten';

  @override
  String get uiCoordLateTasksTail => 'görev gecikmede';

  @override
  String get uiCoordOnTime => 'zamanında';

  @override
  String get uiCoordFinishedTail => 'görev bitirdi';

  @override
  String get uiCoordNoLoad => 'Bu birimde atanmış görev yok.';

  @override
  String get uiCoordAllTeam => 'Tüm ekip';

  @override
  String get uiCoordAddMemberDesc =>
      'Mevcut bir kişiyi seç veya yeni kişi oluştur. Diğer koordinatörlüklerdeki üyelikleri korunur.';

  @override
  String get uiCoordCreatePerson => 'Yeni kişi oluştur';

  @override
  String get uiCoordSearchPerson => 'Kişi veya koordinatörlük ara';

  @override
  String get uiCoordNoCandidates => 'Eklenebilecek kişi bulunamadı.';

  @override
  String get uiCoordMemberAdded => 'Üye eklendi';

  @override
  String get uiFeedbackLoading => 'Yükleniyor';

  @override
  String get uiFeedbackOffline => 'Çevrimdışısınız. Sunucuya ulaşılamıyor.';

  @override
  String get uiFeedbackErrorTitle => 'Bir sorun oluştu';

  @override
  String get uiFeedbackRetryWait => 'Yeniden denemek için bekleyin';

  @override
  String get uiFeedbackSecondsUnit => 'sn';

  @override
  String get uiHomeOverviewTitle => 'Genel durum';

  @override
  String get uiHomeDeletedShortcut => 'Silinenler';

  @override
  String get uiHomePendingHeading => 'Bekleyen işler';

  @override
  String get uiHomePendingErrorRetry =>
      'Bekleyen işler yüklenemedi · Yeniden dene';

  @override
  String get uiHomePendingEmpty => 'Bekleyen iş yok';

  @override
  String get uiHomeUnreadLoading => 'Mesaj sayısı yükleniyor';

  @override
  String get uiHomeUnreadErrorRetry =>
      'Mesaj sayısı yüklenemedi · Yeniden dene';

  @override
  String get uiHomeUnreadChats => 'Okunmamış sohbet';

  @override
  String get uiHomeGreeting => 'Merhaba';

  @override
  String get uiHomeSummaryLabel => 'Özet';

  @override
  String get uiHomeKpiDone => 'Tamamlanma';

  @override
  String get uiHomeKpiDoing => 'Devam eden';

  @override
  String get uiHomeKpiLate => 'Gecikmede';

  @override
  String get uiHomeKpiReview => 'Onay bekleyen';

  @override
  String get uiHomeKpiDoneOf => 'görevin';

  @override
  String get uiHomeKpiDoneTail => 'bitti';

  @override
  String get uiHomeKpiDoingTail => 'tanesi zamanında';

  @override
  String get uiHomeKpiLateLead => 'Açık görevlerin';

  @override
  String get uiHomeKpiReviewCaption => 'Kanıt yüklendi, onayda';

  @override
  String get uiHomeOpenList => 'listeyi aç';

  @override
  String get uiHomeQuickActions => 'hızlı işlemler';

  @override
  String get uiHomeQaTask => 'Yeni görev';

  @override
  String get uiHomeQaMeeting => 'Toplantı';

  @override
  String get uiHomeQaInvite => 'Kişi ekle';

  @override
  String get uiHomeQaReport => 'Rapor';

  @override
  String get uiHomeQaTaskLong => 'Yeni görev';

  @override
  String get uiHomeQaMeetingLong => 'Toplantı oluştur';

  @override
  String get uiHomeQaInviteLong => 'Kullanıcı ekle';

  @override
  String get uiHomeQaReportLong => 'Rapor oluştur';

  @override
  String get uiHomeFormSoon =>
      'Bu form mobilde sonraki adımda eklenecek; şimdilik web portalını kullanabilirsin.';

  @override
  String get uiHomeTeam => 'ekip';

  @override
  String get uiHomeUsers => 'kullanıcı';

  @override
  String get uiHomeCoordinatorshipsLc => 'koordinatörlük';

  @override
  String get uiHomeTeamTotal => 'Toplam üye';

  @override
  String get uiHomeRoleAdmin => 'Admin';

  @override
  String get uiHomeRoleCoordinator => 'Koordinatör';

  @override
  String get uiHomeRoleMember => 'Üye';

  @override
  String get uiHomeRoleAdminLc => 'admin';

  @override
  String get uiHomeRoleCoordinatorLc => 'koordinatör';

  @override
  String get uiHomeRoleMemberLc => 'üye';

  @override
  String get uiHomeHistoryTitle => 'İşlem geçmişi';

  @override
  String get uiHomeHistoryLast => 'Son işlem';

  @override
  String get uiHomeHistoryToday => 'bugün';

  @override
  String get uiHomeHistoryOpen => 'İşlem geçmişini aç';

  @override
  String get uiHomeCoordinatorships => 'Koordinatörlükler';

  @override
  String get uiHomeSortLate => 'Gecikme';

  @override
  String get uiHomeSortProgress => 'İlerleme';

  @override
  String get uiHomeSortName => 'Ada göre';

  @override
  String get uiHomeSortChange => 'Sıralama ölçütünü değiştir';

  @override
  String get uiHomeSortFlip => 'Sırayı ters çevir';

  @override
  String get uiHomeSortDescending => 'büyükten küçüğe';

  @override
  String get uiHomeSortAscending => 'küçükten büyüğe';

  @override
  String get uiHomeCoordinatorshipsEmpty => 'Bu programda koordinatörlük yok.';

  @override
  String get uiHomeUnassigned => 'Koordinatör atanmamış';

  @override
  String get uiHomeTasksLc => 'görev';

  @override
  String get uiHomeLateLc => 'geciken';

  @override
  String get uiHomeNoLate => 'gecikme yok';

  @override
  String get uiHomeShowAll => 'Tümünü göster';

  @override
  String get uiHomeCollapse => 'Daralt';

  @override
  String get uiHomeWaitingTail => 'iş seni bekliyor';

  @override
  String get uiHomeMenu => 'Menü';

  @override
  String get uiHomeShortcuts => 'Ana sayfa kısayolları';

  @override
  String get uiHomeWaitingForYou => 'seni bekleyenler';

  @override
  String get uiHomeDateRequest => 'Tarih talebi';

  @override
  String get uiHomeAwaitingApproval => 'Onay bekliyor';

  @override
  String get uiHomeGo => 'git';

  @override
  String get uiHomeGroupTracking => 'takip';

  @override
  String get uiHomeGroupContent => 'içerik';

  @override
  String get uiHomeGroupAdmin => 'yönetim';

  @override
  String get uiHomeGroupLab => 'deneysel';

  @override
  String get uiHomeModuleHome => 'Ana sayfa';

  @override
  String get uiHomeModuleTasks => 'Görevler';

  @override
  String get uiHomeModuleCalendar => 'Takvim';

  @override
  String get uiHomeModuleMemory => 'Kurumsal hafıza';

  @override
  String get uiHomeModuleArchive => 'Arşiv';

  @override
  String get uiHomeModuleMeetings => 'Toplantılar';

  @override
  String get uiHomeModuleMessages => 'Mesajlar';

  @override
  String get uiHomeModuleSheets => 'Tablolar';

  @override
  String get uiHomeModuleUsers => 'Kullanıcılar';

  @override
  String get uiHomeModuleSeason => 'Teknofest ve sezon';

  @override
  String get uiHomeModuleSimulation => 'Simülasyon';

  @override
  String get uiHomeBeta => 'beta';

  @override
  String get uiHomeDeletedRecords => 'Silinen kayıtlar';

  @override
  String get uiHomeHelp => 'Yardım ve rehberler';

  @override
  String get uiHomeProfile => 'Profil ve hesap';

  @override
  String get uiHomeSoonTail => 'mobilde sonraki adımda eklenecek';

  @override
  String get uiHomeAppName => 'NIZAM.IO';

  @override
  String get uiHomeShiftDaysTail => 'gün';

  @override
  String get uiHomeSeasonTail => 'sezonu';

  @override
  String get uiHomeVersionPrefix => 'v';

  @override
  String get uiHomeAppearance => 'görünüm';

  @override
  String get uiHomeThemeDark => 'Koyu';

  @override
  String get uiHomeThemeLight => 'Açık';

  @override
  String get uiHomeThemeSystem => 'Sistem';

  @override
  String get uiIdentityLoginTitle => 'Giriş yap';

  @override
  String get uiIdentityLoginServer => 'Sunucu';

  @override
  String get uiIdentityLoginEmail => 'E-posta';

  @override
  String get uiIdentityLoginPassword => 'Şifre';

  @override
  String get uiIdentityLoginSubmit => 'Giriş yap';

  @override
  String get uiIdentityPasswordTitle => 'Parola değiştir';

  @override
  String get uiIdentityPasswordIntro =>
      'Devam etmek için parolanızı değiştirmeniz gerekiyor. Parola değişince diğer cihazlardaki oturumlarınız kapanır.';

  @override
  String get uiIdentityPasswordCurrent => 'Mevcut parola';

  @override
  String get uiIdentityPasswordNew => 'Yeni parola';

  @override
  String get uiIdentityPasswordConfirm => 'Yeni parola (tekrar)';

  @override
  String get uiIdentityPasswordSubmit => 'Parolayı değiştir';

  @override
  String get uiIdentityProfileTitle => 'Profil';

  @override
  String get uiIdentityProfileEmail => 'E-posta';

  @override
  String get uiIdentityCrashReportsTitle => 'Hata raporları';

  @override
  String get uiIdentityCrashReportsSwitch => 'Hata raporlarını gönder';

  @override
  String get uiIdentityCrashReportsBody =>
      'Açıkken, uygulama çöktüğünde veya beklenmeyen bir hata oluştuğunda teknik bir özet gönderilir: hata türü, işlem adı, kod izi, uygulama ve cihaz sürümü. Çökme izini cihazdaki Firebase bileşeni de toplar. E-posta, parola, mesaj ve dosya içeriği, sunucu adresi rapora konmaz. Varsayılan kapalıdır; istediğiniz an kapatabilirsiniz.';

  @override
  String get uiIdentityCrashReportsEnableFailed =>
      'Hata raporları açılamadı; kapalı kaldı. Daha sonra tekrar deneyin.';

  @override
  String get uiIdentityCrashReportsRevokeNotPersisted =>
      'Bu oturumda kapatıldı ama tercih kaydedilemedi. Uygulama yeniden açıldığında tekrar açık olabilir; lütfen tekrar kapatmayı deneyin.';

  @override
  String get uiIdentitySignOut => 'Çıkış yap';

  @override
  String get uiIdentitySignOutConfirmTitle => 'Çıkış yapılsın mı?';

  @override
  String get uiIdentitySignOutConfirmMessage =>
      'Bu cihazdaki oturum kapatılır.';

  @override
  String get uiIdentityLoginIntro => 'E-posta adresin ve şifrenle devam et.';

  @override
  String get uiIdentityLoginSubmitting => 'Giriş yapılıyor…';

  @override
  String get uiIdentityLoginEmailHint => 'ad@alan.com';

  @override
  String get uiIdentityLoginPasswordHint => 'Şifren';

  @override
  String get uiIdentityLoginVersionPrefix => 'v';

  @override
  String get uiIdentityLoginFooter => 'Developed by KAYACAN, COSMAN, CALISKAN';

  @override
  String get uiInputsPasswordShow => 'Şifreyi göster';

  @override
  String get uiInputsPasswordHide => 'Şifreyi gizle';

  @override
  String get uiInputsSearch => 'Ara';

  @override
  String get uiInputsSearchClear => 'Aramayı temizle';

  @override
  String get uiInputsSelectPlaceholder => 'Seçin';

  @override
  String get uiInputsInvalidValue => 'Değer geçersiz.';

  @override
  String get uiInputsValidationRequired => 'Bu alan zorunludur.';

  @override
  String get uiInputsValidationEmail => 'Geçerli bir e-posta adresi girin.';

  @override
  String get uiInputsValidationTooShort => 'Değer çok kısa.';

  @override
  String get uiInputsValidationTooLong => 'Değer çok uzun.';

  @override
  String get uiInputsValidationMismatch => 'Değerler eşleşmiyor.';

  @override
  String get uiInputsValidationMustAccept =>
      'Devam etmek için onaylamanız gerekir.';

  @override
  String get uiInputsValidationMustChoose => 'Bir seçim yapın.';

  @override
  String get uiListsTruncated =>
      'Liste kısaltıldı; yalnız ilk kayıtlar gösteriliyor.';

  @override
  String get uiMeetingsTitle => 'Toplantılar';

  @override
  String get uiMeetingsSearch => 'Ara';

  @override
  String get uiMeetingsSearchLabel => 'Toplantılarda ara';

  @override
  String get uiMeetingsSearchHint => 'Başlık ya da koordinatörlük kodu';

  @override
  String get uiMeetingsNew => 'Yeni toplantı';

  @override
  String get uiMeetingsListLabel => 'Toplantı listesi';

  @override
  String get uiMeetingsTabUpcoming => 'Yaklaşan';

  @override
  String get uiMeetingsTabPast => 'Geçmiş';

  @override
  String get uiMeetingsTabDeleted => 'Silinenler';

  @override
  String get uiMeetingsGroupToday => 'Bugün';

  @override
  String get uiMeetingsGroupTomorrow => 'Yarın';

  @override
  String get uiMeetingsGroupThisWeek => 'Bu hafta';

  @override
  String get uiMeetingsGroupNextWeek => 'Gelecek hafta';

  @override
  String get uiMeetingsGroupLater => 'Daha sonra';

  @override
  String get uiMeetingsYesterday => 'Dün';

  @override
  String get uiMeetingsEmptyUpcoming =>
      'Yaklaşan toplantı yok. Yeni bir toplantı açabilirsin.';

  @override
  String get uiMeetingsEmptyPast => 'Geçmiş toplantı yok.';

  @override
  String get uiMeetingsEmptyDeleted => 'Silinmiş toplantı yok.';

  @override
  String get uiMeetingsEmptyFilter => 'Bu filtreyle eşleşen toplantı yok.';

  @override
  String get uiMeetingsPastNote =>
      'Geçmiş tarihe toplantı açılamaz; tarih yalnız ileri alınabilir.';

  @override
  String get uiMeetingsTruncated =>
      'Liste sınırına ulaşıldı; daha eski toplantılar gösterilmiyor.';

  @override
  String get uiMeetingsOwnerPrefix => 'Sahip:';

  @override
  String get uiMeetingsInvitedTail => 'koordinatörlük davetli';

  @override
  String get uiMeetingsDeletedPrefix => 'Silindi';

  @override
  String get uiMeetingsRestore => 'Geri yükle';

  @override
  String get uiMeetingsPurge => 'Kalıcı olarak sil';

  @override
  String get uiMeetingsPurgeQ => 'Toplantı kalıcı olarak silinsin mi?';

  @override
  String get uiMeetingsPurgeDesc =>
      'Notlar, gündem ve koordinatörlük bağları da silinir. Bu işlem geri alınamaz.';

  @override
  String get uiMeetingsTRestored =>
      'Toplantı geri yüklendi · konferans kayıtları geri gelmez';

  @override
  String get uiMeetingsTPurged => 'Toplantı kalıcı olarak silindi';

  @override
  String get uiMeetingsMore => 'Diğer işlemler';

  @override
  String get uiMeetingsNotFound => 'Toplantı bulunamadı.';

  @override
  String get uiMeetingsVisMembers => 'Üyeler dahil';

  @override
  String get uiMeetingsVisLeads => 'Yalnız koordinatörler';

  @override
  String get uiMeetingsConfLabel => 'Konferans';

  @override
  String get uiMeetingsConfLive => 'Canlı';

  @override
  String get uiMeetingsConfSince => 'Başladı';

  @override
  String get uiMeetingsConfStarting => 'Başlatılıyor';

  @override
  String get uiMeetingsConfStartingSub =>
      'Oda açılıyor; birazdan katılabilirsin.';

  @override
  String get uiMeetingsConfEnding => 'Kapanıyor';

  @override
  String get uiMeetingsConfEndingSub => 'Konferans bitirildi, oda kapanıyor.';

  @override
  String get uiMeetingsConfNone => 'Henüz başlamadı';

  @override
  String get uiMeetingsConfNoneSub =>
      'Konferans toplantı saatinde başlatılabilir · en çok 25 kişi.';

  @override
  String get uiMeetingsConfLateSub =>
      'Toplantı saati geçti, konferans başlatılmadı.';

  @override
  String get uiMeetingsConfOff => 'Görüntülü konferans bu sunucuda kapalı.';

  @override
  String get uiMeetingsConfStart => 'Toplantıyı başlat';

  @override
  String get uiMeetingsConfEnd => 'Konferansı bitir';

  @override
  String get uiMeetingsConfJoin => 'Katıl';

  @override
  String get uiMeetingsConfJoinSoon => 'Görüntülü görüşme ekranı yakında';

  @override
  String get uiMeetingsTConfStarted => 'Konferans başlatıldı';

  @override
  String get uiMeetingsTConfEnded => 'Konferans herkes için bitirildi';

  @override
  String get uiMeetingsTabsLabel => 'Toplantı ayrıntısı';

  @override
  String get uiMeetingsTabAgenda => 'Gündem';

  @override
  String get uiMeetingsTabNotes => 'Notlar';

  @override
  String get uiMeetingsTabPeople => 'Kişiler';

  @override
  String get uiMeetingsTabInfo => 'Bilgi';

  @override
  String get uiMeetingsAgendaTitle => 'Gündem';

  @override
  String get uiMeetingsAgendaAdd => 'Gündem maddesi ekle';

  @override
  String get uiMeetingsAdd => 'Ekle';

  @override
  String get uiMeetingsAgendaOfTail => 'maddeden';

  @override
  String get uiMeetingsAgendaDoneTail => 'tamamlandı';

  @override
  String get uiMeetingsAgendaDeleteTail => 'maddesini sil';

  @override
  String get uiMeetingsAgendaEmpty => 'Gündem maddesi yok.';

  @override
  String get uiMeetingsAgendaLimit => '50 madde sınırına ulaşıldı';

  @override
  String get uiMeetingsTAgendaDeleted => 'Gündem maddesi silindi';

  @override
  String get uiMeetingsNfLabel => 'Not süzgeci';

  @override
  String get uiMeetingsNfAll => 'Tümü';

  @override
  String get uiMeetingsNfConverted => 'Göreve dönüşen';

  @override
  String get uiMeetingsNfMine => 'Benim';

  @override
  String get uiMeetingsNoteLabel => 'Not ekle';

  @override
  String get uiMeetingsNoteHint => 'Toplantıda konuşulanı not al…';

  @override
  String get uiMeetingsNoteFooter => 'Katılan herkes not ekleyebilir';

  @override
  String get uiMeetingsNoteEdit => 'Notu düzenle';

  @override
  String get uiMeetingsNoteDelete => 'Notu sil';

  @override
  String get uiMeetingsCancel => 'Vazgeç';

  @override
  String get uiMeetingsSave => 'Kaydet';

  @override
  String get uiMeetingsEdited => 'düzenlendi';

  @override
  String get uiMeetingsToTask => 'Göreve dönüştür';

  @override
  String get uiMeetingsConverted => 'Göreve dönüştü';

  @override
  String get uiMeetingsNotesEmpty =>
      'Henüz not yok. Toplantıda konuşulanları buraya yaz.';

  @override
  String get uiMeetingsNotesEmptyFilter => 'Bu filtrede not yok.';

  @override
  String get uiMeetingsTNoteDeleted => 'Not silindi';

  @override
  String get uiMeetingsRoleAdmin => 'Admin';

  @override
  String get uiMeetingsRoleCoordinator => 'Koordinatör';

  @override
  String get uiMeetingsRoleMember => 'Üye';

  @override
  String get uiMeetingsUnknownPerson => 'Bilinmeyen kişi';

  @override
  String get uiMeetingsPeopleTail => 'katılımcı';

  @override
  String get uiMeetingsRemovePerson => 'Toplantıdan çıkar';

  @override
  String get uiMeetingsTRemovedTail => 'toplantıdan çıkarıldı';

  @override
  String get uiMeetingsMembersTail => 'üye';

  @override
  String get uiMeetingsOtherGroup => 'Diğer';

  @override
  String get uiMeetingsPeopleEmpty => 'Henüz katılımcı eklenmedi.';

  @override
  String get uiMeetingsAddPeopleTitle => 'Katılımcı ekle';

  @override
  String get uiMeetingsAddPeopleDesc =>
      'Toplantıya bağlı koordinatörlüklerin ekibinden seç.';

  @override
  String get uiMeetingsNoCandidates => 'Eklenecek kişi kalmadı.';

  @override
  String get uiMeetingsTAddedTail => 'kişi eklendi';

  @override
  String get uiMeetingsTFailedTail => 'kişi eklenemedi';

  @override
  String get uiMeetingsInfoOwner => 'Sahip';

  @override
  String get uiMeetingsInfoCreator => 'Açan';

  @override
  String get uiMeetingsInfoInvite => 'Davet türü';

  @override
  String get uiMeetingsInfoCreated => 'Oluşturulma';

  @override
  String get uiMeetingsInfoVisibility => 'Kimler görür';

  @override
  String get uiMeetingsInfoConference => 'Konferans';

  @override
  String get uiMeetingsInfoRole => 'Senin rolün';

  @override
  String get uiMeetingsInviteCoord => 'Koordinatörlük';

  @override
  String get uiMeetingsUnitTail => 'birim';

  @override
  String get uiMeetingsVisAllLong => 'Davetli birimlerin tüm üyeleri';

  @override
  String get uiMeetingsVisLeadsLong => 'Yalnız koordinatörler ve katılımcılar';

  @override
  String get uiMeetingsConfInfo => 'Görüntülü · en çok 25 kişi';

  @override
  String get uiMeetingsConfInfoOff => 'Kapalı';

  @override
  String get uiMeetingsCoordsKicker => 'koordinatörlükler';

  @override
  String get uiMeetingsOwnerBadge => 'Sahip';

  @override
  String get uiMeetingsCoordNote =>
      'İlk koordinatörlük sahiptir. Kümeyi yalnız admin değiştirebilir.';

  @override
  String get uiMeetingsMenuEdit => 'Toplantıyı düzenle';

  @override
  String get uiMeetingsMenuDelete => 'Toplantıyı sil';

  @override
  String get uiMeetingsDeleteQ => 'Toplantı silinsin mi?';

  @override
  String get uiMeetingsDeleteDesc =>
      'Toplantı listeden kalkar ve artık değiştirilemez. Admin geri yükleyebilir; konferans kayıtları geri gelmez.';

  @override
  String get uiMeetingsDeleteLive =>
      'Konferans canlı: bağlı herkesin bağlantısı kesilir.';

  @override
  String get uiMeetingsTDeleted => 'Toplantı silindi';

  @override
  String get uiMeetingsNavUpcomingTail => 'yaklaşan';

  @override
  String get uiMeetingsStLive => 'CANLI';

  @override
  String get uiMeetingsStWaiting => 'BEKLİYOR';

  @override
  String get uiMeetingsStNotHeld => 'YAPILMADI';

  @override
  String get uiMeetingsStDone => 'BİTTİ';

  @override
  String get uiMeetingsStatusWaiting => 'Bekliyor';

  @override
  String get uiMeetingsStatusNotHeld => 'Yapılmadı';

  @override
  String get uiMeetingsStatusDone => 'Bitti';

  @override
  String get uiMeetingsMinTail => 'dk';

  @override
  String get uiMeetingsNoteTail => 'not';

  @override
  String get uiMeetingsNoNotes => 'not yok';

  @override
  String get uiMeetingsPersonTail => 'kişi';

  @override
  String get uiMeetingsAgendaStat => 'gündem';

  @override
  String get uiMeetingsConnectedTail => 'kişi bağlı';

  @override
  String get uiMeetingsSinceTail => 'beri';

  @override
  String get uiMeetingsDeletedBy => 'Sildi:';

  @override
  String get uiMeetingsConfRestart => 'Yeni konferans başlat';

  @override
  String get uiMeetingsAgendaCheckBlocked =>
      'Gündemi yönetici ve toplantıya bağlı koordinatörler işaretler.';

  @override
  String get uiMeetingsInvitePerson => 'Kişi';

  @override
  String get uiMeetingsVisPeople => 'Davetli kişiler';

  @override
  String get uiMeetingsVisPeopleLong => 'Yalnız davetli kişiler';

  @override
  String get uiMeetingsInfoPlace => 'Yer';

  @override
  String get uiMeetingsPlacePrefix => 'Yer:';

  @override
  String get uiMeetingsDeleteLivePrefix => 'Konferans canlı:';

  @override
  String get uiMeetingsDeleteLiveTail => 'kişinin bağlantısı kesilir.';

  @override
  String get uiMeetingsAddPeopleDescPerson =>
      'Programdaki koordinatörlüklerin ekiplerinden seç.';

  @override
  String get uiMeetingsPoolPartial =>
      'Liste eksik olabilir: yalnız erişebildiğin ekipler gösteriliyor.';

  @override
  String get uiMeetingsUndo => 'Geri al';

  @override
  String get uiMeetingsSeenAgoTail => 'dk önce';

  @override
  String get uiMeetingsConnectedWasTail => 'kişi bağlıydı';

  @override
  String get uiMessagesTitle => 'Mesajlar';

  @override
  String get uiMessagesChatTitle => 'Sohbet';

  @override
  String get uiMessagesSearch => 'Sohbetlerde ara';

  @override
  String get uiMessagesSearchHint => 'Kişi, grup veya mesaj';

  @override
  String get uiMessagesNewMessage => 'Yeni mesaj';

  @override
  String get uiMessagesFilters => 'Sohbet süzgeci';

  @override
  String get uiMessagesFilterAll => 'Tümü';

  @override
  String get uiMessagesFilterUnread => 'Okunmamış';

  @override
  String get uiMessagesFilterGroups => 'Gruplar';

  @override
  String get uiMessagesFilterPeople => 'Kişiler';

  @override
  String get uiMessagesYou => 'Sen';

  @override
  String get uiMessagesEmpty => 'Eşleşen sohbet yok.';

  @override
  String get uiMessagesUnreadLc => 'okunmamış';

  @override
  String get uiMessagesShortcuts => 'Mesaj kısayolları';

  @override
  String get uiMessagesSectionMessages => 'mesajlar';

  @override
  String get uiMessagesUnreadOnly => 'Okunmamışlar';

  @override
  String get uiMessagesMarkAllRead => 'Tümünü okundu say';

  @override
  String get uiMessagesToday => 'Bugün';

  @override
  String get uiMessagesYesterday => 'Dün';

  @override
  String get uiMessagesTyping => 'yazıyor…';

  @override
  String get uiMessagesOnline => 'çevrimiçi';

  @override
  String get uiMessagesLastSeen => 'son görülme';

  @override
  String get uiMessagesSearchChat => 'Sohbette ara';

  @override
  String get uiMessagesPinned => 'Sabitlenen mesaj';

  @override
  String get uiMessagesNewMessages => 'okunmamış mesajlar';

  @override
  String get uiMessagesEdited => 'düzenlendi';

  @override
  String get uiMessagesToBottom => 'En alta in';

  @override
  String get uiMessagesMessageHint => 'Mesaj';

  @override
  String get uiMessagesSend => 'Gönder';

  @override
  String get uiMessagesAttach => 'Fotoğraf, dosya veya anket ekle';

  @override
  String get uiMessagesReference => 'Görev, koordinatörlük veya arşiv ekle';

  @override
  String get uiMessagesCancel => 'Vazgeç';

  @override
  String get uiMessagesEditMessage => 'Mesajı düzenle';

  @override
  String get uiMessagesReplySelf => 'Kendine yanıt';

  @override
  String get uiMessagesReplyTo => 'kişisine yanıt';

  @override
  String get uiMessagesVotedTail => 'kişi oy verdi';

  @override
  String get uiMessagesReactLike => 'Beğen';

  @override
  String get uiMessagesReactHeart => 'Kalp';

  @override
  String get uiMessagesReactCheck => 'Onay';

  @override
  String get uiMessagesReactStar => 'Yıldız';

  @override
  String get uiMessagesMessageActions => 'Mesaj işlemleri';

  @override
  String get uiMessagesMessage => 'Mesaj';

  @override
  String get uiMessagesQuoteJump => 'Alıntılanan mesaja git';

  @override
  String get uiMessagesReply => 'Yanıtla';

  @override
  String get uiMessagesCopy => 'Kopyala';

  @override
  String get uiMessagesPin => 'Sabitle';

  @override
  String get uiMessagesUnpin => 'Sabiti kaldır';

  @override
  String get uiMessagesEdit => 'Düzenle';

  @override
  String get uiMessagesCopied => 'Mesaj kopyalandı';

  @override
  String get uiMessagesPollResults => 'Anket sonuçları';

  @override
  String get uiMessagesToTask => 'Göreve dönüştür';

  @override
  String get uiMessagesDelete => 'Sil';

  @override
  String get uiMessagesDeleted => 'Mesaj silindi';

  @override
  String get uiMessagesConcluded => 'sonuçlandı';

  @override
  String get uiMessagesGroupInfo => 'grup bilgisi';

  @override
  String get uiMessagesPersonInfo => 'kişi bilgisi';

  @override
  String get uiMessagesInfo => 'bilgisi';

  @override
  String get uiMessagesLeaveGroup => 'Gruptan çık';

  @override
  String get uiMessagesAllUsers => 'Tüm kullanıcılar';

  @override
  String get uiMessagesGroup => 'Grup';

  @override
  String get uiMessagesRoleAdmin => 'Admin';

  @override
  String get uiMessagesRoleCoordinator => 'Koordinatör';

  @override
  String get uiMessagesRoleMember => 'Üye';

  @override
  String get uiMessagesNewChatHint => 'Kişi seç';

  @override
  String get uiMessagesNewGroup => 'Yeni grup';

  @override
  String get uiMessagesGroupName => 'Grup adı';

  @override
  String get uiMessagesCreateGroup => 'Grubu kur';

  @override
  String get uiMessagesCandidatesTruncated => 'Liste ilk 200 kişiyle sınırlı.';

  @override
  String get uiMessagesWhyCannotWrite =>
      'Listede olmayan kişiyle doğrudan yazışamazsınız: birebir sohbet yalnız koordinatörlük zinciri içinde açılır. Ortak bir grupta yazışabilirsiniz.';

  @override
  String get uiMessagesNoCandidates => 'Listede kimse yok.';

  @override
  String get uiMessagesPeerLeft =>
      'Bu kişi artık programda değil; mesaj gönderilemez.';

  @override
  String get uiMessagesChatGone => 'Bu sohbete artık erişimin yok.';

  @override
  String get uiMessagesSendFailed => 'gönderilemedi';

  @override
  String get uiMessagesRetrySend => 'Tekrar gönder';

  @override
  String get uiMessagesDiscardMessage => 'Mesajı at';

  @override
  String get uiMessagesMessageRestored =>
      'Mesaj silinmiş; metin taslağa geri kondu.';

  @override
  String get uiMessagesOlderMessages => 'Önceki mesajlar';

  @override
  String get uiMessagesDeletedMessage => 'Silinmiş mesaj';

  @override
  String get uiMessagesNoMessages => 'Henüz mesaj yok';

  @override
  String get uiMessagesListTruncated => 'Yalnız son sohbetler gösteriliyor.';

  @override
  String get uiMessagesSingleChoice => 'Tek seçim';

  @override
  String get uiMessagesMultiChoice => 'Çoklu seçim';

  @override
  String get uiMessagesAttachPhotos => 'Fotoğraflar';

  @override
  String get uiMessagesAttachFile => 'Dosyalar';

  @override
  String get uiMessagesAttachPoll => 'Anket';

  @override
  String get uiMessagesPickerMissing => 'Dosya seçici bu kurulumda yok.';

  @override
  String get uiMessagesFileSaved => 'Dosya kaydedildi';

  @override
  String get uiMessagesPollNew => 'Anket oluştur';

  @override
  String get uiMessagesPollQuestion => 'Soru';

  @override
  String get uiMessagesPollOption => 'Seçenek';

  @override
  String get uiMessagesPollAddOption => 'Seçenek ekle';

  @override
  String get uiMessagesPollClose => 'Anketi bitir';

  @override
  String get uiMessagesPollClosed => 'Anket bitirildi';

  @override
  String get uiMessagesPollNoVotes => 'Henüz oy yok';

  @override
  String get uiMessagesMembers => 'Üyeler';

  @override
  String get uiMessagesAddMembers => 'Üye ekle';

  @override
  String get uiMessagesAdd => 'Ekle';

  @override
  String get uiMessagesRoleGroupAdmin => 'Yönetici';

  @override
  String get uiMessagesRoleFounder => 'Kurucu';

  @override
  String get uiMessagesFromSource => 'Kaynaktan';

  @override
  String get uiMessagesMakeAdmin => 'Yönetici yap';

  @override
  String get uiMessagesRevokeAdmin => 'Yöneticiliği al';

  @override
  String get uiMessagesRemoveMember => 'Gruptan çıkar';

  @override
  String get uiMessagesRename => 'Adı değiştir';

  @override
  String get uiMessagesSave => 'Kaydet';

  @override
  String get uiMessagesDeleteGroup => 'Grubu sil';

  @override
  String get uiMessagesDeleteGroupConfirm =>
      'Grup ve mesajları herkes için silinir. Bu işlem geri alınamaz.';

  @override
  String get uiMessagesLeaveConfirm =>
      'Gruptan ayrılırsan mesajları artık göremezsin.';

  @override
  String get uiMessagesShared => 'Paylaşılanlar';

  @override
  String get uiMessagesSharedEmpty => 'Henüz paylaşılan öğe yok.';

  @override
  String get uiMessagesMore => 'Daha fazla';

  @override
  String get uiMessagesRefGone => 'Artık yok';

  @override
  String get uiMessagesRefTask => 'Görev';

  @override
  String get uiMessagesRefDepartment => 'Koordinatörlük';

  @override
  String get uiMessagesRefFile => 'Dosya';

  @override
  String get uiMessagesTaskAgainTitle => 'Bu mesajdan görev açılmış';

  @override
  String get uiMessagesTaskAgain =>
      'Aynı mesajdan yeni bir görev daha açılacak.';

  @override
  String get uiMessagesContinue => 'Devam et';

  @override
  String get uiMessagesMentionAll => 'herkes';

  @override
  String get uiMessagesMentionSuggestions => 'Bahsetme önerileri';

  @override
  String get uiMessagesSearchInChatHint => 'Mesaj metni';

  @override
  String get uiMessagesSearchEmpty => 'Eşleşen mesaj yok.';

  @override
  String get uiMessagesSearchMore => 'Daha eski sonuçlar';

  @override
  String get uiMessagesNotInWindow => 'Mesaj bulunamadı.';

  @override
  String get uiMessagesComposeShareTask => 'Görev paylaş';

  @override
  String get uiMessagesComposeShareDepartment => 'Koordinatörlük paylaş';

  @override
  String get uiMessagesComposeShareFile => 'Arşiv dosyası paylaş';

  @override
  String get uiMessagesComposeShareDescription =>
      'Seçili programda erişebildiğin bir kaydı mesaja ekle.';

  @override
  String get uiMessagesComposeShareSearch => 'Kayıt ara';

  @override
  String get uiMessagesComposeShareEmpty =>
      'Paylaşılabilecek kayıt bulunamadı.';

  @override
  String get uiMessagesComposePartial =>
      'Liste sınırlandırıldı. Görünen kayıtlar arasından seçim yapabilirsin.';

  @override
  String get uiMessagesComposeMore => 'Daha fazla göster';

  @override
  String get uiMessagesComposeRemove => 'Paylaşımı kaldır';

  @override
  String get uiMessagesComposeRefLimit =>
      'Bir mesajda en fazla 10 kayıt paylaşabilirsin.';

  @override
  String get uiMessagesComposeDeviceFile => 'Cihazdan yeni dosya yükle';

  @override
  String get uiMessagesComposeAttachmentPreview => 'Dosyayı gönder';

  @override
  String get uiMessagesComposeCaption => 'Açıklama (isteğe bağlı)';

  @override
  String get uiMessagesComposeClosesAt => 'Son tarih';

  @override
  String get uiMessagesComposeCloseDate => 'Kapanış günü';

  @override
  String get uiMessagesComposeCloseTime => 'Kapanış saati';

  @override
  String get uiMessagesComposeNoDeadline => 'Elle kapatılana kadar açık';

  @override
  String get uiMessagesComposeLocalTime =>
      'Tarih ve saat cihazının yerel saat dilimindedir.';

  @override
  String get uiMessagesComposeDeadlineInvalid =>
      'Kapanış tarihi ve saati gelecekte olmalı.';

  @override
  String get uiMessagesComposeClearDeadline => 'Son tarihi kaldır';

  @override
  String get uiMessagesComposePinsTruncated =>
      'Sabitlenen mesajların yalnız bir bölümü gösteriliyor.';

  @override
  String get uiMessagesGroupsSource => 'Üyelik kaynağı';

  @override
  String get uiMessagesGroupsManual => 'Elle seçilen kişiler';

  @override
  String get uiMessagesGroupsProgram => 'Programdaki herkes';

  @override
  String get uiMessagesGroupsDepartment => 'Koordinatörlük ekibi';

  @override
  String get uiMessagesGroupsPickDepartment => 'Koordinatörlük seç';

  @override
  String get uiMessagesGroupsSourceHint =>
      'Kaynağın güncel üyeleri gruba kendiliğinden katılır. Elle kişi de ekleyebilirsin.';

  @override
  String get uiMessagesGroupsChangeSource => 'Kaynağı değiştir';

  @override
  String get uiMessagesGroupsCloseSource => 'Kaynağı kapat';

  @override
  String get uiMessagesGroupsCloseConfirm =>
      'Kaynak kapatılınca mevcut üyeler grupta kalır ve elle yönetilir. Yeni ekip üyeleri gruba kendiliğinden katılmaz.';

  @override
  String get uiMessagesGroupsDepartmentUnavailable =>
      'Koordinatörlük bilgisi şu anda kullanılamıyor.';

  @override
  String get uiMessagesGroupsNoDepartments =>
      'Bu programda seçilebilecek koordinatörlük yok.';

  @override
  String get uiMessagesListsSearchEmpty =>
      'Sohbet geçmişinde eşleşme bulunamadı.';

  @override
  String get uiMessagesListsSearchTruncated =>
      'Arama sonuçları sınırlı. Daha belirli bir ifade arayın.';

  @override
  String get uiMessagesListsSharedKind => 'Paylaşılan öğe türü';

  @override
  String get uiMessagesListsMentioned => 'Bahsedildin';

  @override
  String get uiMessagesListsUnreadChats => 'okunmamış sohbet';

  @override
  String get uiNotificationsTitle => 'Bildirimler';

  @override
  String get uiNotificationsUnreadTail => 'okunmamış';

  @override
  String get uiNotificationsUnreadBadge => 'Okunmadı';

  @override
  String get uiNotificationsMarkAll => 'Tümünü okundu yap';

  @override
  String get uiNotificationsMarkedAll => 'Bütün bildirimler okundu';

  @override
  String get uiNotificationsMore => 'Daha fazla göster';

  @override
  String get uiNotificationsEmptyTitle => 'Bildirim yok';

  @override
  String get uiNotificationsEmptyMessage =>
      'Görev, toplantı ve koordinatörlük gelişmeleri burada görünür.';

  @override
  String get uiNotificationsTypeWorkItemCreated => 'Yeni görev oluşturuldu';

  @override
  String get uiNotificationsTypeWorkItemTransitioned =>
      'Görevin durumu değişti';

  @override
  String get uiNotificationsTypeWorkItemAssignmentChanged =>
      'Görevin atamaları değişti';

  @override
  String get uiNotificationsTypeWorkItemDateChanged =>
      'Görevin tarihleri değişti';

  @override
  String get uiNotificationsTypeWorkDateChangeRequested =>
      'Tarih değişikliği talep edildi';

  @override
  String get uiNotificationsTypeWorkDateChangeReviewed =>
      'Tarih talebi yanıtlandı';

  @override
  String get uiNotificationsTypeCollaborationMessageSent => 'Yeni mesaj';

  @override
  String get uiNotificationsTypeCollaborationMeetingCreated => 'Yeni toplantı';

  @override
  String get uiNotificationsTypeCollaborationMeetingUpdated =>
      'Toplantıya ekip üyeleri eklendi';

  @override
  String get uiNotificationsTypeMembershipAssigned =>
      'Koordinatörlüğe üye eklendi';

  @override
  String get uiNotificationsTypeMembershipRemoved =>
      'Koordinatörlükten üye çıkarıldı';

  @override
  String get uiNotificationsTypeMembershipRoleChanged =>
      'Koordinatörlükte rol değişti';

  @override
  String get uiNotificationsTypeProgramTransferCompleted =>
      'Program aktarımı tamamlandı';

  @override
  String get uiNotificationsTypeUnknown => 'Yeni bildirim';

  @override
  String get uiRouterTabHome => 'Ana sayfa';

  @override
  String get uiRouterNavLabel => 'Ana gezinme';

  @override
  String get uiRouterPageServer => 'Sunucu';

  @override
  String get uiRouterPageUpdateRequired => 'Güncelleme gerekli';

  @override
  String get uiRouterPageLogin => 'Giriş';

  @override
  String get uiRouterPagePassword => 'Parola değiştir';

  @override
  String get uiRouterPageScope => 'Kapsam seçimi';

  @override
  String get uiRouterPlaceholder => 'Bu ekran henüz hazır değil.';

  @override
  String get uiRouterNotFoundTitle => 'Sayfa bulunamadı';

  @override
  String get uiRouterNotFoundMessage =>
      'Aradığınız sayfa yok ya da kaldırılmış.';

  @override
  String get uiRouterNotFoundAction => 'Ana sayfaya dön';

  @override
  String get uiRouterTabHomeCaption => 'bugün';

  @override
  String get uiRouterAssistant => 'Asistana sor';

  @override
  String get uiRouterAssistantSoon =>
      'Asistan mobilde sonraki adımda eklenecek';

  @override
  String get uiRouterTabHistory => 'Geçmiş';

  @override
  String get uiRouterTabTasks => 'Görevler';

  @override
  String get uiRouterTabCoordinatorships => 'Koordinatörlükler';

  @override
  String get uiRouterTabArchive => 'Arşiv';

  @override
  String get uiRouterTabMessages => 'Mesajlar';

  @override
  String get uiRouterAssistantSoonTablet =>
      'Asistan tablette sonraki adımda tasarlanacak';

  @override
  String get uiRouterAllModules => 'Tüm modüller';

  @override
  String get uiRouterPickTitle => 'Bir kayıt seç';

  @override
  String get uiRouterPickBody =>
      'Soldaki listeden bir kayıt seç, ayrıntısı burada açılır.';

  @override
  String get uiScopeTitle => 'Program seçimi';

  @override
  String get uiScopeIntro => 'Çalışacağınız programı seçin.';

  @override
  String get uiScopeEmptyTitle => 'Program yok';

  @override
  String get uiScopeEmptyMessage =>
      'Hesabınıza atanmış bir program bulunmuyor. Yöneticinizle görüşün.';

  @override
  String get uiScopeTruncated =>
      'Liste en çok 200 programı gösterir; bazı programlar görünmüyor olabilir.';

  @override
  String get uiScopeHomeChange => 'Kapsamı değiştir';

  @override
  String get uiServerTitle => 'Sunucuya bağlan';

  @override
  String get uiServerIntro => 'Şirketinizin NIZAM.IO sunucu adresini girin.';

  @override
  String get uiServerUrlLabel => 'Sunucu adresi';

  @override
  String get uiServerUrlHint => 'https://nizam.sirketiniz.com';

  @override
  String get uiServerConnect => 'Bağlan';

  @override
  String get uiServerUpdateTitle => 'Devam etmek için güncelle';

  @override
  String get uiServerUpdateMessage =>
      'Sunucuna bağlanmak için uygulamanın yeni sürümünü yükle.';

  @override
  String get uiServerUpdateApiMessage =>
      'Uygulaman bu sunucuyla uyumlu değil. Yeni sürümü yükle veya yöneticinle iletişime geç.';

  @override
  String get uiServerUpdateServer => 'Sunucu';

  @override
  String get uiServerUpdateRequiredVersion => 'Gerekli sürüm';

  @override
  String get uiServerUpdateInstalledVersion => 'Mevcut sürüm';

  @override
  String get uiServerUpdateRecheck => 'Yeniden kontrol et';

  @override
  String get uiServerUpdateRemoteMessage =>
      'Uygulamayı kullanmaya devam etmek için yeni sürümü yükle.';

  @override
  String get uiServerUpdateOptionalTitle => 'Yeni sürüm kullanıma hazır';

  @override
  String get uiServerUpdateOptionalMessage =>
      'Yeni sürüme şimdi geçebilir veya mevcut sürümle devam edebilirsin.';

  @override
  String get uiServerUpdateStore => 'Şimdi güncelle';

  @override
  String get uiServerUpdateStoreUnavailable =>
      'Güncelleme bağlantısı henüz hazır değil. Daha sonra yeniden kontrol edebilirsin.';

  @override
  String get uiServerUpdateStoreFailed =>
      'Mağaza açılamadı. Yeniden deneyebilirsin.';

  @override
  String get uiServerUpdateLater => 'Daha sonra';

  @override
  String get uiServerUpdateInvalidVersion =>
      'Uygulamanın sürümü doğrulanamadı. Uygulamayı yeniden aç veya yöneticinle iletişime geç.';

  @override
  String get uiServerUpdatePolicyUnavailable =>
      'Güncelleme bilgisi şu anda alınamıyor. Biraz sonra yeniden kontrol edebilirsin.';

  @override
  String get uiServerUpdateStoreRequiredUnavailable =>
      'Güncelleme bağlantısı henüz hazır değil. Yardım için yöneticinle iletişime geç.';

  @override
  String get uiTablesTitle => 'Tablolar';

  @override
  String get uiTablesNew => 'Yeni tablo';

  @override
  String get uiTablesSearch => 'Tablolarda ara';

  @override
  String get uiTablesCoord => 'Koordinatörlük';

  @override
  String get uiTablesPersonal => 'Kişisel';

  @override
  String get uiTablesShared => 'Paylaşılan';

  @override
  String get uiTablesAll => 'Tümü';

  @override
  String get uiTablesOpen => 'Açık';

  @override
  String get uiTablesDone => 'Tamamlanan';

  @override
  String get uiTablesEmpty => 'Henüz tablo yok';

  @override
  String get uiTablesNoResults => 'Sonuç bulunamadı';

  @override
  String get uiTablesName => 'Tablo adı';

  @override
  String get uiTablesTemplate => 'Şablon';

  @override
  String get uiTablesBlank => 'Boş tablo';

  @override
  String get uiTablesTaskList => 'Görev listesi';

  @override
  String get uiTablesEventPlan => 'Etkinlik planı';

  @override
  String get uiTablesActionList => 'Aksiyon listesi';

  @override
  String get uiTablesSupplierList => 'Tedarikçi listesi';

  @override
  String get uiTablesVolunteerList => 'Gönüllü listesi';

  @override
  String get uiTablesInventory => 'Envanter';

  @override
  String get uiTablesCreate => 'Oluştur';

  @override
  String get uiTablesCancel => 'Vazgeç';

  @override
  String get uiTablesSave => 'Kaydet';

  @override
  String get uiTablesRow => 'satır';

  @override
  String get uiTablesColumn => 'sütun';

  @override
  String get uiTablesNewRow => 'Satır ekle';

  @override
  String get uiTablesNewColumn => 'Sütun ekle';

  @override
  String get uiTablesFields => 'Alanlar';

  @override
  String get uiTablesShare => 'Paylaş';

  @override
  String get uiTablesOptions => 'Tablo işlemleri';

  @override
  String get uiTablesRename => 'Yeniden adlandır';

  @override
  String get uiTablesDuplicate => 'Kopya oluştur';

  @override
  String get uiTablesDuplicateEmpty => 'Boş kopya oluştur';

  @override
  String get uiTablesDelete => 'Sil';

  @override
  String get uiTablesDeleteTable => 'Tablo silinsin mi?';

  @override
  String get uiTablesDeleteRow => 'Satır silinsin mi?';

  @override
  String get uiTablesDeleteColumn => 'Sütun silinsin mi?';

  @override
  String get uiTablesDeleteMessage =>
      'Bu işlem örnek veriyi bu oturumdan kaldırır.';

  @override
  String get uiTablesReadonly => 'Yalnızca görüntüleme';

  @override
  String get uiTablesEditable => 'Düzenleme erişimi';

  @override
  String get uiTablesText => 'Metin';

  @override
  String get uiTablesNumber => 'Sayı';

  @override
  String get uiTablesDate => 'Tarih';

  @override
  String get uiTablesPhone => 'Telefon';

  @override
  String get uiTablesEmail => 'E-posta';

  @override
  String get uiTablesPerson => 'Kişi';

  @override
  String get uiTablesUnit => 'Koordinatörlük';

  @override
  String get uiTablesTask => 'Görev';

  @override
  String get uiTablesLink => 'Tablo bağlantısı';

  @override
  String get uiTablesFile => 'Dosya';

  @override
  String get uiTablesTodo => 'Yapıldı';

  @override
  String get uiTablesEditRow => 'Satırı düzenle';

  @override
  String get uiTablesEditColumn => 'Sütunu düzenle';

  @override
  String get uiTablesMoveLeft => 'Sola taşı';

  @override
  String get uiTablesMoveRight => 'Sağa taşı';

  @override
  String get uiTablesSortAsc => 'Artan sırala';

  @override
  String get uiTablesSortDesc => 'Azalan sırala';

  @override
  String get uiTablesSortNone => 'Sıralamayı kaldır';

  @override
  String get uiTablesProgramAccess => 'Program erişimi';

  @override
  String get uiTablesOff => 'Kapalı';

  @override
  String get uiTablesView => 'Görür';

  @override
  String get uiTablesEdit => 'Düzenler';

  @override
  String get uiTablesOwner => 'Sahip';

  @override
  String get uiTablesAddPerson => 'Demo kişi ekle';

  @override
  String get uiTablesRemovePerson => 'Erişimi kaldır';

  @override
  String get uiTablesDemoPerson => 'Demo üye';

  @override
  String get uiTablesDemoNotice =>
      'Bu çalışma alanı yalnızca oturumluk örnek veridir.';

  @override
  String get uiTablesAttachment => 'Örnek ek ekle';

  @override
  String get uiTablesLinkedTable => 'Bağlı tablo';

  @override
  String get uiTablesSummary => 'Özet';

  @override
  String get uiTablesClear => 'Temizle';

  @override
  String get uiTablesTableMissing => 'Tablo bulunamadı';

  @override
  String get uiTablesGrid => 'Tablo görünümü';

  @override
  String get uiTablesCopySuffix => '(kopya)';

  @override
  String get uiTablesEmptySuffix => '(boş)';

  @override
  String get uiTablesTaskSample => 'Örnek görev';

  @override
  String get uiTablesUnitSample => 'Demo koordinatörlük';

  @override
  String get uiTablesFieldName => 'Alan adı';

  @override
  String get uiTablesNameRequired => 'Ad boş bırakılamaz';

  @override
  String get uiTablesNewRecord => 'Yeni kayıt';

  @override
  String get uiTablesRecent => 'Son kullanılanlar';

  @override
  String get uiTablesBackAreas => 'Koordinatörlüklere dön';

  @override
  String get uiTablesCopyLink => 'Bağlantıyı kopyala';

  @override
  String get uiTablesLinkCopied => 'Tablo bağlantısı kopyalandı';

  @override
  String get uiTablesPersonSearch => 'Demo kişilerde ara';

  @override
  String get uiTablesPlace => 'Yer';

  @override
  String get uiTablesApproved => 'Onaylandı';

  @override
  String get uiTablesCompany => 'Firma';

  @override
  String get uiTablesFullName => 'Ad soyad';

  @override
  String get uiTablesMaterial => 'Malzeme';

  @override
  String get uiTablesOffer => 'Teklif';

  @override
  String get uiTablesAction => 'Aksiyon';

  @override
  String get uiTablesActivity => 'Etkinlik';

  @override
  String get uiTablesDueDate => 'Son tarih';

  @override
  String get uiTablesCopyTo => 'Başka alana kopyala';

  @override
  String get uiTablesDestination => 'Kopyanın konumu';

  @override
  String get uiTablesRelated => 'Bağlı tablolar';

  @override
  String get uiTablesBacklinks => 'Bu tabloya bağlananlar';

  @override
  String get uiTablesLinks => 'bağlantı';

  @override
  String get uiTablesRecentAction => 'Son çalıştıkların';

  @override
  String get uiTablesUnitA => 'Atölye';

  @override
  String get uiTablesUnitB => 'Operasyon';

  @override
  String get uiTasksNoStatusTransitions =>
      'Bu görev için kullanabileceğiniz bir durum değişikliği yok.';

  @override
  String get uiTasksTitle => 'Görevler';

  @override
  String get uiTasksDetailTitle => 'Görev';

  @override
  String get uiTasksTasksLc => 'görev';

  @override
  String get uiTasksSearch => 'Ara';

  @override
  String get uiTasksSearchHint => 'Başlık, kimlik veya kişi';

  @override
  String get uiTasksFiltersButton =>
      'Filtreler · kişi, koordinatörlük, öncelik';

  @override
  String get uiTasksNewTask => 'Yeni görev';

  @override
  String get uiTasksMode => 'Görünüm';

  @override
  String get uiTasksModeList => 'Liste';

  @override
  String get uiTasksModeTimeline => 'Zaman çizelgesi';

  @override
  String get uiTasksViews => 'Görünümler';

  @override
  String get uiTasksViewAll => 'Tümü';

  @override
  String get uiTasksViewLate => 'Geciken';

  @override
  String get uiTasksViewDoing => 'Devam';

  @override
  String get uiTasksViewReview => 'Onayda';

  @override
  String get uiTasksViewRequest => 'Tarih talebi';

  @override
  String get uiTasksViewTodo => 'Başlamadı';

  @override
  String get uiTasksViewDone => 'Biten';

  @override
  String get uiTasksListAll => 'Tüm görevler';

  @override
  String get uiTasksListFiltered => 'Filtrelenmiş görevler';

  @override
  String get uiTasksListLate => 'geciken görevler';

  @override
  String get uiTasksListDoing => 'devam eden görevler';

  @override
  String get uiTasksListReview => 'onay bekleyenler';

  @override
  String get uiTasksListRequest => 'tarih talebi olanlar';

  @override
  String get uiTasksListTodo => 'başlamayanlar';

  @override
  String get uiTasksListDone => 'tamamlananlar';

  @override
  String get uiTasksTaskList => 'Görev listesi';

  @override
  String get uiTasksSortMenu => 'Sıralama';

  @override
  String get uiTasksSortCreated => 'Tanımlanma tarihine göre';

  @override
  String get uiTasksSortDue => 'Bitiş tarihine göre';

  @override
  String get uiTasksSortStart => 'Başlangıç tarihine göre';

  @override
  String get uiTasksSortCoord => 'Koordinatörlüğe göre';

  @override
  String get uiTasksSortCreatedShort => 'Tanımlanma tarihi';

  @override
  String get uiTasksSortDueShort => 'Bitiş tarihi';

  @override
  String get uiTasksSortStartShort => 'Başlangıç tarihi';

  @override
  String get uiTasksSortCoordShort => 'Koordinatörlük';

  @override
  String get uiTasksDirCreatedAsc => 'eskiden yeniye';

  @override
  String get uiTasksDirCreatedDesc => 'yeniden eskiye';

  @override
  String get uiTasksDirDueAsc => 'yakından uzağa';

  @override
  String get uiTasksDirDueDesc => 'uzaktan yakına';

  @override
  String get uiTasksDirStartAsc => 'erkenden geçe';

  @override
  String get uiTasksDirStartDesc => 'geçten erkene';

  @override
  String get uiTasksDirTap => 'yönü değiştirmek için dokun';

  @override
  String get uiTasksStatusTodo => 'Başlamadı';

  @override
  String get uiTasksStatusDoing => 'Devam ediyor';

  @override
  String get uiTasksStatusReview => 'Onay bekliyor';

  @override
  String get uiTasksStatusReturned => 'Geri gönderildi';

  @override
  String get uiTasksStatusDone => 'Tamamlandı';

  @override
  String get uiTasksPrioHigh => 'Yüksek';

  @override
  String get uiTasksPrioMedium => 'Orta';

  @override
  String get uiTasksPrioLow => 'Düşük';

  @override
  String get uiTasksCardStart => 'başlangıç';

  @override
  String get uiTasksCardDue => 'bitiş';

  @override
  String get uiTasksCardPriority => 'öncelik';

  @override
  String get uiTasksSubtasksTail => 'alt görev';

  @override
  String get uiTasksLateTail => 'gün gecikti';

  @override
  String get uiTasksRequestBadge => 'Talep';

  @override
  String get uiTasksFilesTail => 'kanıt dosyası';

  @override
  String get uiTasksNotesTail => 'not';

  @override
  String get uiTasksEmpty => 'Bu görünümde görev yok.';

  @override
  String get uiTasksClearFilters => 'Filtreleri temizle';

  @override
  String get uiTasksShowMore => 'Daha fazla göster';

  @override
  String get uiTasksCoordsLc => 'koordinatörlük';

  @override
  String get uiTasksClear => 'Temizle';

  @override
  String get uiTasksRemoveFilterTail => 'filtresini kaldır';

  @override
  String get uiTasksPriority => 'Öncelik';

  @override
  String get uiTasksPriorityFilterRemove => 'Öncelik filtresini kaldır';

  @override
  String get uiTasksFilters => 'Filtreler';

  @override
  String get uiTasksClearAll => 'Tümünü temizle';

  @override
  String get uiTasksGroupPeople => 'Kişi';

  @override
  String get uiTasksActiveFilters => 'Aktif filtreler';

  @override
  String get uiTasksFilterEdit => 'filtresi: düzenle';

  @override
  String get uiTasksFilterRemove => 'filtresini kaldır';

  @override
  String get uiTasksFilterActive => 'aktif';

  @override
  String get uiTasksPeopleCount => 'kişi';

  @override
  String get uiTasksCoordCount => 'koordinatörlük';

  @override
  String get uiTasksSortCreatedCompact => 'Tanımlanma';

  @override
  String get uiTasksSortDueCompact => 'Bitiş';

  @override
  String get uiTasksSortStartCompact => 'Başlangıç';

  @override
  String get uiTasksGroupCoord => 'Koordinatörlük';

  @override
  String get uiTasksSelectedTail => 'seçili';

  @override
  String get uiTasksAllLc => 'tümü';

  @override
  String get uiTasksFilterHint =>
      'Aynı grupta seçenekler “veya”, gruplar arası “ve” ile birleşir.';

  @override
  String get uiTasksShowTasksTail => 'görevi göster';

  @override
  String get uiTasksShortcuts => 'Görevler kısayolları';

  @override
  String get uiTasksFlyView => 'görünüm';

  @override
  String get uiTasksFlySort => 'sıralama';

  @override
  String get uiTasksFlyTasks => 'görevler';

  @override
  String get uiTasksFlyTimelineCaption => 'Dikey Gantt';

  @override
  String get uiTasksFlySearch => 'Görev ara';

  @override
  String get uiTasksFlyFilter => 'Kişi, koordinatörlük, öncelik';

  @override
  String get uiTasksFlyThisTask => 'bu görev';

  @override
  String get uiTasksFlyStatus => 'Durum';

  @override
  String get uiTasksFlyGo => 'git';

  @override
  String get uiTasksFlyTimeline => 'Zaman çizelgesinde gör';

  @override
  String get uiTasksEditTask => 'Görevi düzenle';

  @override
  String get uiTasksMoreActions => 'Diğer işlemler';

  @override
  String get uiTasksNotFound => 'Görev bulunamadı';

  @override
  String get uiTasksDeletedTitle => 'Görev silinen kayıtlara taşındı';

  @override
  String get uiTasksDeletedFilesKept => 'Kanıt dosyaları arşivde kaldı.';

  @override
  String get uiTasksRequestDate => 'Tarih değişikliği iste';

  @override
  String get uiTasksRemind => 'Atanana hatırlat';

  @override
  String get uiTasksUpload => 'Kanıt yükle';

  @override
  String get uiTasksRequestTitle => 'Tarih değişikliği talebi';

  @override
  String get uiTasksReject => 'Reddet';

  @override
  String get uiTasksApprove => 'Onayla';

  @override
  String get uiTasksDaysLc => 'gün';

  @override
  String get uiTasksNoReason => 'Gerekçe yazılmamış';

  @override
  String get uiTasksDetailTabs => 'Görev ayrıntısı';

  @override
  String get uiTasksTabSummary => 'Özet';

  @override
  String get uiTasksTabSubtasks => 'Alt görev';

  @override
  String get uiTasksTabFiles => 'Dosya';

  @override
  String get uiTasksTabNotes => 'Not';

  @override
  String get uiTasksAssignee => 'Atanan';

  @override
  String get uiTasksCreator => 'Oluşturan';

  @override
  String get uiTasksCreated => 'Tanımlandı';

  @override
  String get uiTasksDateRange => 'Tarih aralığı';

  @override
  String get uiTasksEvidenceFile => 'Kanıt dosyası';

  @override
  String get uiTasksNone => 'Yok';

  @override
  String get uiTasksProgress => 'ilerleme';

  @override
  String get uiTasksEvCreated => 'Görev tanımlandı';

  @override
  String get uiTasksEvStarted => 'Planlanan başlangıç';

  @override
  String get uiTasksEvWillStart => 'Başlayacak';

  @override
  String get uiTasksEvDone => 'Tamamlandı';

  @override
  String get uiTasksEvDoneLate => '(geç)';

  @override
  String get uiTasksEvDuePassed => 'Plan bitişi geçti';

  @override
  String get uiTasksEvLateTail => 'gündür gecikmede';

  @override
  String get uiTasksEvToday => 'bugün';

  @override
  String get uiTasksEvDue => 'Planlanan bitiş';

  @override
  String get uiTasksSubsHint =>
      'Kişi ve tarih isteğe bağlıdır. Görev, tüm alt görevler bitmeden tamamlanamaz.';

  @override
  String get uiTasksDoneLc => 'tamamlandı';

  @override
  String get uiTasksSubUntitled => 'Adsız alt görev';

  @override
  String get uiTasksSubName => 'Alt görev adı';

  @override
  String get uiTasksSubPerson => 'Kişi';

  @override
  String get uiTasksSubDate => 'Tarih';

  @override
  String get uiTasksSubEvidence => 'Kanıt';

  @override
  String get uiTasksSubFile => 'Dosya';

  @override
  String get uiTasksRequired => 'Zorunlu';

  @override
  String get uiTasksOptional => 'Opsiyonel';

  @override
  String get uiTasksPickPerson => 'Kişi seç';

  @override
  String get uiTasksNoPerson => 'Kişi yok';

  @override
  String get uiTasksClearDate => 'Tarihi kaldır';

  @override
  String get uiTasksSubDelete => 'Alt görevi sil';

  @override
  String get uiTasksSubAdd => 'Alt görev ekle';

  @override
  String get uiTasksNeedsPerson => 'kişi atanmalı';

  @override
  String get uiTasksEvidenceRequiredLc => 'kanıt zorunlu';

  @override
  String get uiTasksOneEvidence => '1 kanıt';

  @override
  String get uiTasksStart => 'Başlangıç';

  @override
  String get uiTasksDue => 'Bitiş';

  @override
  String get uiTasksNoFiles => 'Henüz kanıt dosyası yok.';

  @override
  String get uiTasksSubtaskPrefix => 'Alt görev:';

  @override
  String get uiTasksDeletedLc => 'silinmiş';

  @override
  String get uiTasksKb => 'KB';

  @override
  String get uiTasksNoNotes => 'Henüz not yok.';

  @override
  String get uiTasksNoteHint => 'Not yaz…';

  @override
  String get uiTasksSend => 'Gönder';

  @override
  String get uiTasksSheetStatus => 'durum';

  @override
  String get uiTasksSheetPriority => 'öncelik';

  @override
  String get uiTasksOpenSubsTail => 'alt görev açık';

  @override
  String get uiTasksCopy => 'Kopyala';

  @override
  String get uiTasksCopySuffix => '(kopya)';

  @override
  String get uiTasksDeleteTask => 'Görevi sil';

  @override
  String get uiTasksEditDescTail => 'değişiklikler işlem geçmişine yazılır';

  @override
  String get uiTasksFieldTitle => 'Başlık';

  @override
  String get uiTasksFieldTitleHint => 'Görev başlığı';

  @override
  String get uiTasksErrTitleEmpty => 'Başlık boş bırakılamaz';

  @override
  String get uiTasksFieldCoord => 'Koordinatörlük';

  @override
  String get uiTasksErrDates => 'Bitiş, başlangıçtan önce olamaz';

  @override
  String get uiTasksSave => 'Kaydet';

  @override
  String get uiTasksCancel => 'Vazgeç';

  @override
  String get uiTasksDateDesc => 'Onaylanınca yeni tarihler göreve uygulanır';

  @override
  String get uiTasksNowLc => 'şu an';

  @override
  String get uiTasksNewStart => 'Yeni başlangıç';

  @override
  String get uiTasksNewDue => 'Yeni bitiş';

  @override
  String get uiTasksReason => 'Gerekçe';

  @override
  String get uiTasksReasonHint => 'Örn. malzeme tedariki gecikti';

  @override
  String get uiTasksSendRequest => 'Talep gönder';

  @override
  String get uiTasksUploadTitle => 'Kanıt dosyası yükle';

  @override
  String get uiTasksUploadDesc => 'Dosya görevin arşiv klasörüne kaydedilir';

  @override
  String get uiTasksTaskFolder => 'görev klasörü';

  @override
  String get uiTasksTaskItself => 'Görevin kendisi';

  @override
  String get uiTasksTag => 'Etiket';

  @override
  String get uiTasksTagSite => 'Saha görselleri';

  @override
  String get uiTasksTagResult => 'Sonuç dosyası';

  @override
  String get uiTasksTagStatus => 'Güncel durum verisi';

  @override
  String get uiTasksTagRequirement => 'İster';

  @override
  String get uiTasksTagPlan => 'Plan';

  @override
  String get uiTasksTagInput => 'Girdi';

  @override
  String get uiTasksTagAnalysis => 'Analiz';

  @override
  String get uiTasksTagOutput => 'Çıktı';

  @override
  String get uiTasksTagOutcome => 'Sonuç';

  @override
  String get uiTasksTagUnknown => 'Diğer';

  @override
  String get uiTasksUploadOk => 'Yükle';

  @override
  String get uiTasksDeleteQTail => 'silinsin mi?';

  @override
  String get uiTasksDeleteDesc => 'Silinen kayıtlardan geri alınabilir';

  @override
  String get uiTasksDeleteBodyTail =>
      'silinen kayıtlara taşınır. Kanıt dosyaları arşivde kalır.';

  @override
  String get uiTasksDeleteOk => 'Sil';

  @override
  String get uiTasksTCreatedTail => 'oluşturuldu';

  @override
  String get uiTasksTDeleted => 'Görev silinen kayıtlara taşındı';

  @override
  String get uiTasksTUpdatedTail => 'güncellendi';

  @override
  String get uiTasksTRequestSent =>
      'Tarih değişikliği talebi gönderildi · onay bekliyor';

  @override
  String get uiTasksTUploaded =>
      'Kanıt dosyası yüklendi · görevin arşiv klasörüne eklendi';

  @override
  String get uiTasksTPendingExists =>
      'Bu görev için zaten bekleyen bir talep var';

  @override
  String get uiTasksTReminded => 'Hatırlatma gönderildi';

  @override
  String get uiTasksTApproved => 'Talep onaylandı';

  @override
  String get uiTasksTNewDue => 'yeni bitiş';

  @override
  String get uiTasksTRejected => 'Talep reddedildi';

  @override
  String get uiTasksTInformed => 'bilgilendirildi';

  @override
  String get uiTasksTSubEvidence =>
      'Bu alt görev için kanıt zorunlu · önce kanıt yükle';

  @override
  String get uiTasksTSubRemovedTail => 'görevinden kaldırıldı';

  @override
  String get uiTasksTSubFileKept => 'kanıt dosyası arşivde kaldı';

  @override
  String get uiTasksRevertTitle => 'Tamamlanmış görevi yeniden aç';

  @override
  String get uiTasksRevertDesc => 'Gerekçe işlem geçmişine yazılır';

  @override
  String get uiTasksRevertHint => 'Neden yeniden açılıyor?';

  @override
  String get uiTasksRevertMin => 'En az 3 karakter';

  @override
  String get uiTasksRevertOk => 'Yeniden aç';

  @override
  String get uiTasksCloseSubsTitle => 'Açık alt görevler var';

  @override
  String get uiTasksCloseSubsDesc =>
      'Görev tamamlanırken açık alt görevler de senin adına kapatılır.';

  @override
  String get uiTasksCloseSubsOk => 'Alt görevleri de kapat';

  @override
  String get uiTasksNoteEdit => 'Düzenle';

  @override
  String get uiTasksNoteDelete => 'Sil';

  @override
  String get uiTasksNoteEditTitle => 'Notu düzenle';

  @override
  String get uiTasksNoteDeleteQ => 'Not silinsin mi?';

  @override
  String get uiTasksNoteDeleteDesc => 'Silinen not geri alınamaz';

  @override
  String get uiTasksTNoteSaved => 'Not güncellendi';

  @override
  String get uiTasksTNoteDeleted => 'Not silindi';

  @override
  String get uiTasksSubRename => 'Başlığı düzenle';

  @override
  String get uiTasksTSubAdded => 'Alt görev eklendi';

  @override
  String get uiTasksTNotifiedTail => 'kişiye bildirim gitti';

  @override
  String get uiTasksNtDesc =>
      'Görev oluşturulduğunda atanan kişiye bildirim gider.';

  @override
  String get uiTasksCreate => 'Oluştur';

  @override
  String get uiTasksNtTitleHint => 'Ne yapılması gerekiyor?';

  @override
  String get uiTasksRowDate => 'Tarih';

  @override
  String get uiTasksEvidenceRequired => 'Kanıt dosyası zorunlu';

  @override
  String get uiTasksPick => 'Seç';

  @override
  String get uiTasksCoordFirst => 'Önce koordinatörlük';

  @override
  String get uiTasksNobodyHere => 'Bu koordinatörlükte kimse yok.';

  @override
  String get uiTasksPeopleLc => 'kişi';

  @override
  String get uiTasksRoleCoordinatorLc => 'koordinatör';

  @override
  String get uiTasksRoleMemberLc => 'üye';

  @override
  String get uiTasksWeeksLc => 'hafta';

  @override
  String get uiTasksOneMonth => '1 ay';

  @override
  String get uiTasksErrTitle => 'Başlık gerekli.';

  @override
  String get uiTasksErrCoord => 'Koordinatörlük seç.';

  @override
  String get uiTasksErrDatesFull => 'Bitiş, başlangıçtan önce olamaz.';

  @override
  String get uiTasksMtTitle => 'Toplantı oluştur';

  @override
  String get uiTasksMtDesc =>
      'Toplantı sahibi sensin. Davetlilere bildirim gider.';

  @override
  String get uiTasksMtTitleHint => 'Toplantının konusu ne?';

  @override
  String get uiTasksRowTime => 'Saat';

  @override
  String get uiTasksRowInvitees => 'Davetliler';

  @override
  String get uiTasksRowAgenda => 'Gündem';

  @override
  String get uiTasksItemsLc => 'madde';

  @override
  String get uiTasksAddItem => 'Madde ekle';

  @override
  String get uiTasksAgendaItem => 'Gündem maddesi';

  @override
  String get uiTasksAddItemLabel => 'Maddeyi ekle';

  @override
  String get uiTasksRemoveItemTail => '. maddeyi kaldır';

  @override
  String get uiTasksItemTail => '. madde';

  @override
  String get uiTasksModePeople => 'Kişiler';

  @override
  String get uiTasksInviteMembers => 'Üyeleri de davet et';

  @override
  String get uiTasksWithMembers => 'üyelerle';

  @override
  String get uiTasksCoordAbbr => 'koord.';

  @override
  String get uiTasksErrPast => 'Tarih geçmişe çekilemez.';

  @override
  String get uiTasksErrMtCoords =>
      'Davetli olarak en az bir koordinatörlük seç.';

  @override
  String get uiTasksErrMtPeople => 'En az bir kişi seç.';

  @override
  String get uiTasksTMeeting => 'Toplantı oluşturuldu';

  @override
  String get uiTasksTCoordsInvited => 'koordinatörlük davetli';

  @override
  String get uiTasksTPeopleInvited => 'kişi davetli';

  @override
  String get uiTasksIvTitle => 'Kullanıcı ekle';

  @override
  String get uiTasksIvDesc =>
      'Hesap açılır ya da var olan hesap seçilen koordinatörlüğün ekibine eklenir. E-posta ya da parola gönderilmez.';

  @override
  String get uiTasksIvSend => 'Ekle';

  @override
  String get uiTasksIvName => 'Ad soyad';

  @override
  String get uiTasksIvNameHint => 'Ad Soyad';

  @override
  String get uiTasksIvEmail => 'E-posta';

  @override
  String get uiTasksIvEmailHint => 'E-posta adresi';

  @override
  String get uiTasksIvRole => 'Rol';

  @override
  String get uiTasksRoleMember => 'Üye';

  @override
  String get uiTasksRoleCoordinator => 'Koordinatör';

  @override
  String get uiTasksRoleAdmin => 'Admin';

  @override
  String get uiTasksRdAdmin =>
      'Tüm koordinatörlükleri, kullanıcıları ve sezonu yönetir.';

  @override
  String get uiTasksRdCoordinator =>
      'Seçtiğin koordinatörlükte görev atar ve dosyaları onaylar.';

  @override
  String get uiTasksRdMember =>
      'Atanan görevleri yürütür, kanıt dosyası yükler.';

  @override
  String get uiTasksErrName => 'Ad soyad gerekli.';

  @override
  String get uiTasksErrEmail => 'Geçerli bir e-posta gir.';

  @override
  String get uiTasksErrIvCoord => 'Bir koordinatörlük seç.';

  @override
  String get uiTasksTInvited => 'Ekibe eklendi:';

  @override
  String get uiTasksIvExisting => 'Bu e-posta var olan bir hesaba ait:';

  @override
  String get uiTasksIvExistingTail => '“Ekle” bu hesabı ekibe ekler.';

  @override
  String get uiTasksExpandSheet => 'Sayfayı büyüt';

  @override
  String get uiTasksCollapseSheet => 'Sayfayı küçült';

  @override
  String get uiTasksClaim => 'Üstlen';

  @override
  String get uiTasksUnclaim => 'Üstlenmeyi bırak';

  @override
  String get uiTasksTClaimed => 'Görevi üstlendin';

  @override
  String get uiTasksTUnclaimed => 'Görevi bıraktın';

  @override
  String get uiTasksFileDownload => 'İndir';

  @override
  String get uiTasksFileRename => 'Adı değiştir';

  @override
  String get uiTasksFileDelete => 'Dosyayı sil';

  @override
  String get uiTasksFileDeleteQ => 'Dosya silinsin mi?';

  @override
  String get uiTasksFileDeleteDesc => 'Silinen dosya geri alınamaz';

  @override
  String get uiTasksFileNameLabel => 'Dosya adı';

  @override
  String get uiTasksTFileSaved => 'Dosya kaydedildi';

  @override
  String get uiTasksTFileRenamed => 'Dosya adı güncellendi';

  @override
  String get uiTasksTFileDeleted => 'Dosya silindi';

  @override
  String get uiTasksPickFileAction => 'Dosya seç';

  @override
  String get uiTasksPickPhotos => 'Fotoğraflar';

  @override
  String get uiTasksPickFiles => 'Dosyalar';

  @override
  String get uiTasksPickerMissing => 'Bu sürümde dosya seçici yok';

  @override
  String get uiTasksErrPickFile => 'Yüklemek için bir dosya seç';

  @override
  String get uiTasksUploadTypes =>
      'PDF, PNG, JPG, CSV, Word, Excel, PowerPoint, Pages · 90 MB altı';

  @override
  String get uiTasksTeamEmpty => 'Bu departmanda atanabilir kişi yok';

  @override
  String get uiTasksUnassigned => 'Atanmamış';

  @override
  String get uiTasksTUnavailable => 'Bu işlem bu görevde şu an yapılamıyor.';

  @override
  String get uiTasksUnknownPerson => 'Bilinmeyen kişi';

  @override
  String get uiTasksDescription => 'Açıklama';

  @override
  String get uiTasksDepartment => 'Departman';

  @override
  String get uiTasksDepartmentAll => 'Tüm departmanlar';

  @override
  String get uiTasksDepartmentFilterCleared =>
      'Seçili departman artık bu programda yok; süzgeç temizlendi.';

  @override
  String get uiTasksNoteTaskTitle => 'Notu göreve dönüştür';

  @override
  String get uiTasksNoteTaskDesc =>
      'Görev bu nottan açılır ve nota bağlanır. Atanan kişiye bildirim gider.';

  @override
  String get uiTasksMessageTaskTitle => 'Mesajı göreve dönüştür';

  @override
  String get uiTasksMessageTaskDesc =>
      'Görevin açıklaması mesaj metnidir; görev mesaja bağlanır. Atanan kişiye bildirim gider.';

  @override
  String get uiTasksMtEditTitle => 'Toplantıyı düzenle';

  @override
  String get uiTasksMtEditDesc =>
      'Katılımcılar ve gündem toplantı ayrıntısında yönetilir.';

  @override
  String get uiTasksTMeetingSaved => 'Toplantı güncellendi';

  @override
  String get uiTasksErrMtOwner => 'Sahip koordinatörlüğü seç.';

  @override
  String get uiTasksRowOwner => 'Sahip koordinatörlük';

  @override
  String get uiTasksSubCheckBlocked =>
      'Alt görevi yönetici, departman koordinatörü ya da alt göreve atanan kişi işaretler.';

  @override
  String get uiTasksConflictTitle => 'Görev siz düzenlerken değişti';

  @override
  String get uiTasksConflictDesc =>
      'Aynı alanı başkası da değiştirdi. Her alan için hangi değerin kalacağını seçin; diğer alanlar korunur.';

  @override
  String get uiTasksConflictBase => 'Açtığınızda';

  @override
  String get uiTasksConflictMine => 'Sizin değeriniz';

  @override
  String get uiTasksConflictServer => 'Sunucudaki değer';

  @override
  String get uiTasksConflictKeepMine => 'Benimkini tut';

  @override
  String get uiTasksConflictTakeServer => 'Sunucudakini al';

  @override
  String get uiTasksConflictPending =>
      'Kaydetmeden önce işaretli alanlar için seçim yapın';

  @override
  String get uiTasksTextConflictTitle => 'Metin siz düzenlerken değişti';

  @override
  String get uiTasksTextConflictDesc =>
      'Sunucudaki metin sizinkinden farklı. Hangisi kalsın?';

  @override
  String get uiTasksRetryAfterHead => 'Yeniden denemek için';

  @override
  String get uiTasksRetryAfterTail => 'sn bekleyin';

  @override
  String get uiTasksEmptyValue => '—';

  @override
  String get uiTasksConflictOn => 'Açık';

  @override
  String get uiTasksConflictOff => 'Kapalı';

  @override
  String get uiTasksFieldPlace => 'Yer';

  @override
  String get uiTasksMtPlaceHint => 'İsteğe bağlı · ör. toplantı salonu';

  @override
  String get uiTasksErrMtPlace => 'Yer en çok 200 karakter olabilir.';

  @override
  String get uiTasksMtPoolPartial =>
      'Liste eksik olabilir: yalnız erişebildiğin ekipler gösteriliyor.';

  @override
  String get uiTasksTPeopleFailed => 'kişi eklenemedi';

  @override
  String get uiTasksTMeetingOpen => 'Toplantıyı aç';

  @override
  String get uiTimelineTitle => 'Zaman çizelgesi';

  @override
  String get uiTimelineFullscreenHint =>
      'Tam ekran · çıkmak için boş alana dokun';

  @override
  String get uiTimelineFullscreenToggle => 'Tam ekranı aç veya kapat';

  @override
  String get uiTimelineView => 'Görünüm';

  @override
  String get uiTimelineList => 'Liste';

  @override
  String get uiTimelineCoord => 'Koordinatörlük';

  @override
  String get uiTimelineCoordAll => 'tümü';

  @override
  String get uiTimelineCoordNone => 'seçilmedi';

  @override
  String get uiTimelineCoordSelected => 'seçili';

  @override
  String get uiTimelineCoordOpenTail => 'açık';

  @override
  String get uiTimelineCoordClear => 'Seçimi kaldır';

  @override
  String get uiTimelineCoordSelectAll => 'Tümünü seç';

  @override
  String get uiTimelineFilter => 'Filtre';

  @override
  String get uiTimelineFilterLabel => 'Filtreler · durum, kişi, öncelik';

  @override
  String get uiTimelineFilters => 'Filtreler';

  @override
  String get uiTimelineClear => 'Temizle';

  @override
  String get uiTimelineStatus => 'Durum';

  @override
  String get uiTimelineStatusAll => 'Tümü';

  @override
  String get uiTimelineStatusOpen => 'Açık';

  @override
  String get uiTimelineStatusLate => 'Geciken';

  @override
  String get uiTimelineStatusDone => 'Biten';

  @override
  String get uiTimelinePerson => 'Kişi';

  @override
  String get uiTimelinePriority => 'Öncelik';

  @override
  String get uiTimelinePrioHigh => 'Yüksek';

  @override
  String get uiTimelinePrioMid => 'Orta';

  @override
  String get uiTimelinePrioLow => 'Düşük';

  @override
  String get uiTimelineScale => 'Ölçek';

  @override
  String get uiTimelineScaleDay => 'Gün';

  @override
  String get uiTimelineScaleWeek => 'Hafta';

  @override
  String get uiTimelineScaleMonth => 'Ay';

  @override
  String get uiTimelineZoomIn => 'Yakınlaştır';

  @override
  String get uiTimelineZoomOut => 'Uzaklaştır';

  @override
  String get uiTimelineOverview => 'Genel bakış';

  @override
  String get uiTimelineOverviewHint =>
      'Her koordinatörlük bir sütun; sütuna dokununca o koordinatörlük açılır.';

  @override
  String get uiTimelineCoordHint =>
      'Koordinatörlük, çizelgenin üstündeki menüden seçilir.';

  @override
  String get uiTimelineShowTasksTail => 'görevi göster';

  @override
  String get uiTimelineLegend => 'Lejant';

  @override
  String get uiTimelineLegendOpen => 'Lejantı göster';

  @override
  String get uiTimelineStTodo => 'Başlamadı';

  @override
  String get uiTimelineStDoing => 'Devam ediyor';

  @override
  String get uiTimelineStReview => 'Onay bekliyor';

  @override
  String get uiTimelineStBack => 'Geri gönderildi';

  @override
  String get uiTimelineStDone => 'Tamamlandı';

  @override
  String get uiTimelineStDoneLate => 'Geç bitti';

  @override
  String get uiTimelineStLate => 'Gecikmede';

  @override
  String get uiTimelineStRequest => 'Tarih talebi';

  @override
  String get uiTimelineLegendToday =>
      'Yeşil çizgi bugünü gösterir; yeşil etiket bugünün tarihi.';

  @override
  String get uiTimelineLegendStrip =>
      'Alttaki şerit sezonun haritası: çerçeve baktığın aralık, kırmızı hafta gecikmenin başladığı hafta. Dokunarak ya da sürükleyerek o haftaya git.';

  @override
  String get uiTimelineLegendBar =>
      'Çubuğa dokun: tarihleri − / + ile ya da tarih alanından değiştir, çubuk anında güncellenir. Seçili çubuğu basılı tutup sürükleyerek de kaydırabilirsin.';

  @override
  String get uiTimelineToday => 'Bugün';

  @override
  String get uiTimelineSeasonMap =>
      'Sezon haritası · parmağını kaydırarak çizelgede gez';

  @override
  String get uiTimelineEmpty => 'Bu filtrede görev yok.';

  @override
  String get uiTimelineEmptyNoCoord => 'Koordinatörlük seç.';

  @override
  String get uiTimelineDependent => 'bağımlı';

  @override
  String get uiTimelineDaysLate => 'gün gecikmede';

  @override
  String get uiTimelineDaysLateDone => 'gün geç bitti';

  @override
  String get uiTimelineSelectedTask => 'Seçili görev';

  @override
  String get uiTimelineOpenTask => 'Görev ayrıntısında aç';

  @override
  String get uiTimelineEvidenceTail => 'kanıt dosyası';

  @override
  String get uiTimelineNoEvidence => 'kanıt yok';

  @override
  String get uiTimelineStart => 'başlangıç';

  @override
  String get uiTimelineEnd => 'bitiş';

  @override
  String get uiTimelineDayBack => 'bir gün geri';

  @override
  String get uiTimelineDayForward => 'bir gün ileri';

  @override
  String get uiTimelineShiftAll => 'tümünü kaydır';

  @override
  String get uiTimelineShiftWeekBack => '−1 hf';

  @override
  String get uiTimelineShiftDayBack => '−1 g';

  @override
  String get uiTimelineShiftDayForward => '+1 g';

  @override
  String get uiTimelineShiftWeekForward => '+1 hf';

  @override
  String get uiTimelineDay => 'gün';

  @override
  String get uiTimelineDuration => 'süre';

  @override
  String get uiTimelineWeekShort => 'hf';

  @override
  String get uiTimelineSave => 'Kaydet';

  @override
  String get uiTimelineSendRequest => 'Talep gönder';

  @override
  String get uiTimelineDates => 'Tarihler';

  @override
  String get uiTimelineReset => 'Sıfırla';

  @override
  String get uiTimelinePrevious => 'önceki';

  @override
  String get uiTimelineRemindUnavailable =>
      'Bu sunucu sürümü hatırlatma göndermeyi desteklemiyor.';

  @override
  String get uiTimelineRemind => 'Atanana hatırlat';

  @override
  String get uiTimelineRequestPending =>
      'Bu görev için zaten bekleyen bir talep var';

  @override
  String get uiTimelineRequestNoChange =>
      'Önce tarihleri değiştir, sonra talep gönder';

  @override
  String get uiTimelineRequestSent => 'Tarih talebi gönderildi · yeni bitiş';

  @override
  String get uiTimelineRequestSentTail => 'onay bekliyor';

  @override
  String get uiTimelineReminded => 'Hatırlatma gönderildi';

  @override
  String get uiTimelineUndoneTail => 'tarihleri geri alındı';

  @override
  String get uiTimelineShiftedForward => 'gün ileri kaydırıldı';

  @override
  String get uiTimelineShiftedBack => 'gün geri kaydırıldı';

  @override
  String get uiTimelineDurationOf => 'süresi';

  @override
  String get uiTimelineExtended => 'gün uzatıldı';

  @override
  String get uiTimelineShortened => 'gün kısaltıldı';

  @override
  String get uiTimelineUndo => 'Geri al';

  @override
  String get uiTimelineTasksLc => 'görev';

  @override
  String get uiTimelineDoneLc => 'bitti';

  @override
  String get uiTimelineLateLc => 'gecikmede';

  @override
  String get uiTimelineOpen => 'aç';

  @override
  String get uiTimelineGanttFilter => 'Görev filtresi';

  @override
  String get uiTimelineGanttZoomDaily => 'Günlük';

  @override
  String get uiTimelineGanttZoomWeekly => 'Haftalık';

  @override
  String get uiTimelineGanttZoomMonthly => 'Aylık';

  @override
  String get uiTimelineGanttAllCoords => 'Tüm koordinatörlükler';

  @override
  String get uiTimelineGanttAllCoordsLc => 'tüm koordinatörlükler';

  @override
  String get uiTimelineGanttLabelHead => 'koordinatörlük · görev';

  @override
  String get uiTimelineGanttLateTail => 'gecikme';

  @override
  String get uiTimelineGanttTodayPill => 'bugün';

  @override
  String get uiTimelineGanttEmpty => 'Bu filtreyle eşleşen görev yok.';

  @override
  String get uiTimelineGanttLegendLate => 'Gecikme';

  @override
  String get uiTimelineGanttCardStatus => 'durum';

  @override
  String get uiTimelineGanttCardDate => 'tarih';

  @override
  String get uiTimelineGanttCardAssignee => 'atanan';

  @override
  String get uiTimelineGanttUnassigned => 'Atanmamış';

  @override
  String get uiTimelineGanttDaysLate => 'gün gecikti';

  @override
  String get uiTimelineGanttOpenTask => 'Görev ayrıntısını aç';

  @override
  String get uiUserAccountFieldsHeading => 'hesap bilgileri';

  @override
  String get uiUserAccountFieldsFullName => 'Ad soyad';

  @override
  String get uiUserAccountFieldsEmail => 'E-posta';

  @override
  String get uiUserAccountFieldsPassword => 'Şifre';

  @override
  String get uiUserAccountFieldsEditFullName => 'Ad soyadı düzenle';

  @override
  String get uiUserAccountFieldsEditEmail => 'E-postayı düzenle';

  @override
  String get uiUserAccountFieldsEditPassword => 'Yeni şifre belirle';

  @override
  String get uiUserAccountFieldsNewPassword => 'Yeni şifre';

  @override
  String get uiUsersProgramShortName => 'Kısa ad (1–4 harf veya rakam)';

  @override
  String get uiUsersProgramColor =>
      'Renk (violet, gold, blue, teal, green, orange, red, slate)';

  @override
  String get uiUsersProgramBadgeInvalid => 'Kısa ad veya renk geçersiz.';

  @override
  String get uiUsersDisableAccount => 'Hesabı kapat';

  @override
  String get uiUsersEnableAccount => 'Hesabı aç';

  @override
  String get uiUsersDisableConfirm =>
      'Oturumlar kapatılır, görevler ve geçmiş korunur.';

  @override
  String get uiUsersEnableConfirm =>
      'Hesap mevcut rol ve üyelikleriyle erişim kazanır; yeniden giriş gerekir.';

  @override
  String get uiUsersAccountHistoryPreserved => 'Görevler ve geçmiş korunur.';

  @override
  String get uiUsersAccountStatusUnknown => 'Hesap durumu bilinmiyor';

  @override
  String get uiUsersOwnAccount => 'Kendi hesabınız';

  @override
  String get uiUsersAccountDisabled => 'Hesap kapalı';

  @override
  String get uiUsersLoginLocked => 'Giriş kilitli';

  @override
  String get uiUsersFilterScope => 'geçerli filtre';

  @override
  String get uiUsersSearchNameEmail => 'Ad veya e-posta ara';

  @override
  String get uiUsersOneDepartment => 'Bir koordinatörlük seçebilirsin';

  @override
  String get uiUsersTitle => 'Kullanıcılar';

  @override
  String get uiUsersSubtitle => 'Hesaplar ve ekip üyelikleri';

  @override
  String get uiUsersSearch => 'Kullanıcı ara';

  @override
  String get uiUsersAll => 'Tümü';

  @override
  String get uiUsersCoordinators => 'Koordinatörler';

  @override
  String get uiUsersMembers => 'Üyeler';

  @override
  String get uiUsersFilters => 'Süzgeç ve sıralama';

  @override
  String get uiUsersEmpty => 'Kullanıcı bulunamadı.';

  @override
  String get uiUsersUnassigned => 'Üyelik yok';

  @override
  String get uiUsersPartial => 'Görünen kayıtlar kısmi olabilir.';

  @override
  String get uiUsersMore => 'Daha fazla göster';

  @override
  String get uiUsersManagement => 'Diğer yönetim işlemleri';

  @override
  String get uiUsersSortName => 'Ada göre';

  @override
  String get uiUsersSortCreated => 'Kayıt tarihine göre';

  @override
  String get uiUsersDescending => 'Azalan sıralama';

  @override
  String get uiUsersProfile => 'Kullanıcı profili';

  @override
  String get uiUsersNotFound => 'Kullanıcı bulunamadı veya erişiminiz yok.';

  @override
  String get uiUsersScopeNote =>
      'Görev özeti yalnız seçili programdaki erişebildiğiniz görevleri kapsar.';

  @override
  String get uiUsersOpen => 'açık';

  @override
  String get uiUsersLate => 'gecikmede';

  @override
  String get uiUsersReview => 'onay bekliyor';

  @override
  String get uiUsersDone => 'Tamamlandı';

  @override
  String get uiUsersTasks => 'Görevler';

  @override
  String get uiUsersFiles => 'Dosyalar';

  @override
  String get uiUsersCalendar => 'Takvim';

  @override
  String get uiUsersHistory => 'Geçmiş';

  @override
  String get uiUsersAccount => 'Hesap';

  @override
  String get uiUsersNoTasks => 'Bu süzgeçte erişilebilir görev bulunamadı.';

  @override
  String get uiUsersHistoryUnavailable =>
      'Kullanıcıya özel işlem geçmişi bu sunucuda sunulmuyor.';

  @override
  String get uiUsersMembershipUnknown => 'Üyelik bilgisi bilinmiyor';

  @override
  String get uiUsersOtherDepartment => 'Diğer programdaki koordinatörlük';

  @override
  String get uiUsersCoordinator => 'Koordinatör';

  @override
  String get uiUsersMember => 'Üye';

  @override
  String get uiUsersMemberships => 'Koordinatörlük ve roller';

  @override
  String get uiUsersMembershipConfirm =>
      'Bu üyelik değişikliği görevleri etkiliyor. Sunucunun bildirdiği etkiyi onaylayarak devam etmek istiyor musunuz?';

  @override
  String get uiUsersSaved => 'İşlem tamamlandı.';

  @override
  String get uiUsersMembershipScope =>
      'Üyelik işlemleri seçili program için uygulanır.';

  @override
  String get uiUsersNotMember => 'Üyelik yok';

  @override
  String get uiUsersRemoveMembership => 'Üyeliği kaldır';

  @override
  String get uiUsersRemoveMembershipConfirm =>
      'Bu koordinatörlükteki üyelik kaldırılsın mı?';

  @override
  String get uiUsersSetMember => 'Üye olarak ata';

  @override
  String get uiUsersSetCoordinator => 'Koordinatör olarak ata';

  @override
  String get uiUsersOpenDepartment => 'Koordinatörlüğü aç';

  @override
  String get uiUsersAdd => 'Kullanıcı ekle';

  @override
  String get uiUsersQuickActions => 'Kullanıcı işlemleri';

  @override
  String get uiUsersOpenProfile => 'Profili aç';

  @override
  String get uiUsersClearDepartments => 'Koordinatörlük seçimini temizle';

  @override
  String get uiUsersLoadedFilterNote =>
      'Koordinatörlük süzgeci yüklenmiş kullanıcı sayfalarında uygulanır. Daha fazla göster ile aramayı genişletebilirsiniz.';

  @override
  String get uiUsersExportLoaded =>
      'Yüklenmiş ve süzülmüş satırları CSV olarak kaydet';

  @override
  String get uiUsersExportName => 'Ad soyad';

  @override
  String get uiUsersExportSaved => 'CSV kaydedildi:';

  @override
  String get uiUsersDistribution => 'Durum dağılımı';

  @override
  String get uiUsersNotStarted => 'Başlamadı';

  @override
  String get uiUsersInProgress => 'Devam ediyor';

  @override
  String get uiUsersReturned => 'Geri gönderildi';

  @override
  String get uiUsersUnknownStatus => 'Durumu bilinmiyor';

  @override
  String get uiUsersKpiCompletion => 'Tamamlanma';

  @override
  String get uiUsersKpiOpen => 'Açık';

  @override
  String get uiUsersKpiLate => 'Gecikme';

  @override
  String get uiUsersKpiReview => 'Onay';

  @override
  String get uiUsersLoadedCountTail => 'kullanıcı yüklendi';

  @override
  String get uiUsersMoreAvailable => 'Devamı var';

  @override
  String get uiUsersAdmin => 'Admin';

  @override
  String get uiUsersCountTail => 'kullanıcı';

  @override
  String get uiUsersNavCountTail => 'kişi';

  @override
  String get uiUsersSearchHint => 'Ad veya koordinatörlük';

  @override
  String get uiUsersRowHint =>
      'Profili açmak için dokunun. Hızlı işlemler için basılı tutun.';

  @override
  String get uiUsersNoLoadedMatch =>
      'Yüklenen kullanıcılar arasında eşleşme yok. Diğer kayıtları yükleyebilirsiniz.';

  @override
  String get uiUsersDirectoryPartial =>
      '+ işareti, listenin devamı olduğunu gösterir. Sayılar yüklenen kayıtları kapsar.';

  @override
  String get uiUsersTaskCountNoun => 'görev';

  @override
  String get uiUsersTaskOpenFilter => 'Açık görevler';

  @override
  String get uiUsersTaskLateFilter => 'Gecikmede olanlar';

  @override
  String get uiUsersTaskReviewFilter => 'Onay bekleyenler';

  @override
  String get uiUsersTaskDoneFilter => 'Tamamlananlar';

  @override
  String get uiUsersTaskAllFilter => 'Tüm görevler';

  @override
  String get uiUsersTaskFilters => 'Görevleri süz';

  @override
  String get uiUsersTaskFilterCountHint =>
      'görev gösteriliyor · birden çok seçebilirsin';

  @override
  String get uiUsersTaskStatusGroup => 'durum';

  @override
  String get uiUsersTaskPriorityGroup => 'öncelik';

  @override
  String get uiUsersTaskGroupLate => 'Gecikmede';

  @override
  String get uiUsersTaskGroupWeek => 'Bu hafta';

  @override
  String get uiUsersTaskGroupLater => 'Sonra';

  @override
  String get uiUsersTaskGroupDone => 'Tamamlanan';

  @override
  String get uiUsersTaskUrgent => 'Acil';

  @override
  String get uiUsersTaskUnknownPriority => 'Bilinmeyen öncelik';

  @override
  String get uiUsersTaskToday => 'bugün';

  @override
  String get uiUsersTaskCompleted => 'tamamlandı';

  @override
  String get uiUsersTaskLateDays => 'gün gecikti';

  @override
  String get uiUsersTaskRemainingDays => 'gün kaldı';

  @override
  String get uiUsersTaskFilesCount => 'dosya';

  @override
  String get uiUsersTaskShowCount => 'görevi göster';

  @override
  String get uiUsersTaskPriorityChip => 'öncelik';

  @override
  String get uiUsersMessage => 'Mesaj';

  @override
  String get uiUsersAssign => 'Görev ata';

  @override
  String get uiUsersEditAccount => 'Hesap ve rolleri düzenle';

  @override
  String get uiUsersMoreActions => 'Diğer işlemler';

  @override
  String get uiUsersPersonalReport => 'Görev raporu (CSV)';

  @override
  String get uiUsersPersonalReportNote =>
      'Seçili programda erişebildiğiniz görevlerin özeti';

  @override
  String get uiUsersAccountAndRoles => 'Hesap ve roller';

  @override
  String get uiUsersSendMessage => 'Mesaj gönder';

  @override
  String get uiUsersReportScope => 'Kapsam';

  @override
  String get uiUsersReportTask => 'Görev';

  @override
  String get uiUsersReportStatus => 'Durum';

  @override
  String get uiUsersReportDue => 'Bitiş';

  @override
  String get uiUsersTaskNoDay => 'Bu gün için görevi yok.';

  @override
  String get uiUsersOpsActive => 'Hesap aktif';

  @override
  String get uiUsersOpsResetLink => 'Şifre sıfırlama bağlantısı gönder';

  @override
  String get uiUsersOpsResetUnavailable =>
      'Bu sunucu e-posta ile sıfırlama bağlantısı göndermiyor.';

  @override
  String get uiUsersOpsDelete => 'Kullanıcıyı sil';

  @override
  String get uiUsersOpsDeleteConfirm =>
      'Bu kullanıcı silinmiş kayıtlara taşınacak ve oturumları kapatılacak.';

  @override
  String get uiUsersOpsSelfDelete =>
      'Kendi hesabınızı bu ekrandan silemezsiniz.';

  @override
  String get uiUsersOpsAdminRequired =>
      'Bu işlem için şirket yöneticisi yetkisi gerekir.';

  @override
  String get uiUsersOpsDeleted => 'Kullanıcı silinmiş kayıtlara taşındı.';

  @override
  String get uiUsersAccountEmail => 'E-posta';

  @override
  String get uiUsersAccountEmailHint => 'Yeni e-posta';

  @override
  String get uiUsersAccountEmailInvalid => 'Geçerli bir e-posta adresi gir';

  @override
  String get uiUsersAccountRoleHeading => 'roller · birden çok seçilebilir';

  @override
  String get uiUsersAccountDepartmentHeading => 'koordinatörlük';

  @override
  String get uiUsersAccountAdminDescription =>
      'Tüm programları ve kullanıcıları yönetir';

  @override
  String get uiUsersAccountCoordinatorDescription =>
      'Koordinatörlükte görevleri ve üyeleri yönetir';

  @override
  String get uiUsersAccountMemberDescription =>
      'Atandığı koordinatörlükte görev alır';

  @override
  String get uiUsersAccountRoleScope =>
      'Rol koordinatörlük bazında atanır. Değiştirilecek koordinatörlüğü seçin.';

  @override
  String get uiUsersAccountGrantAdmin =>
      'Bu kullanıcıya şirket yöneticisi yetkisi verilsin mi?';

  @override
  String get uiUsersAccountRevokeAdmin =>
      'Bu kullanıcının şirket yöneticisi yetkisi kaldırılsın mı?';

  @override
  String get uiUsersAccountAdd => 'Ekle';

  @override
  String get uiUsersAccountAddAsMember => 'Üye olarak ekle';

  @override
  String get uiUsersAccountUnsaved => 'Kaydedilmedi';

  @override
  String get uiUsersAccountCancel => 'Vazgeç';

  @override
  String get uiUsersAccountSave => 'Kaydet';

  @override
  String get uiUsersDraftRoles => 'roller';

  @override
  String get uiUsersDraftAddDepartment => 'Koordinatörlük ekle';

  @override
  String get uiUsersDraftSelected => 'seçili';

  @override
  String get uiUsersDraftInvalid =>
      'Ad soyadı ve geçerli bir e-posta adresini kontrol edin.';

  @override
  String get uiUsersDraftAdminUnknown =>
      'Yönetici yetkisi henüz doğrulanamadı.';

  @override
  String get uiUsersDraftRoleScope =>
      'Admin şirket genelidir. Koordinatör ve Üye seçimi bu programdaki seçili koordinatörlüklere uygulanır.';

  @override
  String get uiUsersDraftSelfConflict =>
      'Kendi yönetici yetkinizi kaldırma ve parola değişikliğini ayrı kaydedin.';
}
