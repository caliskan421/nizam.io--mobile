import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/scope/scope_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';

void main() {
  const owner = ScopeOwner(accountId: 'acc-1', instanceId: 'inst-1');

  test('kaydet → yükle: sahip + program + departman', () async {
    final mem = MemorySecureStore();
    final store = ScopeStore(mem);
    await store.save(
      owner,
      const ScopeSelection(programId: 'p-1', departmentId: 'd-1'),
    );
    final r = await store.load();
    expect(r!.owner, owner);
    expect(r.selection.programId, 'p-1');
    expect(r.selection.departmentId, 'd-1');
    expect(mem.values.keys, [ScopeStore.key]);
  });

  test('kayıt yok → null; clear kaydı siler', () async {
    final mem = MemorySecureStore();
    final store = ScopeStore(mem);
    expect(await store.load(), isNull);
    await store.save(owner, const ScopeSelection(programId: 'p-1'));
    expect(await store.exists(), isTrue);
    await store.clear();
    expect(await store.exists(), isFalse);
  });

  for (final bad in [
    'not json',
    '[]',
    '{}',
    '{"account_id":"a","instance_id":"i"}',
    '{"account_id":"a","instance_id":"i","program_id":""}',
    '{"account_id":"","instance_id":"i","program_id":"p"}',
    '{"account_id":"a","instance_id":1,"program_id":"p"}',
    '{"account_id":"a","instance_id":"i","program_id":"p","department_id":5}',
    '{"account_id":"a","instance_id":"i","program_id":"p","department_id":""}',
  ]) {
    test('bozuk kayıt null döner: $bad', () async {
      final mem = MemorySecureStore()..values[ScopeStore.key] = bad;
      expect(await ScopeStore(mem).load(), isNull);
      expect(await ScopeStore(mem).exists(), isTrue);
    });
  }

  test('ScopeOwner eşitliği hesap + kurulum', () {
    expect(owner, const ScopeOwner(accountId: 'acc-1', instanceId: 'inst-1'));
    expect(
      owner == const ScopeOwner(accountId: 'acc-2', instanceId: 'inst-1'),
      isFalse,
    );
    expect(
      owner == const ScopeOwner(accountId: 'acc-1', instanceId: 'inst-2'),
      isFalse,
    );
  });
}
