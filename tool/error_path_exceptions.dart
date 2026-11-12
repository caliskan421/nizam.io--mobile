// Hata yolu kapsam kapısının (tool/error_paths.dart) istisna listesi. Her öğe: anahtar
// `<lib göreli yol>::<Sınıf.yöntem>#<tür>`, o işlevde izin verilen EN ÇOK yol sayısı ve GERÇEK
// gerekçe. Satır numarasına dayanılmaz (dosya değişince kırılmaz). Envanter
// `docs/yurutme/hata-takibi-kapsam.md`'ye bu dosyadan üretilir; kullanılmayan (bayat) anahtar
// ve kısa gerekçe `test/tool/error_paths_test.dart` ile reddedilir.
//
// Türler: catch, onError, catchError, handleError, guard, asyncError, rawDio, apiCallAlias.
//
// Gerekçe kalıpları (kısaltma yok; her satır kendi başına okunur):
//   GÖZLEMCİ  : hata bir Riverpod sağlayıcı durumuna (AsyncError) gider; ErrorReportingProviderObserver
//               `providerDidFail` ile raporlar (test/app/telemetry/provider_error_observer_test.dart).
//   YENİDEN   : AsyncError, başka bir sağlayıcıdaki ZATEN gözlemlenmiş hatanın yeniden sarılmasıdır
//               (aynı hata nesnesi; ErrorReporting.alreadyHandled tekrarı engeller) ya da beklenen
//               bir ApiError üretir.
//   KUYRUK    : zincir kuyruğunun sürmesi için ayrılmış kol; aynı hata çağıranın await ettiği
//               gelecekte teslim edilir ve orada raporlanır/iletilir.

class ErrorPathException {
  const ErrorPathException(this.max, this.reason);
  final int max;
  final String reason;
}

