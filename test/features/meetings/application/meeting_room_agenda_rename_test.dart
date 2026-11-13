// Gündem maddesinin satır içi başlık düzenlemesi: iyimser, yalnız `title` gönderilir, hatada
// eski başlık geri gelir; boş ya da aynı başlık istek göndermez.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/application/meeting_room_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';

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

AgendaItem _g1(ProviderContainer c) =>
    c.read(_room).requireValue.detail.agenda.firstWhere((a) => a.id == 'g1');

void main() {
  test('başlık düzenlenir; yalnız title gönderilir, işaret korunur', () async {
    final s = MeetingsServer();
    final (h, c, ctl) = await _open(s);
    expect(await ctl.renameAgenda(_g1(c), '  Bütçe onayı '), isNull);
    expect((_g1(c).title, _g1(c).isChecked), ('Bütçe onayı', false));
    expect(calls(h), ['PATCH /v1/meeting-agenda/g1']);
    expect(h.backend.requests.single.body, {'title': 'Bütçe onayı'});
  });

  test('boş ya da aynı başlık istek göndermez', () async {
    final s = MeetingsServer();
    final (h, c, ctl) = await _open(s);
    expect(await ctl.renameAgenda(_g1(c), '   '), isNull);
    expect(await ctl.renameAgenda(_g1(c), _g1(c).title), isNull);
    expect(calls(h), isEmpty);
  });

  test('hatada eski başlık geri gelir, kod döner', () async {
    final s = MeetingsServer()
      ..overrides['PATCH /v1/meeting-agenda/g1'] = () =>
          errorBody(403, 'collaboration.not_authorized');
    final (_, c, ctl) = await _open(s);
    final before = _g1(c).title;
    final e = await ctl.renameAgenda(_g1(c), 'Yeni');
    expect(e?.code, 'collaboration.not_authorized');
    expect(_g1(c).title, before);
  });
}
