// Liste denetleyicisi: kapsamdan alan seçimi (S3 departman yoksa koordinatörlük yok),
// kişisel/paylaşılan ayrımı (sahiplik), arama, oluşturma ve sonucu bilinmeyen oluşturmada
// aynı işlem anahtarı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/tables_list_controller.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

const _personal = TableScope.personal(programId: 'p1');

/// Oluşturma isteğini kaydeden, ilkinde yanıtı kaybeden depo.
class _LossyCreate extends FakeTablesRepository {
  final keys = <String>[];
  @override
  Future<TableReceipt> create(
    TableScope scope,
    String name, {
    required String requestKey,
  }) async {
    keys.add(requestKey);
    if (keys.length == 1) throw ApiError('client.timeout');
    return super.create(scope, name, requestKey: requestKey);
  }
}

void main() {
  test(
    'iki alan yüklenir; kişisel/paylaşılan sahipliğe göre ayrılır',
    () async {
      final repo = FakeTablesRepository()
        ..add('t1')
        ..add('t2', scope: _personal)
        ..add('t3', scope: _personal, owner: 'baskasi');
      final c = tablesContainer(repo);
      c.listen(tablesListControllerProvider, (_, _) {});
      final v = await c.read(tablesListControllerProvider.future);
      expect(v.visible(TablesArea.coordinatorship).map((t) => t.id), ['t1']);
      expect(v.visible(TablesArea.personal).map((t) => t.id), ['t2']);
      expect(v.visible(TablesArea.shared).map((t) => t.id), ['t3']);
      expect(v.visible(TablesArea.personal, 'yok'), isEmpty);
      expect(v.visible(TablesArea.personal, 'TABLO T2').single.id, 't2');
      expect(v.find('t3')!.scope, _personal);
    },
  );

  test('departman seçili değilse koordinatörlük istenmez', () async {
    final repo = FakeTablesRepository()..add('t2', scope: _personal);
    final c = tablesContainer(repo, departmentId: null);
    c.listen(tablesListControllerProvider, (_, _) {});
    final v = await c.read(tablesListControllerProvider.future);
    expect(v.coordinatorship, isNull);
    expect(repo.lists, [_personal]);
  });

  test('program yoksa hiç istek gitmez', () async {
    final repo = FakeTablesRepository();
    final c = tablesContainer(repo, programId: null);
    c.listen(tablesListControllerProvider, (_, _) {});
    final v = await c.read(tablesListControllerProvider.future);
    expect(v.personal, isNull);
    expect(repo.lists, isEmpty);
  });

  test(
    'oluşturma: sonucu bilinmeyen hata sonrası tekrar AYNI anahtarla',
    () async {
      final repo = _LossyCreate();
      final c = tablesContainer(repo);
      c.listen(tablesListControllerProvider, (_, _) {});
      await c.read(tablesListControllerProvider.future);
      final n = c.read(tablesListControllerProvider.notifier);
      await expectLater(
        n.create(TableSpace.personal, ' Plan '),
        throwsA(isA<ApiError>()),
      );
      final id = await n.create(TableSpace.personal, 'Plan');
      expect(repo.keys, hasLength(2));
      expect(repo.keys.first, repo.keys.last);
      expect(repo.keys.first.length, greaterThanOrEqualTo(22));
      final v = await c.read(tablesListControllerProvider.future);
      expect(v.find(id)!.name, 'Plan');
      // Başarıdan sonra yeni oluşturma yeni anahtar alır.
      await n.create(TableSpace.personal, 'Plan');
      expect(repo.keys.last, isNot(repo.keys.first));
    },
  );

  test('renamed/removed listeyi yeniden okumadan günceller', () async {
    final repo = FakeTablesRepository()..add('t1');
    final c = tablesContainer(repo);
    c.listen(tablesListControllerProvider, (_, _) {});
    await c.read(tablesListControllerProvider.future);
    final n = c.read(tablesListControllerProvider.notifier)
      ..renamed('t1', 'Yeni ad');
    expect(
      c.read(tablesListControllerProvider).value!.find('t1')!.name,
      'Yeni ad',
    );
    n.removed('t1');
    expect(c.read(tablesListControllerProvider).value!.find('t1'), isNull);
  });
}
