import 'package:meta/meta.dart';

import 'archive.dart';
import 'records.dart';

/// Arşiv özeti (ana sayfa kartları): dosya sayısı, toplam boyut ve tür dağılımı. Sunucuda
/// özet ucu yok; istemci arşiv dosya listesinden (`archiveAttachments`) hesaplar. [partial]
/// okuma sınırına takıldı: sayılar en az değerdir.
@immutable
final class ArchiveSummary {
  const ArchiveSummary({
    required this.files,
    required this.bytes,
    required this.kinds,
    this.partial = false,
  });

  final int files;
  final int bytes;

  /// Tür başına dosya sayısı (sıfır olan tür de yer alır; sıra [ArchiveFileKind.values]).
  final Map<ArchiveFileKind, int> kinds;
  final bool partial;
}

/// [files]'tan özet; aynı kimlik bir kez sayılır.
ArchiveSummary summarizeArchive(
  Iterable<RecordFile> files, {
  bool partial = false,
}) {
  final seen = <String>{};
  var bytes = 0;
  final kinds = {for (final k in ArchiveFileKind.values) k: 0};
  for (final f in files) {
    if (!seen.add(f.id)) continue;
    bytes += f.sizeBytes;
    kinds[f.kind] = kinds[f.kind]! + 1;
  }
  return ArchiveSummary(
    files: seen.length,
    bytes: bytes,
    kinds: kinds,
    partial: partial,
  );
}

/// Klasörün (koordinatörlük) depolama özeti: dosya, toplam boyut, dosyası olan görev sayısı.
@immutable
final class ArchiveFolderStats {
  const ArchiveFolderStats({
    required this.files,
    required this.bytes,
    required this.tasks,
  });

  static const empty = ArchiveFolderStats(files: 0, bytes: 0, tasks: 0);

  final int files;
  final int bytes;
  final int tasks;
}

/// Yönetici arşiv ana sayfasının depolama özeti: toplam dosya ve boyut, tür başına boyut,
/// dosyası olan görev sayısı ve klasör başına özet. Sunucuda klasör boyutu ve görev sayısı
/// yok; dosya listesinden ve görevin koordinatörlüğünden istemcide türetilir. [partial]: okuma
/// sınırına takıldı, sayılar en az değerdir.
@immutable
final class ArchiveStats {
  const ArchiveStats({
    required this.files,
    required this.bytes,
    required this.tasks,
    required this.kindBytes,
    required this.folders,
    this.partial = false,
  });

  final int files;
  final int bytes;
  final int tasks;

  /// Tür başına toplam bayt (sıfır olan tür de yer alır; sıra [ArchiveFileKind.values]).
  final Map<ArchiveFileKind, int> kindBytes;

  /// Klasör kimliği (departman) → özet; dosyası olmayan klasör yer almaz.
  final Map<String, ArchiveFolderStats> folders;
  final bool partial;

  ArchiveFolderStats folder(String code) =>
      folders[code] ?? ArchiveFolderStats.empty;
}

/// [files]'tan istatistik; aynı kimlik bir kez sayılır. [tags] boş değilse yalnız o etiketli
/// dosyalar. [folderOf] görevin klasörünü (departman kimliği) verir; bilinmeyen görevin
/// dosyası toplamlara girer, klasöre girmez.
ArchiveStats archiveStats(
  Iterable<RecordFile> files, {
  required String? Function(String workItemId) folderOf,
  Set<RecordTag> tags = const {},
  bool partial = false,
}) {
  final seen = <String>{};
  final taskIds = <String>{};
  var bytes = 0;
  final kindBytes = {for (final k in ArchiveFileKind.values) k: 0};
  final folderFiles = <String, int>{};
  final folderBytes = <String, int>{};
  final folderTasks = <String, Set<String>>{};
  for (final f in files) {
    if (tags.isNotEmpty && !tags.contains(f.tag)) continue;
    if (!seen.add(f.id)) continue;
    bytes += f.sizeBytes;
    kindBytes[f.kind] = kindBytes[f.kind]! + f.sizeBytes;
    taskIds.add(f.workItemId);
    final folder = folderOf(f.workItemId);
    if (folder == null) continue;
    folderFiles[folder] = (folderFiles[folder] ?? 0) + 1;
    folderBytes[folder] = (folderBytes[folder] ?? 0) + f.sizeBytes;
    (folderTasks[folder] ??= {}).add(f.workItemId);
  }
  return ArchiveStats(
    files: seen.length,
    bytes: bytes,
    tasks: taskIds.length,
    kindBytes: kindBytes,
    folders: {
      for (final code in folderFiles.keys)
        code: ArchiveFolderStats(
          files: folderFiles[code]!,
          bytes: folderBytes[code]!,
          tasks: folderTasks[code]!.length,
        ),
    },
    partial: partial,
  );
}

/// Yönetici arşiv ana sayfasında koordinatörlük kartlarının sırası.
enum ArchiveFolderSort { size, files, name }

/// Klasörleri [sort] ölçütüyle sıralar ([stats] yokken sunucu dosya sayısı, boyut 0); eşitlikte
/// ad sırası. Ad Türkçe büyük/küçük harf ayırmadan karşılaştırılır.
List<ArchiveFolder> sortArchiveFolders(
  Iterable<ArchiveFolder> folders, {
  required ArchiveStats? stats,
  required ArchiveFolderSort sort,
  required bool descending,
}) {
  String key(ArchiveFolder f) => f.name.toLowerCase();
  int byName(ArchiveFolder a, ArchiveFolder b) => key(a).compareTo(key(b));
  int value(ArchiveFolder f) => switch (sort) {
    ArchiveFolderSort.size => stats?.folder(f.code).bytes ?? 0,
    ArchiveFolderSort.files => stats?.folder(f.code).files ?? f.files,
    ArchiveFolderSort.name => 0,
  };
  final list = List.of(folders)
    ..sort((a, b) {
      final o = sort == ArchiveFolderSort.name
          ? byName(a, b)
          : value(a).compareTo(value(b));
      final d = descending ? -o : o;
      return d != 0 ? d : byName(a, b);
    });
  return list;
}
