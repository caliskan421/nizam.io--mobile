// CoordinatorshipFormController (sunucu biçimli sahte backend): oluştur → programa bağla →
// liste yenilenir; bağlama düşerse departman bekler ve tekrar denemede yeniden oluşturulmaz;
// düzenleme tür/açıklamayı departman kaydına, adı programdaki bağa yazar; yetki görünürlüğü.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorship_form_controller.dart';
import 'package:nizamio/features/coordinatorships/application/coordinatorships_controller.dart';
import 'package:nizamio/features/coordinatorships/domain/department.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

/// Silmeyi [hold] tamamlanana dek bekleten bellek deposu.
class _GatedStore extends MemorySecureStore {
  Completer<void>? hold;

  @override
  Future<void> delete(String key) async {
    await hold?.future;
    return super.delete(key);
  }
}

Future<Harness> _harness(CoordBackend backend) async {
  final h = await pilotHarness(backend, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  h.container.listen(coordinatorshipListProvider, (_, _) {});
  await h.read(taskCatalogControllerProvider.future);
  return h;
}

List<String> _names(Harness h) => [
  for (final c in h.read(coordinatorshipListProvider).requireValue) c.name,
];

List<String> _writes(CoordBackend b) => [for (final (k, _) in b.writes) k];

/// Yazmalar `[yol, gövde]` listesi olarak (derin karşılaştırma).
List<List<Object?>> _log(CoordBackend b) => [
  for (final (k, body) in b.writes) [k, body],
];

void main() {
  test('oluştur → seçili programa bağla → liste yenilenir', () async {
    final backend = CoordBackend();
    final h = await _harness(backend);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    final ok = await ctl.create(
      const CoordinatorshipDraft(
        name: 'Saha',
        kind: DepartmentKind.workingGroup,
        description: 'Saha işleri',
      ),
    );
    expect(ok, isTrue);
    expect(_log(backend), [
      [
        'POST /v1/departments',
        {'name': 'Saha', 'kind': 'calisma_grubu', 'description': 'Saha işleri'},
      ],
      [
        'POST /v1/program/departments',
        {'department_id': 'dep-new-3', 'display_name': 'Saha'},
      ],
    ]);
    expect(h.read(coordinatorshipFormControllerProvider).pending, isNull);
    expect(_names(h), contains('Saha'));
    expect(backend.unhandled, isEmpty);
  });

  test('bağlama düşer → departman bekler; tekrar denemede yeniden oluşturulmaz', () async {
    final backend = CoordBackend()..linkError = 'platform.internal';
    final h = await _harness(backend);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    const draft = CoordinatorshipDraft(
      name: 'Saha',
      kind: DepartmentKind.coordinatorship,
    );
    expect(await ctl.create(draft), isFalse);
    var f = h.read(coordinatorshipFormControllerProvider);
    expect(f.error?.code, 'platform.internal');
    expect(f.pending?.id, 'dep-new-3');
    expect(_names(h), isNot(contains('Saha')));

    // Form yeniden açılır: hata silinir, bekleyen departman kalır.
    ctl.clearError();
    f = h.read(coordinatorshipFormControllerProvider);
    expect((f.error, f.pending?.id), (null, 'dep-new-3'));

    backend.linkError = null;
    // Programdaki ad değiştirilerek yeniden denenir: yalnız bağlama, yeni adla.
    expect(
      await ctl.create(
        const CoordinatorshipDraft(
          name: 'Saha ekibi',
          kind: DepartmentKind.coordinatorship,
        ),
      ),
      isTrue,
    );
    expect(_writes(backend), [
      'POST /v1/departments',
      'POST /v1/program/departments',
      'POST /v1/program/departments',
    ]);
    expect(backend.writes.last.$2, {
      'department_id': 'dep-new-3',
      'display_name': 'Saha ekibi',
    });
    expect(h.read(coordinatorshipFormControllerProvider).pending, isNull);
    expect(_names(h), contains('Saha ekibi'));
  });

  test('bağlama hatası → çıkış, başka hesapla giriş → form boş; tekrar eski departmanı kullanmaz', () async {
    final backend = CoordBackend()..linkError = 'platform.internal';
    final h = await _harness(backend);
    var account = 'acc-1';
    final serve = h.backend.handler;
    h.backend.handler = (r) => r.method == 'POST' && r.path == '/v1/auth/login'
        ? jsonResponse(200, loginBody('1')..['account_id'] = account)
        : serve(r);
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
      h.read(coordinatorshipFormControllerProvider).pending?.id,
      'dep-new-3',
    );

    await h.identity.logout();
    expect(h.read(coordinatorshipFormControllerProvider).pending, isNull);
    account = 'acc-2';
    await h.identity.login(email: 'b@b.test', password: 'p');
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    final f = h.read(coordinatorshipFormControllerProvider);
    expect((f.pending, f.error, f.saving), (null, null, false));

    backend
      ..linkError = null
      ..writes.clear();
    expect(
      await ctl.create(
        const CoordinatorshipDraft(
          name: 'Depo',
          kind: DepartmentKind.coordinatorship,
        ),
      ),
      isTrue,
    );
    // Yeni hesabın departmanı yeniden oluşturulur; önceki hesabın kimliği bağlanmaz.
    expect(_log(backend), [
      [
        'POST /v1/departments',
        {'name': 'Depo', 'kind': 'koordinatorluk'},
      ],
      [
        'POST /v1/program/departments',
        {'department_id': 'dep-new-4', 'display_name': 'Depo'},
      ],
    ]);
  });

  test('program değişir → bekleyen departman silinir', () async {
    final backend = CoordBackend()..linkError = 'platform.internal';
    final h = await _harness(backend);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    await ctl.create(
      const CoordinatorshipDraft(
        name: 'Saha',
        kind: DepartmentKind.coordinatorship,
      ),
    );
    expect(h.read(coordinatorshipFormControllerProvider).pending, isNotNull);
    h.read(scopeControllerProvider).selectProgram('prog-2');
    expect(h.read(coordinatorshipFormControllerProvider).pending, isNull);
  });

  test('uçuştaki bağlama çıkıştan sonra döner → sonucu yok sayılır', () async {
    final backend = CoordBackend();
    final h = await _harness(backend);
    final reached = Completer<void>();
    final gate = Completer<void>();
    final serve = h.backend.handler;
    h.backend.handler = (r) async {
      if (r.method == 'POST' && r.path == '/v1/program/departments') {
        reached.complete();
        await gate.future;
      }
      return serve(r);
    };
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    final flight = ctl.create(
      const CoordinatorshipDraft(
        name: 'Saha',
        kind: DepartmentKind.coordinatorship,
      ),
    );
    await reached.future;
    await h.identity.logout();
    gate.complete();
    expect(await flight, isFalse);
    final f = h.read(coordinatorshipFormControllerProvider);
    expect((f.pending, f.error, f.saving), (null, null, false));
  });

  test('oturum nesli arttı, bildirim henüz yok → dönen oluşturma yanıtı bağlamaya geçmez', () async {
    final backend = CoordBackend();
    // Depo temizliği bekletilir: nesil artar, oturum durumu yayımlanmaz.
    final store = _GatedStore();
    final h = Harness(handler: backend.handle, store: store);
    addTearDown(h.dispose);
    await h.read(serverBindingProvider).verify(testUrl);
    await h.identity.login(email: 'a@b.test', password: 'p');
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    await h.read(taskCatalogControllerProvider.future);
    final reached = Completer<void>();
    final gate = Completer<void>();
    final serve = h.backend.handler;
    h.backend.handler = (r) async {
      if (r.method == 'POST' && r.path == '/v1/departments') {
        reached.complete();
        await gate.future;
      }
      return serve(r);
    };
    final flight = h
        .read(coordinatorshipFormControllerProvider.notifier)
        .create(
          const CoordinatorshipDraft(
            name: 'Saha',
            kind: DepartmentKind.coordinatorship,
          ),
        );
    await reached.future;
    final session = h.read(sessionControllerProvider);
    store.hold = Completer();
    final cleared = session.clear();
    gate.complete();
    expect(await flight, isFalse);
    expect(session.state.value, isA<SessionActive>(), reason: 'aralık');
    expect(_writes(backend), ['POST /v1/departments']);
    store.hold!.complete();
    await cleared;
  });

  test('bağ kurulmuş, yanıt kaybolmuş → tekrar denemede dönen eski ad yeniden adlandırılır', () async {
    final backend = CoordBackend()..linkLost = true;
    final h = await _harness(backend);
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
    backend.linkLost = false;
    expect(
      await ctl.create(
        const CoordinatorshipDraft(
          name: 'Saha ekibi',
          kind: DepartmentKind.coordinatorship,
        ),
      ),
      isTrue,
    );
    // Var olan bağ eski adla döner (sunucu adı değiştirmez) → programdaki ad düzeltilir.
    expect(_log(backend), [
      [
        'POST /v1/departments',
        {'name': 'Saha', 'kind': 'koordinatorluk'},
      ],
      [
        'POST /v1/program/departments',
        {'department_id': 'dep-new-3', 'display_name': 'Saha'},
      ],
      [
        'POST /v1/program/departments',
        {'department_id': 'dep-new-3', 'display_name': 'Saha ekibi'},
      ],
      [
        'PATCH /v1/program/departments/dep-new-3',
        {'display_name': 'Saha ekibi'},
      ],
    ]);
    expect(_names(h), contains('Saha ekibi'));
    expect(_names(h), isNot(contains('Saha')));
  });

  test('oluşturma hatası: bekleyen yok, hata durumda', () async {
    final backend = CoordBackend();
    final h = await _harness(backend);
    final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
    // Ad küresel tekil (büyük/küçük harf duyarsız).
    expect(
      await ctl.create(
        const CoordinatorshipDraft(
          name: 'altyapı ve tesisat',
          kind: DepartmentKind.coordinatorship,
        ),
      ),
      isFalse,
    );
    final f = h.read(coordinatorshipFormControllerProvider);
    expect(f.error?.code, 'organization.department_exists');
    expect(f.pending, isNull);
    expect(_writes(backend), ['POST /v1/departments']);
  });

  test(
    'düzenle: tür/açıklama departman kaydına, ad programdaki bağa',
    () async {
      final backend = CoordBackend();
      final h = await _harness(backend);
      final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
      const initial = CoordinatorshipDraft(
        name: 'Altyapı ve tesisat',
        kind: DepartmentKind.coordinatorship,
        description: 'Su ve yapı işleri',
      );
      // Değişiklik yok → istek yok.
      expect(await ctl.edit(dAlt, initial: initial, draft: initial), isTrue);
      expect(backend.writes, isEmpty);

      // Yalnız ad: yalnız programdaki ad.
      expect(
        await ctl.edit(
          dAlt,
          initial: initial,
          draft: const CoordinatorshipDraft(
            name: 'Altyapı',
            kind: DepartmentKind.coordinatorship,
            description: 'Su ve yapı işleri',
          ),
        ),
        isTrue,
      );
      expect(_log(backend), [
        [
          'PATCH /v1/program/departments/$dAlt',
          {'display_name': 'Altyapı'},
        ],
      ]);
      expect(_names(h), contains('Altyapı'));

      // Tür ve açıklama (boş → silinir): yalnız değişen alanlarla departman kaydı.
      backend.writes.clear();
      expect(
        await ctl.edit(
          dAlt,
          initial: initial,
          draft: const CoordinatorshipDraft(
            name: 'Altyapı ve tesisat',
            kind: DepartmentKind.workingGroup,
          ),
        ),
        isTrue,
      );
      expect(_log(backend), [
        [
          'PATCH /v1/departments/$dAlt',
          {'kind': 'calisma_grubu', 'description': ''},
        ],
      ]);
    },
  );

  test(
    'yetkisiz: düzenleme hatası durumda; düğme görünürlüğü yöneticide',
    () async {
      final backend = CoordBackend()..admin = false;
      final h = await _harness(backend);
      expect(h.read(canManageCoordinatorshipsProvider), isFalse);
      final ctl = h.read(coordinatorshipFormControllerProvider.notifier);
      expect(
        await ctl.edit(
          dAlt,
          initial: const CoordinatorshipDraft(name: 'A', kind: null),
          draft: const CoordinatorshipDraft(name: 'B', kind: null),
        ),
        isFalse,
      );
      expect(
        h.read(coordinatorshipFormControllerProvider).error?.code,
        'program.not_authorized',
      );

      final admin = await _harness(CoordBackend());
      expect(admin.read(canManageCoordinatorshipsProvider), isTrue);
    },
  );
}
