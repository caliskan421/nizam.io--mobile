// Bütün widget testleri için ortak hazırlık: uygulama yazı tipleri (pubspec `fonts:` →
// FontManifest; Inter 400–700, Poppins 500/600, Geist Mono 400/500, MaterialIcons) gerçek
// ağırlık dosyalarıyla bir kez yüklenir. Motor testte manifest ailelerini kendiliğinden yüklemez;
// yüklenmezse metin FlutterTest (Ahem) yazı tipiyle ölçülür ve ölçü/taşma testleri gerçeği
// yansıtmaz. Eski `google_fonts` yolu bunu yan etkiyle yapıyordu (bkz. design-tokens.md).
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/golden.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Bağlayıcı yalnız yazı tipi yüklemek için kurulur; kurulum `HttpOverrides.global`'ı test
  // sahtesine çevirir. Düz `test`ler (ör. gerçek TLS el sıkışması) önceki davranışı görsün diye
  // geri konur; `testWidgets` kendi ortamını kurar.
  final http = HttpOverrides.current;
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();
  HttpOverrides.global = http;
  await testMain();
}
