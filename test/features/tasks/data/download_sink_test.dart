// FileDownloadSink: dosya `indirilenler/` altına AKIŞLA (parça parça) yazılır; ad yalnız son yol
// parçasıdır (sunucu adındaki `../` ya da `\` kökün dışına yazdıramaz). Akış hatasında yarım
// dosya kalmaz. Geçici dosya `indirilenler/.tmp/` altında işleme özgü klasördedir.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/download_sink.dart';

Stream<List<int>> _bytes() => Stream.fromIterable([
  [1, 2],
  [3],
]);

bool _written(File f) => f.existsSync() && f.lengthSync() > 0;

/// Geçici alandaki (`indirilenler/.tmp/`) dosyalar.
List<File> _tmpFiles(Directory root) {
  final t = Directory(
    '${root.path}/indirilenler/${FileDownloadSink.tmpDirName}',
  );
  if (!t.existsSync()) return const [];
  return t.listSync(recursive: true).whereType<File>().toList();
}

/// `indirilenler/` altındaki kullanıcıya görünen girişler (geçici alan hariç).
List<String> _visible(Directory root) =>
    Directory('${root.path}/indirilenler')
        .listSync()
        .map((e) => e.path.split('/').last)
        .where((n) => n != FileDownloadSink.tmpDirName)
        .toList()
      ..sort();

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
    // Geçici alanın adı kullanıcı dosyasına verilemez.
    expect(FileDownloadSink.safeName('x/.tmp'), '_.tmp');
    expect(FileDownloadSink.safeName('.TMP'), '_.TMP');
    expect(FileDownloadSink.safeName(r'y\.Tmp'), '_.Tmp');
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
    ctl.add(List.filled(1024, 7));
    // İlk parça akış bitmeden diske (geçici alana) ulaşır (bellekte toplanmaz).
    for (var i = 0; i < 100 && !_tmpFiles(root).any(_written); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(_tmpFiles(root).any(_written), isTrue);
    expect(_visible(root), isEmpty);
    await ctl.close();
    final path = await saved;
    expect(File(path).lengthSync(), 1024);
    expect(_tmpFiles(root), isEmpty);
  });

  test('akış hatası: yarım dosya kalmaz, hata fırlar', () async {
    final sink = FileDownloadSink(root: () async => root);
    Stream<List<int>> broken() async* {
      yield [1, 2, 3];
      throw StateError('koptu');
    }

    await expectLater(sink.save('yarim.pdf', broken()), throwsStateError);
    expect(_visible(root), isEmpty);
    expect(_tmpFiles(root), isEmpty);
  });

  // Codex kapı 2 / 1: geçici dosya kullanıcı dosyalarıyla aynı adı paylaşmaz.
  test('var olan `<ad>.part` kullanıcı dosyası korunur', () async {
    final dir = Directory('${root.path}/indirilenler')..createSync();
    final user = File('${dir.path}/rapor.pdf.part')..writeAsBytesSync([9, 9]);
    final sink = FileDownloadSink(root: () async => root);
    final p = await sink.save('rapor.pdf', _bytes());
    expect(File(p).readAsBytesSync(), [1, 2, 3]);
    expect(user.readAsBytesSync(), [9, 9]);
    expect(_visible(root), ['rapor.pdf', 'rapor.pdf.part']);
  });

  test('aynı adlı iki eşzamanlı indirme birbirini bozmaz', () async {
    final sink = FileDownloadSink(root: () async => root);
    final a = StreamController<List<int>>();
    final b = StreamController<List<int>>();
    final sa = sink.save('ayni.bin', a.stream);
    final sb = sink.save('ayni.bin', b.stream);
    // Parçalar iç içe gelir; her indirme kendi geçici dosyasına yazar.
    a.add(List.filled(10, 1));
    b.add(List.filled(20, 2));
    a.add(List.filled(10, 1));
    b.add(List.filled(20, 2));
    for (var i = 0; i < 100 && _tmpFiles(root).length < 2; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(_tmpFiles(root), hasLength(2));
    await a.close();
    final pa = await sa;
    // Bitmiş A tam ve tutarlıdır (B'nin baytları karışmaz).
    expect(File(pa).readAsBytesSync(), List.filled(20, 1));
    await b.close();
    final pb = await sb;
    expect(pb, pa);
    // Son biten kazanır (üzerine yazma); içerik yine tek indirmenin baytlarıdır.
    expect(File(pb).readAsBytesSync(), List.filled(40, 2));
    expect(_tmpFiles(root), isEmpty);
  });

  test('taşıma hatası: geçici dosya kalmaz, hata fırlar', () async {
    // Hedef adda bir klasör var → rename başarısız; kopyalama yedeği yok, hata iletilir.
    Directory('${root.path}/indirilenler/engel').createSync(recursive: true);
    final sink = FileDownloadSink(root: () async => root);
    await expectLater(
      sink.save('engel', _bytes()),
      throwsA(isA<FileSystemException>()),
    );
    expect(_tmpFiles(root), isEmpty);
    expect(
      Directory('${root.path}/indirilenler/${FileDownloadSink.tmpDirName}')
          .listSync(),
      isEmpty,
    );
    expect(Directory('${root.path}/indirilenler/engel').existsSync(), isTrue);
  });

  // Codex kapı 3 / 1: rename hatasında hedefteki (ör. başka indirmenin yayımladığı) dosya korunur.
  test('rename hatası: hedef dosya korunur, geçici alan boş', () async {
    final dir = Directory('${root.path}/indirilenler')..createSync();
    final target = File('${dir.path}/rapor.pdf')..writeAsBytesSync([7, 7]);
    var calls = 0;
    final sink = FileDownloadSink(
      root: () async => root,
      rename: (from, to) async {
        calls++;
        throw FileSystemException('rename başarısız', to);
      },
    );
    await expectLater(
      sink.save('rapor.pdf', _bytes()),
      throwsA(isA<FileSystemException>()),
    );
    expect(calls, 1);
    expect(target.readAsBytesSync(), [7, 7]);
    expect(_tmpFiles(root), isEmpty);
    expect(_visible(root), ['rapor.pdf']);
  });
}
