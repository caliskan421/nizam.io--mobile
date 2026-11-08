import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/api/generated/models/archive_folder.dart' as api;
import '../../../core/api/generated/models/archive_task.dart' as api;
import '../../../core/api/generated/models/file_list_item.dart' as api;
import '../../../core/api/generated/models/file_record.dart' as api;
import '../../../core/api/generated/models/tag.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/domain/upload_types.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/file_download.dart';
import '../../../core/http/file_upload.dart';
import '../../../core/http/interceptors.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/archive.dart';
import '../domain/records.dart';

/// records arşiv uçlarına üretilmiş istemciyle erişim. Üretilmiş DTO'lar bu katmanda kalır;
/// dışarıya domain varlıkları döner (A1/A2). Her istek açık departman başlığıyla gider
/// ([withDepartment]; program seçili kapsamdan). Bütün hatalar [ApiError] olarak fırlar.
///
/// İndirmeler (dosya ve ZIP) akışla okunur ([getBinaryStream]); yol ve operationId üretilmiş
/// istemcinin `…OpenapiExtras` değerleriyle aynıdır.
class ApiRecordsRepository implements ArchiveRepository {
  /// [dio]: doğrulanmış bağın güncel API istemcisi; bağ yoksa null →
  /// `client.server_not_verified`. İstek anında okunur (bağ değişebilir).
  ApiRecordsRepository(this._dio);

  final Dio? Function() _dio;

