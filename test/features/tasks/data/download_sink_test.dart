// FileDownloadSink: dosya `indirilenler/` altına AKIŞLA (parça parça) yazılır; ad yalnız son yol
// parçasıdır (sunucu adındaki `../` ya da `\` kökün dışına yazdıramaz). Akış hatasında yarım
// dosya kalmaz.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/download_sink.dart';

Stream<List<int>> _bytes() => Stream.fromIterable([
  [1, 2],
  [3],
]);

bool _written(File f) => f.existsSync() && f.lengthSync() > 0;

void main() {
  late Directory root;
  setUp(() => root = Directory.systemTemp.createTempSync('nz_sink_'));
  tearDown(() => root.deleteSync(recursive: true));

  test('indirilenler altına yazar; yol kaçışı yok', () async {
    final sink = FileDownloadSink(root: () async => root);
    final a = await sink.save('rapor.pdf', _bytes());
    expect(a, '${root.path}/indirilenler/rapor.pdf');
    expect(File(a).readAsBytesSync(), [1, 2, 3]);
    final b = await sink.save('../../etc/x.pdf', _bytes());
    expect(b, '${root.path}/indirilenler/x.pdf');
    final c = await sink.save(r'..\..\y.pdf', _bytes());
    expect(c, '${root.path}/indirilenler/y.pdf');
    final d = await sink.save('  ', _bytes());
    expect(d, '${root.path}/indirilenler/dosya');
  });

  // Fable B4: `.` / `..` / boş ad klasörün kendisine ya da üstüne yazdıramaz.
  test('`.`, `..`, boş ve ayırıcıyla biten ad → dosya', () async {
    for (final n in ['.', '..', '', '  ', 'a/..', r'b\.', 'c/']) {
      expect(FileDownloadSink.safeName(n), 'dosya', reason: n);
    }
    expect(FileDownloadSink.safeName('a/..b'), '..b');
    final sink = FileDownloadSink(root: () async => root);
    for (final n in ['.', '..']) {
      final p = await sink.save(n, _bytes());
      expect(p, '${root.path}/indirilenler/dosya');
      expect(File(p).readAsBytesSync(), [1, 2, 3]);
    }
  });

  test('akış parça parça yazılır: tüm gövde beklenmeden diske gider', () async {
    final sink = FileDownloadSink(root: () async => root);
    final ctl = StreamController<List<int>>();
    final saved = sink.save('buyuk.bin', ctl.stream);
    final part = File('${root.path}/indirilenler/buyuk.bin.part');
    ctl.add(List.filled(1024, 7));
    // İlk parça akış bitmeden diske ulaşır (bellekte toplanmaz).
    for (var i = 0; i < 100 && !_written(part); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(_written(part), isTrue);
    await ctl.close();
    final path = await saved;
    expect(File(path).lengthSync(), 1024);
    expect(part.existsSync(), isFalse);
  });

  test('akış hatası: yarım dosya kalmaz, hata fırlar', () async {
    final sink = FileDownloadSink(root: () async => root);
    Stream<List<int>> broken() async* {
      yield [1, 2, 3];
      throw StateError('koptu');
    }

    await expectLater(sink.save('yarim.pdf', broken()), throwsStateError);
    expect(Directory('${root.path}/indirilenler').listSync(), isEmpty);
  });
}
