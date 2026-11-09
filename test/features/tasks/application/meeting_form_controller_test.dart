// Hızlı toplantı formu: doğrulama (kişi kipinde sahip koordinatörlük, yer uzunluğu), yeni
// toplantı ve düzenleme gövdeleri (davet kipi, yer; toplantı yazma portu meetings'te; gerçek
// bileşim kökü), kişi kipinde sahip seçenekleri, sunucu hatasında taslağın korunması. "Nottan görev" kipindeki yeni görev formu `convertNoteToTask`'e gider.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/application/meeting_form_controller.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../meetings/meetings_server.dart';
import '../../pilot_support.dart';

Map<Object?, Object?> _body(Harness h) =>
    h.backend.requests.single.body! as Map<Object?, Object?>;

Future<(Harness, ProviderContainer, MeetingFormController)> _open(
  MeetingsServer s,
) async {
  final (h, c) = await openMeetings(s);
  c.listen(meetingFormControllerProvider, (_, _) {});
  return (h, c, c.read(meetingFormControllerProvider.notifier));
}

void main() {
  test('yeni taslak örnek gündem taşımaz', () async {
    final (_, c, _) = await _open(MeetingsServer());
    expect(c.read(meetingFormControllerProvider).agenda, isEmpty);
  });

  test(
    'koordinatörlük kipi: departmanlar, üye bayrağı, gündem, duvar saati',
    () async {
      final (h, c, f) = await _open(MeetingsServer());
      final day = f.today.add(const Duration(days: 2));
      f
        ..prepare(coordinatorship: 'd1', date: day)
        ..setTitle('  Enerji dağıtım planı ')
        ..toggleCoordinatorship('d2')
        ..toggleAllMembers()
        ..setTime(15, 30)
        ..setAgendaDraft('Jeneratör yerleşimi')
        ..addAgenda();
      final sent = await f.submit();
      expect(sent?.title, '  Enerji dağıtım planı ');
      String two(int n) => n.toString().padLeft(2, '0');
      expect(_body(h), {
        'title': 'Enerji dağıtım planı',
        'meeting_date':
            '${day.year}-${two(day.month)}-${two(day.day)}T15:30:00',
        'department_ids': ['d1', 'd2'],
        'members_included': true,
        'invite_mode': 'coordinatorship',
        'agenda_items': ['Jeneratör yerleşimi'],
      });
      expect(
        c.read(meetingFormControllerProvider).title,
        '',
        reason: 'sıfırlandı',
      );
    },
  );

  test('kişi kipi: sahip koordinatörlük zorunlu; katılımcılar gider', () async {
    final (h, c, f) = await _open(MeetingsServer());
    f
      ..prepare()
      ..setTitle('Saha keşfi')
      ..setMode(MeetingMode.people)
      ..togglePerson('u1');
    expect(await f.submit(), isNull);
    expect(c.read(meetingFormControllerProvider).error, MeetingError.owner);
    expect(h.backend.requests, isEmpty);

    f.pickOwner('d2');
    expect(await f.submit(), isNotNull);
    expect(_body(h), {
      'title': 'Saha keşfi',
      'meeting_date': isA<String>(),
      'department_ids': ['d2'],
      'participant_ids': ['u1'],
      'members_included': false,
      'invite_mode': 'person',
    });
  });

  test(
    'kişi kipi: sunucunun yazamadığı katılımcılar gönderilen formda ayrı döner',
    () async {
      final s = MeetingsServer();
      s.overrides['POST /v1/meetings'] = () => jsonResponse(201, {
        'meeting': meetingWire(id: 'm7', title: 'Saha'),
        'failed_participants': ['u2'],
        'side_effects': {'failed_messages': 0, 'event_failed': false},
      });
      final (_, _, f) = await _open(s);
      f
        ..prepare()
        ..setTitle('Saha')
        ..setMode(MeetingMode.people)
        ..togglePerson('u1')
        ..togglePerson('u2')
        ..pickOwner('d2');
      final sent = await f.submit();
      expect(sent?.created?.id, 'm7');
      expect(sent?.people, ['u1', 'u2']);
      expect(sent?.notInvited, ['u2']);
    },
  );

  test('yer: kırpılarak gider; 200 karakteri aşan istek göndermez', () async {
    final (h, c, f) = await _open(MeetingsServer());
    f
      ..prepare(coordinatorship: 'd1')
      ..setTitle('Bütçe')
      ..setPlace('x' * 201);
    expect(await f.submit(), isNull);
    expect(c.read(meetingFormControllerProvider).error, MeetingError.place);
    expect(h.backend.requests, isEmpty);
    f.setPlace('  Toplantı salonu ');
    expect(await f.submit(), isNotNull);
    expect(_body(h)['place'], 'Toplantı salonu');
  });

  test(
    'kişi kipi düzenleme: departman/üye bayrağı/kip gitmez; boş yer kaldırır',
    () async {
      final (h, c, f) = await _open(MeetingsServer()..inviteMode = 'person');
      f.prepareEdit(
        MeetingSeed(
          id: 'm1',
          title: 'Saha',
          at: DateTime(2030, 1, 1, 9),
          departmentIds: const ['d2'],
          membersIncluded: false,
          place: 'Depo',
          byPerson: true,
        ),
      );
      final form = c.read(meetingFormControllerProvider);
      expect(
        (form.mode, form.owner, form.place),
        (MeetingMode.people, 'd2', 'Depo'),
      );
      f.setPlace('');
      expect(
        await f.submit(),
        isNotNull,
        reason: 'katılımcı düzenlemede istenmez',
      );
      expect(_body(h), {
        'title': 'Saha',
        'meeting_date': isA<String>(),
        'place': '',
      });
    },
  );

  test('sahip seçenekleri: yönetici hepsi, koordinatör yalnız kendi koordinatörlüğü', () {
    TaskCatalog cat({required bool admin}) => TaskCatalog(
      today: DateTime(2030),
      me: 'me',
      tasks: const [],
      people: const [],
      access: TaskAccess(accountId: 'me', companyAdmin: admin, seats: const []),
      coordinatorships: const [
        CoordinatorshipRef(code: 'd1', name: 'A', leads: ['me'], members: []),
        CoordinatorshipRef(
          code: 'd2',
          name: 'B',
          leads: ['x'],
          members: ['me'],
        ),
      ],
    );
    expect(meetingOwnerChoices(cat(admin: true)).map((c) => c.code), [
      'd1',
      'd2',
    ]);
    expect(meetingOwnerChoices(cat(admin: false)).map((c) => c.code), ['d1']);
  });

  test('düzenleme: PATCH, geçmiş gün bugüne çekilir; gündem/kip yok', () async {
    final (h, c, f) = await _open(MeetingsServer());
    f.prepareEdit(
      MeetingSeed(
        id: 'm1',
        title: 'Haftalık',
        at: DateTime(2020, 1, 1, 9, 15),
        departmentIds: const ['d1'],
        membersIncluded: false,
      ),
    );
    final form = c.read(meetingFormControllerProvider);
    expect(
      (form.editing, form.date, form.hour, form.minute),
      ('m1', f.today, 9, 15),
    );
    expect(await f.submit(), isNotNull);
    expect(h.backend.requests.single.method, 'PATCH');
    expect(h.backend.requests.single.path, '/v1/meetings/m1');
    expect(_body(h)['department_ids'], ['d1']);
    // Düzenlemeden sonra yeni toplantı boş taslakla açılır.
    f.prepare();
    expect(c.read(meetingFormControllerProvider).editing, isNull);
    expect(c.read(meetingFormControllerProvider).title, '');
  });

  test('sunucu hatası: kod formda, taslak korunur', () async {
    final s = MeetingsServer()
      ..overrides['POST /v1/meetings'] = () =>
          errorBody(422, 'collaboration.scope_invalid');
    final (_, c, f) = await _open(s);
    f
      ..prepare(coordinatorship: 'd1')
      ..setTitle('Bütçe');
    expect(await f.submit(), isNull);
    final form = c.read(meetingFormControllerProvider);
    expect(
      (form.failure?.code, form.title, form.busy),
      ('collaboration.scope_invalid', 'Bütçe', false),
    );
  });

  test(
    'nottan görev: convertNoteToTask gövdesi; kanıt bayrağı gitmez',
    () async {
      final (h, c) = await openMeetings(MeetingsServer());
      c.listen(newTaskFormControllerProvider, (_, _) {});
      final t = c.read(newTaskFormControllerProvider.notifier)
        ..prepare(coordinatorship: 'd1', note: 'n1', title: 'Vana eksik');
      expect(c.read(newTaskFormControllerProvider).note, 'n1');
      final r = await t.submit();
      expect(r, isNotNull);
      final req = h.backend.requests.firstWhere((r) => r.method == 'POST');
      expect(req.path, '/v1/meeting-notes/n1/convert-to-task');
      final body = req.body! as Map<Object?, Object?>;
      expect(body['title'], 'Vana eksik');
      expect(body['department_id'], 'd1');
      expect(body.containsKey('completion_evidence_required'), isFalse);
      // Nottan olmayan açılış bağımsız göreve döner.
      t.prepare(coordinatorship: 'd1');
      expect(c.read(newTaskFormControllerProvider).note, isNull);
    },
  );
}
