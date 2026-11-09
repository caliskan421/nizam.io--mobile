// Kullanıcı ekle formu (sunucu biçimli sahte backend, gerçek depo zinciri): doğrulama istek
// göndermez; yönetici rol/yöneticilik gönderir, koordinatör yalnız kendi koordinatörlüğüne üye
// ekler; var olan e-postada aktarım teklifi ikinci gönderimde `transfer_account_id` olur;
// sunucu hatası başarı sayılmaz; başarıda ekip yeniden okunur; oturum değişince taslak düşer.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/invite_form_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

/// [CoordBackend] + `POST /v1/admin/users`: e-posta tekildir; yeni hesap ya da aktarım hedef
/// ekibe üye satırı ekler. Koordinatör çağıranın rolü `uye`'ye zorlanır, başka departman 403.
class _Backend extends CoordBackend {
  /// Kayıtlı e-postalar → (hesap, ad).
  final accounts = <String, (String, String)>{
    'kadir@ornek.test': (pKadir, 'Kadir Özbek'),
  };

  /// Gönderilen `createUser` gövdeleri.
  final created = <Map<String, Object?>>[];

  /// Doluysa `createUser` bu durum ve kodla düşer.
  (int, String)? fail;

  @override
  ResponseBody handle(Seen r) {
    if ('${r.method} ${r.path}' != 'POST /v1/admin/users') {
      return super.handle(r);
    }
    final body = r.body! as Map<String, Object?>;
    created.add(body);
    if (fail case (final status, final code)) return errorBody(status, code);
    final dept = body['department_id']! as String;
    if (!admin && dept != dAlt) {
      return errorBody(403, 'organization.not_authorized');
    }
    final transfer = body['transfer_account_id'] as String?;
    var account = transfer;
    var name = 'Aktarılan';
    if (account == null) {
      final email = body['email']! as String;
      if (accounts[email] case (final id, final full)) {
        return errorBody(
          409,
          'identity.account_exists',
          fields: [
            if (admin) ...[
              {
                'field': 'email',
                'code': 'organization.transfer_available',
                'message': 'aktarım yapılabilir',
              },
              {
                'field': 'account_id',
                'code': 'organization.transfer_available',
                'message': id,
              },
              {
                'field': 'user_full_name',
                'code': 'organization.transfer_available',
                'message': full,
              },
            ],
          ],
        );
      }
      name = body['full_name']! as String;
      account = 'acc-new-${accounts.length}';
      accounts[email] = (account, name);
    }
    final role = admin ? body['role']! as String : 'uye';
    rosters[dept]!.add({
      'membership_id': 'm-$account',
      'account_id': account,
      'full_name': name,
      'role': role,
      'status': 'active',
    });
    return jsonResponse(201, {
      'account_id': account,
      'membership_id': 'm-$account',
      'created': transfer == null,
      'transferred': transfer != null,
    });
  }
}

