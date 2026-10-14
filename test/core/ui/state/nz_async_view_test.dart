// NzAsyncView: yükleniyor / hata / boş / veri; yenilemede eski veri.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/ui/state/nz_async_view.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_error_state.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_loader.dart';

late Future<int> Function() _factory;
final _p = FutureProvider<int>((ref) => _factory());

class _View extends ConsumerWidget {
  const _View({this.isEmpty, this.empty, this.loading, this.onRetry});
  final bool Function(int)? isEmpty;
  final Widget? empty;
  final Widget? loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) => NzAsyncView<int>(
    value: ref.watch(_p),
    data: (d) => Text('veri $d'),
    isEmpty: isEmpty,
    empty: empty,
    loading: loading,
    onRetry: onRetry,
  );
}

Future<ProviderContainer> _pump(WidgetTester tester, Widget view) async {
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
        home: Scaffold(body: view),
      ),
    ),
  );
  return container;
}

ApiError _shown(WidgetTester tester) =>
    tester.widget<NzErrorState>(find.byType(NzErrorState)).error;

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('ilk yükleme: varsayılan NzLoader', (tester) async {
    final c = Completer<int>();
    _factory = () => c.future;
    await _pump(tester, const _View());
    expect(find.byType(NzLoader), findsOneWidget);
    c.complete(1);
    await tester.pump();
    expect(find.text('veri 1'), findsOneWidget);
    expect(find.byType(NzLoader), findsNothing);
  });

  testWidgets('ilk yükleme: loading verilirse o çizilir', (tester) async {
    final c = Completer<int>();
    _factory = () => c.future;
    await _pump(tester, const _View(loading: Text('iskelet')));
    expect(find.text('iskelet'), findsOneWidget);
    expect(find.byType(NzLoader), findsNothing);
    c.complete(1);
  });

  testWidgets('hata: NzErrorState ApiError ile; onRetry bağlı', (tester) async {
    _factory = () => Future.error(ApiError(ClientErrorCode.timeout));
    var retried = 0;
    await _pump(tester, _View(onRetry: () => retried++));
    await tester.pump();
    expect(_shown(tester).code, ClientErrorCode.timeout);
    expect(
      tester.widget<NzErrorState>(find.byType(NzErrorState)).onRetry,
      isNotNull,
    );
    tester.widget<NzErrorState>(find.byType(NzErrorState)).onRetry!();
    expect(retried, 1);
  });

  testWidgets('ApiError dışı istisna client.invalid_response olur', (
    tester,
  ) async {
    _factory = () => Future.error(StateError('ham'));
    await _pump(tester, const _View());
    await tester.pump();
    expect(_shown(tester).code, ClientErrorCode.invalidResponse);
    expect(find.textContaining('ham'), findsNothing);
  });

  testWidgets('boş: isEmpty + empty → empty; empty yoksa data çağrılır', (
    tester,
  ) async {
    _factory = () async => 0;
    await _pump(
      tester,
      _View(isEmpty: (d) => d == 0, empty: const Text('boş')),
    );
    await tester.pump();
    expect(find.text('boş'), findsOneWidget);
    expect(find.text('veri 0'), findsNothing);
  });

  testWidgets('isEmpty false → veri; empty verilmediyse veri', (tester) async {
    _factory = () async => 0;
    await _pump(tester, _View(isEmpty: (d) => d == 0));
    await tester.pump();
    expect(find.text('veri 0'), findsOneWidget);
  });

  testWidgets('yenileme: eski veri görünür kalır, yükleyici çıkmaz', (
    tester,
  ) async {
    _factory = () async => 1;
    final container = await _pump(tester, const _View());
    await tester.pump();
    expect(find.text('veri 1'), findsOneWidget);

    final c = Completer<int>();
    _factory = () => c.future;
    container.invalidate(_p);
    await tester.pump();
    expect(container.read(_p).isLoading, isTrue);
    expect(find.text('veri 1'), findsOneWidget);
    expect(find.byType(NzLoader), findsNothing);
    c.complete(2);
    await tester.pump();
    await tester.pump();
    expect(find.text('veri 2'), findsOneWidget);
  });

  testWidgets('yenileme hatasında önceki veri gösterilmeye devam eder', (
    tester,
  ) async {
    _factory = () async => 1;
    final container = await _pump(tester, const _View());
    await tester.pump();

    _factory = () => Future.error(ApiError(ClientErrorCode.networkError));
    container.invalidate(_p);
    await tester.pump();
    await tester.pump();
    expect(container.read(_p).hasError, isTrue);
    expect(find.text('veri 1'), findsOneWidget);
    expect(find.byType(NzErrorState), findsNothing);
  });

  testWidgets('hatadan sonra yeniden yükleme: gösterge görünür, hata kalkar', (
    tester,
  ) async {
    _factory = () => Future.error(ApiError(ClientErrorCode.timeout));
    final container = await _pump(tester, const _View());
    await tester.pump();
    expect(find.byType(NzErrorState), findsOneWidget);

    final c = Completer<int>();
    _factory = () => c.future;
    container.invalidate(_p);
    await tester.pump();
    expect(container.read(_p).isLoading, isTrue);
    expect(container.read(_p).hasError, isTrue, reason: 'önceki hata taşınır');
    expect(find.byType(NzLoader), findsOneWidget);
    expect(find.byType(NzErrorState), findsNothing);

    c.complete(3);
    await tester.pump();
    await tester.pump();
    expect(find.text('veri 3'), findsOneWidget);
  });
}
