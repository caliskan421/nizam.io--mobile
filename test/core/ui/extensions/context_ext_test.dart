// BuildContext uzantısı: tema rolleri, ThemeData ve ARB metni tek erişim yolundan gelir.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<BuildContext> pump(WidgetTester tester, ThemeMode mode) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return ctx;
  }

  testWidgets('açık modda colors/text/theme/l10n', (tester) async {
    final c = await pump(tester, ThemeMode.light);
    expect(c.colors, same(NizamioColors.light));
    expect(c.text.bodyMd.color, NizamioColors.light.text);
    expect(c.theme.brightness, Brightness.light);
    expect(c.l10n.uiCommonRetry, 'Yeniden dene');
  });

  testWidgets('koyu modda aynı getter koyu rolleri verir', (tester) async {
    final c = await pump(tester, ThemeMode.dark);
    expect(c.colors, same(NizamioColors.dark));
    expect(c.text.titleMd.color, NizamioColors.dark.text);
    expect(c.theme.brightness, Brightness.dark);
  });
}
