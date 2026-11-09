import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/reports/application/report_pdf_controller.dart';
import 'package:nizamio/features/reports/domain/report_pdf_repository.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

class _Pdf implements ReportPdfRepository {
  // ignore: close_sinks
  final stream = StreamController<List<int>>();
  @override
  Future<Stream<List<int>>> open(
    String path, {
    List<String>? memberIds,
  }) async => stream.stream;
}

class _Sink implements DownloadSink {
  bool saved = false;
  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    await bytes.drain<void>();
    saved = true;
    return '/report.pdf';
  }
}

void main() {
  test(
    'kapsam değişiminde yarım PDF başarıyla bitmez, sink hata alır',
    () async {
      final repository = _Pdf();
      final sink = _Sink();
      final container = moduleContainer(
        overrides: [
          reportPdfRepositoryProvider.overrideWithValue(repository),
          downloadSinkProvider.overrideWithValue(sink),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(repository.stream.close);
      container.listen(reportPdfControllerProvider, (_, _) {});
      final save = container
          .read(reportPdfControllerProvider.notifier)
          .save('/v1/reports/season/pdf');
      final error = expectLater(save, throwsA(isA<ApiError>()));
      await Future<void>.delayed(Duration.zero);
      repository.stream.add([1, 2]);
      await Future<void>.delayed(Duration.zero);
      container.read(scopeControllerProvider).selectProgram('other');
      await container.pump();
      repository.stream.add([3]);
      await repository.stream.close();
      await error;
      expect(sink.saved, isFalse);
    },
  );
}
