import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/update_store.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_update_page.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';

import '../../../support/golden.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadAppFonts);

  Future<void> pump(
    WidgetTester tester, {
    UpdateStore store = const UnavailableUpdateStore(),
    VoidCallback? dismiss,
    VoidCallback? recheck,
    bool dark = false,
    double scale = 1,
  }) async {
    final l = await AppLocalizations.delegate.load(const Locale('tr'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          updateStoreProvider.overrideWithValue(store),
          connectivityStateProvider.overrideWith(
            (ref) => ConnectivityState.unknown,
          ),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.dark() : AppTheme.light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: NzUpdatePage(
            title: dismiss == null
                ? l.uiServerUpdateTitle
                : l.uiServerUpdateOptionalTitle,
            message: dismiss == null
                ? l.uiServerUpdateRemoteMessage
                : l.uiServerUpdateOptionalMessage,
            onDismiss: dismiss,
            onRecheck: recheck,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('optional dismissal uses later without a close button', (
    tester,
  ) async {
    var dismissed = 0;
    await pump(tester, dismiss: () => dismissed++, recheck: () {});
    expect(find.bySemanticsLabel('Kapat'), findsNothing);
    await tester.tap(find.text('Daha sonra'));
    expect(dismissed, 1);
  });

  testWidgets(
    'missing store uses update label and retries its unavailable target',
    (tester) async {
      var checked = 0;
      await pump(tester, recheck: () => checked++);
      expect(find.text('Şimdi güncelle'), findsOneWidget);
      expect(find.bySemanticsLabel('Kapat'), findsNothing);
      expect(find.text('Daha sonra'), findsNothing);
      await tester.tap(find.text('Şimdi güncelle'));
      expect(checked, 1);
    },
  );

  testWidgets(
    'store primary opens target and reports failure with working retry',
    (tester) async {
      final store = _Store();
      await pump(tester, store: store, recheck: () {});
      await tester.tap(find.text('Şimdi güncelle'));
      await tester.pumpAndSettle();
      expect(store.calls, 1);
      expect(
        find.text('Mağaza açılamadı. Yeniden deneyebilirsin.'),
        findsOneWidget,
      );
      store.opened = true;
      await tester.tap(find.text('Şimdi güncelle'));
      await tester.pumpAndSettle();
      expect(store.calls, 2);
      expect(
        find.text('Mağaza açılamadı. Yeniden deneyebilirsin.'),
        findsNothing,
      );
    },
  );

  for (final size in [const Size(320, 568), const Size(1024, 1366)]) {
    testWidgets(
      'available store secondary actions wrap without overflow at 2x $size',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await pump(
          tester,
          scale: 2,
          store: _Store(),
          dismiss: () {},
          recheck: () {},
        );
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.text('Daha sonra'), 150);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final size in [const Size(320, 568), const Size(1024, 1366)]) {
    for (final dark in [false, true]) {
      for (final optional in [false, true]) {
        testWidgets(
          'no overflow at 2x text $size dark=$dark optional=$optional',
          (tester) async {
            await tester.binding.setSurfaceSize(size);
            addTearDown(() => tester.binding.setSurfaceSize(null));
            await pump(
              tester,
              scale: 2,
              dark: dark,
              dismiss: optional ? () {} : null,
              recheck: () {},
            );
            expect(tester.takeException(), isNull);
            await tester.scrollUntilVisible(find.text('Şimdi güncelle'), 150);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}

class _Store implements UpdateStore {
  int calls = 0;
  bool opened = false;
  @override
  bool get available => true;
  @override
  Future<bool> open() async {
    calls++;
    return opened;
  }
}
