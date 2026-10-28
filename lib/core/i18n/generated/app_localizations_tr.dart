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
  String get uiArchiveTitle => 'Arşiv';

  @override
  String get uiArchiveFolderTitle => 'Klasör';

  @override
  String get uiButtonsBusy => 'Meşgul';

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
  String get uiCoordSortLate => 'Gecikmeye göre';

  @override
  String get uiCoordSortProgress => 'İlerlemeye göre';

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
  String get uiCoordToastAddForm => 'Koordinatörlük formu açılır';

  @override
  String get uiCoordFlyAllList => 'Tüm liste';

  @override
  String get uiCoordSubUnitsTail => 'alt birim';

  @override
  String get uiCoordPeopleTail => 'kişi';

  @override
  String get uiCoordStateActive => 'Aktif';

  @override
  String get uiCoordMessageTeam => 'Ekibe mesaj';

  @override
  String get uiCoordAssignTask => 'Görev ata';

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
  String get uiCoordPctNoteOf => 'görevden';

  @override
  String get uiCoordPctNoteDone => 'tamamlandı';

  @override
  String get uiCoordSeasonAverage => 'sezon ortalaması';

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
  String get uiCoordUnassigned => 'Koordinatör atanmamış';

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
  String get uiCoordAbout => 'hakkında';

  @override
  String get uiCoordFactParent => 'Üst birim';

  @override
  String get uiCoordFactFounded => 'Kuruluş';

  @override
  String get uiCoordFactVisibility => 'Görünürlük';

  @override
  String get uiCoordVisibilityAll => 'Tüm koordinatörler';

  @override
  String get uiCoordFeed => 'son etkinlik';

  @override
  String get uiCoordMoreActions => 'Diğer işlemler';

  @override
  String get uiCoordMenuTitleTail => 'işlemleri';

  @override
  String get uiCoordMenuEdit => 'Bilgileri düzenle';

  @override
  String get uiCoordToastEditTail => 'düzenleme formu açılır';

  @override
  String get uiCoordMenuMeeting => 'Toplantı planla';

  @override
  String get uiCoordMenuParent => 'Üst birimi değiştir';

  @override
  String get uiCoordToastParent => 'Üst birim seçimi açılır';

  @override
  String get uiCoordMenuMerge => 'Başka koordinatörlükle birleştir';

  @override
  String get uiCoordToastMerge => 'Birleştirme önizlemesi açılır';

  @override
  String get uiCoordMenuDeactivate => 'Pasifleştir';

  @override
  String get uiCoordToastDeactivatedTail =>
      'pasifleştirildi · görevler arşivde kalır';

  @override
  String get uiCoordNotFound => 'Bu koordinatörlük bulunamadı.';

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
  String get uiHomeKpiDoneOf => 'görevden';

  @override
  String get uiHomeKpiDoneTail => 'tanesi bitti';

  @override
  String get uiHomeKpiDoingTail => 'tanesi zamanında';

  @override
  String get uiHomeKpiLateLead => 'Açık görevlerde';

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
  String get uiHomeQaInvite => 'Davet et';

  @override
  String get uiHomeQaReport => 'Rapor';

  @override
  String get uiHomeQaTaskLong => 'Yeni görev';

  @override
  String get uiHomeQaMeetingLong => 'Toplantı oluştur';

  @override
  String get uiHomeQaInviteLong => 'Kullanıcı davet et';

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
  String get uiHomeFilterLabel => 'Koordinatörlük durumu';

  @override
  String get uiHomeFilterAll => 'Tümü';

  @override
  String get uiHomeFilterLate => 'Gecikmesi olan';

  @override
  String get uiHomeFilterOnTrack => 'Yolunda';

  @override
  String get uiHomeFilterUnassigned => 'Koordinatörsüz';

  @override
  String get uiHomeFilterEmpty => 'Bu filtreye uyan koordinatörlük yok.';

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
  String get uiHomeNotifications => 'Bildirimler';

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
  String get uiHomeModuleTracking => 'İş takibi';

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
  String get uiHomeModuleRequests => 'Talepler';

  @override
  String get uiHomeModuleBudget => 'Bütçe';

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
  String get uiIdentityLoginTitle => 'Giriş yap';

  @override
  String get uiIdentityLoginServer => 'Sunucu';

  @override
  String get uiIdentityLoginEmail => 'E-posta';

  @override
  String get uiIdentityLoginPassword => 'Parola';

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
  String get uiIdentitySignOut => 'Çıkış yap';

  @override
  String get uiIdentitySignOutConfirmTitle => 'Çıkış yapılsın mı?';

  @override
  String get uiIdentitySignOutConfirmMessage =>
      'Bu cihazdaki oturum kapatılır.';

  @override
  String get uiIdentityLoginIntro => 'E-posta adresin ve parolanla devam et.';

  @override
  String get uiIdentityLoginSubmitting => 'Giriş yapılıyor…';

  @override
  String get uiIdentityLoginEmailHint => 'ad@alan.com';

  @override
  String get uiIdentityLoginPasswordHint => 'Parolan';

  @override
  String get uiIdentityLoginVersionPrefix => 'v';

  @override
  String get uiInputsPasswordShow => 'Parolayı göster';

  @override
  String get uiInputsPasswordHide => 'Parolayı gizle';

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
  String get uiListsEmptyTitle => 'Gösterilecek kayıt yok';

  @override
  String get uiListsTruncated =>
      'Liste kısaltıldı; yalnız ilk kayıtlar gösteriliyor.';

  @override
  String get uiMessagesTitle => 'Mesajlar';

  @override
  String get uiMessagesChatTitle => 'Sohbet';

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
  String get uiRouterDevCatalogOpen => 'Bileşen kataloğunu aç';

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
  String get uiServerUpdateTitle => 'Güncelleme gerekli';

  @override
  String get uiServerUpdateMessage =>
      'Bu sunucu uygulamanın daha yeni bir sürümünü gerektiriyor. Giriş yapabilmek için uygulamayı güncelleyin.';

  @override
  String get uiServerUpdateApiMessage =>
      'Bu sunucunun API sürümü uygulamayla uyumlu değil. Giriş yapabilmek için uygulamayı güncelleyin ya da sunucu yöneticinize başvurun.';

  @override
  String get uiServerUpdateServer => 'Sunucu';

  @override
  String get uiServerUpdateRequiredVersion => 'Gerekli sürüm';

  @override
  String get uiServerUpdateInstalledVersion => 'Kurulu sürüm';

  @override
  String get uiServerUpdateRecheck => 'Yeniden denetle';

  @override
  String get uiTasksTitle => 'Görevler';

  @override
  String get uiTasksDetailTitle => 'Görev';

  @override
  String get uiTimelineTitle => 'Zaman çizelgesi';

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
      'Yeşil çizgi bugünü gösterir; soldaki kutu bugünün tarihi.';

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
  String get uiTimelineSave => 'Tarihleri kaydet';

  @override
  String get uiTimelineSendRequest => 'Talep olarak gönder';

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
}
