import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_phase.dart';
import '../core/config/flavor.dart';
import '../core/i18n/generated/app_localizations.dart';
import '../core/providers.dart';
import '../core/security/privacy_mask.dart';
import '../core/ui/page/nz_app_nav.dart';
import '../core/ui/theme/app_theme.dart';
import 'dev/catalog_entry_button.dart';
import 'router/app_nav.dart';
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
  // Prototip modu yalnız dev flavor'da vardır (katalogdan açılır; prod'da null).
  late final ValueNotifier<bool>? _prototype =
      ref.read(flavorProvider) == Flavor.dev ? ValueNotifier(false) : null;
  late final GoRouter _router = createRouter(
    _phase,
    devCatalog: ref.read(flavorProvider) == Flavor.dev,
    devPrototype: _prototype,
  );
  late final NzAppNav _nav = GoRouterAppNav(_router, ref);
  final PrivacyMaskController _mask = PrivacyMaskController();
  final ThemeData _light = AppTheme.light();
  final ThemeData _dark = AppTheme.dark();

  @override
  void dispose() {
    _router.dispose();
    _phase.dispose();
    _prototype?.dispose();
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
      builder: (context, child) => NzAppNavScope(
        nav: _nav,
        child: PrivacyMask(
          controller: _mask,
          child: _withDevEntry(child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
