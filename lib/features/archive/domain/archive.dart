import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';

/// Arşiv klasörü: bir koordinatörlüğün dosyaları (sayılar sunucunun hesapladığı değerlerdir).
///
/// Sunucu karşılığı `ArchiveFolder` (`GET /v1/records/archive/folders`): `folder_id` → [code],
/// `name` → [name], `file_count` → [files], `is_virtual` → [isVirtual]. Diğer alanlar sunucuda
/// yoktur (varsayılanlı; entegrasyonda karar).
@immutable
final class ArchiveFolder {
  const ArchiveFolder({
    required this.code,
    required this.name,
    required this.files,
    this.tasks = 0,
    this.sizeMb = 0,
    this.lastUploadDays,
    this.leads = const [],
    this.isVirtual = false,
  });

  /// Rota kimliği. Örnek veride koordinatörlük kodu (`ALT`); sunucuda `folder_id`
  /// (departman kimliği ya da üyenin sanal klasör kimliği — biçimi spec'te tanımsız).
  final String code;
  final String name;
  final int files;

  /// Dosyası olan görev sayısı. Sunucuda yok — entegrasyonda karar (`archiveTasks` ile türetilebilir).
  final int tasks;

  /// Klasör boyutu. Sunucuda yok — entegrasyonda karar.
  final double sizeMb;

  /// Son yüklemeden bu yana gün (null → hiç yükleme yok). Sunucuda yok — entegrasyonda karar.
  final int? lastUploadDays;

  /// Koordinatör kişi kimlikleri (görev kataloğundaki kişiler). Sunucuda yok — entegrasyonda
  /// karar (koordinatörler organization uçlarından gelir).
  final List<String> leads;

  /// Üyenin "Görevlerim" sanal klasörü (sunucu `is_virtual`; RECORDS-K18): koordinatörlük değildir.
  final bool isVirtual;
}

/// Arşiv klasörlerinin kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class ArchiveRepository {
  Future<List<ArchiveFolder>> loadFolders();
}

/// Hazır dosya etiketleri; [share] örnek dağılımdaki payıdır. Örnek veriden türedi; sunucunun
/// kapalı etiket kümesi `RecordTag`'dir (`records.dart`) — örtüşmez, entegrasyonda karar.
enum ArchiveTag {
  field(0.5),
  result(0.3),
  data(0.2);

  const ArchiveTag(this.share);

  final double share;
}

/// Kullanıcının eklediği etiket rengi.
enum ArchiveTagColor { violet, gold, green, red, gray }

/// Kullanıcının eklediği etiket (bellekte; sunucuya yazılmaz).
@immutable
final class ArchiveCustomTag {
  const ArchiveCustomTag({
    required this.id,
    required this.name,
    required this.color,
  });

  final String id;
  final String name;
  final ArchiveTagColor color;
}

/// Klasör sıralaması (prototip: Son yükleme → Ada göre → Boyuta göre). Sunucuda aynı üç eksen
/// arşiv DOSYA listesinin `sort` parametresidir (`ArchiveAttachmentFilter.sort`): [recent] →
/// varsayılan (yükleme zamanı azalan), [name] → `name`, [size] → `size`.
enum ArchiveSort { recent, name, size }

/// Dosya türü.
enum ArchiveFileKind { image, document, pdf }

/// Klasördeki dosya.
@immutable
final class ArchiveFile {
  const ArchiveFile({
    required this.id,
    required this.name,
    required this.kind,
    required this.tag,
    required this.taskCode,
    required this.taskTitle,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.sizeMb,
  });

  final String id;
  final String name;
  final ArchiveFileKind kind;
  final ArchiveTag tag;
  final String taskCode;
  final String taskTitle;

  /// Yükleyen kişinin adı (null → bilinmiyor, "Admin").
  final String? uploadedBy;
  final DateTime uploadedAt;
  final double sizeMb;
}

/// Görev klasörü: dosyası olan görev ve dosya sayısı.
typedef ArchiveTaskFolder = ({TaskItem task, int files});

int _compareTr(String a, String b) => _trKey(a).compareTo(_trKey(b));

/// Türkçe alfabe sırası için basit anahtar (ç, ğ, ı, ö, ş, ü harflerin ardından gelir).
String _trKey(String s) {
  const order = 'aâbcçdefgğhıiîjklmnoöprsştuüûvyz';
  final lower = s.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
  return String.fromCharCodes(
    lower.runes.map((r) {
      final i = order.indexOf(String.fromCharCode(r));
      return i < 0 ? r + 200 : 97 + i;
    }),
  );
}

