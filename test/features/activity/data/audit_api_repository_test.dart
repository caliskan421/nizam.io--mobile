// İşlem geçmişi data katmanı (iPad 26): `GET /v1/audit/entries` → ActivityLog; tür eylem kodu
// önekinden, aktör süzgeci sorguda, sistem kaydı boş aktör, 403 → ActivityUnavailable.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/activity/data/audit_api_repository.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);
  ResponseBody Function(RequestOptions o) respond;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int status = 200]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

(ApiActivityLogRepository, _Adapter) _repo(
  ResponseBody Function(RequestOptions o) respond,
) {
  final adapter = _Adapter(respond);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = adapter;
  return (
    ApiActivityLogRepository(() => dio, now: () => DateTime(2026, 11, 14)),
    adapter,
  );
}

Map<String, Object?> _entry(
  String id,
  String code, {
  String? actor = 'u1',
  String? dept = 'd1',
  String outcome = 'succeeded',
}) => {
  'entry_id': id,
  'occurred_at': '2026-11-14T09:30:00Z',
  'actor_account_id': actor,
  'actor_full_name': actor == null ? null : 'Ayşe Yılmaz',
  'subject_kind': 'work_item',
  'subject_id': 'w1',
  'action_code': code,
  'outcome': outcome,
  'program_id': 'p1',
  'department_id': dept,
  'details': code == 'work.item.transitioned'
      ? 'acting_as=company_admin'
      : null,
};

void main() {
  test(
    'kayıtlar eşlenir: tür önekten, kişi/departman önerileri, sistem kaydı',
    () async {
      final (repo, a) = _repo(
        (_) => _json({
          'entries': [
            _entry('e1', 'work.item.transitioned'),
            _entry('e2', 'records.file.tag_changed', outcome: 'failed'),
            _entry('e3', 'identity.session.opened', actor: null, dept: null),
          ],
          'next_cursor': null,
        }),
      );
      final log = await repo.load();
      final o = a.seen.single;
      expect('${o.method} ${o.uri.path}', 'GET /v1/audit/entries');
      expect(o.uri.queryParameters, {'limit': '200'});
      expect(log.today, DateTime(2026, 11, 14));
      final [e1, e2, e3] = log.entries;
      expect(
        (e1.kind, e1.actionCode, e1.detail, e1.subjectKind, e1.subjectId),
        (
          ActivityKind.task,
          'work.item.transitioned',
          'acting_as=company_admin',
          'work_item',
          'w1',
        ),
      );
      expect(
        (e1.actorId, e1.actorName, e1.departmentId),
        ('u1', 'Ayşe Yılmaz', 'd1'),
      );
      expect((e2.kind, e2.failed), (ActivityKind.file, true));
      expect(
        (e3.kind, e3.actorId, e3.actorName),
        (ActivityKind.account, '', ''),
      );
      expect(e1.at, DateTime.utc(2026, 11, 14, 9, 30).toLocal());
      expect(log.people, ['u1']);
      expect(log.coordinatorships, ['d1']);
    },
  );

  test('kişiye özel: actor_account_id sorguda', () async {
    final (repo, a) = _repo(
      (_) => _json({'entries': <Object>[], 'next_cursor': null}),
    );
    await repo.load(actorAccountId: 'u7');
    expect(a.seen.single.uri.queryParameters['actor_account_id'], 'u7');
  });

  test(
    '403 audit.not_authorized → ActivityUnavailable; diğer hata ApiError',
    () async {
      final (repo, _) = _repo(
        (_) => _json({
          'code': 'audit.not_authorized',
          'message': 'x',
          'request_id': 'r',
        }, 403),
      );
      await expectLater(repo.load(), throwsA(isA<ActivityUnavailable>()));
      final (repo2, _) = _repo(
        (_) => _json({
          'code': 'audit.input_invalid',
          'message': 'x',
          'request_id': 'r',
        }, 422),
      );
      await expectLater(repo2.load(), throwsA(isA<ApiError>()));
    },
  );
}
