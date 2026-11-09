import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../domain/program_admin.dart';
import 'admin_controller.dart';

final transferProgramsProvider = FutureProvider.autoDispose((ref) {
  ref.watch(sessionGenerationProvider);
  ref.watch(scopeStateProvider);
  return ref.watch(scopeServiceProvider).programs();
});
typedef TransferSelection = ({
  String source,
  String target,
  String department,
  List<String> tasks,
});

class AdminTransferState {
  const AdminTransferState({
    this.busy = false,
    this.preview,
    this.selection,
    this.outcome,
  });
  final bool busy;
  final TransferPreview? preview;
  final TransferSelection? selection;
  final TransferOutcome? outcome;
}

final adminTransferProvider =
    NotifierProvider.autoDispose<AdminTransferController, AdminTransferState>(
      AdminTransferController.new,
    );

class AdminTransferController extends Notifier<AdminTransferState> {
  int _epoch = 0;
  RequestKeys _keys = const RequestKeys();
  @override
  AdminTransferState build() {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    _epoch++;
    _keys = const RequestKeys();
    return const AdminTransferState();
  }

  Future<void> preview(TransferSelection selection) async {
    _authorize();
    if (state.busy) {
      return;
    }
    final epoch = ++_epoch;
    state = AdminTransferState(busy: true, selection: selection);
    try {
      final preview = await ref
          .read(programAdminRepositoryProvider)
          .previewTransfer(
            sourceProgramId: selection.source,
            targetProgramId: selection.target,
            departmentId: selection.department,
            workItemIds: selection.tasks,
          );
      if (ref.mounted && epoch == _epoch) {
        state = AdminTransferState(preview: preview, selection: selection);
      }
    } finally {
      if (ref.mounted && epoch == _epoch && state.busy) {
        state = AdminTransferState(selection: selection);
      }
    }
  }

  Future<void> execute({required bool addMissingAccess}) async {
    _authorize();
    final selection = state.selection;
    final preview = state.preview;
    if (state.busy ||
        selection == null ||
        preview == null ||
        !preview.canExecute) {
      return;
    }
    final epoch = _epoch;
    final signature =
        '${selection.source}|${selection.target}|${selection.department}|${selection.tasks.join(',')}|${preview.fingerprint}|$addMissingAccess';
    final (keys, key) = _keys.keyFor('transfer', signature);
    _keys = keys;
    state = AdminTransferState(
      busy: true,
      selection: selection,
      preview: preview,
    );
    try {
      final outcome = await ref
          .read(programAdminRepositoryProvider)
          .transfer(
            idempotencyKey: key,
            sourceProgramId: selection.source,
            targetProgramId: selection.target,
            departmentId: selection.department,
            workItemIds: selection.tasks,
            previewFingerprint: preview.fingerprint,
            addMissingAccess: addMissingAccess,
          );
      if (!ref.mounted || epoch != _epoch) {
        return;
      }
      _keys = _keys.clear('transfer');
      state = AdminTransferState(outcome: outcome);
    } on ApiError catch (e) {
      if (ref.mounted && epoch == _epoch && isKeyReused(e)) {
        _keys = _keys.clear('transfer');
      }
      rethrow;
    } finally {
      if (ref.mounted && epoch == _epoch && state.busy) {
        state = AdminTransferState(selection: selection, preview: preview);
      }
    }
  }

  void clearPreview() {
    if (!state.busy) {
      state = const AdminTransferState();
    }
  }

  void _authorize() {
    if (ref.read(taskCatalogControllerProvider).value?.access?.companyAdmin !=
        true) {
      throw ApiError('program.not_authorized');
    }
  }
}