Future<Harness> _harness(_Backend backend) async {
  final h = await pilotHarness(backend, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  await h.read(taskCatalogControllerProvider.future);
  return h;
}

InviteFormController _ctl(Harness h) =>
    h.read(inviteFormControllerProvider.notifier);

InviteForm _form(Harness h) => h.read(inviteFormControllerProvider);

List<String> _team(Harness h, String dept) => h
    .read(taskCatalogControllerProvider)
    .requireValue
    .coordinatorship(dept)!
    .team;

void main() {
  test('doğrulama: ad, e-posta, koordinatörlük; istek gönderilmez', () async {
    final backend = _Backend();
    final h = await _harness(backend);
    final ctl = _ctl(h);
    expect(await ctl.submit(), isNull);
    expect(_form(h).error, InviteError.name);
    ctl
      ..setName('Ayşe Deneme')
      ..setEmail('ayse');
    expect(await ctl.submit(), isNull);
    expect(_form(h).error, InviteError.email);
    ctl.setEmail('ayse.deneme@ornek.test');
    expect(await ctl.submit(), isNull);
    expect(_form(h).error, InviteError.coordinatorship);
    expect(backend.created, isEmpty);

    // Koordinatörlük ayrıntısından açılış: o koordinatörlük seçili, rol üye.
    ctl
      ..setRole(InviteRole.coordinator)
      ..prepare(coordinatorship: dEgi);
    expect(
      (_form(h).coordinatorship, _form(h).role),
      (dEgi, InviteRole.member),
    );
  });

  test('yönetici: hesap açılır ve ekibe eklenir; rol gönderilir; ekip yeniden okunur', () async {
    final backend = _Backend();
    final h = await _harness(backend);
    final ctl = _ctl(h)
      ..setName(' Ayşe Deneme ')
      ..setEmail('ayse@ornek.test ')
      ..setRole(InviteRole.coordinator)
      ..togglePane()
      ..pickCoordinatorship(dEle);
    expect(_form(h).paneOpen, isFalse);
    final sent = await ctl.submit();
    expect(sent?.email.trim(), 'ayse@ornek.test');
    expect(backend.created, [
      {
        'email': 'ayse@ornek.test',
        'program_id': coordProgram,
        'department_id': dEle,
        'full_name': 'Ayşe Deneme',
        'role': 'koordinator',
      },
    ]);
    expect(_form(h).name, '', reason: 'başarıda taslak sıfırlanır');
    expect(_team(h, dEle), contains('acc-new-1'));

    // Yönetici rolü: yöneticilik bayrağı, ekip satırı üye.
    backend.created.clear();
    ctl
      ..setName('Can Yönetici')
      ..setEmail('can@ornek.test')
      ..setRole(InviteRole.admin)
      ..pickCoordinatorship(dAlt);
    expect(await ctl.submit(), isNotNull);
    expect(backend.created.single, containsPair('company_admin', true));
    expect(backend.created.single, containsPair('role', 'uye'));
  });

  test(
    'var olan e-posta: aktarım teklifi; ikinci gönderim var olan hesabı ekler',
    () async {
      final backend = _Backend();
      final h = await _harness(backend);
      final ctl = _ctl(h)
        ..setName('Kadir')
        ..setEmail('kadir@ornek.test')
        ..pickCoordinatorship(dEle);
      expect(await ctl.submit(), isNull);
      var f = _form(h);
      expect(f.existing, (accountId: pKadir, fullName: 'Kadir Özbek'));
      expect((f.failure, f.busy), (null, false));

      expect(await ctl.submit(), isNotNull);
      expect(backend.created.last, {
        'email': 'kadir@ornek.test',
        'program_id': coordProgram,
        'department_id': dEle,
        'role': 'uye',
        'transfer_account_id': pKadir,
      });
      expect(_team(h, dEle), contains(pKadir));

      // E-posta değişince teklif düşer.
      ctl
        ..setName('Kadir')
        ..setEmail('kadir@ornek.test')
        ..pickCoordinatorship(dEgi);
      await ctl.submit();
      expect(_form(h).existing, isNotNull);
      ctl.setEmail('baska@ornek.test');
      f = _form(h);
      expect(f.existing, isNull);
    },
  );

  test(
    'koordinatör: yalnız kendi koordinatörlüğü; rol ve yöneticilik gönderilmez',
    () async {
      final backend = _Backend()..admin = false;
      final h = await _harness(backend);
      final ctl = _ctl(h)
        ..setName('Yeni Üye')
        ..setEmail('uye@ornek.test')
        ..setRole(InviteRole.admin)
        ..pickCoordinatorship(dEle);
      expect(await ctl.submit(), isNull);
      expect(_form(h).error, InviteError.coordinatorship);
      expect(backend.created, isEmpty);

      ctl.pickCoordinatorship(dAlt);
      expect(await ctl.submit(), isNotNull);
      expect(backend.created.single, {
        'email': 'uye@ornek.test',
        'program_id': coordProgram,
        'department_id': dAlt,
        'full_name': 'Yeni Üye',
        'role': 'uye',
      });

      // Koordinatöre teklif gelmez: var olan e-posta düz hata.
      ctl
        ..setName('Kadir')
        ..setEmail('kadir@ornek.test')
        ..pickCoordinatorship(dAlt);
      expect(await ctl.submit(), isNull);
      final f = _form(h);
      expect((f.existing, f.failure?.code), (null, 'identity.account_exists'));
    },
  );

  test('yetkisiz (üye): istek gönderilmez', () async {
    // Şirket yöneticisi değil, ekip satırı yok (PilotBackend `/v1/me`): koordinatörlüğü yok.
    final backend = _Backend()..companyAdmin = false;
    final h = await _harness(backend);
    final ctl = _ctl(h)
      ..setName('X')
      ..setEmail('x@ornek.test')
      ..pickCoordinatorship(dAlt);
    expect(await ctl.submit(), isNull);
    expect(_form(h).failure?.code, 'organization.not_authorized');
    expect(backend.created, isEmpty);
  });

  test('sunucu hatası başarı sayılmaz; sonuç bilinmiyorsa ayrı kod', () async {
    final backend = _Backend()..fail = (403, 'organization.not_authorized');
    final h = await _harness(backend);
    final ctl = _ctl(h)
      ..setName('Ayşe')
      ..setEmail('ayse@ornek.test')
      ..pickCoordinatorship(dAlt);
    expect(await ctl.submit(), isNull);
    var f = _form(h);
    expect(
      (f.failure?.code, f.busy, f.name),
      ('organization.not_authorized', false, 'Ayşe'),
    );

    backend.fail = (503, 'platform.internal');
    expect(await ctl.submit(), isNull);
    f = _form(h);
    expect(f.failure?.code, ClientErrorCode.outcomeUnknown);
    expect(f.email, 'ayse@ornek.test', reason: 'taslak korunur');
  });

  test('çıkışta taslak ve teklif düşer', () async {
    final backend = _Backend();
    final h = await _harness(backend);
    final ctl = _ctl(h)
      ..setName('Kadir')
      ..setEmail('kadir@ornek.test')
      ..pickCoordinatorship(dEle);
    await ctl.submit();
    expect(_form(h).existing, isNotNull);
    await h.identity.logout();
    final f = _form(h);
    expect(
      (f.name, f.email, f.existing, f.coordinatorship),
      ('', '', null, null),
    );
  });
}
