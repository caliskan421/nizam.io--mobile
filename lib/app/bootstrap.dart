import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/flavor.dart';
import '../core/providers.dart';
import '../core/server/server_binding.dart';
import 'app.dart';
import 'di/composition.dart';

/// Uygulamayı verilen flavor ile başlatır. Composition root: somut bağlar burada ve
/// `app/` altındadır; `core/` ve `features/` app'e bağımlı değildir.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final composition = Composition.create(flavor: flavor);
  runApp(
    UncontrolledProviderScope(
      container: composition.container,
      child: const NizamioApp(),
    ),
  );
  await startup(composition.container);
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
