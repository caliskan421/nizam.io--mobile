import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/scope/scope_store.dart';

import 'gated_secure_store.dart';

void main() {
  const owner = ScopeOwner(
    accountId: 'acc-secret-1',
    instanceId: 'inst-secret-1',
  );
  late GatedSecureStore mem;
  late ScopeController scope;
  late List<String> logs;
  ScopeOwner? current = owner;

  setUp(() {
    mem = GatedSecureStore();
    scope = ScopeController(store: ScopeStore(mem))..attachOwner(() => current);
    current = owner;
    logs = [];
    Log.sink = logs.add;
  });
  tearDown(Log.resetSink);

  test('mevcut açık API: depo olmadan da çalışır', () async {
    final s = ScopeController()..attachOwner(() => owner);
    s.selectProgram('p-1');
    s.selectDepartment('d-1');
    expect(s.current.programId, 'p-1');
    expect(s.current.departmentId, 'd-1');
    s.clear();
    expect(s.current.hasProgram, isFalse);
    await s.settled;
  });

  test(
    'seçim güvenli depoya sahip bilgisiyle yazılır; departman üzerine yazar',
    () async {
      scope.selectProgram('p-1');
      await scope.settled;
      var r = await ScopeStore(mem).load();
      expect(r!.owner, owner);
      expect(r.selection.programId, 'p-1');
      expect(r.selection.hasDepartment, isFalse);
      scope.selectDepartment('d-1');
      await scope.settled;
      r = await ScopeStore(mem).load();
      expect(r!.selection.departmentId, 'd-1');
      expect(mem.values.keys, [
        ScopeStore.key,
      ], reason: 'yalnız tek sabit anahtar');
    },
  );

  test('oturum sahibi yoksa kalıcılaştırılmaz', () async {
    current = null;
    scope.selectProgram('p-1');
    await scope.settled;
    expect(mem.values, isEmpty);
    expect(scope.current.programId, 'p-1');
  });

  test('clear bellek + kayıt siler', () async {
    scope.selectProgram('p-1');
    await scope.settled;
    scope.clear();
    expect(scope.current.hasProgram, isFalse);
    await scope.settled;
    expect(mem.values, isEmpty);
  });

  test('yarış: yazım sürerken clear → kayıt kalmaz', () async {
    mem.holdWrites(ScopeStore.key);
    scope.selectProgram('p-1');
    await Future<void>.delayed(Duration.zero);
    scope.clear();
    mem.release();
    await scope.settled;
    expect(mem.values.containsKey(ScopeStore.key), isFalse);
    expect(scope.current.hasProgram, isFalse);
  });

  test('yarış: kuyrukta bekleyen yazım clear sonrası hiç yazılmaz', () async {
    mem.holdWrites(ScopeStore.key);
    scope.selectProgram('p-1');
    scope.selectDepartment('d-1'); // ikinci yazım kuyrukta bekler
    await Future<void>.delayed(Duration.zero);
    scope.clear();
    mem.release();
    await scope.settled;
    expect(mem.values, isEmpty);
  });

  test(
    'clear sonrası yeni seçim yeniden yazılır (nesil yalnız eskiyi öldürür)',
    () async {
      scope.selectProgram('p-1');
      scope.clear();
      scope.selectProgram('p-2');
      await scope.settled;
      final r = await ScopeStore(mem).load();
      expect(r!.selection.programId, 'p-2');
    },
  );

  test('yazma hatası: seçim bellekte kalır, kimlik loglanmaz', () async {
    mem.failWrites = true;
    scope.selectProgram('p-secret');
    await scope.settled;
    expect(scope.current.programId, 'p-secret');
    expect(mem.values, isEmpty);
    final all = logs.join('\n');
    expect(all, contains('kalıcılaştırılamadı'));
    for (final s in ['p-secret', 'acc-secret-1', 'inst-secret-1']) {
      expect(all, isNot(contains(s)));
    }
  });

  test(
    'silme hatası: bellek temizlenir, yerel yeniden denenir, uyarı loglanır',
    () async {
      scope.selectProgram('p-1');
      await scope.settled;
      final before = mem.deleteCalls;
      mem.failDeletes = true;
      scope.clear();
      await scope.settled;
      expect(scope.current.hasProgram, isFalse);
      expect(mem.deleteCalls - before, ScopeController.storeAttempts);
      expect(logs.join('\n'), contains('silinemedi'));
    },
  );

  group('restore', () {
    Future<void> seed({
      String acc = 'acc-secret-1',
      String inst = 'inst-secret-1',
    }) => ScopeStore(mem).save(
      ScopeOwner(accountId: acc, instanceId: inst),
      const ScopeSelection(programId: 'p-1', departmentId: 'd-1'),
    );

    test('eşleşen hesap + kurulum: seçim geri yüklenir, kayıt durur', () async {
      await seed();
      expect(await scope.restore(owner), isTrue);
      expect(scope.current.programId, 'p-1');
      expect(scope.current.departmentId, 'd-1');
      expect(mem.values.containsKey(ScopeStore.key), isTrue);
    });

    test('farklı hesap: seçim yok, kayıt silinir', () async {
      await seed(acc: 'acc-other');
      expect(await scope.restore(owner), isFalse);
      expect(scope.current.hasProgram, isFalse);
      expect(mem.values, isEmpty);
    });

    test('farklı kurulum: seçim yok, kayıt silinir', () async {
      await seed(inst: 'inst-other');
      expect(await scope.restore(owner), isFalse);
      expect(scope.current.hasProgram, isFalse);
      expect(mem.values, isEmpty);
    });

    test('bozuk kayıt: seçim yok, kayıt silinir', () async {
      mem.values[ScopeStore.key] = '{bozuk';
      expect(await scope.restore(owner), isFalse);
      expect(scope.current.hasProgram, isFalse);
      expect(mem.values, isEmpty);
    });

    test('kayıt yok: seçim yok', () async {
      expect(await scope.restore(owner), isFalse);
      expect(scope.current.hasProgram, isFalse);
    });

    test('okuma hatası: seçim yok (fail-closed)', () async {
      await seed();
      mem.failReads = true;
      expect(await scope.restore(owner), isFalse);
      expect(scope.current.hasProgram, isFalse);
      expect(logs.join('\n'), isNot(contains('acc-secret-1')));
    });

    test('restore sürerken clear: geri yükleme uygulanmaz', () async {
      await seed();
      final pending = scope.restore(owner);
      scope.clear();
      expect(await pending, isFalse);
      expect(scope.current.hasProgram, isFalse);
      await scope.settled;
      expect(mem.values, isEmpty);
    });

    test('depo yoksa false', () async {
      expect(await ScopeController().restore(owner), isFalse);
    });
  });
}
