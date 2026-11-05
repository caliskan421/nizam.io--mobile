// Hızlı işlem formları: davet (e-posta, rol kuralları).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';

import '../../pilot_support.dart';

Future<ProviderContainer> _setup() async =>
    (await pilotHarness(PilotBackend())).container;

void main() {
  test(
    'davet: ad, e-posta, koordinatör için koordinatörlük, admin kilidi',
    () async {
      final c = await _setup();
      final ctl = c.read(inviteFormControllerProvider.notifier);
      InviteForm f() => c.read(inviteFormControllerProvider);
      expect(ctl.submit(), isNull);
      expect(f().error, InviteError.name);
      ctl
        ..setName('Ayşe Deneme')
        ..setEmail('ayse');
      expect(ctl.submit(), isNull);
      expect(f().error, InviteError.email);
      ctl
        ..setEmail('ayse.deneme@ornek.test')
        ..setRole(InviteRole.coordinator);
      expect(ctl.submit(), isNull);
      expect(f().error, InviteError.coordinatorships);
      ctl
        ..togglePane()
        ..toggleCoordinatorship('ALT');
      expect(f().paneOpen, isTrue);
      ctl.setRole(InviteRole.admin);
      expect(f().paneOpen, isFalse);
      ctl.togglePane();
      expect(f().paneOpen, isFalse);
      expect(ctl.submit()!.email, 'ayse.deneme@ornek.test');
      expect(f().name, '');
      ctl.prepare(coordinatorship: 'EĞİ');
      expect(f().role, InviteRole.member);
      expect(f().coordinatorships, ['EĞİ']);
    },
  );
}
