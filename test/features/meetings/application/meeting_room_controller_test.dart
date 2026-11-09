// Toplantı ayrıntısı: ayrıntı + kalan not sayfaları, iyimser gündem işareti ve hatada geri alma,
// not/gündem yazmaları, konferans başlat/bitir, katılımcı ekleme (kısmi hata), silme sonrası
// listenin yeniden okunması, bağlı koordinatörlük (K21) türetimi.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/application/meeting_room_controller.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/domain/meeting_board.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../meetings_server.dart';

final _room = meetingRoomControllerProvider('m1');

Future<(Harness, ProviderContainer, MeetingRoomController)> _open(
  MeetingsServer s,
) async {
  final (h, c) = await openMeetings(s);
  c.listen(_room, (_, _) {});
  await c.read(_room.future);
  h.backend.requests.clear();
  return (h, c, c.read(_room.notifier));
}

MeetingRoom _now(ProviderContainer c) => c.read(_room).requireValue;

DioException _networkError() => DioException(
  requestOptions: RequestOptions(path: '/v1/meetings/m1/notes'),
  type: DioExceptionType.connectionError,
);

ResponseBody _noteCreated(String content) => jsonResponse(
  201,
  noteWire('n-$content', content: content, created: '2030-01-10T08:00:00Z'),
);

/// Gönderilen not isteklerinin işlem anahtarları (sırayla).
List<String?> _noteKeys(Harness h) => [
  for (final r in h.backend.requests)
    if (r.method == 'POST' && r.path == '/v1/meetings/m1/notes')
      r.header('Idempotency-Key'),
];

