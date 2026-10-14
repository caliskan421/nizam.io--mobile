import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_phase.dart';
import '../core/config/flavor.dart';
import '../core/i18n/generated/app_localizations.dart';
import '../core/providers.dart';
import '../core/security/privacy_mask.dart';
import '../core/ui/theme/app_theme.dart';
import 'router.dart';

/// Minimal kabuk: tema token'ları, TR yerelleştirme, durum makinesinden türetilen router ve
/// arka plan maskesi. Ekran yoktur (D-0174).
class NizamioApp extends ConsumerStatefulWidget {
  const NizamioApp({super.key});

  @override
  ConsumerState<NizamioApp> createState() => _NizamioAppState();
}

class _NizamioAppState extends ConsumerState<NizamioApp> {
  late final ValueNotifier<AppPhase> _phase = ValueNotifier(
    ref.read(appPhaseProvider),
  );
  late final GoRouter _router = createRouter(
    _phase,
    devCatalog: ref.read(flavorProvider) == Flavor.dev,
  );
  final PrivacyMaskController _mask = PrivacyMaskController();
  final ThemeData _light = AppTheme.light();
  final ThemeData _dark = AppTheme.dark();

  @override
  void dispose() {
    _router.dispose();
    _phase.dispose();
    _mask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appPhaseProvider, (_, next) => _phase.value = next);
    return MaterialApp.router(
      title: 'NIZAM.IO',
      debugShowCheckedModeBanner: ref.watch(flavorProvider) == Flavor.dev,
      theme: _light,
      darkTheme: _dark,
      themeMode: ref.watch(themeModeProvider),
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      builder: (context, child) => PrivacyMask(
        controller: _mask,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
