// FileDownloadSink: dosya `indirilenler/` altına yazılır; ad yalnız son yol parçasıdır (sunucu
// adındaki `../` ya da `\` kökün dışına yazdıramaz).
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/download_sink.dart';

void main() {
  late Directory root;
  setUp(() => root = Directory.systemTemp.createTempSync('nz_sink_'));
  tearDown(() => root.deleteSync(recursive: true));

  test('indirilenler altına yazar; yol kaçışı yok', () async {
    final sink = FileDownloadSink(root: () async => root);
    final bytes = Uint8List.fromList([1, 2, 3]);
    final a = await sink.save('rapor.pdf', bytes);
    expect(a, '${root.path}/indirilenler/rapor.pdf');
    expect(File(a).readAsBytesSync(), [1, 2, 3]);
    final b = await sink.save('../../etc/x.pdf', bytes);
    expect(b, '${root.path}/indirilenler/x.pdf');
    final c = await sink.save(r'..\..\y.pdf', bytes);
    expect(c, '${root.path}/indirilenler/y.pdf');
    final d = await sink.save('  ', bytes);
    expect(d, '${root.path}/indirilenler/dosya');
  });
}
