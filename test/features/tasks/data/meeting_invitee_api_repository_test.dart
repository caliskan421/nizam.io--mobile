// Kişi kipindeki toplantının davet havuzu (Codex v12 bulgu 2; ADR-0031, COLLABORATION-K21):
// yönetici olmayan koordinatörde kendi ekipleri (katalog) + programın geri kalanı
// (`listAssignable` rolleri + `listProgramDepartments` adları, program sabit); rolü olmayan
// (başka programdaki) hesap havuza girmez; kesilme ya da okunamayan havuz → `partial` (kendi
// ekipler kalır). Yönetici kataloğun bütün ekiplerini kullanır, havuz ucu çağrılmaz.
// Gerçek bileşim kökü (DI + tel eşlemesi) sahte sunucuyla.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../meetings/meetings_server.dart';
import '../../pilot_support.dart';

const _members = 'GET /v1/departments/d1/members';
const _assignable = 'GET /v1/departments/d1/assignable';

Map<String, Object?> _roster(String id, String name, String role) => {
  'membership_id': 'ms-$id',
  'account_id': id,
  'full_name': name,
  'role': role,
  'status': 'active',
};

Map<String, Object?> _pool(String id, String name, List<String> roles) => {
  'account_id': id,
  'full_name': name,
  'roles': roles,
};

/// Koordinatör (d1): ekip acc-1 (koordinatör) + u1; havuz u2 (d2 koordinatörü), u3 (d2 üyesi),
/// u4 (yalnız başka programda).
MeetingsServer _coordinator({Map<String, List<String>>? poolHeaders}) {
  final s = MeetingsServer(admin: false, seat: 'koordinator');
  s.overrides[_members] = () => jsonResponse(200, {
    'members': [
      _roster('acc-1', 'Ayşe Yılmaz', 'koordinator'),
      _roster('u1', 'Bora Kaya', 'uye'),
    ],
  });
  s.overrides[_assignable] = () => jsonResponse(200, {
    'accounts': [
      _pool('u2', 'Cem Er', ['d2:koordinator']),
      _pool('u3', 'Deniz Ak', ['d2:uye']),
      _pool('u4', 'Ece Su', []),
    ],
  }, headers: poolHeaders);
  return s;
}

Future<(Harness, MeetingInvitees)> _load(MeetingsServer s) async {
  final (h, c) = await openMeetings(s);
  c.listen(meetingInviteesProvider, (_, _) {});
  return (h, await c.read(meetingInviteesProvider.future));
}

/// "departman: koordinatörler / üyeler".
List<String> _groups(MeetingInvitees i) => [
  for (final g in i.groups)
    '${g.code}: ${g.leads.join(',')} / ${g.members.join(',')}',
];

void main() {
  test('koordinatör: kendi ekibi + programın diğer koordinatörlükleri; rolsüz hesap yok', () async {
    final (h, i) = await _load(_coordinator());
    expect(_groups(i), ['d1: acc-1 / u1', 'd2: u2 / u3']);
    expect(i.groups.last.name, 'Mekanik');
    expect((i.nameOf('u2'), i.nameOf('u4')), ('Cem Er', null));
    expect(i.partial, isFalse);
    final pool = h.backend.requests.singleWhere(
      (r) => r.path == '/v1/departments/d1/assignable',
    );
    expect(pool.header('X-Nizamio-Program'), 'prog-1');
  });

  test('havuz kesildiyse eksik olabilir bayrağı', () async {
    final (_, i) = await _load(
      _coordinator(
        poolHeaders: {
          'X-Result-Truncated': ['true'],
        },
      ),
    );
    expect(i.partial, isTrue);
    expect(i.groups, hasLength(2));
  });

  test(
    'havuz okunamazsa yalnız kendi ekipler, eksik olabilir bayrağıyla',
    () async {
      final s = _coordinator()
        ..overrides[_assignable] = () =>
            errorBody(403, 'organization.not_authorized');
      final (_, i) = await _load(s);
      expect(_groups(i), ['d1: acc-1 / u1']);
      expect(i.partial, isTrue);
    },
  );

  test('yönetici: kataloğun ekipleri; havuz ucu çağrılmaz', () async {
    final s = MeetingsServer()
      ..overrides['GET /v1/departments/d2/members'] = () => jsonResponse(200, {
        'members': [_roster('u2', 'Cem Er', 'koordinator')],
      });
    final (h, i) = await _load(s);
    expect(_groups(i), ['d2: u2 / ']);
    expect(i.partial, isFalse);
    expect(
      h.backend.requests.where((r) => r.path.endsWith('/assignable')),
      isEmpty,
    );
  });
}
