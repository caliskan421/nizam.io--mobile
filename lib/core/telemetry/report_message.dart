import '../i18n/generated/app_localizations_tr.dart';
import '../i18n/generated/error_messages.gen.dart';
import 'error_report.dart';

/// Rapora girebilen SABİT Türkçe teknik açıklama. Hata iletisi (`toString`, `message`),
/// sunucu gövdesi ya da alan metni HİÇBİR koşulda kaynak değildir: metin yalnız kapalı
/// kümelerden ([ReportKind], [ReportErrorType]) ve (varsa) beyaz listeli hata kodunun yerel
/// katalog metninden kurulur. Kullanıcıya gösterilen genel hata iletisiyle aynı kanonik kod.
String reportMessage({
  required ReportKind kind,
  required ReportErrorType errorType,
  String? apiCode,
}) {
  final base = switch (kind) {
    ReportKind.invalidResponse =>
      'Sunucu yanıtı beklenen biçimde ayrıştırılamadı.',
    ReportKind.serverError => 'Sunucu 5xx sınıfında hata döndürdü.',
    ReportKind.streamServerError =>
      'Sunucu, başarılı akış yanıtı içinde teknik hata olayı bildirdi.',
    ReportKind.storage =>
      'Yerel depolama ya da platform hizmeti başarısız oldu.',
    ReportKind.serialization =>
      'Yerel veri ayrıştırılırken ya da eşlenirken tür/biçim hatası oluştu.',
    ReportKind.unexpected => 'Beklenmeyen bir uygulama hatası oluştu.',
    ReportKind.framework => 'Flutter çerçevesi bir hata bildirdi.',
    ReportKind.uncaughtAsync => 'Yakalanmamış eşzamansız hata oluştu.',
    ReportKind.startup => 'Uygulama açılışı başarısız oldu.',
  };
  final type = switch (errorType) {
    ReportErrorType.typeError => 'Tür hatası.',
    ReportErrorType.formatException => 'Biçim hatası.',
    ReportErrorType.stateError => 'Geçersiz durum hatası.',
    ReportErrorType.argumentError => 'Geçersiz bağımsız değişken.',
    ReportErrorType.rangeError => 'Aralık dışı değer.',
    ReportErrorType.unsupportedError => 'Desteklenmeyen işlem.',
    ReportErrorType.assertionError => 'Doğrulama koşulu sağlanmadı.',
    ReportErrorType.fileSystem => 'Dosya sistemi hatası.',
    ReportErrorType.platform => 'Platform hizmeti hatası.',
    ReportErrorType.timeout => 'Zaman aşımı.',
    ReportErrorType.http => 'Ağ hatası.',
    ReportErrorType.other => '',
  };
  final catalog = apiCode == null
      ? null
      : localizedErrorText(AppLocalizationsTr(), apiCode);
  return [
    base,
    if (type.isNotEmpty) type,
    if (catalog != null) 'Hata kodu karşılığı: $catalog',
  ].join(' ');
}
