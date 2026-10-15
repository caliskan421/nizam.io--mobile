// tool/check_test_presence.dart: Q2 deseni, aynı göreli yol kuralı, negatif çıkış kodu.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_test_presence.dart';

void main() {
  group('missingTests', () {
    test('aynı göreli yoldaki test varsa eksik yok', () {
      expect(
        missingTests(
          [
            'features/identity/application/identity_service.dart',
            'features/identity/data/identity_repository.dart',
            'features/identity/presentation/controllers/login_controller.dart',
            'core/ui/widgets/buttons/nz_button.dart',
          ],
          {
            'features/identity/application/identity_service_test.dart',
            'features/identity/data/identity_repository_test.dart',
            'features/identity/presentation/controllers/login_controller_test.dart',
            'core/ui/widgets/buttons/nz_button_test.dart',
          },
        ),
        isEmpty,
      );
    });
    test('yanlış yoldaki test eksik sayılır (depo testi kök dizinde)', () {
      expect(
        missingTests(
          ['features/identity/data/identity_repository.dart'],
          {'features/identity/identity_repository_test.dart'},
        ),
        ['test/features/identity/data/identity_repository_test.dart'],
      );
    });
    test('her desen için eksik bildirilir', () {
      expect(
        missingTests([
          'features/a/application/a_service.dart',
          'features/a/data/a_repository.dart',
          'features/a/presentation/controllers/c.dart',
          'core/ui/widgets/x/y/nz_z.dart',
        ], {}),
        [
          'test/core/ui/widgets/x/y/nz_z_test.dart',
          'test/features/a/application/a_service_test.dart',
          'test/features/a/data/a_repository_test.dart',
          'test/features/a/presentation/controllers/c_test.dart',
        ],
      );
    });
    test(
      'gerçek yerleşim: application/*_controller.dart de zorunlu (Codex 9)',
      () {
        expect(
          missingTests([
            'features/identity/application/login_controller.dart',
            'features/scope/application/program_list_controller.dart',
          ], {}),
          [
            'test/features/identity/application/login_controller_test.dart',
            'test/features/scope/application/program_list_controller_test.dart',
          ],
        );
        expect(
          missingTests(
            ['features/identity/application/login_controller.dart'],
            {'features/identity/application/login_controller_test.dart'},
          ),
          isEmpty,
        );
      },
    );
    test(
      'application altında controller olmayan ve iç içe dosyalar istenmez',
      () {
        expect(
          missingTests([
            'features/a/application/a_controller.g.dart',
            'features/a/application/controller_helper.dart',
            'features/a/application/sub/b_controller.dart',
            'features/a/application/a_providers.dart',
          ], {}),
          isEmpty,
        );
      },
    );
    test('desen dışı, iç içe ve üretilmiş dosyalar istenmez', () {
      expect(
        missingTests([
          'features/a/application/a_model.dart',
          'features/a/application/sub/b_service.dart',
          'features/a/data/a_dto.dart',
          'features/a/presentation/pages/p.dart',
          'features/a/presentation/controllers/c.g.dart',
          'features/a/presentation/controllers/c.freezed.dart',
          'core/ui/widgets/x/helper.dart',
          'core/http/api_service.dart',
          'core/api/generated/x_service.dart',
        ], {}),
        isEmpty,
      );
    });
  });

  group('süreç çıkış kodu', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('presence_'));
    tearDown(() => dir.deleteSync(recursive: true));

    Future<ProcessResult> run(List<String> files) {
      for (final f in files) {
        File('${dir.path}/$f')
          ..createSync(recursive: true)
          ..writeAsStringSync('');
      }
      return Process.run('dart', [
        '${Directory.current.path}/tool/check_test_presence.dart',
      ], workingDirectory: dir.path);
    }

    test('eksik test → 1, tamam → 0', () async {
      final bad = await run([
        'lib/features/a/data/a_repository.dart',
        'test/x_test.dart',
      ]);
      expect(bad.exitCode, 1);
      expect(
        '${bad.stderr}',
        contains('test/features/a/data/a_repository_test.dart'),
      );
      File('${dir.path}/test/features/a/data/a_repository_test.dart')
          .createSync(recursive: true);
      final ok = await Process.run('dart', [
        '${Directory.current.path}/tool/check_test_presence.dart',
      ], workingDirectory: dir.path);
      expect(ok.exitCode, 0, reason: '${ok.stdout}${ok.stderr}');
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