/// Türkçe küçük harf (arama).
String lowerTr(String s) =>
    s.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

/// Arama ([query]) ve sıralama uygulanmış klasör listesi.
List<ArchiveFolder> visibleFolders(
  List<ArchiveFolder> folders, {
  required ArchiveSort sort,
  String query = '',
}) {
  final q = lowerTr(query.trim());
  final list = [
    for (final f in folders)
      if (q.isEmpty || lowerTr(f.name).contains(q)) f,
  ];
  int days(ArchiveFolder f) => f.lastUploadDays ?? 1 << 30;
  switch (sort) {
    case ArchiveSort.recent:
      list.sort((a, b) => days(a).compareTo(days(b)));
    case ArchiveSort.name:
      list.sort((a, b) => _compareTr(a.name, b.name));
    case ArchiveSort.size:
      list.sort((a, b) => b.sizeMb.compareTo(a.sizeMb));
  }
  return list;
}

/// Seçili etikete göre klasördeki dosya sayısı (etiketsiz → hepsi; özel etiket → 0).
int folderFilesFor(ArchiveFolder f, {ArchiveTag? tag, bool customTag = false}) {
  if (customTag) return 0;
  return tag == null ? f.files : (f.files * tag.share).round();
}

/// Etiket hapındaki sayı (toplam dosya × pay).
int tagCount(int totalFiles, ArchiveTag tag) =>
    (totalFiles * tag.share).round();

/// Klasörün görev klasörleri: dosyası olan ya da bitmiş görevler; kalan dosyalar görevlere
/// sırayla dağıtılarak klasör toplamına tamamlanır (prototip kuralı; sayılar örnek veridir).
List<ArchiveTaskFolder> taskFolders(ArchiveFolder folder, TaskCatalog catalog) {
  final tasks = [
    for (final t in catalog.tasksOf(folder.code))
      if (t.files > 0 || t.status == TaskStatus.done) t,
  ];
  final counts = [for (final t in tasks) t.files];
  var rest = folder.files - counts.fold(0, (a, b) => a + b);
  var i = 0;
  while (rest > 0 && tasks.isNotEmpty) {
    counts[i % tasks.length]++;
    rest--;
    i++;
  }
  return [
    for (var j = 0; j < tasks.length; j++) (task: tasks[j], files: counts[j]),
  ];
}

/// Klasörün dosyaları (örnek üretim: tür/etiket sırası, tarih ve ad prototipteki gibi).
List<ArchiveFile> folderFiles(ArchiveFolder folder, TaskCatalog catalog) {
  const tags = [
    ArchiveTag.field,
    ArchiveTag.result,
    ArchiveTag.field,
    ArchiveTag.data,
    ArchiveTag.result,
  ];
  const kinds = [
    ArchiveFileKind.image,
    ArchiveFileKind.document,
    ArchiveFileKind.image,
    ArchiveFileKind.pdf,
    ArchiveFileKind.image,
  ];
  final per = folder.files == 0 ? 0.0 : folder.sizeMb / folder.files;
  final out = <ArchiveFile>[];
  var k = 0;
  final groups = taskFolders(folder, catalog);
  for (var ti = 0; ti < groups.length; ti++) {
    final (:task, :files) = groups[ti];
    for (var j = 0; j < files; j++) {
      final kind = kinds[k % 5];
      final day = 2 + ((k * 7 + ti * 3) % 26);
      final month = 9 - (k % 2);
      String two(int n) => n.toString().padLeft(2, '0');
      final name = kind == ArchiveFileKind.image
          ? 'WhatsApp Image 2026-${two(month)}-${two(day)} at '
                '${10 + (k % 11)}.${10 + (k * 13) % 50}.${10 + (k * 7) % 50}.jpeg'
          : '${task.code}_${kind == ArchiveFileKind.document ? 'Rapor' : 'Tutanak'}'
                '_Rev${1 + (k % 3)}.${kind == ArchiveFileKind.document ? 'docx' : 'pdf'}';
      final lead = task.assignees.isEmpty ? null : task.assignees.first;
      out.add(
        ArchiveFile(
          id: '${task.code}-$j',
          name: name,
          kind: kind,
          tag: tags[k % 5],
          taskCode: task.code,
          taskTitle: task.title,
          uploadedBy: lead == null ? null : catalog.person(lead)?.name,
          uploadedAt: DateTime(
            2026,
            month,
            day,
            10 + (k % 8),
            5 + (k * 11) % 50,
          ),
          sizeMb: per * (kind == ArchiveFileKind.image ? 0.8 : 1.4),
        ),
      );
      k++;
    }
  }
  return out;
}