  Dio get _http {
    final d = _dio();
    if (d == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return d;
  }

  RecordsClient get _client => RecordsClient(_http);

  @override
  Future<List<ArchiveFolder>> loadFolders({required String department}) async {
    final r = await apiCall(
      () => _client.archiveFolders(
        extras: withDepartment(
          RecordsClient.archiveFoldersOpenapiExtras,
          department,
        ),
      ),
    );
    return r.folders.map(_folder).toList(growable: false);
  }

  @override
  Future<List<ArchiveTaskSummary>> archiveTasks({
    required String department,
  }) async {
    final r = await apiCall(
      () => _client.archiveTasks(
        extras: withDepartment(
          RecordsClient.archiveTasksOpenapiExtras,
          department,
        ),
      ),
    );
    return r.tasks.map(_task).toList(growable: false);
  }

  @override
  Future<List<String>> archiveUploaders({required String department}) async {
    final r = await apiCall(
      () => _client.archiveUploaders(
        extras: withDepartment(
          RecordsClient.archiveUploadersOpenapiExtras,
          department,
        ),
      ),
    );
    return List.unmodifiable(r.uploaders);
  }

  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  }) async {
    final tag = filter.tag;
    final r = await apiCall(
      () => _client.archiveAttachments(
        mimeCategory: filter.mimeCategory?.name,
        tag: tag == null ? null : _tagOut(tag).json,
        workItemId: filter.workItemId,
        uploaderId: filter.uploaderId,
        from: filter.from?.toUtc().toIso8601String(),
        to: filter.to?.toUtc().toIso8601String(),
        search: filter.search,
        sort: switch (filter.sort) {
          ArchiveSort.recent => null,
          ArchiveSort.name => 'name',
          ArchiveSort.size => 'size',
        },
        limit: page.limit,
        cursor: page.cursor,
        extras: withDepartment(
          RecordsClient.archiveAttachmentsOpenapiExtras,
          department,
        ),
      ),
    );
    final next = r.nextCursor;
    return PageSlice(
      items: r.files.map(_item).toList(),
      nextCursor: next == null || next.isEmpty ? null : next,
    );
  }

  @override
  Future<RecordFile> attachFile({
    required String department,
    required String workItemId,
    required RecordTag tag,
    required String filePath,
    required String filename,
    required String requestKey,
  }) async {
    final wire = _tagOut(tag);
    final dot = filename.lastIndexOf('.');
    final type = uploadContentType(
      dot < 0 ? '' : filename.substring(dot + 1).toLowerCase(),
    );
    // Küme dışı tür sunucuda 422 olurdu: istek gönderilmez, metin yine koddan.
    if (type == null) throw ApiError('records.content_rejected');
    final dio = _http;
    return _record(
      await apiCall(
        () async => decodeJsonObject(
          await postWorkItemFile(
            dio,
            workItemId: workItemId,
            tag: wire.json!,
            filePath: filePath,
            filename: filename,
            contentType: type,
            requestKey: requestKey,
            extras: withDepartment(
              RecordsClient.attachFileOpenapiExtras,
              department,
            ),
          ),
          api.FileRecord.fromJson,
        ),
      ),
    );
  }

  @override
  Future<void> deleteFile(String fileId, {required String department}) =>
      apiCall(
        () => _client.deleteFile(
          id: fileId,
          extras: withDepartment(
            RecordsClient.deleteFileOpenapiExtras,
            department,
          ),
        ),
      );

  @override
  Future<Stream<List<int>>> downloadFile(
    String fileId, {
    required String department,
  }) async => getFileStream(
    _http,
    fileId: fileId,
    extras: withDepartment(RecordsClient.downloadFileOpenapiExtras, department),
  );

  @override
  Future<Stream<List<int>>> downloadFolderZip(
    String folderId, {
    required String department,
  }) async => getBinaryStream(
    _http,
    '/v1/records/archive/folders/${Uri.encodeComponent(folderId)}/download-zip',
    extras: withDepartment(
      RecordsClient.archiveFolderZipOpenapiExtras,
      department,
    ),
  );

  @override
  Future<Stream<List<int>>> downloadSelectionZip(
    List<String> fileIds, {
    required String department,
  }) async {
    return getBinaryStream(
      _http,
      RecordsDownloadTargets.selectionZip(fileIds),
      extras: withDepartment(
        RecordsClient.archiveSelectionZipOpenapiExtras,
        department,
      ),
    );
  }

  @override
  Future<Stream<List<int>>> downloadPeriodZip({
    required String department,
  }) async => getBinaryStream(
    _http,
    '/v1/records/archive/period/download-zip',
    extras: withDepartment(
      RecordsClient.archiveFullZipOpenapiExtras,
      department,
    ),
  );

  static Tag _tagOut(RecordTag t) => switch (t) {
    RecordTag.ister => Tag.ister,
    RecordTag.plan => Tag.plan,
    RecordTag.girdi => Tag.girdi,
    RecordTag.analiz => Tag.analiz,
    RecordTag.cikti => Tag.cikti,
    RecordTag.sonuc => Tag.sonuc,
    RecordTag.unknown => throw ArgumentError.value(
      t,
      'tag',
      'bilinmeyen etiket gönderilemez',
    ),
  };

  static RecordTag _tagIn(String? wire) =>
      enumFromWire(RecordTag.values, wire, RecordTag.unknown);

  static RecordFile _record(api.FileRecord r) => RecordFile(
    id: r.fileId,
    workItemId: r.workItemId,
    displayName: r.displayName,
    contentType: r.contentType,
    sizeBytes: r.sizeBytes,
    tag: _tagIn(r.tag.json),
  );

  static RecordFile _item(api.FileListItem r) => RecordFile(
    id: r.fileId,
    workItemId: r.workItemId,
    displayName: r.displayName,
    contentType: r.contentType,
    sizeBytes: r.sizeBytes,
    tag: _tagIn(r.tag),
    uploaderId: r.uploadedByAccountId,
  );

  static ArchiveFolder _folder(api.ArchiveFolder r) => ArchiveFolder(
    code: r.folderId,
    name: r.name,
    files: r.fileCount,
    isVirtual: r.isVirtual,
  );

  static ArchiveTaskSummary _task(api.ArchiveTask r) => ArchiveTaskSummary(
    workItemId: r.workItemId,
    title: r.title,
    fileCount: r.fileCount,
  );
}
