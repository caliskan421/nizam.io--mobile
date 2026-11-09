// uploadDigest: yükleme niyeti imzasının içerik özeti (SHA-256, akışla). Aynı içerik farklı
// yolda aynı özet; aynı boyutta farklı içerik farklı özet (Codex tur 3 / N5).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/upload_digest.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('nz_digest_'));
  tearDown(() => dir.deleteSync(recursive: true));

  String write(String name, List<int> bytes) =>
      (File('${dir.path}/$name')..writeAsBytesSync(bytes)).path;

  test('SHA-256 onaltılık; yol bağımsız, içerik bağımlı', () async {
    final a = await uploadDigest(write('a.pdf', 'abc'.codeUnits));
    expect(
      a,
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
    expect(await uploadDigest(write('kopya.pdf', 'abc'.codeUnits)), a);
    expect(await uploadDigest(write('c.pdf', 'abd'.codeUnits)), isNot(a));
  });
}
