// ref_ext: oturum bitti kodları; listenErrors (toast, ayıklama, tekrar yok); listenSuccess.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/api/generated/error_catalog.gen.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/ui/extensions/ref_ext.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';

late Future<int> Function() _factory;
final _p = FutureProvider<int>((ref) => _factory());

/// Elle sürülen AsyncValue: sayaç artınca AYNI hata nesnesiyle yeni AsyncError üretir.
final _tick = NotifierProvider<_Tick, int>(_Tick.new);

class _Tick extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

Object _sameError = ApiError(ClientErrorCode.timeout);
final _manual = Provider<AsyncValue<int>>((ref) {
  final n = ref.watch(_tick);
  return AsyncError<int>(_sameError, StackTrace.fromString('s$n'));
});

class _Errors extends ConsumerWidget {
  const _Errors(this.provider);
  final ProviderListenable<AsyncValue<int>> provider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenErrors(provider, context);
    return const Text('ekran');
  }
}

class _Success extends ConsumerWidget {
  const _Success(this.onData);
  final void Function(int) onData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenSuccess(_p, onData);
    ref.watch(_p);
    return const Text('ekran');
  }
}

Future<ProviderContainer> _pump(WidgetTester tester, Widget body) async {
  final container = ProviderContainer(retry: (_, _) => null);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: body),
      ),
    ),
  );
  return container;
}

String _text(WidgetTester tester, ApiError e) =>
    errorText(AppLocalizations.of(tester.element(find.text('ekran'))), e);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('sessionEndedErrorCodes', () {
    test('en az istenen dört kod; client.* sabitlerden', () {
      expect(
        sessionEndedErrorCodes,
        containsAll(<String>[
          ClientErrorCode.sessionEnded,
          ClientErrorCode.notSignedIn,
          ClientErrorCode.reauthRequired,
          'identity.force_password_change_required',
        ]),
      );
      expect(
        sessionEndedErrorCodes.where((c) => c.startsWith('client.')),
        everyElement(isIn(ClientErrorCode.all)),
      );
    });

    test('sunucu kodu errorCatalog\'da var', () {
      for (final c in sessionEndedErrorCodes.where(
        (c) => !c.startsWith('client.'),
      )) {
        expect(errorCatalog, contains(c));
      }
    });

    test('scope_missing ve ağ hataları listede yok (kullanıcı görmeli)', () {
      expect(
        sessionEndedErrorCodes,
        isNot(contains(ClientErrorCode.scopeMissing)),
      );
      expect(
        sessionEndedErrorCodes,
        isNot(contains(ClientErrorCode.networkError)),
      );
    });
  });

  group('listenErrors', () {
    testWidgets('AsyncError\'a geçişte toast; ilk build veri iken yok', (
      tester,
    ) async {
      _factory = () async => 1;
      final container = await _pump(tester, _Errors(_p));
      await tester.pump();
      expect(find.byType(SnackBar), findsNothing);

      final err = ApiError(ClientErrorCode.timeout);
      _factory = () => Future.error(err);
      container.invalidate(_p);
      await tester.pump();
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(_text(tester, err)), findsOneWidget);
    });

    testWidgets('ApiError dışı istisna invalid_response metniyle', (
      tester,
    ) async {
      _factory = () => Future.error(StateError('ham'));
      await _pump(tester, _Errors(_p));
      await tester.pump();
      await tester.pump();
      expect(
        find.text(_text(tester, ApiError(ClientErrorCode.invalidResponse))),
        findsOneWidget,
      );
      expect(find.textContaining('ham'), findsNothing);
    });

    for (final code in sessionEndedErrorCodes) {
      testWidgets('oturum bitti kodu ($code) toast göstermez', (tester) async {
        _factory = () => Future.error(ApiError(code));
        await _pump(tester, _Errors(_p));
        await tester.pump();
        await tester.pump();
        expect(find.byType(SnackBar), findsNothing);
      });
    }

    testWidgets('aynı hata nesnesi tekrar bildirilmez; yeni hata bildirilir', (
      tester,
    ) async {
      _sameError = ApiError(ClientErrorCode.timeout);
      final container = await _pump(tester, _Errors(_manual));
      container.read(_tick.notifier).bump();
      await tester.pump();
      await tester.pump();
      container.read(_tick.notifier).bump();
      await tester.pump();
      // İlk toast gösterildi; kapat, aynı hata tekrar gelse de yeni toast çıkmamalı.
      ScaffoldMessenger.of(tester.element(find.text('ekran')))
          .removeCurrentSnackBar();
      await tester.pump();
      expect(find.byType(SnackBar), findsNothing);
      container.read(_tick.notifier).bump();
      await tester.pump();
      await tester.pump();
      expect(find.byType(SnackBar), findsNothing, reason: 'aynı hata');

      _sameError = ApiError(ClientErrorCode.networkError);
      container.read(_tick.notifier).bump();
      await tester.pump();
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget, reason: 'yeni hata');
    });
  });

  group('listenSuccess', () {
    testWidgets(
      'ilk build\'de tetiklenmez; yükleniyor → veri geçişinde bir kez',
      (tester) async {
        final c = Completer<int>();
        _factory = () => c.future;
        final got = <int>[];
        await _pump(tester, _Success(got.add));
        expect(got, isEmpty);
        c.complete(7);
        await tester.pump();
        await tester.pump();
        expect(got, [7]);
      },
    );

    testWidgets('veri zaten varken ilk build tetiklemez; yenilemede tetikler', (
      tester,
    ) async {
      _factory = () async => 1;
      final got = <int>[];
      final container = await _pump(tester, _Success(got.add));
      await tester.pump();
      await tester.pump();
      // ilk yükleme (loading → data) bir kez
      expect(got, [1]);
      _factory = () async => 2;
      container.invalidate(_p);
      await tester.pump();
      await tester.pump();
      expect(got, [1, 2]);
    });

    testWidgets('yükleniyor → hata tetiklemez', (tester) async {
      _factory = () => Future.error(ApiError(ClientErrorCode.timeout));
      final got = <int>[];
      await _pump(tester, _Success(got.add));
      await tester.pump();
      await tester.pump();
      expect(got, isEmpty);
    });
  });
}
