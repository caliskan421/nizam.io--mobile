import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/errors/error_text.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_empty_state.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_error_state.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_loader.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_list_tile.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_paged_list.dart';

import '../../../../support/golden.dart';
import '../feedback/feedback_test_support.dart';

const _rowHeight = 100.0;

Widget _row(BuildContext context, int item) =>
    SizedBox(height: _rowHeight, child: Text('Satır $item'));

PageSlice<int> _slice(int from, int count, {String? next, bool cut = false}) =>
    PageSlice<int>(
      items: [for (var i = from; i < from + count; i++) i],
      nextCursor: next,
      truncated: cut,
    );

/// Çağrıları kaydeden, her çağrıyı elle tamamlanan yükleyici.
class _Loader {
  final requests = <PageRequest>[];
  final _pending = <Completer<PageSlice<int>>>[];

  Future<PageSlice<int>> call(PageRequest request) {
    requests.add(request);
    final c = Completer<PageSlice<int>>();
    _pending.add(c);
    return c.future;
  }

  void complete(PageSlice<int> slice) => _pending.removeAt(0).complete(slice);
  void fail(Object error) => _pending.removeAt(0).completeError(error);
}

Widget _app(_Loader loader, {Widget? empty, int pageSize = 20}) => testApp(
  NzPagedList<int>(
    load: loader.call,
    itemBuilder: _row,
    pageSize: pageSize,
    empty: empty,
  ),
);

final _network = ApiError(ClientErrorCode.networkError);

Future<void> _scrollToEnd(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -5000));
  await tester.pump();
}

Widget _variants(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    SizedBox(
      height: 360,
      child: NzPagedList<int>(
        load: (_) async => _slice(0, 3, cut: true),
        itemBuilder: (_, item) => NzListTile(title: 'Satır $item'),
      ),
    ),
    cellGap,
    SizedBox(
      height: 200,
      child: NzPagedList<int>(
        load: (_) async => _slice(0, 0),
        itemBuilder: _row,
      ),
    ),
    cellGap,
    SizedBox(
      height: 240,
      child: NzPagedList<int>(
        load: (_) => Future.error(ApiError(ClientErrorCode.networkError)),
        itemBuilder: _row,
      ),
    ),
  ],
);

