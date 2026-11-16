// Etkin görünüm hakları ve varsayılan türetme kuralı (ScopeGrants.resolve).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/effective_role.dart';

const _a = EffectiveRole.admin;
const _k = EffectiveRole.coordinator;
const _u = EffectiveRole.member;

ScopeGrants _g({bool admin = false, List<ScopeSeat> seats = const []}) =>
    ScopeGrants(admin: admin, seats: seats);

void main() {
  final mixed = _g(
    seats: const [
      (departmentId: 'ALT', role: _u),
      (departmentId: 'MEK', role: _k),
      (departmentId: 'ULA', role: _k),
      (departmentId: 'EGI', role: _u),
    ],
  );

  test('roller gerçek haklardan, sabit sırayla', () {
    expect(_g(admin: true).roles, [_a]);
    expect(mixed.roles, [_k, _u]);
    expect(_g(admin: true, seats: mixed.seats).roles, [_a, _k, _u]);
    expect(ScopeGrants.none.roles, isEmpty);
  });

  test('koordinatörlükler role göre süzülür; yöneticide yok', () {
    expect(mixed.departmentsFor(_k), ['MEK', 'ULA']);
    expect(mixed.departmentsFor(_u), ['ALT', 'EGI']);
    expect(_g(admin: true, seats: mixed.seats).departmentsFor(_a), isEmpty);
  });

  group('resolve: geçerli seçim korunur, değilse varsayılan', () {
    final cases =
        <(String, ScopeGrants, EffectiveRole?, String?, ResolvedView)>[
          (
            'yönetici, seçim yok',
            _g(admin: true, seats: mixed.seats),
            null,
            null,
            (role: _a, departmentId: null),
          ),
          (
            'koordinatörlüğü var → ilk koordinatörlük',
            mixed,
            null,
            null,
            (role: _k, departmentId: 'MEK'),
          ),
          (
            'yalnız üye → ilk üye satırı',
            _g(seats: const [(departmentId: 'X', role: _u)]),
            null,
            null,
            (role: _u, departmentId: 'X'),
          ),
          ('geçerli seçim', mixed, _u, 'EGI', (role: _u, departmentId: 'EGI')),
          (
            'koordinatörlük rolde yok → rolün ilki',
            mixed,
            _k,
            'ALT',
            (role: _k, departmentId: 'MEK'),
          ),
          (
            'hak edilmeyen rol → varsayılan',
            mixed,
            _a,
            null,
            (role: _k, departmentId: 'MEK'),
          ),
          (
            'eski kayıt: rol yok, koordinatörlük geçerli',
            mixed,
            null,
            'ULA',
            (role: _k, departmentId: 'ULA'),
          ),
          (
            'yönetici rolünde koordinatörlük düşer',
            _g(admin: true, seats: mixed.seats),
            _a,
            'MEK',
            (role: _a, departmentId: null),
          ),
          (
            'hiç hak yok → üye, koordinatörlük yok',
            ScopeGrants.none,
            _k,
            'MEK',
            (role: _u, departmentId: null),
          ),
        ];
    for (final (name, grants, role, dept, want) in cases) {
      test(name, () => expect(grants.resolve(role, dept), want));
    }
  });

  test('kayıt biçimi: bilinmeyen değer null', () {
    for (final r in EffectiveRole.values) {
      expect(EffectiveRole.fromWire(r.wire), r);
    }
    expect(EffectiveRole.fromWire('superuser'), isNull);
    expect(EffectiveRole.fromWire(null), isNull);
  });
}
