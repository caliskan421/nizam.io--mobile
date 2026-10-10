import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/config/flavor.dart';
import '../core/preferences/theme_mode_controller.dart';
import '../core/providers.dart';
import '../core/server/server_binding.dart';
import 'app.dart';
import 'di/composition.dart';

/// Uygulamayı verilen flavor ile başlatır. Composition root: somut bağlar burada ve
/// `app/` altındadır; `core/` ve `features/` app'e bağımlı değildir.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Yazı tipleri yalnız uygulama varlıklarından (assets/fonts); çalışma anında Google'a
  // istek yok (çevrimdışı açılış, gizlilik). OFL lisans metinleri lisans sayfasına eklenir.
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(_fontLicenses);
  final composition = Composition.create(flavor: flavor);
  // Tercihler runApp'ten önce (tema titreşimi yok). Güvenlik açılış sırası (startup) ayrıdır
  // ve tercihlere bağlı değildir; tercih okuma hatası sistem temasına düşer.
  // Tamamlanmayan platform çağrısı açılışı kilitlemesin (CX-r3-Ö-01): süre aşımında sistem
  // teması ile devam edilir.
  await loadPreferences(composition.locator<ThemeModeController>());
  runApp(
    UncontrolledProviderScope(
      container: composition.container,
      child: const NizamioApp(),
    ),
  );
  await startup(composition.container);
}

/// Tercihleri açılışa sınırlı süre bekletir: tamamlanmayan platform çağrısında [timeout]
/// sonunda sistem temasıyla devam edilir (CX-r3-Ö-01).
Future<void> loadPreferences(
  ThemeModeController theme, {
  Duration timeout = const Duration(milliseconds: 500),
}) => theme.load().timeout(timeout, onTimeout: () {});

Stream<LicenseEntry> _fontLicenses() async* {
  for (final (font, file) in const [
    ('Inter', 'assets/fonts/OFL-Inter.txt'),
    ('JetBrains Mono', 'assets/fonts/OFL-JetBrainsMono.txt'),
  ]) {
    yield LicenseEntryWithLineBreaks([font], await rootBundle.loadString(file));
  }
}

/// Açılış (CX-Ö-03): önce oturum denetleyicisi kurulur (yeniden bağlanma dinleyicisi bağ
/// doğrulamasından ÖNCE kayıtlı olsun); sonra kayıtlı bağ yeniden doğrulanır (sürüm denetimi
/// dahil; farklı kurulum → oturum temizliği); oturum yalnız doğrulanmış bağda ve yalnız
/// belirteç kaydı AYNI kuruluma (instance_id) aitse geri yüklenir.
Future<void> startup(ProviderContainer container) async {
  final session = container.read(sessionControllerProvider);
  final binding = await container.read(serverBindingProvider).restore();
  if (binding is BindingVerified) {
    await session.restore(instanceId: binding.info.instanceId);
  }
}
