import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../tasks/tasks.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'table_detail_controller.dart';

Future<TableOperationReceipt?> uploadWorkspaceAttachment(
  WidgetRef ref,
  String id,
  String row,
  String column,
) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final before = ref.read(tableDetailProvider(id));
  final session = ref.read(sessionGenerationProvider);
  final scope = ref.read(scopeStateProvider);
  final picker = ref.read(uploadPickerProvider);
  if (!picker.available ||
      before.busy ||
      before.pending ||
      before.data == null) {
    return null;
  }
  final file = await picker.pick(UploadOrigin.files);
  if (file == null || !ref.context.mounted) return null;
  if (ref.read(sessionGenerationProvider) != session ||
      ref.read(scopeStateProvider) != scope) {
    return null;
  }
  final current = ref.read(tableDetailProvider(id));
  if (current.data == null ||
      current.data!.cell(row, column).version !=
          before.data!.cell(row, column).version) {
    throw ApiError('tables.cell_conflict');
  }
  if (file.contentType == null) throw ApiError('tables.attachment_rejected');
  if (file.sizeBytes > 90 * 1024 * 1024) {
    throw ApiError('tables.attachment_too_large');
  }
  final version = before.data!.cell(row, column).version;
  final location = controller.location;
  final repo = controller.repository;
  return controller.perform(
    (key) =>
        uploadTableSource(repo, location, id, row, column, version, file, key),
  );
}

Future<TableOperationReceipt> uploadTableSource(
  TablesRepository repo,
  TableLocation location,
  String id,
  String row,
  String column,
  int version,
  UploadSource file,
  String key,
) async {
  if (file.contentType == null) throw ApiError('tables.attachment_rejected');
  if (file.sizeBytes > 90 * 1024 * 1024) {
    throw ApiError('tables.attachment_too_large');
  }
  final source = File(file.path);
  int length;
  try {
    length = await source.length();
  } on FileSystemException catch (e, st) {
    reportUnexpected(e, st, source: ReportSource.files);
    throw ApiError('client.file_unreadable');
  }
  if (length != file.sizeBytes) throw ApiError('client.file_unreadable');
  return repo.upload(
    location,
    id,
    row: row,
    column: column,
    version: version,
    name: file.name,
    bytes: source.openRead().handleError((Object e, StackTrace st) {
      reportUnexpected(e, st, source: ReportSource.files);
      throw ApiError('client.file_unreadable');
    }, test: (e) => e is FileSystemException),
    length: length,
    key: key,
  );
}
