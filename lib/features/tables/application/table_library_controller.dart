import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';

final tableLibraryWritesProvider =
    NotifierProvider<TableLibraryWrites, TableLibraryWriteState>(
      TableLibraryWrites.new,
      dependencies: [sessionGenerationProvider, scopeStateProvider],
    );

class TableLibraryWriteState {
  const TableLibraryWriteState({
    this.busy = false,
    this.pending = false,
    this.error,
    this.result,
    this.revision = 0,
  });
  final int revision;
  final bool busy;
  final bool pending;
  final ApiError? error;
  final String? result;
}

/// Liste düzeyindeki proje/öneri komutları. Belirsiz sonuç aynı çağrı ve
/// anahtarla sürer; hesap/kapsam değişince plan ve sonuçlar atılır.
class TableLibraryWrites extends Notifier<TableLibraryWriteState> {
  ({Future<String?> Function(String) call, String key})? _pending;
  Object _epoch = Object();
  @override
  TableLibraryWriteState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _epoch = Object();
    _pending = null;
    return const TableLibraryWriteState();
  }

  Future<bool> run(Future<String?> Function(String) call) async {
    if (state.busy || _pending != null) return false;
    _pending = (call: call, key: newRequestKey());
    return retry();
  }

  void abandon() {
    if (state.busy) return;
    _pending = null;
    state = TableLibraryWriteState(revision: state.revision + 1);
  }

  Future<bool> retry() async {
    if (state.busy || _pending == null) return false;
    final epoch = _epoch;
    final pending = _pending!;
    state = TableLibraryWriteState(
      busy: true,
      pending: true,
      revision: state.revision,
    );
    try {
      final result = await pending.call(pending.key);
      if (!ref.mounted || !identical(epoch, _epoch)) return false;
      _pending = null;
      state = TableLibraryWriteState(
        result: result,
        revision: state.revision + 1,
      );
      return true;
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.provider);
      if (ref.mounted && identical(epoch, _epoch)) {
        if (!isOutcomeUnknown(error) && error.code != 'client.invalid_response') {
          _pending = null;
        }
        state = TableLibraryWriteState(
          pending: _pending != null,
          error: error,
          revision: state.revision,
        );
      }
      return false;
    }
  }
}
