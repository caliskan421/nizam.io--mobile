// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/archive_file_list.dart';
import '../models/archive_folders.dart';
import '../models/archive_tasks.dart';
import '../models/archive_uploaders.dart';
import '../models/file_record.dart';
import '../models/file_record_list.dart';
import '../models/rename_file_request.dart';
import '../models/tag.dart';

part 'records_client.g.dart';

@RestApi()
abstract class RecordsClient {
  factory RecordsClient(Dio dio, {String? baseUrl}) = _RecordsClient;

  static const Map<String, dynamic> attachFileOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["records"],
      'operationId': "attachFile",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> listWorkItemFilesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "listWorkItemFiles",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> downloadFileOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "downloadFile",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> renameFileOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["records"],
      'operationId': "renameFile",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> deleteFileOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["records"],
      'operationId': "deleteFile",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> archiveAttachmentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveAttachments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> archiveFoldersOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveFolders",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> archiveTasksOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveTasks",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> archiveUploadersOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveUploaders",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> archiveFolderZipOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveFolderZip",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> archiveSelectionZipOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveSelectionZip",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> archiveFullZipOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["records"],
          'operationId': "archiveFullZip",
          'externalDocsUrl': null,
        },
      };

  /// Göreve dosya yükler (multipart `file` parçası; akışla). CSRF başlığı istenmez (taşıyıcı yalnız Bearer).
  ///
  /// [tag] - Kapalı etiket kümesinden biri. Eksikse 422 `records.tag_required`, küme dışıysa 422 `records.tag_invalid`.
  @MultiPart()
  @POST('/v1/work-items/{id}/files')
  Future<FileRecord> attachFile({
    @Path('id') required String id,
    @Query('tag') required Tag tag,
    @Part(name: 'file') required File file,
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.attachFileOpenapiExtras,
  });

  /// Görevin dosyaları.
  @GET('/v1/work-items/{id}/files')
  Future<FileRecordList> listWorkItemFiles({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.listWorkItemFilesOpenapiExtras,
  });

  /// Tek dosyayı indirir (yetkisiz çağıran da bulunamadı alır).
  @GET('/v1/files/{id}/download')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadFile({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.downloadFileOpenapiExtras,
  });

  /// Görünen adı değiştirir (uzantı verilirse dosyanın türüyle uyumlu olmalı; uzantısız ad olduğu gibi yazılır; depolama nesnesine dokunmaz).
  @PATCH('/v1/files/{id}/name')
  Future<FileRecord> renameFile({
    @Path('id') required String id,
    @Body() required RenameFileRequest body,
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.renameFileOpenapiExtras,
  });

  /// Dosyayı siler (metadata + nesne). Yalnız yükleyen siler; ikinci silme 404 `records.file_not_found` alır.
  @DELETE('/v1/files/{id}')
  Future<void> deleteFile({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.deleteFileOpenapiExtras,
  });

  /// Arşiv dosya listesi (süzgeçli, imleçli; kapsam sunucuda sabit).
  ///
  /// [mimeCategory] - `belge`, `tablo`, `gorsel`, `arsiv`, `metin`; bilinmeyen değer süzgeçsizdir.
  ///
  /// [tag] - Etiket; küme dışı değer 422 records.tag_invalid.
  ///
  /// [workItemId] - Görev süzgeci.
  ///
  /// [uploaderId] - Yükleyen süzgeci.
  ///
  /// [from] - RFC 3339 alt sınır; çözümlenemeyen değer yok sayılır.
  ///
  /// [to] - RFC 3339 üst sınır; çözümlenemeyen değer yok sayılır.
  ///
  /// [search] - Ad araması (Türkçe harf duyarsız).
  ///
  /// [sort] - Sıralama ekseni; izinli liste dışı değer varsayılana düşer.
  ///
  /// [limit] - Sayfa boyu; sayı olmayan ya da negatif değer varsayılana düşer.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/records/archive/attachments')
  Future<ArchiveFileList> archiveAttachments({
    @Query('mime_category') String? mimeCategory,
    @Query('tag') String? tag,
    @Query('work_item_id') String? workItemId,
    @Query('uploader_id') String? uploaderId,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('search') String? search,
    @Query('sort') String? sort,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        RecordsClient.archiveAttachmentsOpenapiExtras,
  });

  /// Koordinatörlük başına dosya özeti (üyeye tek sanal klasör).
  @GET('/v1/records/archive/folders')
  Future<ArchiveFolders> archiveFolders({
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.archiveFoldersOpenapiExtras,
  });

  /// Dosyası olan görevler (seçenek listesi).
  @GET('/v1/records/archive/tasks')
  Future<ArchiveTasks> archiveTasks({
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.archiveTasksOpenapiExtras,
  });

  /// Yükleyen hesap kimlikleri (seçenek listesi).
  @GET('/v1/records/archive/uploaders')
  Future<ArchiveUploaders> archiveUploaders({
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.archiveUploadersOpenapiExtras,
  });

  /// Klasörü ZIP olarak akıtır (kullanıcı başına dışa aktarım kotası).
  @GET('/v1/records/archive/folders/{id}/download-zip')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> archiveFolderZip({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.archiveFolderZipOpenapiExtras,
  });

  /// Seçili dosyaları ZIP olarak akıtır (en çok 100 kimlik; dışa aktarım kotası).
  ///
  /// [fileIds] - Virgülle ayrılmış dosya kimlikleri (1–100).
  @GET('/v1/records/archive/files/download-zip')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> archiveSelectionZip({
    @Query('file_ids') required String fileIds,
    @Extras()
    Map<String, dynamic>? extras =
        RecordsClient.archiveSelectionZipOpenapiExtras,
  });

  /// Dönemin tam arşivini ZIP olarak akıtır (yalnız şirket yöneticisi; dışa aktarım kotası).
  @GET('/v1/records/archive/period/download-zip')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> archiveFullZip({
    @Extras()
    Map<String, dynamic>? extras = RecordsClient.archiveFullZipOpenapiExtras,
  });
}
