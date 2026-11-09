import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/administration/application/admin_controller.dart';
import 'package:nizamio/features/administration/application/admin_transfer_controller.dart';
import 'package:nizamio/features/administration/domain/program_admin.dart';
import 'package:nizamio/features/administration/domain/program_admin_repository.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../connected_module_support.dart';

class _Program implements ProgramAdminRepository {
  final keys = <String>[];
  final fingerprints = <String>[];
  @override
  Future<TransferPreview> previewTransfer({
    required String sourceProgramId,
    required String targetProgramId,
    required String departmentId,
    required List<String> workItemIds,
  }) async => TransferPreview(
    resolvedWorkItemIds: workItemIds,
    fileCount: 1,
    fileTotalBytes: 10,
    preservedDependencyCount: 0,
    missingAccess: false,
    blockers: const [],
    warnings: const [],
    canExecute: true,
    fingerprint: 'fingerprint',
  );
  @override
  Future<TransferOutcome> transfer({
    required String idempotencyKey,
    required String sourceProgramId,
    required String targetProgramId,
    required String departmentId,
    required List<String> workItemIds,
    required String previewFingerprint,
    bool? addMissingAccess,
  }) async {
    keys.add(idempotencyKey);
    fingerprints.add(previewFingerprint);
    throw ApiError('client.network_error');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('önizleme olmadan aktarım yok; sonucu bilinmeyen tekrar aynı anahtar ve fingerprint taşır', () async {
    final repository = _Program();
    final container = moduleContainer(
      overrides: [programAdminRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    await container.read(taskCatalogControllerProvider.future);
    container.listen(adminTransferProvider, (_, _) {});
    final controller = container.read(adminTransferProvider.notifier);
    await controller.execute(addMissingAccess: false);
    expect(repository.keys, isEmpty);
    await controller.preview((
      source: 'program',
      target: 'target',
      department: 'department',
      tasks: ['task'],
    ));
    await expectLater(
      controller.execute(addMissingAccess: false),
      throwsA(isA<ApiError>()),
    );
    await expectLater(
      controller.execute(addMissingAccess: false),
      throwsA(isA<ApiError>()),
    );
    expect(repository.keys, hasLength(2));
    expect(repository.keys[0], repository.keys[1]);
    expect(repository.fingerprints, ['fingerprint', 'fingerprint']);
    controller.clearPreview();
    expect(container.read(adminTransferProvider).preview, isNull);
  });
}
