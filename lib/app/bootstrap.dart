import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/flavor.dart';
import 'app.dart';

/// Uygulamayı verilen flavor ile başlatır. Bağımlılıkların somut bağı (composition root)
/// burada ve `app/` altındadır; `core/` ve `features/` app'e bağımlı değildir.
void bootstrap(Flavor flavor) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: NizamioApp(flavor: flavor)));
}
