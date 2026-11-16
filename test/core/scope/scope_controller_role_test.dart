// Etkin görünüm seçimi (rol + koordinatörlük): geçerlilik denetimi, kalıcılık ve eski kayıt
// uyumu (ADR-0003 karar 20 uzantısı).
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/scope/scope_store.dart';

import 'gated_secure_store.dart';

const _owner = ScopeOwner(accountId: 'acc', instanceId: 'inst');

final _grants = ScopeGrants(
  admin: true,
  seats: const [
    (departmentId: 'MEK', role: EffectiveRole.coordinator),
    (departmentId: 'ALT', role: EffectiveRole.member),
  ],
);

void main() {
  late GatedSecureStore mem;
  late ScopeController scope;

  setUp(() {
    mem = GatedSecureStore();
    scope = ScopeController(store: ScopeStore(mem))..attachOwner(() => _owner);
    scope.selectProgram('p1');
  });

  test(
    'rol: yalnız hak edilen seçilir; koordinatörlük role göre ayarlanır',
    () async {
      expect(scope.selectRole(EffectiveRole.coordinator, _grants), isTrue);
      expect(scope.current.role, EffectiveRole.coordinator);
      expect(scope.current.departmentId, 'MEK');

      expect(scope.selectRole(EffectiveRole.member, _grants), isTrue);
      expect(scope.current.departmentId, 'ALT');

      expect(scope.selectRole(EffectiveRole.admin, _grants), isTrue);
      expect(scope.current.departmentId, isNull);

      final noAdmin = ScopeGrants(admin: false, seats: _grants.seats);
      expect(scope.selectRole(EffectiveRole.admin, noAdmin), isFalse);
      expect(scope.current.role, EffectiveRole.admin, reason: 'seçim değişmez');
    },
  );

  test('koordinatörlük: yalnız etkin rolün satırları; yöneticide hayır', () {
    expect(
      scope.selectDepartment('MEK', grants: _grants),
      isFalse,
      reason: 'türetilen rol yönetici',
    );
    scope.selectRole(EffectiveRole.coordinator, _grants);
    expect(
      scope.selectDepartment('ALT', grants: _grants),
      isFalse,
      reason: 'ALT yalnız üye satırı',
    );
    expect(scope.current.departmentId, 'MEK');
    final two = ScopeGrants(
      admin: false,
      seats: const [
        (departmentId: 'MEK', role: EffectiveRole.coordinator),
        (departmentId: 'ULA', role: EffectiveRole.coordinator),
      ],
    );
    expect(scope.selectDepartment('ULA', grants: two), isTrue);
    expect(scope.current.departmentId, 'ULA');
    expect(scope.current.role, EffectiveRole.coordinator);
  });

  test('türetilen rol koordinatörlük seçilince sabitlenir', () {
    final member = ScopeGrants(
      admin: false,
      seats: const [
        (departmentId: 'ALT', role: EffectiveRole.member),
        (departmentId: 'EGI', role: EffectiveRole.member),
      ],
    );
    expect(scope.current.role, isNull);
    expect(scope.selectDepartment('EGI', grants: member), isTrue);
    expect(scope.current.role, EffectiveRole.member);
  });

  test('program yoksa seçim yapılmaz; program değişimi seçimi sıfırlar', () {
    scope.selectRole(EffectiveRole.coordinator, _grants);
    scope.selectProgram('p2');
    expect((scope.current.role, scope.current.departmentId), (null, null));
    scope.clear();
    expect(scope.selectRole(EffectiveRole.coordinator, _grants), isFalse);
  });

  test('rol ve koordinatörlük kayda yazılır, geri yüklenir', () async {
    scope.selectRole(EffectiveRole.coordinator, _grants);
    await scope.settled;
    final raw = jsonDecode((await mem.read(ScopeStore.key))!) as Map;
    expect(raw['role'], 'coordinator');
    expect(raw['department_id'], 'MEK');

    final fresh = ScopeController(store: ScopeStore(mem));
    expect(await fresh.restore(_owner), isTrue);
    expect(fresh.current.role, EffectiveRole.coordinator);
    expect(fresh.current.departmentId, 'MEK');
  });

  test(
    'eski kayıt (rol yok) ve bilinmeyen rol: seçim yüklenir, rol türetilir',
    () async {
      for (final extra in [
        <String, Object>{},
        {'role': 'superuser'},
      ]) {
        await mem.write(
          ScopeStore.key,
          jsonEncode({
            'account_id': 'acc',
            'instance_id': 'inst',
            'program_id': 'p1',
            ...extra,
          }),
        );
        final fresh = ScopeController(store: ScopeStore(mem));
        expect(await fresh.restore(_owner), isTrue);
        expect(fresh.current.programId, 'p1');
        expect(fresh.current.role, isNull);
      }
    },
  );
}
