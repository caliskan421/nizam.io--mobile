// Mesajlaşma uçlarının SUNUCU BİÇİMLİ bellek içi fikstürü (yalnız test): ekranlar gerçek depo →
// üretilmiş istemci → bu yanıtlar zinciriyle beslenir. Oturumdaki hesap `acc-1` (PilotBackend
// girişi). Akış ucu (`/v1/chats/stream`) 404 döner: ekran testlerinde akış kapalıdır (akış
// döngüsü denetleyici testlerinde sınanır).
import 'package:dio/dio.dart';

import '../../support/fake_backend.dart';
import '../pilot_support.dart';

const chatMe = 'acc-1';

/// Sohbet satırı (sunucu `ChatSummary`).
Map<String, Object?> _chat(
  String id, {
  required String kind,
  String? name,
  String? auto,
  String? counterpart,
  String? counterpartName,
  int unread = 0,
  bool mentioned = false,
  bool? online,
}) => {
  'chat_id': id,
  'kind': kind,
  'name': name,
  'source': auto == null ? 'manual' : 'department',
  'source_department_id': null,
  'auto_kind': auto,
  'created_by_account_id': null,
  'counterpart_account_id': counterpart,
  'counterpart_name': counterpartName,
  'last_seq': 0,
  'last_message_at': null,
  'created_at': '2026-10-01T06:00:00Z',
  'unread_count': unread,
  'mentioned': mentioned,
  'last_message': null,
  'peer_online': online,
  'peer_last_seen_at': null,
};

class ChatFixture {
  ChatFixture() {
    _add(
      'koord',
      'acc-my',
      'Mehmet Yıldız',
      'Bu hafta tüm koordinatörlükler haftalık raporu cuma 17:00’ye kadar yüklesin.',
    );
    _add(
      'koord',
      'acc-rk',
      'Reha Koçak',
      '@Muhammet Ali trafo onayı bugün bekleniyor, son durumu #ELE-4 kartına yazdım.',
    );
    _add(
      'gen',
      'acc-ko',
      'Kadir Özbek',
      'Pompalar 28 Ekim sabahı sahada olacak.',
    );
    _add('gen', chatMe, 'Ayşe Yılmaz', 'Teşekkürler, takipteyim.');
    _add(
      'kadir',
      'acc-ko',
      'Kadir Özbek',
      'Hidrofor için yeni tarih talebini gönderdim.',
    );
    _add('kadir', chatMe, 'Ayşe Yılmaz', 'Planı onayladım.');
    messages['koord']!.first['refs'] = [
      {'ref_id': 'ref-1', 'kind': 'file', 'target_id': 'f1'},
    ];
  }

  /// Liste sırası (son etkinlik).
  final chats = <Map<String, Object?>>[
    _chat(
      'koord',
      kind: 'group',
      name: 'Koordinatörler',
      unread: 1,
      mentioned: true,
    ),
    _chat('gen', kind: 'group', name: 'Genel', auto: 'general', unread: 1),
    _chat(
      'kadir',
      kind: 'direct',
      counterpart: 'acc-ko',
      counterpartName: 'Kadir Özbek',
      online: true,
    ),
  ];

  final messages = <String, List<Map<String, Object?>>>{};
  final reads = <String, String>{};

  /// Eylem yazmaları (`METOT yol`): tepki, sabit, üye, grup ayarı.
  final writes = <String>[];

  /// `getChat` rolü (eylem görünürlüğü).
  String role = 'member';
  var readAll = 0;
  var _seq = 0;

  /// Doluysa sonraki gönderim/düzenleme bu kodla (HTTP durumuyla) düşer.
  (int, String)? sendError;
  (int, String)? editError;

  Map<String, Object?> _message(
    String chat,
    String sender,
    String name,
    String body, {
    String? clientId,
    String? replyTo,
  }) {
    final seq = ++_seq;
    return {
      'message_id': 'm$seq',
      'chat_id': chat,
      'seq': seq,
      'sender_account_id': sender,
      'sender_name': name,
      'client_message_id': clientId ?? 'c$seq',
      'body': body,
      'reply_to_message_id': replyTo,
      'edited': false,
      'edited_at': null,
      'created_at': DateTime.utc(2026, 11, 9, 7, seq).toIso8601String(),
      'mentions': <Object>[],
      'refs': <Object>[],
      'task_ids': <Object>[],
      'reactions': <Object>[],
      'pinned_at': null,
      'poll': null,
      'attachments': <Object>[],
      'edit_revision': 0,
    };
  }

