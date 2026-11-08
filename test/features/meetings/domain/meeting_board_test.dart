// Toplantı listesi ve ayrıntısının saf karar mantığı: sekme ayrımı, gün grupları, arama, gündem
// sırası, not süzgeci ve görüntüleyen izinleri (COLLABORATION-K16/K21/K28/K29/K32).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/domain/meeting_board.dart';

/// Çarşamba.
final _today = DateTime(2026, 10, 14);

Meeting _m(
  String id,
  DateTime at, {
  String title = 'Toplantı',
  List<(String, String)> depts = const [('d1', 'Altyapı')],
  DateTime? deletedAt,
}) => Meeting(
  id: id,
  programId: 'p',
  ownerDepartmentId: depts.first.$1,
  title: title,
  meetingDate: at,
  membersIncluded: false,
  createdByAccountId: 'a',
  createdByRole: MeetingRole.admin,
  createdAt: at,
  updatedAt: at,
  departments: [
    for (final (id, name) in depts) MeetingDepartment(id: id, name: name),
  ],
  deletedAt: deletedAt,
);

AgendaItem _a(String id, int order, {DateTime? checkedAt}) => AgendaItem(
  id: id,
  meetingId: 'm',
  title: id,
  sortOrder: order,
  isChecked: checkedAt != null,
  createdAt: _today,
  checkedAt: checkedAt,
);

MeetingNote _n(
  String id, {
  String? author = 'me',
  MeetingRole role = MeetingRole.member,
  String? task,
  int minute = 0,
}) => MeetingNote(
  id: id,
  meetingId: 'm',
  authorAccountId: author,
  authorName: 'Yazar',
  authorRole: role,
  content: id,
  convertedToWorkItemId: task,
  createdAt: DateTime(2026, 10, 14, 10, minute),
  updatedAt: DateTime(2026, 10, 14, 10, minute),
  editRevision: 1,
);

