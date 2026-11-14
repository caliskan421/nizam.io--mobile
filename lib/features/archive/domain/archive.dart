import 'package:meta/meta.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/domain/turkish_collation.dart';
import 'records.dart';

/// Arşiv klasörü (`GET /v1/records/archive/folders` satırı): `folder_id` → [code], `name` →
/// [name], `file_count` → [files], `is_virtual` → [isVirtual]. Sunucu boyut, son yükleme ve
/// koordinatör bilgisi vermez; bu alanlar yoktur.
@immutable
final class ArchiveFolder {
  const ArchiveFolder({
    required this.code,
    required this.name,
    required this.files,
    this.isVirtual = false,
  });

  /// Rota kimliği: departman kimliği ya da üyenin sanal klasörü (`my-tasks`).
  final String code;

  /// Departmanın programdaki adı (sanal klasörde "Görevlerim").
  final String name;
  final int files;

  /// Üyenin "Görevlerim" sanal klasörü (RECORDS-K18): koordinatörlük değildir.
  final bool isVirtual;
}

/// Arşiv uçlarının kapsamı (S3). Sunucu arşiv yetkisini isteğin departman başlığındaki ekip
/// rolünden çözer (RECORDS-K18): yönetici dönem geneli, koordinatör kendi koordinatörlüğü, üye
/// atandığı görevler. Seçili kapsamda departman tutulmadığından başlık burada seçilir.
@immutable
final class ArchiveScope {
  const ArchiveScope({required this.department, required this.admin});

  /// Klasör listesinin ve sanal klasörün departman başlığı (ilk koordinatörlük, yoksa ilk
  /// ekip satırı; yöneticide programın ilk departmanı).
  final String department;

  /// Şirket yöneticisi: liste uçları dönem genelidir (departman başlığı daraltmaz).
  final bool admin;

  /// [folder] için gönderilecek departman: gerçek klasörde kendi kimliği, sanal klasörde
  /// [department].
  String departmentFor(ArchiveFolder folder) =>
      folder.isVirtual ? department : folder.code;

  /// Liste uçları (görevler, dosyalar, yükleyenler) bu klasöre sunucuda daralmaz mı:
  /// yöneticide dönem geneli döner, istemci klasörün görevleriyle süzer.
  bool widerThan(ArchiveFolder folder) => admin && !folder.isVirtual;

  @override
  bool operator ==(Object other) =>
      other is ArchiveScope &&
      other.department == department &&
      other.admin == admin;

  @override
  int get hashCode => Object.hash(department, admin);
}

/// Arşiv dosya listesinin sıralama ekseni (`sort`): [recent] → varsayılan (yükleme zamanı
/// azalan), [name] → `name`, [size] → `size`. Eksen değişince imleç geçersizleşir.
enum ArchiveSort { recent, name, size }

/// Dosya türü (`content_type`'tan türetilir).
enum ArchiveFileKind { image, document, pdf }

/// records arşiv uçlarının kaynağı (domain portu; gerçekleştirme `data/records_api_repository.dart`).
/// Bütün uçlar S3'tür: [department] isteğin departman başlığıdır ([ArchiveScope]). İndirmeler
/// akış döner (belleğe toplanmaz). Hatalar `ApiError` olarak fırlar.
abstract interface class ArchiveRepository {
  /// Klasör özeti (`archiveFolders`).
  Future<List<ArchiveFolder>> loadFolders({required String department});

  /// Dosyası olan görevler (`archiveTasks`; imleçsiz).
  Future<List<ArchiveTaskSummary>> archiveTasks({required String department});

  /// Yükleyen hesap kimlikleri (`archiveUploaders`; ad yok).
  Future<List<String>> archiveUploaders({required String department});

  /// Arşiv dosya listesi (`archiveAttachments`; imleçli, `total` yok).
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  });

  /// Göreve dosya yükler (`attachFile`, multipart). [tag] [RecordTag.unknown] olamaz; uzantı
  /// izinli kümede değilse istek gönderilmez (`records.content_rejected`). [requestKey]:
  /// `Idempotency-Key` (ADR-0027).
  Future<RecordFile> attachFile({
    required String department,
    required String workItemId,
    required RecordTag tag,
    required String filePath,
    required String filename,
    required String requestKey,
  });

  /// Dosyayı siler (`deleteFile`; yalnız yükleyen).
  Future<void> deleteFile(String fileId, {required String department});

  /// Etiketi değiştirir (`retagFile`, `PATCH /v1/files/{id}/tag`; RECORDS-K10 yetkisi:
  /// yönetici, ekibin koordinatörü ya da ekipte satırı olan yükleyen).
  Future<void> retagFile(
    String fileId,
    RecordTag tag, {
    required String department,
  });

  /// Tek dosyanın içeriği (`downloadFile`).
  Future<Stream<List<int>>> downloadFile(
    String fileId, {
    required String department,
  });

  /// Klasörün ZIP'i (`archiveFolderZip`).
  Future<Stream<List<int>>> downloadFolderZip(
    String folderId, {
    required String department,
  });

  /// Seçili dosyaların ZIP'i (`archiveSelectionZip`; 1–100 kimlik).
  Future<Stream<List<int>>> downloadSelectionZip(
    List<String> fileIds, {
    required String department,
  });

  /// Dönemin tam arşivi (`archiveFullZip`; yalnız şirket yöneticisi).
  Future<Stream<List<int>>> downloadPeriodZip({required String department});
}

/// Arama ([query]) uygulanmış, Türkçe alfabe sırasıyla klasör listesi.
List<ArchiveFolder> visibleFolders(
  List<ArchiveFolder> folders, {
  String query = '',
}) {
  final q = trLower(query.trim());
  return [
    for (final f in folders)
      if (q.isEmpty || trLower(f.name).contains(q)) f,
  ]..sort((a, b) => compareTurkish(a.name, b.name));
}
