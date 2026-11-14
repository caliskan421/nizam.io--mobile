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
