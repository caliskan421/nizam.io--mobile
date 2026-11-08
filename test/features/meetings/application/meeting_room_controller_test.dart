// Toplantı ayrıntısı: ayrıntı + kalan not sayfaları, iyimser gündem işareti ve hatada geri alma,
// not/gündem yazmaları, konferans başlat/bitir, katılımcı ekleme (kısmi hata), silme sonrası
// listenin yeniden okunması, bağlı koordinatörlük (K21) türetimi.
import 'dart:async';

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
    expect(await ctl.addNote('Basınç testi tamam'), isNull);
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
