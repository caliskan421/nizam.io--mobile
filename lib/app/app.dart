import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_phase.dart';
import '../core/config/flavor.dart';
import '../core/i18n/generated/app_localizations.dart';
import '../core/providers.dart';
import '../core/security/privacy_mask.dart';
import '../core/theme/generated/tokens.gen.dart';
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
  late final GoRouter _router = createRouter(_phase);
  final PrivacyMaskController _mask = PrivacyMaskController();

  @override
  void dispose() {
    _router.dispose();
    _phase.dispose();
    _mask.dispose();
    super.dispose();
  }

  ThemeData _theme(Brightness b, NizamioColors c) => ThemeData(
    brightness: b,
    colorScheme: ColorScheme.fromSeed(seedColor: c.primary, brightness: b),
    scaffoldBackgroundColor: c.background,
    extensions: [c],
  );

  @override
  Widget build(BuildContext context) {
    ref.listen(appPhaseProvider, (_, next) => _phase.value = next);
    return MaterialApp.router(
      title: 'NIZAM.IO',
      debugShowCheckedModeBanner: ref.watch(flavorProvider) == Flavor.dev,
      theme: _theme(Brightness.light, NizamioColors.light),
      darkTheme: _theme(Brightness.dark, NizamioColors.dark),
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
