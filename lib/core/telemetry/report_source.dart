/// Hatanın YAKALANDIĞI yerin kapalı, statik sınıfı (özellik/altyapı alanı). Dinamik sağlayıcı
/// adı, rota ya da serbest metin kaynak olamaz; rapora yalnız [code] sabiti girer.
///
/// Kesin kullanıcı işlemini (bkz. `ReportOperation`) değil, kodun hangi alandan geldiğini
/// söyler: küresel çerçeve/yakalanmamış hata ve sağlayıcı gözlemcisi için işlem bilinmez ve
/// bu sahte kesinlikle atfedilmez (`framework`, `uncaught`, `provider`).
enum ReportSource {
  /// Kaynak bilinmiyor (ör. işlem sınırı dışı doğrudan `ErrorReporting.report`).
  unknown('unknown'),
  app('app'),
  preferences('preferences'),
  secureStorage('secure_storage'),
  session('session'),
  server('server'),
  scope('scope'),
  push('push'),
  network('network'),
  files('files'),
  ui('ui'),
  identity('identity'),
  administration('administration'),
  archive('archive'),
  assistant('assistant'),
  coordinatorships('coordinatorships'),
  meetings('meetings'),
  messages('messages'),
  notifications('notifications'),
  reports('reports'),
  tasks('tasks'),
  timeline('timeline'),
  activity('activity'),
  calendar('calendar'),

  /// Riverpod gözlemcisi: sağlayıcı build/future/stream hatası; hangi sağlayıcı olduğu
  /// BİLİNMEZ ve rapora girmez.
  provider('provider'),

  /// `FlutterError.onError`: işlem bağlamı kesin değildir.
  framework('framework'),

  /// `PlatformDispatcher.onError`: işlem bağlamı kesin değildir.
  uncaught('uncaught');

  const ReportSource(this.code);
  final String code;
}
