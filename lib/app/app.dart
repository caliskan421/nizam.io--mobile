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
import 'dev/catalog_entry_button.dart';
import 'router/router.dart';
import 'router/shell.dart' show openDevCatalog;

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

  bool get _isDev => ref.watch(flavorProvider) == Flavor.dev;

  /// Dev flavor'da katalog giriş noktası (her fazda; katalog fazdan muaftır). Prod'da ağaca
  /// hiç eklenmez.
  Widget _withDevEntry(Widget child) => !_isDev
      ? child
      : Stack(
          textDirection: TextDirection.ltr,
          children: [
            child,
            CatalogEntryButton(onOpen: _openCatalog),
          ],
        );

  void _openCatalog() => openDevCatalog(_router);

  @override
  Widget build(BuildContext context) {
    ref.listen(appPhaseProvider, (_, next) => _phase.value = next);
    return MaterialApp.router(
      title: 'NIZAM.IO',
      debugShowCheckedModeBanner: _isDev,
      theme: _light,
      darkTheme: _dark,
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),
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
        child: _withDevEntry(child ?? const SizedBox.shrink()),
      ),
    );
  }
}
