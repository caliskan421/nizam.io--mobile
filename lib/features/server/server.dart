/// server özelliğinin açık yüzü: sunucu bağlama ve "güncelleme gerekli" ekranları. Bağ
/// doğrulaması core `ServerBindingController`'dadır; bu özellik onu kullanan ekran katmanıdır.
/// Başka feature'lar ve `app/` yalnız bu dosyayı import eder (sınır kuralı B3).
library;

export 'presentation/server_page.dart' show ServerPage;
export 'presentation/update_required_page.dart' show UpdateRequiredPage;
