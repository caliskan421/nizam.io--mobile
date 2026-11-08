// Ölçüm sürücüsü: testin `reportData` çıktısını yerel `build/perf/` altına yazar (commit'lenmez).
// Dosya adı `PERF_OUT` ortam değişkeninden (varsayılan `perf-result`).
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    await writeResponseData(
      data,
      testOutputFilename: Platform.environment['PERF_OUT'] ?? 'perf-result',
      destinationDirectory: 'build/perf',
    );
  },
);