  Map<String, Object?> _add(
    String chat,
    String sender,
    String name,
    String body,
  ) {
    final m = _message(chat, sender, name, body);
    messages.putIfAbsent(chat, () => []).add(m);
    return m;
  }

  Map<String, Object?> _row(Map<String, Object?> c) {
    final list = messages[c['chat_id']] ?? const [];
    final last = list.lastOrNull;
    return {
      ...c,
      'last_seq': last?['seq'] ?? 0,
      'last_message_at': last?['created_at'],
      'last_message': last == null
          ? null
          : {
              'message_id': last['message_id'],
              'seq': last['seq'],
              'sender_account_id': last['sender_account_id'],
              'sender_name': last['sender_name'],
              'body': last['body'],
              'deleted': false,
              'created_at': last['created_at'],
            },
    };
  }

  Map<String, Object?> _detail(Map<String, Object?> c) => {
    for (final e in _row(c).entries)
      if (!const {'unread_count', 'mentioned', 'last_message'}.contains(e.key))
        e.key: e.value,
    'role': role,
  };

  /// Mesajlaşma isteğini yanıtlar; başka uç ise null.
  ResponseBody? handle(Seen r) {
    if (r.path.startsWith('/v1/chat-refs/')) {
      return jsonResponse(200, {
        'ref_id': r.path.split('/').last,
        'kind': 'file',
        'target_id': 'f1',
        'chat_id': 'koord',
        'message_id': 'm1',
        'available': true,
        'file': {
          'name': 'Rapor.pdf',
          'content_type': 'application/pdf',
          'size_bytes': 2400000,
          'created_at': '2026-11-01T07:00:00Z',
        },
      });
    }
    if (!r.path.startsWith('/v1/chats')) return null;
    final key = '${r.method} ${r.path}';
    switch (key) {
      case 'GET /v1/chats':
        return jsonResponse(200, {
          'items': [for (final c in chats) _row(c)],
          'next_cursor': '',
        });
      case 'POST /v1/chats/read-all':
        readAll++;
        for (final c in chats) {
          c['unread_count'] = 0;
          c['mentioned'] = false;
        }
        return ResponseBody.fromString('', 204);
      case 'GET /v1/chats/stream':
        return errorBody(404, 'platform.route_not_found');
      case 'GET /v1/chats/candidates':
        return jsonResponse(200, {
          'items': [
            {
              'account_id': 'acc-rk',
              'full_name': 'Reha Koçak',
              'role': 'coordinator',
            },
          ],
          'truncated': false,
        });
      case 'POST /v1/chats/direct':
        final body = r.body! as Map<String, Object?>;
        final c = _chat(
          'd-${body['account_id']}',
          kind: 'direct',
          counterpart: body['account_id']! as String,
          counterpartName: 'Reha Koçak',
        );
        chats.insert(0, c);
        return jsonResponse(201, _detail(c));
    }
    if (_actions(r) case final res?) return res;
    final m = RegExp(
      r'^/v1/chats/([^/]+)(?:/(messages|read|typing)(?:/([^/]+))?)?$',
    ).firstMatch(r.path);
    if (m == null) return errorBody(404, 'platform.not_found');
    final id = m.group(1)!;
    final chat = chats.where((c) => c['chat_id'] == id).firstOrNull;
    if (chat == null) return errorBody(404, 'messaging.chat_not_found');
    final list = messages.putIfAbsent(id, () => []);
    switch ((r.method, m.group(2), m.group(3))) {
      case ('GET', null, null):
        return jsonResponse(200, _detail(chat));
      case ('GET', 'messages', null):
        final q = r.query;
        final limit = int.tryParse(q['limit'] ?? '') ?? 50;
        int? n(String k) => int.tryParse(q[k] ?? '');
        Iterable<Map<String, Object?>> items = list;
        if (q['q'] case final text?) {
          items = list.where((x) => (x['body']! as String).contains(text));
        } else if (n('after') case final a?) {
          items = list.where((x) => (x['seq']! as int) > a).take(limit);
        } else if (n('around') case final a?) {
          items = list.where((x) => ((x['seq']! as int) - a).abs() <= 2);
        } else {
          if (n('before') case final b?) {
            items = list.where((x) => (x['seq']! as int) < b);
          }
          final all = items.toList();
          items = all.length <= limit ? all : all.sublist(all.length - limit);
        }
        return jsonResponse(200, {
          'items': items.toList(),
          'peer_read_seq': chat['kind'] == 'direct' ? 0 : null,
        });
      case ('POST', 'messages', null):
        if (sendError case (final status, final code)) {
          sendError = null;
          return errorBody(status, code);
        }
        final body = r.body! as Map<String, Object?>;
        final msg = _message(
          id,
          chatMe,
          'Ayşe Yılmaz',
          body['body']! as String,
          clientId: body['client_message_id']! as String,
          replyTo: body['reply_to_message_id'] as String?,
        );
        if (body['poll'] case final Map<String, Object?> poll) {
          final options = poll['options']! as List<Object?>;
          msg['poll'] = {
            'multi': poll['multi'] ?? false,
            'closes_at': null,
            'closed_at': null,
            'results': [
              for (var i = 0; i < options.length; i++)
                {
                  'option_index': i,
                  'label': options[i],
                  'count': 0,
                  'voters': <Object>[],
                },
            ],
          };
        }
        list.add(msg);
        return jsonResponse(201, msg);
      case ('PATCH', 'messages', final mid?):
        if (editError case (final status, final code)) {
          return errorBody(status, code);
        }
        final body = r.body! as Map<String, Object?>;
        final i = list.indexWhere((x) => x['message_id'] == mid);
        list[i] = {
          ...list[i],
          'body': body['body'],
          'edited': true,
          'edit_revision': (list[i]['edit_revision']! as int) + 1,
        };
        return jsonResponse(200, list[i]);
      case ('DELETE', 'messages', final mid?):
        list.removeWhere((x) => x['message_id'] == mid);
        return ResponseBody.fromString('', 204);
      case ('POST', 'read', null):
        reads[id] = (r.body! as Map<String, Object?>)['message_id']! as String;
        chat['unread_count'] = 0;
        chat['mentioned'] = false;
        return ResponseBody.fromString('', 204);
      case ('POST', 'typing', null):
        return ResponseBody.fromString('', 204);
    }
    return errorBody(404, 'platform.not_found');
  }
}

