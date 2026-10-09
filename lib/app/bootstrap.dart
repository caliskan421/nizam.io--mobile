import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/flavor.dart';
import '../core/providers.dart';
import '../core/server/server_binding.dart';
import 'app.dart';

/// Uygulamayı verilen flavor ile başlatır. Composition root: somut bağlar burada ve
/// `app/` altındadır; `core/` ve `features/` app'e bağımlı değildir.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer(
    overrides: [flavorProvider.overrideWithValue(flavor)],
  );
  runApp(
    UncontrolledProviderScope(container: container, child: const NizamioApp()),
  );
  await startup(container);
}

/// Açılış: kayıtlı sunucu bağı her açılışta yeniden doğrulanır (sürüm denetimi dahil);
/// oturum yalnız doğrulanmış bağda geri yüklenir.
Future<void> startup(ProviderContainer container) async {
  final binding = await container.read(serverBindingProvider).restore();
  if (binding is BindingVerified) {
    await container.read(sessionControllerProvider).restore();
  }
}