void main() {
  test('ayrıntı + kalan not sayfası birlikte okunur', () async {
    final s = MeetingsServer()
      ..moreNotes = [noteWire('n2', created: '2026-11-02T07:00:00Z')];
    final (h, c) = await openMeetings(s);
    c.listen(_room, (_, _) {});
    final r = await c.read(_room.future);
    expect(r.notes.map((n) => n.id), ['n1', 'n2']);
    expect(calls(h), ['GET /v1/meetings/m1', 'GET /v1/meetings/m1/notes']);
    expect(h.backend.requests.last.query['cursor'], 'n2');
    expect(r.me, 'acc-1');
    expect(r.permissions.canManage, isTrue);
    expect(
      r.permissions.canManageParticipants,
      isFalse,
      reason: 'koordinatör satırı olmayan yönetici katılımcı yönetemez (K21)',
    );
  });

  test('bağlı departmanın koordinatörü katılımcı yönetir', () async {
    final s = MeetingsServer(admin: false, seat: 'koordinator')
      ..viewerRole = 'coordinator';
    final (_, c, _) = await _open(s);
    expect(_now(c).permissions.canManageParticipants, isTrue);
  });

  test(
    'kişi kipinde yöneten koordinatör bağ olmadan katılımcı yönetir',
    () async {
      final s = MeetingsServer(admin: false)
        ..viewerRole = 'coordinator'
        ..inviteMode = 'person';
      final (_, c, _) = await _open(s);
      expect(_now(c).permissions.canManageParticipants, isTrue);
    },
  );

  test(
    'ayrıntı yazması liste satırının özetini ağ isteği olmadan günceller',
    () async {
      final s = MeetingsServer();
      final (h, c, ctl) = await _open(s);
      c.listen(meetingsBoardControllerProvider, (_, _) {});
      await c.read(meetingsBoardControllerProvider.future);
      expect(await ctl.addAgenda('Yeni'), isNull);
      final row = c.read(meetingsBoardControllerProvider).value!.visible.single;
      expect((row.summary!.agendaTotal, row.summary!.noteCount), (3, 1));
      expect(calls(h).where((x) => x.startsWith('GET /v1/meetings/')), isEmpty);
    },
  );

  test('gündem işareti iyimser; sunucu yanıtıyla oturur', () async {
    final s = MeetingsServer()..hold = Completer();
    final (h, c, ctl) = await _open(s);
    final g1 = _now(c).detail.agenda.first;
    final pending = ctl.toggleAgenda(g1);
    await Future<void>.delayed(Duration.zero);
    final optimistic = _now(c).detail.agenda.first;
    expect(
      (optimistic.isChecked, optimistic.checkedByAccountId),
      (true, 'acc-1'),
    );
    s.hold!.complete();
    expect(await pending, isNull);
    expect(_now(c).detail.agenda.first.isChecked, isTrue);
    expect(calls(h), ['PATCH /v1/meeting-agenda/g1']);
    expect(h.backend.requests.single.body, {'is_checked': true});
  });

  test('gündem işareti hatada geri alınır, kod döner', () async {
    final s = MeetingsServer()
      ..overrides['PATCH /v1/meeting-agenda/g1'] = () =>
          errorBody(403, 'collaboration.not_authorized');
    final (_, c, ctl) = await _open(s);
    final e = await ctl.toggleAgenda(_now(c).detail.agenda.first);
    expect(e?.code, 'collaboration.not_authorized');
    expect(_now(c).detail.agenda.first.isChecked, isFalse);
  });

  test('gündem ekle/sil; silme hatasında madde geri gelir', () async {
    final s = MeetingsServer();
    final (h, c, ctl) = await _open(s);
    expect(await ctl.addAgenda('  Kurulum bütçesi '), isNull);
    expect(_now(c).detail.agenda.last.title, 'Kurulum bütçesi');
    expect(h.backend.requests.single.body, {'title': 'Kurulum bütçesi'});

    s.overrides['DELETE /v1/meeting-agenda/g1'] = () =>
        errorBody(404, 'collaboration.agenda_item_not_found');
    final g1 = _now(c).detail.agenda.first;
    final e = await ctl.deleteAgenda(g1);
    expect(e?.code, 'collaboration.agenda_item_not_found');
    expect(_now(c).detail.agenda.map((a) => a.id), contains('g1'));

    s.overrides.clear();
    expect(await ctl.deleteAgenda(g1), isNull);
    expect(_now(c).detail.agenda.map((a) => a.id), isNot(contains('g1')));
  });

  test('not ekle (başa), düzenle, sil', () async {
    final s = MeetingsServer();
    final (h, c, ctl) = await _open(s);
    expect(await ctl.addNote('Basınç testi tamam'), isA<NoteAdded>());
    expect(
      filterNotes(_now(c).notes, NoteFilter.all, 'acc-1').first.content,
      'Basınç testi tamam',
    );
    final n1 = _now(c).notes.firstWhere((n) => n.id == 'n1');
    expect(await ctl.updateNote(n1, 'Düzeltildi'), isNull);
    expect(_now(c).notes.firstWhere((n) => n.id == 'n1').content, 'Düzeltildi');
    expect(await ctl.updateNote(n1, '  '), isNull, reason: 'boş: istek yok');
    expect(await ctl.deleteNote(_now(c).notes.first), isNull);
    expect(calls(h), [
      'POST /v1/meetings/m1/notes',
      'PATCH /v1/meeting-notes/n1',
      'DELETE /v1/meeting-notes/n9',
    ]);
  });

  test('not: ağ hatasından sonra aynı metin aynı işlem anahtarıyla gider; uçuşta kilitli', () async {
    final s = MeetingsServer();
    var fail = true;
    s.overrides['POST /v1/meetings/m1/notes'] = () =>
        fail ? throw _networkError() : _noteCreated('A');
    final (h, c, ctl) = await _open(s);
    final first = ctl.addNote('A');
    expect(_now(c).noteSubmitting, isTrue, reason: 'kilit denetleyicide');
    expect(await ctl.addNote('B'), isA<NoteIgnored>());
    expect(await first, isA<NoteFailed>(), reason: 'ağ hatası');
    expect(_now(c).noteSubmitting, isFalse);
    fail = false;
    expect(await ctl.addNote(' A '), isA<NoteAdded>());
    final keys = _noteKeys(h);
    expect(keys, hasLength(2), reason: 'kilitliyken B gönderilmedi');
    expect(keys.first, isNotNull);
    expect(keys.last, keys.first, reason: 'tekrar aynı anahtarla');
  });

  test('uçuştayken ikinci gönderim "yoksayıldı": istek yok, anahtar ve kilit değişmez', () async {
    final s = MeetingsServer()..hold = Completer();
    final (h, c, ctl) = await _open(s);
    final first = ctl.addNote('A');
    final key = ctl.pendingNoteKey;
    expect(key, isNotNull);
    final notes = _now(c).notes;
    expect(await ctl.addNote('B'), isA<NoteIgnored>());
    expect(ctl.pendingNoteKey, key, reason: 'anahtar A\'nınki kalır');
    expect(_now(c).noteSubmitting, isTrue);
    expect(_now(c).notes, same(notes));
    s.hold!.complete();
    expect(await first, isA<NoteAdded>());
    expect(_noteKeys(h), [key], reason: 'yalnız A gönderildi');
  });

  test('yenileme uçuş kilidini kaldırmaz: aynı metin ikinci kez gitmez; uçuş bitince kilit '
      'açılır, anahtar korunur', () async {
    final s = MeetingsServer();
    final gate = Completer<void>();
    var n = 0;
    s.overrides['POST /v1/meetings/m1/notes'] = () {
      n++;
      if (n == 1) throw _networkError(); // A: sonucu bilinmiyor
      return _noteCreated('A');
    };
    s.hold = gate;
    final (h, c, ctl) = await _open(s);
    final a = ctl.addNote('A');
    await Future<void>.delayed(Duration.zero);
    final key = ctl.pendingNoteKey;
    // Aşağı çekerek yenileme state'i yeniden kurar; kilit denetleyicide kalır.
    await ctl.refresh();
    final again = c.read(_room.notifier);
    expect(
      _now(c).noteSubmitting,
      isTrue,
      reason: 'kilit yenilemeden sonra da açık',
    );
    expect(await again.addNote('A'), isA<NoteIgnored>(), reason: 'aynı metin');
    expect(
      await again.addNote('B'),
      isA<NoteIgnored>(),
      reason: 'farklı metin',
    );
    expect(_noteKeys(h), hasLength(1), reason: 'tek istek uçuşta');
    gate.complete();
    expect(await a, isA<NoteFailed>());
    expect(_now(c).noteSubmitting, isFalse, reason: 'kendi uçuşu kilidi açtı');
    expect(again.pendingNoteKey, key, reason: 'ağ hatasında anahtar korunur');
    expect(await again.addNote('A'), isA<NoteAdded>());
    final keys = _noteKeys(h);
    expect(keys, [key, key], reason: 'tekrar aynı anahtarla, tek ek istek');
    expect(
      again.pendingNoteKey,
      isNull,
      reason: 'başarıda kendi anahtarı düşer',
    );
  });

  test('not: beklenmeyen Error ile düşen uçuşta da kilit kapanır', () async {
    final s = MeetingsServer();
    var boom = true;
    s.overrides['POST /v1/meetings/m1/notes'] = () =>
        boom ? throw StateError('beklenmeyen') : _noteCreated('A');
    final (h, c, ctl) = await _open(s);
    expect(await ctl.addNote('A'), isA<NoteFailed>());
    expect(
      _now(c).noteSubmitting,
      isFalse,
      reason: 'kilit finally ile kapandı',
    );
    boom = false;
    expect(await ctl.addNote('A'), isA<NoteAdded>(), reason: 'yoksayılmaz');
    expect(_noteKeys(h), hasLength(2));
  });

  test('konferans başlat → canlı; bitir → yok', () async {
    final s = MeetingsServer();
    final (h, c, ctl) = await _open(s);
    expect(await ctl.startConference(), isNull);
    expect(_now(c).detail.conference?.status, ConferenceStatus.live);
    expect(await ctl.endConference(), isNull);
    expect(_now(c).detail.conference, isNull);
    expect(calls(h), [
      'POST /v1/meetings/m1/conference',
      'DELETE /v1/meetings/m1/conference',
    ]);
  });

  test(
    'katılımcı ekleme kısmi hata: eklenenler görünür, ilk hata döner',
    () async {
      final s = MeetingsServer();
      var n = 0;
      s.overrides['POST /v1/meetings/m1/participants'] = () => ++n == 2
          ? errorBody(422, 'collaboration.participant_invalid')
          : jsonResponse(201, {'meeting_id': 'm1', 'user_id': 'x'});
      final (_, c, ctl) = await _open(s);
      final r = await ctl.addParticipants(const [
        MeetingParticipant(accountId: 'u1', fullName: 'Bir'),
        MeetingParticipant(accountId: 'u2', fullName: 'İki'),
        MeetingParticipant(accountId: 'u3', fullName: 'Üç'),
      ]);
      expect(
        (r.added, r.failed, r.error?.code),
        (2, 1, 'collaboration.participant_invalid'),
      );
      expect(_now(c).detail.participants.map((p) => p.accountId), [
        'acc-1',
        'u1',
        'u3',
      ]);
      expect(await ctl.removeParticipant('u1'), isNull);
      expect(
        _now(c).detail.participants.map((p) => p.accountId),
        isNot(contains('u1')),
      );
    },
  );

  test('toplantıyı silmek listeyi yeniden okutur', () async {
    final s = MeetingsServer();
    final (h, c, ctl) = await _open(s);
    c.listen(meetingsBoardControllerProvider, (_, _) {});
    await c.read(meetingsBoardControllerProvider.future);
    h.backend.requests.clear();
    expect(await ctl.deleteMeeting(), isNull);
    await c.read(meetingsBoardControllerProvider.future);
    expect(calls(h), [
      'DELETE /v1/meetings/m1',
      'GET /v1/meetings',
      'GET /v1/admin/deleted/meetings',
    ]);
  });

  test('görünüm: bölüm ve not süzgeci toplantı başına', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final v = meetingDetailViewControllerProvider('m1');
    c.listen(v, (_, _) {});
    c.read(v.notifier)
      ..select(MeetingSection.notes)
      ..filterNotes(NoteFilter.mine);
    expect(
      c.read(v),
      const MeetingDetailView(
        section: MeetingSection.notes,
        noteFilter: NoteFilter.mine,
      ),
    );
    expect(
      c.read(meetingDetailViewControllerProvider('m2')),
      const MeetingDetailView(),
    );
  });
}