extension on ChatFixture {
  /// Sabit şeridi, üyeler, tepki ve sabitleme (sunucu biçimli; yazmalar [writes]'a).
  ResponseBody? _actions(Seen r) {
    if (RegExp(r'^/v1/chats/[^/]+/refs$').hasMatch(r.path)) {
      return jsonResponse(200, {
        'items': [
          {
            'ref_id': 'ref-1',
            'kind': 'file',
            'target_id': 'f1',
            'message_id': 'm1',
            'sender_account_id': 'acc-my',
            'created_at': '2026-11-01T07:00:00Z',
          },
        ],
        'next_cursor': null,
      });
    }
    if (r.method == 'PATCH' && RegExp(r'^/v1/chats/[^/]+$').hasMatch(r.path)) {
      writes.add('PATCH ${r.path}');
      final c = chats.firstWhere((x) => r.path.endsWith('/${x['chat_id']}'));
      c['name'] = (r.body! as Map<String, Object?>)['name'];
      return jsonResponse(200, _detail(c));
    }
    final m = RegExp(
      r'^/v1/chats/([^/]+)/(pins|admins/[^/]+|members(?:/[^/]+)?|messages/([^/]+)/(reaction|pin))$',
    ).firstMatch(r.path);
    if (m == null) return null;
    final id = m.group(1)!;
    final list = messages[id] ?? const [];
    switch ((r.method, m.group(2)!, m.group(4))) {
      case ('GET', 'pins', null):
        return jsonResponse(200, {
          'items': [
            for (final x in list)
              if (x['pinned_at'] != null) x,
          ],
          'truncated': false,
        });
      case ('GET', 'members', null):
        return jsonResponse(200, {
          'items': [
            for (final (acc, name, role) in [
              (chatMe, 'Ayşe Yılmaz', 'admin'),
              ('acc-rk', 'Reha Koçak', 'member'),
            ])
              {
                'account_id': acc,
                'full_name': name,
                'role': role,
                'founder': false,
                'from_source': false,
              },
          ],
          'truncated': false,
        });
    }
    writes.add('${r.method} ${r.path}');
    final msg = list.where((x) => x['message_id'] == m.group(3)).firstOrNull;
    if (msg != null && m.group(4) == 'reaction') {
      final kind = (r.body as Map<String, Object?>?)?['kind'];
      msg['reactions'] = r.method == 'PUT'
          ? [
              {'kind': kind, 'count': 1, 'mine': true},
            ]
          : <Object>[];
    }
    if (msg != null && m.group(4) == 'pin') {
      msg['pinned_at'] = r.method == 'PUT' ? '2026-11-09T09:00:00Z' : null;
    }
    return ResponseBody.fromString('', 204);
  }
}

/// [ChatFixture] + pilot uçları.
class ChatBackend extends PilotBackend {
  final chats = ChatFixture();

  @override
  ResponseBody handle(Seen r) => chats.handle(r) ?? super.handle(r);
}
