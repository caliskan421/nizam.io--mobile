# Hata takibi — hata yolu envanteri ve kapsam

> ÜRETİLMİŞTİR — elle düzenlenmez. `dart run tool/error_path_inventory.dart` ile yeniden yazılır; `--check` (test/tool/error_paths_test.dart) güncel olduğunu doğrular.

Kapsam kapısı (`tool/error_paths.dart`, `make boundaries`): `lib/` altındaki her el yazımı Dart dosyasında hatayı yutan ya da başka hataya çeviren yol, **rapor cephesine** (`reportUnexpected` / `toReportedApiError` / `reportApiFailure` / `streamApiError`) YAKALANAN hata değişkeniyle, HATA konumunda ve `catch` GİRİŞİNDE koşulsuz (önceki `return`/`if`-çıkışı, `if`, `?:`, `&&`, kapanış olmadan) bağlanmak, girişte koşulsuz **iletilmek**, aynı dosyada `implements ExpectedFailure` taşıyan beklenen bir sınıf olmak ya da aşağıdaki **istisna** tablosunda gerekçeli durmak zorundadır. `on ApiError` ve özel (`_`) sınıflar tür adıyla muaf DEĞİLDİR; ApiError de politika yardımcısından geçer. Rapor cephesi adlarını yerel olarak yeniden bildirmek (gölgeleme) E6 ihlalidir. Üretilmiş dosyalar ve `core/telemetry`, `app/telemetry` (raporlayıcı kendi hatasını raporlayamaz: döngü) ölçüt dışıdır.

## Sahip dağılımı

| Sahip | Yol sayısı |
|---|---|
| denetim akışı | 1 |
| iletilir | 15 |
| istisna | 58 |
| rapor | 164 |

Sahip anlamları: `rapor` = hata çevrilmeden/yutulmadan ÖNCE sınıflandırılıp raporlanır (beklenen sınıflar süzülür); `iletilir` = `rethrow`/aynı hata yeniden fırlatılır (üst sınır raporlar); `denetim akışı` = aynı dosyadaki `ExpectedFailure` işaretli beklenen sonuç sınıfı; `istisna` = aşağıdaki gerekçe.

Küresel ağlar (yutulmayan ya da kaçan hatalar için): `FlutterError.onError` (`framework`), `PlatformDispatcher.onError` (`uncaught`), Riverpod `ErrorReportingProviderObserver` (`provider`; `AsyncError` durumları, `AsyncValue.guard`, build/stream hataları). Küresel kaynaklarda işlem **bilinmez**: `op=none` yazılır, sahte atıf yapılmaz.

## İstisnalar (her biri gerekçeli, sayısı sınırlı)

