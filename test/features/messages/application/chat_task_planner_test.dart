// Mesajdan görev (§10.9) uçtan uca: tasks'ın yeni görev formu "mesajdan görev" kipinde bileşim
// kökünün bağladığı MessagesTaskPlanner → ApiChatRepository → `createTaskFromChatMessage`:
// gövde (departman, tarih, öncelik, atanan; kanıt bayrağı yok), `Idempotency-Key`,
// `conflict_retry` aynı anahtarla tek tekrar; açık sohbetteki mesaj `task_ids` ile güncellenir.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/chat_room_controller.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../meetings/meetings_server.dart';
import '../../pilot_support.dart';

Map<String, Object?> _message({List<String> tasks = const []}) => {
  'message_id': 'm1',
  'chat_id': 'c1',
  'seq': 1,
  'sender_account_id': 'acc-2',
  'sender_name': 'Kadir Özbek',
  'client_message_id': 'k1',
  'body': 'Trafo onayı bekleniyor',
  'reply_to_message_id': null,
  'edited': false,
  'edited_at': null,
  'created_at': '2026-11-09T07:00:00Z',
  'mentions': <Object>[],
  'refs': <Object>[],
  'task_ids': tasks,
  'reactions': <Object>[],
  'pinned_at': null,
  'poll': null,
  'attachments': <Object>[],
  'edit_revision': 0,
};

Map<String, Object?> _chat() => {
  'chat_id': 'c1',
  'kind': 'group',
  'name': 'Saha',
  'source': 'none',
  'source_department_id': null,
  'auto_kind': null,
  'created_by_account_id': null,
  'counterpart_account_id': null,
  'counterpart_name': null,
  'last_seq': 1,
  'last_message_at': null,
  'created_at': '2026-11-01T07:00:00Z',
  'role': 'admin',
};

void main() {
  test(
    'form → createTaskFromChatMessage; conflict_retry aynı anahtarla',
    () async {
      final s = MeetingsServer();
      const path = '/v1/chats/c1/messages/m1/tasks';
      var n = 0;
      s.overrides['POST $path'] = () => n++ == 0
          ? errorBody(409, 'platform.conflict_retry')
          : jsonResponse(201, {
              'work_item_id': 'w9',
              'message': _message(tasks: ['w9']),
            });
      s.overrides['GET /v1/chats/c1'] = () => jsonResponse(200, _chat());
      s.overrides['GET /v1/chats/c1/messages'] = () => jsonResponse(200, {
        'items': [_message()],
        'peer_read_seq': null,
      });
      s.overrides['GET /v1/chats/c1/pins'] = () =>
          jsonResponse(200, {'items': <Object>[], 'truncated': false});
      s.overrides['GET /v1/chats'] = () =>
          jsonResponse(200, {'items': <Object>[], 'next_cursor': ''});
      s.overrides['POST /v1/chats/c1/read'] = () => jsonResponse(204, null);
      final (h, c) = await openMeetings(s);
      c.listen(chatRoomControllerProvider('c1'), (_, _) {});
      await c.read(chatRoomControllerProvider('c1').future);
      c.listen(newTaskFormControllerProvider, (_, _) {});
      final form = c.read(newTaskFormControllerProvider.notifier)
        ..prepare(
          coordinatorship: 'd1',
          title: 'Trafo onayı',
          chatMessage: const ChatTaskSource(chatId: 'c1', messageId: 'm1'),
        );
      expect(c.read(newTaskFormControllerProvider).standalone, isFalse);
      expect(await form.submit(), isNotNull);
      final posts = [
        for (final r in h.backend.requests)
          if (r.method == 'POST' && r.path == path) r,
      ];
      expect(posts, hasLength(2));
      final key = posts.first.headers['Idempotency-Key'];
      expect(key, isNotNull);
      expect(posts.last.headers['Idempotency-Key'], key);
      final body = posts.first.body! as Map<Object?, Object?>;
      expect(body['department_id'], 'd1');
      expect(body['title'], 'Trafo onayı');
      expect(body['priority'], 'orta');
      expect(body.containsKey('completion_evidence_required'), isFalse);
      expect(body['start_date'], isA<String>());
      expect(
        c
            .read(chatRoomControllerProvider('c1'))
            .requireValue
            .message('m1')!
            .taskIds,
        ['w9'],
      );
      // Mesajsız açılış bağımsız göreve döner.
      form.prepare(coordinatorship: 'd1');
      expect(c.read(newTaskFormControllerProvider).chatMessage, isNull);
    },
  );
}
