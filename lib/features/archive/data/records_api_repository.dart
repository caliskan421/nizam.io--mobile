import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/api/generated/models/archive_folder.dart' as api;
import '../../../core/api/generated/models/archive_task.dart' as api;
import '../../../core/api/generated/models/file_list_item.dart' as api;
import '../../../core/api/generated/models/file_record.dart' as api;
import '../../../core/api/generated/models/rename_file_request.dart';
import '../../../core/api/generated/models/tag.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/archive.dart';
import '../domain/records.dart';

/// records uçlarına (görev dosyaları + arşiv) üretilmiş istemciyle erişim. Üretilmiş DTO'lar bu
/// katmanda kalır; dışarıya domain varlıkları döner (A1/A2). Bütün hatalar [ApiError] olarak fırlar.
///
/// İkili yanıtlar (dosya ve ZIP indirme): üretilmiş istemci bu uçları `Stream<String>` olarak
/// UTF-8 çözerek döndürür; ikili gövdede bu ya hata verir ya da veriyi bozar. Bu yüzden indirmeler
/// aynı yöntem + yol + operationId metaverisiyle (`*OpenapiExtras`, ara katmanın işlem eşlemesi
/// için) doğrudan [Dio] ile bayt olarak alınır. Üretici düzeltilince üretilmiş çağrıya dönülür.
class ApiRecordsRepository implements RecordsRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (kapsam başlıklarını ara katman ekler).
  ApiRecordsRepository(Dio dio) : _dio = dio, _client = RecordsClient(dio);

  final Dio _dio;
  final RecordsClient _client;

  @override
  Future<RecordFile> attachFile({
    required String workItemId,
    required RecordTag tag,
    required String filePath,
  }) async {
    final wire = _tagOut(tag);
    return _record(
      await apiCall(
        () =>
            _client.attachFile(id: workItemId, tag: wire, file: File(filePath)),
      ),
    );
  }

  @override
  Future<List<RecordFile>> listWorkItemFiles(String workItemId) async {
    final r = await apiCall(() => _client.listWorkItemFiles(id: workItemId));
    return r.files.map(_item).toList(growable: false);
  }

  @override
  Future<Uint8List> downloadFile(String fileId) => _bytes(
    RecordsDownloadTargets.file(fileId),
    Options(
      responseType: ResponseType.bytes,
      extra: RecordsClient.downloadFileOpenapiExtras,
    ),
  );

  @override
  Future<RecordFile> renameFile(String fileId, String displayName) async =>
      _record(
        await apiCall(
          () => _client.renameFile(
            id: fileId,
            body: RenameFileRequest(displayName: displayName),
          ),
        ),
      );

  @override
  Future<void> deleteFile(String fileId) =>
      apiCall(() => _client.deleteFile(id: fileId));

  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
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
      ),
    );
    final next = r.nextCursor;
    return PageSlice(
      items: r.files.map(_item).toList(),
      nextCursor: next == null || next.isEmpty ? null : next,
    );
  }

  @override
  Future<List<ArchiveFolder>> loadFolders() async {
    final r = await apiCall(_client.archiveFolders);
    return r.folders.map(_folder).toList(growable: false);
  }

  @override
  Future<List<ArchiveTaskSummary>> archiveTasks() async {
    final r = await apiCall(_client.archiveTasks);
    return r.tasks.map(_task).toList(growable: false);
  }

  @override
  Future<List<String>> archiveUploaders() async {
    final r = await apiCall(_client.archiveUploaders);
    return List.unmodifiable(r.uploaders);
  }

  @override
  Future<Uint8List> downloadFolderZip(String folderId) => _bytes(
    RecordsDownloadTargets.folderZip(folderId),
    Options(
      responseType: ResponseType.bytes,
      extra: RecordsClient.archiveFolderZipOpenapiExtras,
    ),
  );

  @override
  Future<Uint8List> downloadSelectionZip(List<String> fileIds) => _bytes(
    RecordsDownloadTargets.selectionZip(fileIds),
    Options(
      responseType: ResponseType.bytes,
      extra: RecordsClient.archiveSelectionZipOpenapiExtras,
    ),
  );

  @override
  Future<Uint8List> downloadPeriodZip() => _bytes(
    RecordsDownloadTargets.periodZip,
    Options(
      responseType: ResponseType.bytes,
      extra: RecordsClient.archiveFullZipOpenapiExtras,
    ),
  );

  /// İkili GET: gövde bayt olarak okunur; hata zarfı [apiCall] ile [ApiError] olur. [options]
  /// `ResponseType.bytes` + işlemin operationId metaverisini taşır (Dio birleştirirken `extra`
  /// haritasını kopyalar; sabit harita değişmez).
  Future<Uint8List> _bytes(String path, Options options) async {
    final r = await apiCall(() => _dio.get<List<int>>(path, options: options));
    final data = r.data;
    if (data == null) return Uint8List(0);
    return data is Uint8List ? data : Uint8List.fromList(data);
  }

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
