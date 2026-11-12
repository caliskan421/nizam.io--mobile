import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/application/coord_member_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

class _Backend extends CoordBackend {
  String? failure;
  final assigned = <Seen>[];
  @override
  ResponseBody handle(Seen r) {
    if (r.path == '/v1/departments/$dAlt/assignable' && r.method == 'GET') {
      if (admin) return errorBody(403, 'organization.not_authorized');
      return jsonResponse(200, {
        'accounts': [
          {
            'account_id': pBahar,
            'full_name': 'Bahar Kılıç',
            'roles': ['$dEgi:uye'],
          },
        ],
      });
    }
    if (r.path == '/v1/departments/$dAlt/memberships' && r.method == 'POST') {
      assigned.add(r);
      if (failure case final code?) return errorBody(403, code);
      final body = r.body! as Map<String, Object?>;
      final id = body['account_id']! as String;
      rosters[dAlt]!.add({
        'membership_id': 'm-$id',
        'account_id': id,
        'full_name': 'Bahar Kılıç',
        'role': 'uye',
        'status': 'active',
      });
      return jsonResponse(201, {
        'membership_id': 'm-$id',
        'program_id': coordProgram,
        'department_id': dAlt,
        'account_id': id,
        'role': 'uye',
      });
    }
    return super.handle(r);
  }
}

Future<Harness> _ready(_Backend b) async {
  final h = await pilotHarness(b, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  await h.read(taskCatalogControllerProvider.future);
  h.container.listen(coordMemberCandidatesProvider(dAlt), (_, _) {});
  h.container.listen(coordMemberControllerProvider(dAlt), (_, _) {});
  return h;
}

void main() {
  test('admin başka ekip üyelerini listeler, hedeftekileri dışlar ve kaynağı korur', () async {
    final b = _Backend();
    final h = await _ready(b);
    final pool = await h.read(coordMemberCandidatesProvider(dAlt).future);
    expect(pool.items.map((p) => p.accountId), containsAll([pBahar, pBurak]));
    expect(pool.items.map((p) => p.accountId), isNot(contains(pKadir)));
    expect(pool.items.map((p) => p.accountId), isNot(contains(pEski)));
    final ctl = h.read(coordMemberControllerProvider(dAlt).notifier);
    ctl.select(pBahar);
    expect(await ctl.submit(), isTrue);
    expect(b.assigned.single.body, {'account_id': pBahar, 'role': 'uye'});
    expect(b.assigned.single.header('X-Nizamio-Program'), coordProgram);
    expect(b.rosters[dEgi]!.any((p) => p['account_id'] == pBahar), isTrue);
    expect(
      h
          .read(taskCatalogControllerProvider)
          .requireValue
          .coordinatorship(dAlt)!
          .team,
      contains(pBahar),
    );
  });

  test(
    'koordinatör atanabilir havuzu kullanır; sunucu reddi başarı sayılmaz',
    () async {
      final b = _Backend()..admin = false;
      final h = await _ready(b);
      final pool = await h.read(coordMemberCandidatesProvider(dAlt).future);
      expect(pool.items.single.accountId, pBahar);
      final ctl = h.read(coordMemberControllerProvider(dAlt).notifier);
      ctl.select(pBahar);
      b.failure = 'organization.not_authorized';
      expect(await ctl.submit(), isFalse);
      expect(
        h.read(coordMemberControllerProvider(dAlt)).error?.code,
        b.failure,
      );
      expect(b.assigned.single.body, {'account_id': pBahar, 'role': 'uye'});
      expect(b.rosters[dAlt]!.any((p) => p['account_id'] == pBahar), isFalse);
    },
  );

  test(
    'havuz dışı kişi veya hedef yetkisi olmayan hesap istek göndermez',
    () async {
      final b = _Backend()..admin = false;
      final h = await _ready(b);
      await h.read(coordMemberCandidatesProvider(dAlt).future);
      final ctl = h.read(coordMemberControllerProvider(dAlt).notifier)
        ..select('unknown');
      expect(await ctl.submit(), isFalse);
      expect(b.assigned, isEmpty);
      await expectLater(
        h.read(coordMemberCandidatesProvider(dEle).future),
        throwsA(anything),
      );
    },
  );

  test(
    'gönderim başlarken program değişirse yazma ilk programa sabitlenir',
    () async {
      final b = _Backend();
      final h = await _ready(b);
      await h.read(coordMemberCandidatesProvider(dAlt).future);
      final ctl = h.read(coordMemberControllerProvider(dAlt).notifier)
        ..select(pBahar);
      final flight = ctl.submit();
      h.read(scopeControllerProvider).selectProgram('prog-2');
      expect(await flight, isFalse);
      expect(b.assigned.single.header('X-Nizamio-Program'), coordProgram);
    },
  );

  test('yanıt beklerken program değişimi eski başarıyı uygulamaz', () async {
    final b = _Backend();
    final h = await _ready(b);
    await h.read(coordMemberCandidatesProvider(dAlt).future);
    final reached = Completer<void>();
    final gate = Completer<void>();
    final serve = h.backend.handler;
    h.backend.handler = (r) async {
      if (r.method == 'POST' && r.path.endsWith('/memberships')) {
        reached.complete();
        await gate.future;
      }
      return serve(r);
    };
    final ctl = h.read(coordMemberControllerProvider(dAlt).notifier)
      ..select(pBahar);
    final flight = ctl.submit();
    await reached.future;
    h.read(scopeControllerProvider).selectProgram('prog-2');
    gate.complete();
    expect(await flight, isFalse);
    expect(h.read(coordMemberControllerProvider(dAlt)).selected, isNull);
  });
}