void main() {
  group('sekme ve gruplar', () {
    test('bugünkü toplantı saati geçse de yaklaşandadır; dün geçmiştir', () {
      final board = MeetingsBoard(
        visible: [
          _m('dun', DateTime(2026, 10, 13, 18)),
          _m('bugun', DateTime(2026, 10, 14, 0, 30)),
          _m('yarin', DateTime(2026, 10, 15, 9)),
        ],
      );
      expect(board.of(MeetingsTab.upcoming, _today).map((m) => m.id), [
        'bugun',
        'yarin',
      ]);
      expect(board.of(MeetingsTab.past, _today).map((m) => m.id), ['dun']);
      expect(board.deleted, isNull, reason: 'yönetici değil: sekme yok');
      expect(board.of(MeetingsTab.deleted, _today), isEmpty);
    });

    test('geçmiş yeniden eskiye; yaklaşan eskiden yeniye', () {
      final board = MeetingsBoard(
        visible: [
          _m('a', DateTime(2026, 9, 1)),
          _m('b', DateTime(2026, 10, 1)),
          _m('c', DateTime(2026, 11, 2)),
          _m('d', DateTime(2026, 10, 20)),
        ],
      );
      expect(board.of(MeetingsTab.past, _today).map((m) => m.id), ['b', 'a']);
      expect(board.of(MeetingsTab.upcoming, _today).map((m) => m.id), [
        'd',
        'c',
      ]);
    });

    test('göreli gün grupları (hafta pazartesi başlar)', () {
      MeetingWhen w(int d) => meetingWhen(DateTime(2026, 10, d), _today);
      expect(w(14), MeetingWhen.today);
      expect(w(15), MeetingWhen.tomorrow);
      expect(w(18), MeetingWhen.thisWeek, reason: 'pazar');
      expect(w(19), MeetingWhen.nextWeek, reason: 'pazartesi');
      expect(w(25), MeetingWhen.nextWeek);
      expect(w(26), MeetingWhen.later);
    });

    test('ardışık aynı grup birleşir; geçmişte ay grupları', () {
      final up = [
        _m('a', DateTime(2026, 10, 14, 9)),
        _m('b', DateTime(2026, 10, 14, 15)),
        _m('c', DateTime(2026, 10, 16)),
      ];
      final g = groupMeetings(up, MeetingsTab.upcoming, _today);
      expect(g.map((x) => (x.when, x.items.length)), [
        (MeetingWhen.today, 2),
        (MeetingWhen.thisWeek, 1),
      ]);
      final past = groupMeetings(
        [_m('x', DateTime(2026, 10, 2)), _m('y', DateTime(2026, 9, 30))],
        MeetingsTab.past,
        _today,
      );
      expect(past.map((x) => (x.month, x.items.single.id)), [
        (DateTime(2026, 10), 'x'),
        (DateTime(2026, 9), 'y'),
      ]);
    });
  });

  test('arama başlık, kod ve departman adıyla; Türkçe küçük harf', () {
    final list = [
      _m('a', _today, title: 'İhale Değerlendirme'),
      _m('b', _today, depts: [('d2', 'Mekanik')]),
    ];
    String label(MeetingDepartment d) => d.id == 'd2' ? 'MEK' : 'ALT';
    expect(searchMeetings(list, 'ihale', label).map((m) => m.id), ['a']);
    expect(searchMeetings(list, 'mek', label).map((m) => m.id), ['b']);
    expect(searchMeetings(list, '  ', label), hasLength(2));
  });

  test('gündem: açıklar sırayla, işaretliler işaretlenme anına göre altta', () {
    final items = [
      _a('c', 3),
      _a('x', 1, checkedAt: DateTime(2026, 10, 14, 11)),
      _a('a', 2),
      _a('y', 4, checkedAt: DateTime(2026, 10, 14, 10)),
    ];
    expect(orderAgenda(items).map((a) => a.id), ['a', 'c', 'y', 'x']);
    expect(orderAgenda(items, held: {'x'}).map((a) => a.id), [
      'x',
      'a',
      'c',
      'y',
    ], reason: 'tutulan işaretli madde açıkların arasında kendi sırasında');
  });

  test('not süzgeci yeniden eskiye; Benim oturum hesabıyla', () {
    final notes = [
      _n('eski', minute: 1),
      _n('gorev', author: 'baska', task: 'w1', minute: 2),
      _n('yeni', minute: 3),
    ];
    expect(filterNotes(notes, NoteFilter.all, 'me').map((n) => n.id), [
      'yeni',
      'gorev',
      'eski',
    ]);
    expect(filterNotes(notes, NoteFilter.converted, 'me').map((n) => n.id), [
      'gorev',
    ]);
    expect(filterNotes(notes, NoteFilter.mine, 'me').map((n) => n.id), [
      'yeni',
      'eski',
    ]);
    expect(filterNotes(notes, NoteFilter.mine, null), isEmpty);
  });

  group('izinler', () {
    const member = MeetingPermissions(role: MeetingRole.member, me: 'me');
    const coord = MeetingPermissions(role: MeetingRole.coordinator, me: 'me');
    const admin = MeetingPermissions(role: MeetingRole.admin, me: 'me');

    test(
      'yönetim yöneticiye ve koordinatöre; katılımcı yalnız bağlı koordinatöre',
      () {
        expect(
          (member.canManage, coord.canManage, admin.canManage),
          (false, true, true),
        );
        expect(admin.canManageParticipants, isFalse, reason: 'K21');
        expect(
          const MeetingPermissions(
            role: MeetingRole.admin,
            me: 'me',
            coordinatesLinked: true,
          ).canManageParticipants,
          isTrue,
        );
      },
    );

    test('üye yalnız kendi dönüşmemiş notunu düzenler ve siler (K28/K29)', () {
      final own = _n('o');
      final converted = _n('c', task: 'w1');
      final other = _n('x', author: 'baska');
      expect(
        [
          own,
          converted,
          other,
        ].map((n) => (member.canEditNote(n), member.canDeleteNote(n))),
        [(true, true), (false, false), (false, false)],
      );
    });

    test('yönetici/koordinatör üye notunu düzenleyemez, her notu siler', () {
      final memberNote = _n('m', author: 'baska');
      final coordNote = _n('k', author: 'baska', role: MeetingRole.coordinator);
      expect(coord.canEditNote(memberNote), isFalse);
      expect(coord.canEditNote(coordNote), isTrue);
      expect(coord.canDeleteNote(memberNote), isTrue);
    });

    test(
      'göreve dönüştürme yöneticiye/koordinatöre, dönüşmemiş notta (K32)',
      () {
        expect(member.canConvertNote(_n('a')), isFalse);
        expect(coord.canConvertNote(_n('a')), isTrue);
        expect(coord.canConvertNote(_n('b', task: 'w')), isFalse);
      },
    );
  });
}