| Anahtar (`dosya::işlev#tür`) | En çok | Gerekçe |
|---|---|---|
| `app/config/firebase_release_policy_source.dart::FirebaseReleasePolicySource._fetch#catch` | 2 | Uzak yapılandırma getirme: (1) biçimsiz önbellek adayı FormatException ve (2) ağ/SDK/geçersiz aday Exception. İkisi de bilinçli doğrulama sonucudur; son geçerli politika (zorunlu güncelleme tabanı dahil) korunur ve uzak kaynak kurtarır. Çevrimdışı açılış her gün olan beklenen durumdur; raporlanırsa rapor fırtınası olur. |
| `app/config/firebase_services.dart::initializeFirebaseServices#catch` | 1 | Firebase başlatılamadı: raporlayıcının kendisi yoktur (kapı kapalı, raporlanacak yer yok). SDK hata gövdesi yapılandırma/kimlik içerebileceği için günlüğe de yazılmaz; sonuç null → denetim görünmez ve hiçbir şey gönderilmez (docs/yurutme/hata-takibi.md). |
| `app/config/native_release.dart::readNativeRelease#catch` | 1 | Açılışta, onay okunmadan ÖNCE çalışır; Dart kapısı bu noktada kapalıdır, rapor üretilemez. Sonuç `invalid` sürümdür ve sürüm politikası bunu açıkça işler. |
| `app/config/release_policy_host.dart::_ReleasePolicyHostState._refresh#onError` | 1 | GÖZLEMCİ: mobileReleasePolicyProvider hatası ErrorReportingProviderObserver tarafından raporlanır; burada yalnız unawaited geleceğin hatasının kök bölgeye sızması engellenir. |
| `app/orientation_policy.dart::_OrientationPolicyHostState._evaluate#catch` | 1 | FlutterView.display erişimi StateError verirse (görünüm henüz bağlı değil) sistem varsayılanına dönülür; bu çerçevenin belgelenmiş normal durumudur, hata değildir. |
| `core/cache_owner.dart::CacheOwnership.ownedOnly#asyncError` | 1 | YENİDEN: sahibi olmayan sağlayıcı durumunda mevcut hata aynı nesneyle taşınır. |
| `core/config/release_policy_provider.dart::_cachedPolicies#catch` | 1 | GÖZLEMCİ: önbellek okuma hatası Stream.error ile aynı nesne ve yığınla sağlayıcıya iletilir (yutulmaz); sağlayıcı hatasını gözlemci raporlar. |
| `core/errors/api_error.dart::_fromResponse#catch` | 1 | Sunucu gövdesi hata zarfı biçiminde değil: sonuç client.invalid_response ApiError`dır ve apiCall bunu `reportApiFailure` ile raporlar (sunucu gövdesi rapora girmez). |
| `core/errors/api_error.dart::_fromResponse#invalidResponse` | 1 | Saf dönüştürücü: zarfsız yanıt invalid_response olur; apiCall/streamApiError bu ApiError`ı `reportApiFailure` ile (HTTP durum sınıfıyla) raporlar. |
| `core/errors/api_error.dart::apiCall#invalidResponse` | 1 | DTO ayrıştırma hatası invalid_response ApiError`a çevrilir ve HEMEN ARDINDAN aynı catch içinde özgün hata + yığınla reportApiFailure ile raporlanır. |
| `core/errors/api_error.dart::invalidResponseError#invalidResponse` | 1 | Raporlu fabrika: ApiError`ı kurar ve aynı işlevde reportApiFailure çağırır. |
| `core/errors/api_error.dart::toApiError#invalidResponse` | 2 | Saf dönüştürücü (yan etkisiz): çağıranlar rapor sahibidir — apiCall, `toReportedApiError` ve `streamApiError` dönüştürmeden ÖNCE özgün hata ve yığınla raporlar. |
| `core/http/file_upload.dart::_filePart#catch` | 1 | Kullanıcının seçtiği dosya okunamıyor (silindi/izin/yer değiştirdi): kullanıcıya client.file_unreadable gösterilen beklenen durum; dosya yolu/adı hiçbir koşulda rapora girmez. |
| `core/http/file_upload.dart::_filePart#handleError` | 1 | Yükleme sırasında dosya akışı kesildi (FileSystemException): file_unreadable beklenen kullanıcı durumu; yol/ad raporlanmaz. |
| `core/http/interceptors.dart::AuthInterceptor.onError#catch` | 1 | İSTEK TEKRARINDAKİ hata zincirde `handler.next(e)` ile ilerler; son halka ve apiCall aynı DioException`ı sınıflandırıp işlem kimliğiyle raporlar. |
| `core/http/sse.dart::materializeStreamError#catch` | 1 | Hata yanıtının gövdesi okunamazsa decoded=null olur ve sonuç zarfsız yanıttır; `streamApiError` bunu invalid_response/5xx olarak raporlar (gövde rapora girmez). |
| `core/http/sse.dart::sseJsonObject#invalidResponse` | 2 | SSE yükü JSON nesnesi değil: çağıranlar (assistant ve chat olay çözücüleri) ApiError`ı kendi kaynak/işlem/API işlem kimliğiyle raporlar; olay yükü hiçbir koşulda rapora girmez. |
| `core/notifications/push_registration_controller.dart::PushRegistrationController.<new>#catchError` | 1 | KUYRUK: `_enqueue` hatayı kendi catchError kolunda reportUnexpected ile raporlayıp yeniden fırlatır; bu dış kol yalnız unawaited sonucun yakalanmamış kalmasını önler. |
| `core/notifications/push_registration_controller.dart::PushRegistrationController._enqueue#catchError` | 1 | KUYRUK: zincir kuyruğunun sürmesi için ayrılmış kol; hata `result` üzerinden çağırana gider ve ilk catchError kolunda zaten raporlanmıştır. |
| `core/preferences/app_preferences.dart::AppPreferences._confirmConsentWrite#catch` | 1 | Çağıranın 500 ms beklemesi yalnız GECİKME sınırıdır. Zaman aşımı hata değildir; GERÇEK yazı hatası depo şeridinin kuyruk kolunda (`_queueConsentWrite`) özgün hata ve yığınla tam bir kez raporlanır — burada ikinci rapor üretilmez (çift rapor/erken-geç ayrımı yok). |
| `core/preferences/app_preferences.dart::AppPreferences.setReleasePolicy#catch` | 1 | Aynı gecikme sınırı: zaman aşımı hata değildir; gerçek yazı hatası `_releasePolicyWrites` kuyruk kolunda özgün hata ve yığınla bir kez raporlanır. |
| `core/scope/scope_controller.dart::ScopeController._enqueue#onError` | 1 | KUYRUK: işlem kuyruğunun sürmesi için ayrılmış kol; hata `run` geleceğiyle çağırana gider. |
| `core/session/session_controller.dart::SessionController._serial#onError` | 1 | KUYRUK: yazı kuyruğunun sürmesi için ayrılmış kol; hata `run` geleceğiyle çağırana gider. |
| `core/session/session_controller.dart::SessionController.refresh#onError` | 1 | Tek uçuş yenilemenin sonucu `f` ile çağırana iletilir; bu kol yalnız `_inflight` temizliği içindir. Yenileme hataları `_rotate` içinde raporlanır (K-05). |
| `features/activity/application/activity_query_controller.dart::activityView#asyncError` | 1 | YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır. |
| `features/administration/application/admin_controller.dart::AdminUsersController.loadMore#asyncError` | 1 | Yalnız `on ApiError` dalında: yetki hatası (organization.not_authorized) beklenen durumdur ve apiCall kaynağında zaten sınıflandırılmıştır. |
| `features/administration/application/admin_controller.dart::AdminUsersController.visible#asyncError` | 4 | YENİDEN: yetki yok (beklenen ApiError) ya da katalog/önceki durumun AYNI hata nesnesi taşınır; kaynak sağlayıcılar gözlemlenir. |
| `features/administration/presentation/admin_user_profile_page.dart::_AdminUserProfilePageState.build#asyncError` | 2 | YENİDEN: görünüm için aynı hata nesnesi yeniden sarılır. |
| `features/administration/presentation/administration_page.dart::_AdministrationPageState.build#asyncError` | 1 | YENİDEN: görünüm için aynı hata nesnesi yeniden sarılır. |
| `features/assistant/data/assistant_api_repository.dart::ApiAssistantRepository.chat#rawDio` | 1 | text/event-stream üretilmiş istemciyle iptal edilebilir akış verilemediği için ham Dio; hata `streamApiError` ile sınıflandırılır ve işlem kimliği isteğin üretilmiş `openapi.operationId` metaverisinden (assistantChat) doğrulanarak alınır. |
| `features/coordinatorships/application/coordinatorship_detail_controller.dart::coordinatorshipDetail#asyncError` | 2 | YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır. |
| `features/identity/application/logout_controller.dart::LogoutController.signOut#guard` | 1 | GÖZLEMCİ: guard sonucu `state`e atanır; AsyncError durumu providerDidFail ile raporlanır (test: provider_error_observer_test). |
| `features/identity/application/password_change_controller.dart::PasswordChangeController.submit#guard` | 1 | GÖZLEMCİ: guard sonucu `state`e atanır; beklenmeyen hata providerDidFail ile raporlanır, yanlış parola/doğrulama (ApiError) süzülür. |
| `features/messages/application/chat_actions_controller.dart::ChatActionsController._queue#onError` | 1 | Kendi API`mizin ApiError geri çağrısı (hata yutma değil): `_fly` hatayı raporlayıp çağıranlara iletir; geri çağrı yalnız anket-kapalı gibi beklenen kodlara tepki verir. |
| `features/messages/application/chat_actions_controller.dart::ChatActionsController._vote#onError` | 1 | Kendi API`mizin ApiError geri çağrısı: yalnız messaging.poll_closed beklenen koduna tepki verir; hata başka yerde yutulmaz. |
| `features/messages/application/messages_providers.dart::chatUnreadBadges#asyncError` | 1 | YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır. |
| `features/messages/data/chat_api_repository.dart::ApiChatRepository.events#rawDio` | 1 | text/event-stream için ham Dio; hata `streamApiError` ile sınıflandırılır ve işlem kimliği isteğin doğrulanmış `openapi.operationId` (streamChatEvents) metaverisinden gelir. |
| `features/messages/presentation/messages_page.dart::_MessagesPageState.build#asyncError` | 1 | YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır. |
| `features/reports/data/report_pdf_api_repository.dart::ApiReportPdfRepository.open#rawDio` | 1 | PDF gövdesi akış olarak okunur (üretilmiş istemci bayt akışı vermez); hata `toReportedApiError`/streamApiError ile sınıflandırılır, işlem kimliği isteğin doğrulanmış metaverisinden (reportWorkloadPdf) alınır. |
| `features/scope/application/scope_selection_controller.dart::ScopeSelectionController.clear#guard` | 1 | GÖZLEMCİ: guard sonucu `state`e atanır; AsyncError durumu providerDidFail ile raporlanır. |
| `features/scope/application/scope_selection_controller.dart::ScopeSelectionController.select#guard` | 1 | GÖZLEMCİ: guard sonucu `state`e atanır; AsyncError durumu providerDidFail ile raporlanır. |
| `features/server/application/server_connect_controller.dart::ServerConnectController.connect#guard` | 1 | GÖZLEMCİ: guard sonucu `state`e atanır; sunucu bağ doğrulama hatalarının beklenenleri (ApiError) süzülür, beklenmeyen providerDidFail ile raporlanır. |
| `features/tasks/application/task_list_filter.dart::taskListCatalog#asyncError` | 1 | YENİDEN: kaynak sağlayıcı hatası aynı nesneyle taşınır. |
| `features/tasks/data/download_sink.dart::FileDownloadSink._reserve#catch` | 1 | Özel oluşturma çakışması (ad dolu) FileSystemException ile gelir ve sıradaki kopya adına geçilir; ad dolu DEĞİLSE aynı hata koşulsuz kanıtla (typeSync) yeniden fırlatılır ve `save` çağıranı raporlar. Çakışma normal akıştır, yarışta tek sahip. |
| `features/tasks/data/download_sink.dart::FileDownloadSink._save#catchError` | 3 | Hata sonrası geçici dosya temizliği (en iyi çaba). Asıl yerel dosya sistemi hatası `save` içinde FileSystemException olarak raporlanıp yeniden fırlatılır; temizlik hatası ikincil ve eyleme dönüşmez. |
| `features/tasks/data/file_upload_picker.dart::FileUploadPicker.pick#catch` | 1 | Platform dosya seçicisinin hatası kullanıcı eylemidir (izin reddi, bulut dosyası indirilemedi); kullanıcıya client.file_unreadable gösterilir. Raporlanırsa her izin reddi rapor fırtınası olur; dosya adı/yolu zaten rapora giremez. |
| `features/tasks/data/task_catalog_api_repository.dart::ApiTaskCatalogRepository._teams#catchError` | 1 | Ekip üyeleri isteğe bağlı zenginleştirmedir: apiCall beklenmeyen hatayı ZATEN işlem kimliğiyle raporlamıştır; bu kol yalnız eksik ekibi boş liste yapar. |
| `features/tasks/data/upload_digest.dart::uploadDigest#catch` | 1 | Kullanıcının seçtiği geçici dosya özet çıkarılırken okunamadı (silindi/taşındı): client.file_unreadable beklenen durumdur; dosya yolu/adı rapora girmez. |
| `features/tasks/presentation/task_detail_page.dart::TaskDetailPage.build#catch` | 1 | GÖZLEMCİ: taskDetailsProvider hatası sayfadaki banner ile gösterilir ve providerDidFail ile raporlanır; çekme-yenile closure`ı yalnız tekrar fırlatmayı keser. |

## Tüm yollar (dosya → işlev → tür → sahip)

| Dosya | İşlev | Tür | Sahip | Adet |
|---|---|---|---|---|
| `app/bootstrap.dart` | `bootstrap` | catch | rapor | 1 |
| `app/config/firebase_release_policy_source.dart` | `FirebaseReleasePolicySource._fetch` | catch | istisna | 2 |
| `app/config/firebase_release_policy_source.dart` | `FirebaseReleasePolicySource._readCached` | catch | rapor | 1 |
| `app/config/firebase_services.dart` | `initializeFirebaseServices` | catch | istisna | 1 |
| `app/config/native_release.dart` | `readNativeRelease` | catch | istisna | 1 |
| `app/config/native_update_store.dart` | `NativeUpdateStore.open` | catch | rapor | 1 |
| `app/config/release_policy_host.dart` | `_ReleasePolicyHostState._refresh` | onError | istisna | 1 |
| `app/orientation_policy.dart` | `_OrientationPolicyHostState._apply` | onError | rapor | 1 |
| `app/orientation_policy.dart` | `_OrientationPolicyHostState._evaluate` | catch | istisna | 1 |
| `core/cache_owner.dart` | `CacheOwnership.ownedOnly` | asyncError | istisna | 1 |
| `core/config/release_policy_provider.dart` | `_cachedPolicies` | catch | istisna | 1 |
| `core/errors/api_error.dart` | `_fromResponse` | catch | istisna | 1 |
| `core/errors/api_error.dart` | `_fromResponse` | invalidResponse | istisna | 1 |
| `core/errors/api_error.dart` | `apiCall` | catch | rapor | 3 |
| `core/errors/api_error.dart` | `apiCall` | invalidResponse | istisna | 1 |
| `core/errors/api_error.dart` | `invalidResponseError` | invalidResponse | istisna | 1 |
| `core/errors/api_error.dart` | `toApiError` | invalidResponse | istisna | 2 |
| `core/http/file_download.dart` | `getBinaryStream` | catch | rapor | 1 |
| `core/http/file_download.dart` | `getBinaryStream` | handleError | rapor | 1 |
| `core/http/file_upload.dart` | `_filePart` | catch | istisna | 1 |
| `core/http/file_upload.dart` | `_filePart` | handleError | istisna | 1 |
| `core/http/interceptors.dart` | `AuthInterceptor.onError` | catch | istisna | 1 |
| `core/http/interceptors.dart` | `AuthInterceptor.onError` | catch | rapor | 1 |
| `core/http/sse.dart` | `materializeStreamError` | catch | istisna | 1 |
| `core/http/sse.dart` | `sseJsonObject` | invalidResponse | istisna | 1 |
| `core/network/connectivity_monitor.dart` | `ConnectivityMonitor.dispose` | catch | rapor | 1 |
| `core/network/connectivity_monitor.dart` | `ConnectivityMonitor.dispose` | onError | rapor | 1 |
| `core/network/connectivity_monitor.dart` | `ConnectivityMonitor.start` | catch | rapor | 1 |
| `core/network/connectivity_monitor.dart` | `ConnectivityMonitor.start` | onError | rapor | 1 |
| `core/notifications/push_registration_controller.dart` | `PushRegistrationController.<new>` | catchError | istisna | 1 |
| `core/notifications/push_registration_controller.dart` | `PushRegistrationController.<new>` | onError | rapor | 1 |
| `core/notifications/push_registration_controller.dart` | `PushRegistrationController._enqueue` | catchError | istisna | 1 |
| `core/notifications/push_registration_controller.dart` | `PushRegistrationController._enqueue` | catchError | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences._confirmConsentWrite` | catch | istisna | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences._queueConsentWrite` | onError | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences._read` | catch | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences._revertToClosed` | catch | iletilir | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences._revertToClosed` | catch | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences._write` | catch | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences.errorReportingConsent` | catch | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences.releasePolicy` | catch | rapor | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences.setReleasePolicy` | catch | istisna | 1 |
| `core/preferences/app_preferences.dart` | `AppPreferences.setReleasePolicy` | onError | rapor | 1 |
| `core/refresh.dart` | `refreshWithFeedback` | catch | rapor | 1 |
| `core/scope/scope_controller.dart` | `ScopeController._attempt` | catch | rapor | 1 |
| `core/scope/scope_controller.dart` | `ScopeController._enqueue` | onError | istisna | 1 |
| `core/scope/scope_controller.dart` | `ScopeController.restore` | catch | rapor | 1 |
| `core/scope/scope_store.dart` | `ScopeStore.load` | catch | rapor | 1 |
| `core/server/server_binding.dart` | `ServerBindingController._loadSaved` | catch | rapor | 1 |
| `core/server/server_binding.dart` | `ServerBindingController.verify` | catch | rapor | 3 |
| `core/session/session_controller.dart` | `SessionController._attempt` | catch | rapor | 1 |
| `core/session/session_controller.dart` | `SessionController._rotate` | catch | rapor | 2 |
| `core/session/session_controller.dart` | `SessionController._serial` | onError | istisna | 1 |
| `core/session/session_controller.dart` | `SessionController.refresh` | onError | istisna | 1 |
| `core/session/session_controller.dart` | `SessionController.restore` | catch | rapor | 1 |
| `core/session/token_pair.dart` | `TokenPair.decode` | catch | rapor | 1 |
| `core/stale_clock.dart` | `StaleClock.refreshIfStale` | catch | rapor | 1 |
| `core/storage/flutter_secure_store.dart` | `FlutterSecureStore._guard` | catch | rapor | 1 |
| `core/ui/page/nz_page.dart` | `_guardedRefresh` | catch | rapor | 1 |
| `features/activity/application/activity_query_controller.dart` | `activityView` | asyncError | istisna | 1 |
| `features/administration/application/admin_controller.dart` | `<top>` | catch | rapor | 1 |
| `features/administration/application/admin_controller.dart` | `AdminUsersController.build` | catch | iletilir | 1 |
| `features/administration/application/admin_controller.dart` | `AdminUsersController.loadMore` | asyncError | istisna | 1 |
| `features/administration/application/admin_controller.dart` | `AdminUsersController.loadMore` | catch | iletilir | 1 |
| `features/administration/application/admin_controller.dart` | `AdminUsersController.visible` | asyncError | istisna | 4 |
| `features/administration/application/admin_transfer_controller.dart` | `AdminTransferController.execute` | catch | iletilir | 1 |
| `features/administration/application/user_account_draft_controller.dart` | `UserAccountDraftController.save` | catch | denetim akışı | 1 |
| `features/administration/application/user_account_draft_controller.dart` | `UserAccountDraftController.save` | catch | rapor | 2 |
| `features/administration/presentation/admin_deleted_records.dart` | `_AdminDeletedRecordsState.build` | catch | rapor | 1 |
| `features/administration/presentation/admin_management_tools.dart` | `AdminManagementTools.build` | catch | rapor | 1 |
| `features/administration/presentation/admin_program_actions.dart` | `AdminProgramActions.build` | catch | rapor | 1 |
| `features/administration/presentation/admin_transfer_panel.dart` | `_AdminTransferPanelState.build` | catch | rapor | 1 |
| `features/administration/presentation/admin_user_account_operations.dart` | `AdminUserAccountOperations.build` | catch | rapor | 2 |
| `features/administration/presentation/admin_user_actions.dart` | `AdminUserActions.build` | catch | rapor | 1 |
| `features/administration/presentation/admin_user_memberships.dart` | `AdminUserMemberships.build` | catch | rapor | 2 |
| `features/administration/presentation/admin_user_profile_page.dart` | `_AdminUserProfilePageState.build` | asyncError | istisna | 2 |
| `features/administration/presentation/admin_user_report.dart` | `exportAdminUserReport` | catch | rapor | 1 |
| `features/administration/presentation/administration_page.dart` | `_AdministrationPageState.build` | asyncError | istisna | 1 |
| `features/administration/presentation/administration_page.dart` | `_AdministrationPageState.build` | catch | rapor | 1 |
| `features/archive/application/archive_actions_controller.dart` | `ArchiveActionsController._run` | catch | rapor | 1 |
| `features/archive/application/archive_actions_controller.dart` | `ArchiveActionsController._send` | catch | rapor | 2 |
| `features/archive/application/archive_controller.dart` | `ArchiveController.downloadAll` | catch | rapor | 1 |
| `features/archive/application/archive_files_controller.dart` | `ArchiveFilesController.loadMore` | catch | rapor | 1 |
| `features/archive/application/person_files_controller.dart` | `PersonFilesController.loadMore` | catch | rapor | 1 |
| `features/archive/presentation/open_archive_file.dart` | `openArchiveFile` | catch | rapor | 1 |
| `features/archive/presentation/person_files.dart` | `_PersonFilesState._download` | catch | rapor | 1 |
| `features/assistant/application/assistant_controller.dart` | `AssistantController.delete` | catch | rapor | 1 |
| `features/assistant/application/assistant_controller.dart` | `AssistantController.open` | catch | rapor | 1 |
| `features/assistant/application/assistant_controller.dart` | `AssistantController.send` | onError | rapor | 1 |
| `features/assistant/data/assistant_api_repository.dart` | `ApiAssistantRepository._call` | catch | rapor | 1 |
| `features/assistant/data/assistant_api_repository.dart` | `ApiAssistantRepository._event` | catch | rapor | 1 |
| `features/assistant/data/assistant_api_repository.dart` | `ApiAssistantRepository.chat` | catch | iletilir | 1 |
| `features/assistant/data/assistant_api_repository.dart` | `ApiAssistantRepository.chat` | catch | rapor | 4 |
| `features/assistant/data/assistant_api_repository.dart` | `ApiAssistantRepository.chat` | rawDio | istisna | 1 |
| `features/coordinatorships/application/coordinatorship_detail_controller.dart` | `coordinatorshipDetail` | asyncError | istisna | 2 |
| `features/coordinatorships/application/coordinatorship_form_controller.dart` | `CoordinatorshipFormController.create` | catch | rapor | 3 |
| `features/coordinatorships/application/coordinatorship_form_controller.dart` | `CoordinatorshipFormController.edit` | catch | rapor | 2 |
| `features/coordinatorships/presentation/coord_archive_meetings_tabs.dart` | `CoordArchiveTab.build` | catch | rapor | 2 |
| `features/identity/application/identity_service.dart` | `IdentityService.logout` | catch | rapor | 1 |
| `features/identity/application/identity_service.dart` | `IdentityService.me` | catch | iletilir | 1 |
| `features/identity/application/login_controller.dart` | `LoginController.submit` | catch | rapor | 1 |
| `features/identity/application/login_controller.dart` | `LoginController.submit` | guard | rapor | 1 |
| `features/identity/application/logout_controller.dart` | `LogoutController.signOut` | guard | istisna | 1 |
| `features/identity/application/password_change_controller.dart` | `PasswordChangeController.submit` | guard | istisna | 1 |
| `features/meetings/application/meeting_room_agenda.dart` | `MeetingRoomAgenda.addAgenda` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_agenda.dart` | `MeetingRoomAgenda.deleteAgenda` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_agenda.dart` | `MeetingRoomAgenda.toggleAgenda` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController._commitDelete` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.addNote` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.addParticipants` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.deleteMeeting` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.endConference` | catch | rapor | 2 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.refresh` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.removeParticipant` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.startConference` | catch | rapor | 1 |
| `features/meetings/application/meeting_room_controller.dart` | `MeetingRoomController.updateNote` | catch | rapor | 1 |
| `features/meetings/application/meetings_controller.dart` | `MeetingsBoardController.purge` | catch | rapor | 1 |
| `features/meetings/application/meetings_controller.dart` | `MeetingsBoardController.refresh` | catch | rapor | 1 |
| `features/meetings/application/meetings_controller.dart` | `MeetingsBoardController.restore` | catch | rapor | 1 |
| `features/meetings/presentation/meeting_people.dart` | `_MeetingPeopleState._showAdd` | catch | rapor | 1 |
| `features/messages/application/chat_actions_controller.dart` | `ChatActionsController._closePoll` | catch | iletilir | 1 |
| `features/messages/application/chat_actions_controller.dart` | `ChatActionsController._fly` | catch | rapor | 1 |
| `features/messages/application/chat_actions_controller.dart` | `ChatActionsController._queue` | onError | istisna | 1 |
| `features/messages/application/chat_actions_controller.dart` | `ChatActionsController._togglePin` | catch | iletilir | 1 |
| `features/messages/application/chat_actions_controller.dart` | `ChatActionsController._vote` | onError | istisna | 1 |
| `features/messages/application/chat_members_controller.dart` | `ChatMembersController.refresh` | catch | rapor | 1 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController._delete` | catch | rapor | 1 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController._deliver` | catch | rapor | 2 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController._edit` | catch | iletilir | 1 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController._enqueue` | catch | rapor | 1 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController._reloadPins` | catch | rapor | 1 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController.build` | onError | rapor | 2 |
| `features/messages/application/chat_room_controller.dart` | `ChatRoomController.loadOlder` | catch | rapor | 1 |
| `features/messages/application/chat_room_presence.dart` | `_RoomPresence._typingSignal` | catch | rapor | 1 |
| `features/messages/application/chat_room_read.dart` | `_RoomRead._markRead` | catch | rapor | 1 |
| `features/messages/application/chat_room_reconcile.dart` | `_RoomHistory._fetchNewer` | catch | rapor | 1 |
| `features/messages/application/chat_room_reconcile.dart` | `_RoomHistory._refreshInfo` | catch | rapor | 1 |
| `features/messages/application/chat_search_controller.dart` | `ChatSearchController.more` | catch | iletilir | 1 |
| `features/messages/application/chat_search_controller.dart` | `ChatSearchController.search` | catch | iletilir | 1 |
| `features/messages/application/chat_shared_controller.dart` | `ChatSharedController.more` | catch | iletilir | 1 |
| `features/messages/application/chat_sync_controller.dart` | `ChatSyncController._run` | onError | rapor | 1 |
| `features/messages/application/chats_controller.dart` | `ChatsController.refresh` | catch | rapor | 1 |
| `features/messages/application/messages_providers.dart` | `chatUnreadBadges` | asyncError | istisna | 1 |
| `features/messages/application/new_chat_controller.dart` | `NewChatController.createGroup` | catch | iletilir | 1 |
| `features/messages/application/new_chat_controller.dart` | `NewChatController.createGroup` | catch | rapor | 1 |
| `features/messages/data/chat_api_repository.dart` | `ApiChatRepository._event` | catch | rapor | 1 |
| `features/messages/data/chat_api_repository.dart` | `ApiChatRepository.events` | catch | iletilir | 1 |
| `features/messages/data/chat_api_repository.dart` | `ApiChatRepository.events` | catch | rapor | 3 |
| `features/messages/data/chat_api_repository.dart` | `ApiChatRepository.events` | rawDio | istisna | 1 |
| `features/messages/presentation/chat/chat_find_sheets.dart` | `_SearchState._run` | catch | rapor | 1 |
| `features/messages/presentation/chat/chat_find_sheets.dart` | `_SharedState._run` | catch | rapor | 1 |
| `features/messages/presentation/chat/chat_group_source_info.dart` | `_ChatGroupSourceInfoState._change` | catch | rapor | 1 |
| `features/messages/presentation/chat/chat_info_sheet.dart` | `_Members._run` | catch | rapor | 1 |
| `features/messages/presentation/chat/new_chat_sheet.dart` | `_NewChatState._run` | catch | rapor | 1 |
| `features/messages/presentation/chat_page.dart` | `_ChatPageState._actions` | catch | rapor | 1 |
| `features/messages/presentation/chat_page.dart` | `_ChatPageState._send` | catch | rapor | 1 |
| `features/messages/presentation/chat_page.dart` | `_ChatPageState._try` | catch | rapor | 1 |
| `features/messages/presentation/messages_page.dart` | `_MessagesPageState._markAllRead` | catch | rapor | 1 |
| `features/messages/presentation/messages_page.dart` | `_MessagesPageState.build` | asyncError | istisna | 1 |
| `features/messages/presentation/open_person_chat.dart` | `openPersonChat` | catch | rapor | 1 |
| `features/notifications/application/notifications_controller.dart` | `NotificationUnreadController.refresh` | catch | rapor | 1 |
| `features/notifications/application/notifications_controller.dart` | `NotificationsController.loadMore` | catch | rapor | 1 |
| `features/notifications/application/notifications_controller.dart` | `NotificationsController.markAllRead` | catch | rapor | 1 |
| `features/notifications/application/notifications_controller.dart` | `NotificationsController.markRead` | catch | rapor | 1 |
| `features/notifications/application/notifications_controller.dart` | `NotificationsController.refresh` | catch | rapor | 1 |
| `features/reports/data/report_pdf_api_repository.dart` | `ApiReportPdfRepository._bytes` | catch | rapor | 1 |
| `features/reports/data/report_pdf_api_repository.dart` | `ApiReportPdfRepository.open` | catch | rapor | 1 |
| `features/reports/data/report_pdf_api_repository.dart` | `ApiReportPdfRepository.open` | rawDio | istisna | 1 |
| `features/reports/presentation/report_details.dart` | `ReportPdfButton.build` | catch | rapor | 1 |
| `features/scope/application/home_dashboard_controller.dart` | `HomeDashboardController._load` | catch | iletilir | 1 |
| `features/scope/application/home_dashboard_controller.dart` | `HomeDashboardController._refresh` | catch | rapor | 2 |
| `features/scope/application/scope_selection_controller.dart` | `ScopeSelectionController.clear` | guard | istisna | 1 |
| `features/scope/application/scope_selection_controller.dart` | `ScopeSelectionController.select` | guard | istisna | 1 |
| `features/server/application/server_connect_controller.dart` | `ServerConnectController.connect` | guard | istisna | 1 |
| `features/tasks/application/invite_form_controller.dart` | `InviteFormController.submit` | catch | rapor | 1 |
| `features/tasks/application/meeting_form_controller.dart` | `MeetingFormController.submit` | catch | rapor | 1 |
| `features/tasks/application/quick_forms_controller.dart` | `NewTaskFormController.submit` | catch | rapor | 3 |
| `features/tasks/application/task_catalog_controller.dart` | `TaskCatalogController.reload` | catch | rapor | 1 |
| `features/tasks/application/task_detail_controller.dart` | `TaskDetailController._reread` | catch | rapor | 1 |
| `features/tasks/application/task_detail_controller.dart` | `TaskDetailController._writeKeyed` | catch | rapor | 1 |
| `features/tasks/application/task_detail_controller.dart` | `TaskDetailController._write` | catch | rapor | 2 |
| `features/tasks/application/task_detail_controller.dart` | `TaskDetailController.downloadFile` | catch | rapor | 1 |
| `features/tasks/application/task_detail_controller.dart` | `TaskDetailController.openEdit` | catch | rapor | 1 |
| `features/tasks/application/task_detail_upload.dart` | `_UploadFlow.pickUploadFile` | catch | rapor | 1 |
| `features/tasks/application/task_detail_upload.dart` | `_UploadFlow.submitUpload` | catch | rapor | 1 |
| `features/tasks/application/task_list_filter.dart` | `taskListCatalog` | asyncError | istisna | 1 |
| `features/tasks/application/task_list_filter.dart` | `taskListPage` | catch | rapor | 1 |
| `features/tasks/application/tasks_providers.dart` | `meetingInvitees` | catch | rapor | 1 |
| `features/tasks/data/download_sink.dart` | `FileDownloadSink._reserve` | catch | istisna | 1 |
| `features/tasks/data/download_sink.dart` | `FileDownloadSink._save` | catchError | istisna | 3 |
| `features/tasks/data/download_sink.dart` | `FileDownloadSink.save` | catch | rapor | 1 |
| `features/tasks/data/file_upload_picker.dart` | `FileUploadPicker.pick` | catch | istisna | 1 |
| `features/tasks/data/task_catalog_api_repository.dart` | `ApiTaskCatalogRepository._teams` | catchError | istisna | 1 |
| `features/tasks/data/upload_digest.dart` | `uploadDigest` | catch | istisna | 1 |
| `features/tasks/presentation/deleted_tasks_page.dart` | `DeletedTasksPage.build` | catch | rapor | 2 |
| `features/tasks/presentation/detail/task_dependencies.dart` | `TaskDependencies.build` | catch | rapor | 1 |
| `features/tasks/presentation/task_detail_page.dart` | `TaskDetailPage.build` | catch | istisna | 1 |
| `features/timeline/application/timeline_controller.dart` | `TimelineController.requestDates` | catch | rapor | 3 |
| `features/timeline/presentation/timeline_page.dart` | `_TimelinePageState._request` | catch | rapor | 1 |
| `features/timeline/presentation/timeline_page.dart` | `_TimelinePageState._save` | catch | rapor | 1 |
| `features/timeline/presentation/timeline_page.dart` | `_TimelinePageState._undo` | catch | rapor | 1 |