const errorPathExceptions = <String, ErrorPathException>{
  // --- app/ ---------------------------------------------------------------------------------
  'app/config/firebase_release_policy_source.dart::FirebaseReleasePolicySource._fetch#catch':
      ErrorPathException(
        2,
        'Uzak yapılandırma getirme: (1) biçimsiz önbellek adayı FormatException ve (2) '
        'ağ/SDK/geçersiz aday Exception. İkisi de bilinçli doğrulama sonucudur; son geçerli '
        'politika (zorunlu güncelleme tabanı dahil) korunur ve uzak kaynak kurtarır. Çevrimdışı '
        'açılış her gün olan beklenen durumdur; raporlanırsa rapor fırtınası olur.',
      ),
  'app/config/firebase_services.dart::initializeFirebaseServices#catch':
      ErrorPathException(
        1,
        'Firebase başlatılamadı: raporlayıcının kendisi yoktur (kapı kapalı, raporlanacak '
        'yer yok). SDK hata gövdesi yapılandırma/kimlik içerebileceği için günlüğe de yazılmaz; '
        'sonuç null → denetim görünmez ve hiçbir şey gönderilmez (docs/yurutme/hata-takibi.md).',
      ),
  'app/config/native_release.dart::readNativeRelease#catch': ErrorPathException(
    1,
    'Açılışta, onay okunmadan ÖNCE çalışır; Dart kapısı bu noktada kapalıdır, rapor '
    'üretilemez. Sonuç `invalid` sürümdür ve sürüm politikası bunu açıkça işler.',
  ),
  'app/config/release_policy_host.dart::_ReleasePolicyHostState._refresh#onError':
      ErrorPathException(
        1,
        'GÖZLEMCİ: mobileReleasePolicyProvider hatası ErrorReportingProviderObserver tarafından '
        'raporlanır; burada yalnız unawaited geleceğin hatasının kök bölgeye sızması engellenir.',
      ),
  'app/orientation_policy.dart::_OrientationPolicyHostState._evaluate#catch':
      ErrorPathException(
        1,
        'FlutterView.display erişimi StateError verirse (görünüm henüz bağlı değil) sistem '
        'varsayılanına dönülür; bu çerçevenin belgelenmiş normal durumudur, hata değildir.',
      ),
  // --- core/ --------------------------------------------------------------------------------
  'core/cache_owner.dart::CacheOwnership.ownedOnly#asyncError':
      ErrorPathException(
        1,
        'YENİDEN: sahibi olmayan sağlayıcı durumunda mevcut hata aynı nesneyle taşınır.',
      ),
  'core/config/release_policy_provider.dart::_cachedPolicies#catch':
      ErrorPathException(
        1,
        'GÖZLEMCİ: önbellek okuma hatası Stream.error ile aynı nesne ve yığınla sağlayıcıya '
        'iletilir (yutulmaz); sağlayıcı hatasını gözlemci raporlar.',
      ),
  'core/errors/api_error.dart::toApiError#invalidResponse': ErrorPathException(
    2,
    'Saf dönüştürücü (yan etkisiz): çağıranlar rapor sahibidir — apiCall, `toReportedApiError` '
    've `streamApiError` dönüştürmeden ÖNCE özgün hata ve yığınla raporlar.',
  ),
  'core/errors/api_error.dart::_fromResponse#invalidResponse':
      ErrorPathException(
        1,
        'Saf dönüştürücü: zarfsız yanıt invalid_response olur; apiCall/streamApiError bu ApiError`ı '
        '`reportApiFailure` ile (HTTP durum sınıfıyla) raporlar.',
      ),
  'core/errors/api_error.dart::apiCall#invalidResponse': ErrorPathException(
    1,
    'DTO ayrıştırma hatası invalid_response ApiError`a çevrilir ve HEMEN ARDINDAN aynı catch içinde '
    'özgün hata + yığınla reportApiFailure ile raporlanır.',
  ),
  'core/errors/api_error.dart::invalidResponseError#invalidResponse':
      ErrorPathException(
        1,
        'Raporlu fabrika: ApiError`ı kurar ve aynı işlevde reportApiFailure çağırır.',
      ),
  'core/http/sse.dart::sseJsonObject#invalidResponse': ErrorPathException(
    2,
    'SSE yükü JSON nesnesi değil: çağıranlar (assistant ve chat olay çözücüleri) ApiError`ı '
    'kendi kaynak/işlem/API işlem kimliğiyle raporlar; olay yükü hiçbir koşulda rapora girmez.',
  ),
  'core/errors/api_error.dart::_fromResponse#catch': ErrorPathException(
    1,
    'Sunucu gövdesi hata zarfı biçiminde değil: sonuç client.invalid_response ApiError`dır ve '
    'apiCall bunu `reportApiFailure` ile raporlar (sunucu gövdesi rapora girmez).',
  ),
  'core/http/file_upload.dart::_filePart#catch': ErrorPathException(
    1,
    'Kullanıcının seçtiği dosya okunamıyor (silindi/izin/yer değiştirdi): kullanıcıya '
    'client.file_unreadable gösterilen beklenen durum; dosya yolu/adı hiçbir koşulda rapora girmez.',
  ),
  'core/http/file_upload.dart::_filePart#handleError': ErrorPathException(
    1,
    'Yükleme sırasında dosya akışı kesildi (FileSystemException): file_unreadable beklenen '
    'kullanıcı durumu; yol/ad raporlanmaz.',
  ),
  'core/http/interceptors.dart::AuthInterceptor.onError#catch':
      ErrorPathException(
        1,
        'İSTEK TEKRARINDAKİ hata zincirde `handler.next(e)` ile ilerler; son halka ve apiCall '
        'aynı DioException`ı sınıflandırıp işlem kimliğiyle raporlar.',
      ),
  'core/http/sse.dart::materializeStreamError#catch': ErrorPathException(
    1,
    'Hata yanıtının gövdesi okunamazsa decoded=null olur ve sonuç zarfsız yanıttır; '
    '`streamApiError` bunu invalid_response/5xx olarak raporlar (gövde rapora girmez).',
  ),
  'core/notifications/push_registration_controller.dart::PushRegistrationController.<new>#catchError':
      ErrorPathException(
        1,
        'KUYRUK: `_enqueue` hatayı kendi catchError kolunda reportUnexpected ile raporlayıp '
        'yeniden fırlatır; bu dış kol yalnız unawaited sonucun yakalanmamış kalmasını önler.',
      ),
  'core/notifications/push_registration_controller.dart::PushRegistrationController._enqueue#catchError':
      ErrorPathException(
        1,
        'KUYRUK: zincir kuyruğunun sürmesi için ayrılmış kol; hata `result` üzerinden çağırana '
        'gider ve ilk catchError kolunda zaten raporlanmıştır.',
      ),
  'core/preferences/app_preferences.dart::AppPreferences._confirmConsentWrite#catch':
      ErrorPathException(
        1,
        'Çağıranın 500 ms beklemesi yalnız GECİKME sınırıdır. Zaman aşımı hata değildir; GERÇEK '
        'yazı hatası depo şeridinin kuyruk kolunda (`_queueConsentWrite`) özgün hata ve yığınla '
        'tam bir kez raporlanır — burada ikinci rapor üretilmez (çift rapor/erken-geç ayrımı yok).',
      ),
  'core/preferences/app_preferences.dart::AppPreferences.setReleasePolicy#catch':
      ErrorPathException(
        1,
        'Aynı gecikme sınırı: zaman aşımı hata değildir; gerçek yazı hatası `_releasePolicyWrites` '
        'kuyruk kolunda özgün hata ve yığınla bir kez raporlanır.',
      ),
  'core/scope/scope_controller.dart::ScopeController._enqueue#onError':
      ErrorPathException(
        1,
        'KUYRUK: işlem kuyruğunun sürmesi için ayrılmış kol; hata `run` geleceğiyle çağırana gider.',
      ),
  'core/session/session_controller.dart::SessionController._serial#onError':
      ErrorPathException(
        1,
        'KUYRUK: yazı kuyruğunun sürmesi için ayrılmış kol; hata `run` geleceğiyle çağırana gider.',
      ),
  'core/session/session_controller.dart::SessionController.refresh#onError':
      ErrorPathException(
        1,
        'Tek uçuş yenilemenin sonucu `f` ile çağırana iletilir; bu kol yalnız `_inflight` '
        'temizliği içindir. Yenileme hataları `_rotate` içinde raporlanır (K-05).',
      ),
  // --- features/ ----------------------------------------------------------------------------
  'features/activity/application/activity_query_controller.dart::activityView#asyncError':
      ErrorPathException(
        1,
        'YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır.',
      ),
  'features/administration/application/admin_controller.dart::AdminUsersController.loadMore#asyncError':
      ErrorPathException(
        1,
        'Yalnız `on ApiError` dalında: yetki hatası (organization.not_authorized) beklenen '
        'durumdur ve apiCall kaynağında zaten sınıflandırılmıştır.',
      ),
  'features/administration/application/admin_controller.dart::AdminUsersController.visible#asyncError':
      ErrorPathException(
        4,
        'YENİDEN: yetki yok (beklenen ApiError) ya da katalog/önceki durumun AYNI hata nesnesi '
        'taşınır; kaynak sağlayıcılar gözlemlenir.',
      ),
  'features/administration/presentation/admin_user_profile_page.dart::_AdminUserProfilePageState.build#asyncError':
      ErrorPathException(
        2,
        'YENİDEN: görünüm için aynı hata nesnesi yeniden sarılır.',
      ),
  'features/administration/presentation/administration_page.dart::_AdministrationPageState.build#asyncError':
      ErrorPathException(
        1,
        'YENİDEN: görünüm için aynı hata nesnesi yeniden sarılır.',
      ),
  'features/assistant/data/assistant_api_repository.dart::ApiAssistantRepository.chat#rawDio':
      ErrorPathException(
        1,
        'text/event-stream üretilmiş istemciyle iptal edilebilir akış verilemediği için ham '
        'Dio; hata `streamApiError` ile sınıflandırılır ve işlem kimliği isteğin '
        'üretilmiş `openapi.operationId` metaverisinden (assistantChat) doğrulanarak alınır.',
      ),
  'features/coordinatorships/application/coordinatorship_detail_controller.dart::coordinatorshipDetail#asyncError':
      ErrorPathException(
        2,
        'YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır.',
      ),
  'features/identity/application/logout_controller.dart::LogoutController.signOut#guard':
      ErrorPathException(
        1,
        'GÖZLEMCİ: guard sonucu `state`e atanır; AsyncError durumu providerDidFail ile '
        'raporlanır (test: provider_error_observer_test).',
      ),
  'features/identity/application/password_change_controller.dart::PasswordChangeController.submit#guard':
      ErrorPathException(
        1,
        'GÖZLEMCİ: guard sonucu `state`e atanır; beklenmeyen hata providerDidFail ile raporlanır, '
        'yanlış parola/doğrulama (ApiError) süzülür.',
      ),
  'features/messages/application/chat_actions_controller.dart::ChatActionsController._queue#onError':
      ErrorPathException(
        1,
        'Kendi API`mizin ApiError geri çağrısı (hata yutma değil): `_fly` hatayı raporlayıp '
        'çağıranlara iletir; geri çağrı yalnız anket-kapalı gibi beklenen kodlara tepki verir.',
      ),
  'features/messages/application/chat_actions_controller.dart::ChatActionsController._vote#onError':
      ErrorPathException(
        1,
        'Kendi API`mizin ApiError geri çağrısı: yalnız messaging.poll_closed beklenen koduna '
        'tepki verir; hata başka yerde yutulmaz.',
      ),
  'features/messages/application/messages_providers.dart::chatUnreadBadges#asyncError':
      ErrorPathException(
        1,
        'YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır.',
      ),
  'features/messages/data/chat_api_repository.dart::ApiChatRepository.events#rawDio':
      ErrorPathException(
        1,
        'text/event-stream için ham Dio; hata `streamApiError` ile sınıflandırılır ve işlem '
        'kimliği isteğin doğrulanmış `openapi.operationId` (streamChatEvents) metaverisinden gelir.',
      ),
  'features/messages/presentation/messages_page.dart::_MessagesPageState.build#asyncError':
      ErrorPathException(
        1,
        'YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır.',
      ),
  'features/reports/data/report_pdf_api_repository.dart::ApiReportPdfRepository.open#rawDio':
      ErrorPathException(
        1,
        'PDF gövdesi akış olarak okunur (üretilmiş istemci bayt akışı vermez); hata '
        '`toReportedApiError`/streamApiError ile sınıflandırılır, işlem kimliği isteğin '
        'doğrulanmış metaverisinden (reportWorkloadPdf) alınır.',
      ),
  'features/scope/application/scope_selection_controller.dart::ScopeSelectionController.clear#guard':
      ErrorPathException(
        1,
        'GÖZLEMCİ: guard sonucu `state`e atanır; AsyncError durumu providerDidFail ile raporlanır.',
      ),
  'features/scope/application/scope_selection_controller.dart::ScopeSelectionController.select#guard':
      ErrorPathException(
        1,
        'GÖZLEMCİ: guard sonucu `state`e atanır; AsyncError durumu providerDidFail ile raporlanır.',
      ),
  'features/server/application/server_connect_controller.dart::ServerConnectController.connect#guard':
      ErrorPathException(
        1,
        'GÖZLEMCİ: guard sonucu `state`e atanır; sunucu bağ doğrulama hatalarının beklenenleri '
        '(ApiError) süzülür, beklenmeyen providerDidFail ile raporlanır.',
      ),
  'features/tasks/application/task_list_filter.dart::taskListCatalog#asyncError':
      ErrorPathException(
        1,
        'YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır.',
      ),
  'features/tasks/data/download_sink.dart::FileDownloadSink._reserve#catch':
      ErrorPathException(
        1,
        'Özel oluşturma çakışması (ad dolu) FileSystemException ile gelir ve sıradaki kopya '
        'adına geçilir; ad dolu DEĞİLSE aynı hata koşulsuz kanıtla (typeSync) yeniden '
        'fırlatılır ve `save` çağıranı raporlar. Çakışma normal akıştır, yarışta tek sahip.',
      ),
  'features/tasks/data/download_sink.dart::FileDownloadSink._save#catchError':
      ErrorPathException(
        3,
        'Hata sonrası geçici dosya temizliği (en iyi çaba). Asıl yerel dosya sistemi hatası '
        '`save` içinde FileSystemException olarak raporlanıp yeniden fırlatılır; temizlik '
        'hatası ikincil ve eyleme dönüşmez.',
      ),
  'features/tasks/data/file_upload_picker.dart::FileUploadPicker.pick#catch':
      ErrorPathException(
        1,
        'Platform dosya seçicisinin hatası kullanıcı eylemidir (izin reddi, bulut dosyası '
        'indirilemedi); kullanıcıya client.file_unreadable gösterilir. Raporlanırsa her izin '
        'reddi rapor fırtınası olur; dosya adı/yolu zaten rapora giremez.',
      ),
  'features/tasks/data/task_catalog_api_repository.dart::ApiTaskCatalogRepository._teams#catchError':
      ErrorPathException(
        1,
        'Ekip üyeleri isteğe bağlı zenginleştirmedir: apiCall beklenmeyen hatayı ZATEN '
        'işlem kimliğiyle raporlamıştır; bu kol yalnız eksik ekibi boş liste yapar.',
      ),
  'features/tasks/data/upload_digest.dart::uploadDigest#catch':
      ErrorPathException(
        1,
        'Kullanıcının seçtiği geçici dosya özet çıkarılırken okunamadı (silindi/taşındı): '
        'client.file_unreadable beklenen durumdur; dosya yolu/adı rapora girmez.',
      ),
  'features/tasks/presentation/task_detail_page.dart::TaskDetailPage.build#catch':
      ErrorPathException(
        1,
        'GÖZLEMCİ: taskDetailsProvider hatası sayfadaki banner ile gösterilir ve '
        'providerDidFail ile raporlanır; çekme-yenile closure`ı yalnız tekrar fırlatmayı keser.',
      ),
};
