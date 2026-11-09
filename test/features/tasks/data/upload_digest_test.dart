// uploadDigest: yükleme niyeti imzasının içerik özeti (SHA-256, akışla). Aynı içerik farklı
// yolda aynı özet; aynı boyutta farklı içerik farklı özet (Codex tur 3 / N5). Okunamayan dosya
// `client.file_unreadable`; iptal okumayı durdurur (Codex tur 4 / N7, N8).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/tasks/data/upload_digest.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('nz_digest_'));
  tearDown(() => dir.deleteSync(recursive: true));

  String write(String name, List<int> bytes) =>
      (File('${dir.path}/$name')..writeAsBytesSync(bytes)).path;

  Future<String?> digest(String path) =>
      uploadDigest(path, cancelled: () => false);

  test('SHA-256 onaltılık; yol bağımsız, içerik bağımlı', () async {
    final a = await digest(write('a.pdf', 'abc'.codeUnits));
    expect(
      a,
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
    expect(await digest(write('kopya.pdf', 'abc'.codeUnits)), a);
    expect(await digest(write('c.pdf', 'abd'.codeUnits)), isNot(a));
  });

  test('okunamayan (silinmiş) dosya: client.file_unreadable', () async {
    await expectLater(
      digest('${dir.path}/yok.pdf'),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.fileUnreadable,
        ),
      ),
    );
  });

  test('iptal: okuma ilk parçadan sonra durur, null döner', () async {
    // Birkaç okuma parçası (akış parçası 64 KiB).
    final path = write('buyuk.pdf', List.filled(512 * 1024, 7));
    var asked = 0;
    final r = await uploadDigest(path, cancelled: () => ++asked > 1);
    expect(r, isNull);
    expect(asked, 2, reason: 'kalan parçalar okunmaz');
  });
}
