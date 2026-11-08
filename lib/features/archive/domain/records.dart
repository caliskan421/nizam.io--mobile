import 'package:meta/meta.dart';

import 'archive.dart';

/// Sunucunun kapalı dosya etiketi kümesi (records `tag`: `ister, plan, girdi, analiz, cikti,
/// sonuc`). Üye adları tel değeriyle aynıdır (`enumFromWire`).
enum RecordTag {
  ister,
  plan,
  girdi,
  analiz,
  cikti,
  sonuc,

  /// Bilinmeyen ya da boş sunucu değeri. İstekte gönderilemez.
  unknown,
}

/// Arşiv süzgecinin MIME kategorisi (`mime_category`). Üye adları tel değeriyle aynıdır.
enum ArchiveMimeCategory { belge, tablo, gorsel, arsiv, metin }

/// Bir görev dosyasının kaydı (sunucu `FileRecord` / `FileListItem`). Arşiv listesi yükleme
/// zamanı, görev başlığı ve yükleyen adı taşımaz; görev başlığı `archiveTasks`'tan, yükleyen adı
/// görev kataloğundan çözülür (yoksa nötr etiket).
@immutable
final class RecordFile {
  const RecordFile({
    required this.id,
    required this.workItemId,
    required this.displayName,
    required this.contentType,
    required this.sizeBytes,
    required this.tag,
    this.uploaderId,
  });

  /// `file_id`.
  final String id;

  /// Dosyanın bağlı olduğu görev (`work_item_id`).
  final String workItemId;

  /// Görünen ad (`display_name`).
  final String displayName;
  final String contentType;
  final int sizeBytes;
  final RecordTag tag;

  /// Yükleyen hesap (`uploaded_by_account_id`). Yalnız liste satırında gelir; yükleme ve yeniden
  /// adlandırma yanıtında (`FileRecord`) yoktur → `null`. Ad dizini sunucuda yok.
  final String? uploaderId;

  /// UI dosya türü ([ArchiveFileKind]) `content_type`'tan türetilir: `image/*` → görsel,
  /// `application/pdf` → pdf, kalan her şey belge.
  ArchiveFileKind get kind {
    final t = contentType.toLowerCase();
    if (t.startsWith('image/')) return ArchiveFileKind.image;
    if (t == 'application/pdf') return ArchiveFileKind.pdf;
    return ArchiveFileKind.document;
  }

  /// MB cinsinden boyut (UI `sizeMb` alanlarıyla aynı birim).
  double get sizeMb => sizeBytes / (1024 * 1024);
}

/// Dosyası olan görev (`GET /v1/records/archive/tasks` satırı).
@immutable
final class ArchiveTaskSummary {
  const ArchiveTaskSummary({
    required this.workItemId,
    required this.title,
    required this.fileCount,
  });

  final String workItemId;
  final String title;
  final int fileCount;
}

/// Arşiv dosya listesinin süzgeçleri (`GET /v1/records/archive/attachments`). Boş alan
/// süzgeçsizdir.
@immutable
final class ArchiveAttachmentFilter {
  const ArchiveAttachmentFilter({
    this.mimeCategory,
    this.tag,
    this.workItemId,
    this.uploaderId,
    this.from,
    this.to,
    this.search,
    this.sort = ArchiveSort.recent,
  });

  final ArchiveMimeCategory? mimeCategory;

  /// [RecordTag.unknown] süzgeç olarak gönderilemez.
  final RecordTag? tag;
  final String? workItemId;
  final String? uploaderId;

  /// Yükleme zamanı alt/üst sınırı (RFC 3339, UTC'ye çevrilerek gönderilir).
  final DateTime? from;
  final DateTime? to;

  /// Ad araması (sunucuda Türkçe harf duyarsız).
  final String? search;

  /// Sıralama ekseni. Eksen değişince imleç geçersizleşir (422 `records.invalid_cursor`):
  /// liste baştan yüklenmeli.
  final ArchiveSort sort;

  @override
  bool operator ==(Object other) =>
      other is ArchiveAttachmentFilter &&
      other.mimeCategory == mimeCategory &&
      other.tag == tag &&
      other.workItemId == workItemId &&
      other.uploaderId == uploaderId &&
      other.from == from &&
      other.to == to &&
      other.search == search &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(
    mimeCategory,
    tag,
    workItemId,
    uploaderId,
    from,
    to,
    search,
    sort,
  );
}

/// İndirme uçlarının göreli yolları (göreli yol + ham sorgu dizesi; yöntem `GET`): doğrudan
/// istekte ve indirme biletinin hedefinde (`POST /v1/download-tickets` `path`) aynıdır.
/// Kimlikler yol parçası olarak kodlanır.
abstract final class RecordsDownloadTargets {
  /// Seçim ZIP'inde en çok kimlik sayısı (spec: 1–100).
  static const maxSelection = 100;

  /// `downloadFile`.
  static String file(String fileId) =>
      '/v1/files/${Uri.encodeComponent(fileId)}/download';

  /// `archiveFolderZip`.
  static String folderZip(String folderId) =>
      '/v1/records/archive/folders/${Uri.encodeComponent(folderId)}/download-zip';

  /// `archiveSelectionZip`; [fileIds] 1–[maxSelection] kimlik, aksi [ArgumentError].
  static String selectionZip(List<String> fileIds) {
    checkSelection(fileIds);
    // Kimlikler tek tek kodlanır; ayraç virgül ham kalır (sunucu virgülle böler).
    final ids = fileIds.map(Uri.encodeQueryComponent).join(',');
    return '/v1/records/archive/files/download-zip?file_ids=$ids';
  }

  /// `archiveFullZip` (yalnız şirket yöneticisi).
  static const periodZip = '/v1/records/archive/period/download-zip';

  /// Seçim ZIP'i kimlik sayısı denetimi (1–[maxSelection]).
  static void checkSelection(List<String> fileIds) {
    if (fileIds.isEmpty || fileIds.length > maxSelection) {
      throw ArgumentError.value(
        fileIds.length,
        'fileIds',
        '1–$maxSelection dosya kimliği olmalı',
      );
    }
  }
}
