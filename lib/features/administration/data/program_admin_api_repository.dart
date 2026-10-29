import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/models/create_program_request.dart';
import '../../../core/api/generated/models/delete_program_request.dart';
import '../../../core/api/generated/models/program.dart' as api;
import '../../../core/api/generated/models/reset_program_request.dart';
import '../../../core/api/generated/models/transfer_history_item.dart';
import '../../../core/api/generated/models/transfer_preview_request.dart';
import '../../../core/api/generated/models/transfer_request.dart';
import '../../../core/api/generated/models/transfer_result.dart';
import '../../../core/api/generated/models/update_program_request.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../scope/scope.dart' show Program;
import '../domain/program_admin.dart';
import '../domain/program_admin_repository.dart';

/// [ProgramAdminRepository]'nin program uçlarıyla gerçekleştirmesi (S1). Üretilmiş istemci
/// burada kurulur (sınır kuralı A2); DTO'lar bu katmanda kalır (A1); her çağrı [apiCall] ile
/// sarılır (hata → [ApiError]).
class ApiProgramAdminRepository implements ProgramAdminRepository {
  /// [dio]: doğrulanmış bağın API istemcisi.
  ApiProgramAdminRepository(Dio dio) : _client = ProgramClient(dio);

  final ProgramClient _client;

  @override
  Future<ProgramCreation> createProgram({
    required String name,
    int? year,
    String? description,
  }) async {
    final r = await apiCall(
      () => _client.createProgram(
        body: CreateProgramRequest(
          name: name,
          year: year,
          description: description,
        ),
      ),
    );
    return ProgramCreation(program: _program(r), created: r.created ?? false);
  }

  @override
  Future<Program> updateProgram(
    String programId, {
    String? name,
    int? year,
    String? description,
  }) async => _program(
    await apiCall(
      () => _client.updateProgram(
        id: programId,
        body: UpdateProgramRequest(
          name: name,
          year: year,
          description: description,
        ),
      ),
    ),
  );

  @override
  Future<void> deleteProgram(String programId, {required String password}) =>
      apiCall(
        () => _client.deleteProgram(
          id: programId,
          body: DeleteProgramRequest(password: password),
        ),
      );

  @override
  Future<ProgramReset> resetProgram(
    String programId, {
    required String password,
  }) async {
    final r = await apiCall(
      () => _client.resetProgram(
        id: programId,
        body: ResetProgramRequest(password: password),
      ),
    );
    return ProgramReset(
      programId: r.programId,
      tasks: r.tasks,
      files: r.files,
      messages: r.messages,
      meetings: r.meetings,
    );
  }

  @override
  Future<TransferPreview> previewTransfer({
    required String sourceProgramId,
    required String targetProgramId,
    required String departmentId,
    required List<String> workItemIds,
  }) async {
    final r = await apiCall(
      () => _client.previewTransfer(
        body: TransferPreviewRequest(
          sourceProgramId: sourceProgramId,
          targetProgramId: targetProgramId,
          departmentId: departmentId,
          workItemIds: workItemIds,
        ),
      ),
    );
    return TransferPreview(
      resolvedWorkItemIds: r.resolvedWorkItemIds ?? const [],
      fileCount: r.fileCount,
      fileTotalBytes: r.fileTotalBytes,
      preservedDependencyCount: r.preservedDependencyCount,
      missingAccess: r.missingAccess,
      blockers: r.blockers,
      warnings: r.warnings,
      canExecute: r.canExecute,
      fingerprint: r.previewFingerprint,
      unresolvedWorkItemIds: r.unresolvedWorkItemIds ?? const [],
      missingFileIds: r.missingFileIds ?? const [],
      cutDependencyIds: r.cutDependencyIds ?? const [],
      cycleWorkItemIds: r.cycleWorkItemIds ?? const [],
    );
  }

  @override
  Future<TransferOutcome> transfer({
    required String idempotencyKey,
    required String sourceProgramId,
    required String targetProgramId,
    required String departmentId,
    required List<String> workItemIds,
    required String previewFingerprint,
    bool? addMissingAccess,
  }) async => _outcome(
    await apiCall(
      () => _client.transferWorkItems(
        idempotencyKey: idempotencyKey,
        body: TransferRequest(
          sourceProgramId: sourceProgramId,
          targetProgramId: targetProgramId,
          departmentId: departmentId,
          workItemIds: workItemIds,
          previewFingerprint: previewFingerprint,
          addMissingAccess: addMissingAccess,
        ),
      ),
    ),
  );

  @override
  Future<TransferOutcome> reverseTransfer({
    required String idempotencyKey,
    required String transferId,
  }) async => _outcome(
    await apiCall(
      () => _client.transferWorkItems(
        idempotencyKey: idempotencyKey,
        body: TransferRequest(reversesTransferId: transferId),
      ),
    ),
  );

  @override
  Future<PageSlice<TransferRecord>> listTransfers({
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _client.listTransfers(limit: page.limit, cursor: page.cursor),
    );
    return PageSlice(
      items: r.transfers.map(_record).toList(),
      nextCursor: r.nextCursor,
    );
  }

  @override
  Future<TransferRecord> readTransfer(String transferId) async =>
      _record(await apiCall(() => _client.readTransfer(id: transferId)));

  static Program _program(api.Program r) => Program(
    id: r.programId,
    name: r.name,
    year: r.year,
    description: r.description,
  );

  static TransferOutcome _outcome(TransferResult r) => TransferOutcome(
    transferId: r.transferId,
    movedWorkItemIds: r.movedWorkItemIds ?? const [],
    movedFileCount: r.movedFileCount,
    cutDependencyCount: r.cutDependencyCount,
    restoredDependencyCount: r.restoredDependencyCount,
    grantedLinks: r.grantedLinks,
    revokedLinks: r.revokedLinks,
    retainedLinks: r.retainedLinks,
    replayed: r.replayed,
    skippedWorkItemIds: r.skippedWorkItemIds ?? const [],
  );

  static TransferRecord _record(TransferHistoryItem r) => TransferRecord(
    transferId: r.transferId,
    sourceProgramId: r.sourceProgramId,
    targetProgramId: r.targetProgramId,
    departmentId: r.departmentId,
    workItemIds: r.workItemIds ?? const [],
    movedItemCount: r.movedItemCount,
    movedFileCount: r.movedFileCount,
    cutDependencyCount: r.cutDependencyCount,
    restoredDependencyCount: r.restoredDependencyCount,
    createdAt: r.createdAt,
    skippedWorkItemIds: r.skippedWorkItemIds ?? const [],
    reversesTransferId: r.reversesTransferId,
  );
}
