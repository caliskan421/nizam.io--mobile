// Koordinatörlük formunun sözleşme alanları: kısa kod kuralı (ORGANIZATION-K10) ve gövdeye
// yazımı, düzenlemede kod, ad çakışmasında var olan kaydın ekibinin başka programdan kopyası
// (`copy_members_from_program_id`), başarıda bağlanan departman kimliği.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_form_controller.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorships_controller.dart';
import 'package:nizamio/features/coordinatorships/domain/department.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

Future<Harness> _harness(CoordBackend backend) async {
  final h = await pilotHarness(backend, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  h.container.listen(coordinatorshipListProvider, (_, _) {});
  await h.read(taskCatalogControllerProvider.future);
  return h;
}

List<List<Object?>> _log(CoordBackend b) => [
  for (final (k, body) in b.writes) [k, body],
];

void main() {
  test('kısa kod kuralı: boş geçerli; kırpılır, büyük harfe çevrilir', () {
    for (final ok in ['', '  ', 'AB', 'alt', ' sh1 ', 'ABCDE12345']) {
      expect(DepartmentCode.isValid(ok), isTrue, reason: ok);
    }
    for (final bad in ['A', 'ABCDE123456', 'A-B', 'ŞH', 'A B', 'ç1']) {
      expect(DepartmentCode.isValid(bad), isFalse, reason: bad);
    }
    expect(DepartmentCode.normalize(' sh1 '), 'SH1');
    expect(
      const CoordinatorshipDraft(name: 'x', kind: null, code: ' ').wireCode,
      isNull,
    );
  });

  test('oluştur: kod gövdeye normalize gider; bağlanan kimlik döner', () async {
    final backend = CoordBackend();
    final h = await _harness(backend);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    final ok = await ctl.create(
      const CoordinatorshipDraft(
        name: 'Saha',
        kind: DepartmentKind.coordinatorship,
        code: ' sh1 ',
      ),
    );
    expect(ok, isTrue);
    expect(_log(backend).first, [
      'POST /v1/departments',
      {'name': 'Saha', 'kind': 'koordinatorluk', 'code': 'SH1'},
    ]);
    expect(ctl.createdId, 'dep-new-3');
  });

  test('kod çakışması (409) hata durumunda; bekleyen yok', () async {
    final backend = CoordBackend();
    final h = await _harness(backend);
    final serve = h.backend.handler;
    h.backend.handler = (r) => r.method == 'POST' && r.path == '/v1/departments'
        ? errorBody(409, 'organization.department_code_conflict')
        : serve(r);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    expect(
      await ctl.create(
        const CoordinatorshipDraft(
          name: 'Saha',
          kind: DepartmentKind.coordinatorship,
          code: 'ALT',
        ),
      ),
      isFalse,
    );
    final f = h.read(coordinatorshipFormControllerProvider);
    expect(f.error?.code, 'organization.department_code_conflict');
    expect(f.pending, isNull);
    expect(ctl.createdId, isNull);
  });

  test(
    'ad çakışması: var olan kayıt başka programın ekibiyle bağlanır',
    () async {
      final backend = CoordBackend();
      final h = await _harness(backend);
      final serve = h.backend.handler;
      h.backend.handler = (r) {
        if (r.method == 'POST' && r.path == '/v1/departments') {
          return jsonResponse(409, {
            'code': 'organization.department_exists',
            'message': '',
            'request_id': 'r',
            'fields': [
              {
                'field': 'department_id',
                'code': 'organization.existing_department',
                'message': 'dep-old',
              },
              {
                'field': 'deleted',
                'code': 'organization.existing_department',
                'message': 'false',
              },
            ],
          });
        }
        if (r.method == 'POST' && r.path == '/v1/program/departments') {
          backend.writes.add(('POST /v1/program/departments', r.body));
          return jsonResponse(201, {
            'program_id': coordProgram,
            'department_id': 'dep-old',
            'display_name': 'Saha',
            'copied_member_count': 3,
          });
        }
        return serve(r);
      };
      final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
      expect(
        await ctl.create(
          const CoordinatorshipDraft(
            name: 'Saha',
            kind: DepartmentKind.coordinatorship,
          ),
        ),
        isFalse,
      );
      expect(
        h.read(coordinatorshipFormControllerProvider).existingId,
        'dep-old',
      );
      expect(await ctl.confirmExisting(copyMembersFrom: 'prog-2024'), isTrue);
      expect(_log(backend).last, [
        'POST /v1/program/departments',
        {
          'department_id': 'dep-old',
          'display_name': 'Saha',
          'copy_members_from_program_id': 'prog-2024',
        },
      ]);
      expect(ctl.createdId, 'dep-old');
    },
  );

  test('düzenle: kod yalnız dolu ve farklıysa departman kaydına', () async {
    final backend = CoordBackend();
    final h = await _harness(backend);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    const initial = CoordinatorshipDraft(
      name: 'Altyapı ve tesisat',
      kind: DepartmentKind.coordinatorship,
      code: 'ALT',
      description: 'Su ve yapı işleri',
    );
    // Boş kod "değişmez" (sunucu boşaltmaz) → istek yok.
    expect(
      await ctl.edit(
        dAlt,
        initial: initial,
        draft: const CoordinatorshipDraft(
          name: 'Altyapı ve tesisat',
          kind: DepartmentKind.coordinatorship,
          description: 'Su ve yapı işleri',
        ),
      ),
      isTrue,
    );
    expect(backend.writes, isEmpty);
    expect(
      await ctl.edit(
        dAlt,
        initial: initial,
        draft: const CoordinatorshipDraft(
          name: 'Altyapı ve tesisat',
          kind: DepartmentKind.coordinatorship,
          code: 'alt2',
          description: 'Su ve yapı işleri',
        ),
      ),
      isTrue,
    );
    expect(_log(backend), [
      [
        'PATCH /v1/departments/$dAlt',
        {'code': 'ALT2'},
      ],
    ]);
  });
}
