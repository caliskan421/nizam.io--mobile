import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/report_pdf_repository.dart';

final reportPdfRepositoryProvider = Provider<ReportPdfRepository>(
  (ref) => throw UnimplementedError(),
);
final reportPdfControllerProvider =
    NotifierProvider.autoDispose<ReportPdfController, bool>(
      ReportPdfController.new,
    );

class ReportPdfController extends Notifier<bool> {
  int _epoch = 0;
  @override
  bool build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _epoch++;
    return false;
  }

  Future<String?> save(String path, {List<String>? memberIds}) async {
    if (state) {
      return null;
    }
    state = true;
    final epoch = _epoch;
    try {
      final repository = ref.read(reportPdfRepositoryProvider);
      final sink = ref.read(downloadSinkProvider);
      final stream = await repository.open(path, memberIds: memberIds);
      if (!ref.mounted || epoch != _epoch) {
        throw ApiError('client.scope_changed');
      }
      final saved = await sink.save(
        'nizamio-rapor.pdf',
        stream.map((chunk) {
          if (!ref.mounted || epoch != _epoch) {
            throw ApiError('client.scope_changed');
          }
          return chunk;
        }),
      );
      if (!ref.mounted || epoch != _epoch) {
        throw ApiError('client.scope_changed');
      }
      return saved;
    } finally {
      if (ref.mounted && epoch == _epoch) {
        state = false;
      }
    }
  }
}