void main() {
  setUpFonts();

  group('ilk sayfa', () {
    testWidgets('yüklenirken gösterge, sonra satırlar; istek sınırı iletilir', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader, pageSize: 7));
      expect(find.byType(NzLoader), findsOneWidget);
      expect(loader.requests.single.limit, 7);
      expect(loader.requests.single.cursor, isNull);

      loader.complete(_slice(0, 3));
      await tester.pump();
      expect(find.byType(NzLoader), findsNothing);
      expect(find.text('Satır 0'), findsOneWidget);
      expect(find.text('Satır 2'), findsOneWidget);
      expect(loader.requests, hasLength(1));
    });

    testWidgets('boş liste varsayılan NzEmptyState gösterir', (tester) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 0));
      await tester.pump();
      expect(find.byType(NzEmptyState), findsOneWidget);
      expect(find.text('Gösterilecek kayıt yok'), findsOneWidget);
    });

    testWidgets('boş liste çağıranın verdiği görünümü gösterir', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(
        _app(loader, empty: const NzEmptyState(title: 'Özel boş')),
      );
      loader.complete(_slice(0, 0));
      await tester.pump();
      expect(find.text('Özel boş'), findsOneWidget);
      expect(find.text('Gösterilecek kayıt yok'), findsNothing);
    });

    testWidgets(
      'hata → NzErrorState (errorText); otomatik yeniden deneme yok',
      (tester) async {
        final loader = _Loader();
        await tester.pumpWidget(_app(loader));
        loader.fail(_network);
        await tester.pump();
        expect(find.byType(NzErrorState), findsOneWidget);
        final l = tester.element(find.byType(NzErrorState)).l10n;
        expect(find.text(errorText(l, _network)), findsOneWidget);

        await tester.pump(const Duration(minutes: 10));
        expect(loader.requests, hasLength(1));

        await tester.tap(find.text('Yeniden dene'));
        await tester.pump();
        expect(loader.requests, hasLength(2));
        expect(loader.requests.last.cursor, isNull);
        expect(find.byType(NzLoader), findsOneWidget);
        loader.complete(_slice(0, 2));
        await tester.pump();
        expect(find.text('Satır 0'), findsOneWidget);
        expect(find.byType(NzErrorState), findsNothing);
      },
    );

    testWidgets('ApiError dışı istisna da ApiError olarak gösterilir', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.fail(StateError('x'));
      await tester.pump();
      expect(find.byType(NzErrorState), findsOneWidget);
    });
  });

  group('sonraki sayfa', () {
    testWidgets('sona gelince imleçle istenir ve satırlar eklenir', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 10, next: 'c1'));
      await tester.pump();
      await _scrollToEnd(tester);
      await tester.pump();

      expect(loader.requests, hasLength(2));
      expect(loader.requests.last.cursor, 'c1');
      loader.complete(_slice(10, 3));
      await tester.pump();
      await _scrollToEnd(tester);
      expect(find.text('Satır 12'), findsOneWidget);
      expect(loader.requests, hasLength(2));
    });

    testWidgets('kısa liste ekranı doldurmuyorsa sonraki sayfa kendiliğinden', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 2, next: 'c1'));
      await tester.pump();
      await tester.pump();
      expect(loader.requests, hasLength(2));
      expect(loader.requests.last.cursor, 'c1');
    });

    testWidgets('hızlı kaydırmada ikinci çağrı yok (aynı anda en çok bir)', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 10, next: 'c1'));
      await tester.pump();

      for (var i = 0; i < 5; i++) {
        await _scrollToEnd(tester);
        await tester.drag(find.byType(ListView), const Offset(0, 300));
        await tester.pump();
        await _scrollToEnd(tester);
      }
      expect(loader.requests, hasLength(2)); // ilk + tek sonraki
      expect(find.byType(NzLoader), findsOneWidget); // alt satır göstergesi

      loader.complete(_slice(10, 10, next: 'c2'));
      await tester.pump();
      await _scrollToEnd(tester);
      await tester.pump();
      expect(loader.requests, hasLength(3));
      expect(loader.requests.last.cursor, 'c2');
    });

    testWidgets('hata: alt satırda inline hata, otomatik yeniden deneme yok', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 10, next: 'c1'));
      await tester.pump();
      await _scrollToEnd(tester);
      loader.fail(_network);
      await tester.pump();
      await _scrollToEnd(tester);

      expect(find.byType(NzErrorState), findsOneWidget);
      expect(
        find.text('Satır 0'),
        findsNothing,
      ); // sondayız, ilk satırlar dışarıda
      final l = tester.element(find.byType(NzErrorState)).l10n;
      expect(find.text(errorText(l, _network)), findsOneWidget);

      // Süre geçse ve kaydırılsa da çağrı yapılmaz.
      await tester.pump(const Duration(minutes: 10));
      await _scrollToEnd(tester);
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await _scrollToEnd(tester);
      expect(loader.requests, hasLength(2));

      // Dokunuşla yeniden deneme aynı imleçle çağrılır.
      await tester.tap(find.text('Yeniden dene'));
      await tester.pump();
      expect(loader.requests, hasLength(3));
      expect(loader.requests.last.cursor, 'c1');
      loader.complete(_slice(10, 2));
      await tester.pump();
      await _scrollToEnd(tester);
      expect(find.byType(NzErrorState), findsNothing);
      expect(find.text('Satır 11'), findsOneWidget);
    });
  });

  group('yenile', () {
    testWidgets('aşağı çekince ilk sayfa yeniden yüklenir (imleç sıfırlanır)', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 10, next: 'c1'));
      await tester.pump();
      await _scrollToEnd(tester);
      loader.complete(_slice(10, 10, next: 'c2'));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, 5000));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(loader.requests.last.cursor, isNull);
      final before = loader.requests.length;
      loader.complete(_slice(100, 3));
      await tester.pumpAndSettle();
      expect(find.text('Satır 100'), findsOneWidget);
      expect(find.text('Satır 0'), findsNothing);
      expect(loader.requests, hasLength(before));
    });

    testWidgets('yenilemeden önce uçuştaki sayfanın sonucu yok sayılır', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 10, next: 'c1'));
      await tester.pump();
      await _scrollToEnd(tester); // sonraki sayfa uçuşta
      await tester.drag(find.byType(ListView), const Offset(0, 5000));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(loader.requests.last.cursor, isNull);

      loader.complete(_slice(500, 2)); // eski sonraki sayfa geç döner
      loader.complete(_slice(100, 2)); // yenileme
      await tester.pumpAndSettle();
      expect(find.text('Satır 100'), findsOneWidget);
      expect(find.text('Satır 500'), findsNothing);
    });

    testWidgets(
      'yenileme beklerken liste sonu çizilse de ek sayfa istenmez (tek istek)',
      (tester) async {
        final loader = _Loader();
        await tester.pumpWidget(_app(loader, pageSize: 10));
        loader.complete(_slice(0, 10, next: 'c1'));
        await tester.pump();
        await tester.drag(find.byType(ListView), const Offset(0, 400));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(loader.requests, hasLength(2));
        expect(loader.requests.last.cursor, isNull);

        // Yenileme beklerken yeniden çizim (liste sonu satırı) ek istek başlatmamalı.
        await _scrollToEnd(tester);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(loader.requests, hasLength(2));

        loader.complete(_slice(100, 2));
        await tester.pumpAndSettle();
        expect(find.text('Satır 100'), findsOneWidget);
        expect(find.text('Satır 0'), findsNothing);
        expect(loader.requests, hasLength(2));
      },
    );

    testWidgets('ters yanıt sırası: yenileme önce döner, eski ek sayfa sonra', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 10, next: 'c1'));
      await tester.pump();
      await _scrollToEnd(tester); // ek sayfa uçuşta
      await tester.drag(find.byType(ListView), const Offset(0, 5000));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(loader.requests.last.cursor, isNull);

      loader._pending[1].complete(_slice(100, 2)); // yenileme önce
      await tester.pumpAndSettle();
      loader._pending[0].complete(_slice(500, 2)); // eski ek sayfa sonra
      await tester.pumpAndSettle();
      expect(find.text('Satır 100'), findsOneWidget);
      expect(find.text('Satır 500'), findsNothing);
      expect(find.text('Satır 0'), findsNothing);
    });

    testWidgets('boş listede de aşağı çekilebilir', (tester) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 0));
      await tester.pump();
      await tester.drag(find.byType(NzEmptyState), const Offset(0, 400));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(loader.requests, hasLength(2));
      loader.complete(_slice(0, 1));
      await tester.pumpAndSettle();
      expect(find.text('Satır 0'), findsOneWidget);
    });
  });

  group('kısaltma', () {
    testWidgets('truncated true → listenin sonunda bilgi satırı', (
      tester,
    ) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 3, cut: true));
      await tester.pump();
      expect(
        find.text('Liste kısaltıldı; yalnız ilk kayıtlar gösteriliyor.'),
        findsOneWidget,
      );
      expect(loader.requests, hasLength(1));
    });

    testWidgets('truncated false → bilgi satırı yok', (tester) async {
      final loader = _Loader();
      await tester.pumpWidget(_app(loader));
      loader.complete(_slice(0, 3));
      await tester.pump();
      expect(
        find.text('Liste kısaltıldı; yalnız ilk kayıtlar gösteriliyor.'),
        findsNothing,
      );
    });
  });

  testWidgets('pageSize 0 reddedilir', (tester) async {
    expect(
      () => NzPagedList<int>(
        load: (_) async => _slice(0, 0),
        itemBuilder: _row,
        pageSize: 0,
      ),
      throwsAssertionError,
    );
  });

  testWidgets('dispose sonrası dönen yanıt hata vermez', (tester) async {
    final loader = _Loader();
    await tester.pumpWidget(_app(loader));
    await tester.pumpWidget(testApp(const SizedBox()));
    loader.complete(_slice(0, 1));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('piksel: tabaka 1024 geniş; hata ikonu ve ana renkler çizilir', (
    tester,
  ) async {
    await pumpSheet(tester, _variants);
    await tester.pump(const Duration(milliseconds: 100));
    await expectSheetPixels(tester, [
      NizamioColors.light.danger,
      NizamioColors.dark.danger,
    ]);
  });

  goldenTestWidgets(
    'golden: kısaltılmış · boş · hata × açık/koyu × compact/expanded × 1.0/2.0',
    (tester) async {
      await pumpSheet(tester, _variants);
      await tester.pump(const Duration(milliseconds: 100));
      await expectLater(
        find.byKey(sheetKey),
        matchesGoldenFile('goldens/nz_paged_list.png'),
      );
    },
  );
}
