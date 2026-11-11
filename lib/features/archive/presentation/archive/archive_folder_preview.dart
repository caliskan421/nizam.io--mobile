/// Geçici tasarım önizlemesi; klasör özeti API alanları sağlandığında kaldırılır.
/// Gerçek klasör adı ve dosya sayısı bu tablodan alınmaz.
typedef ArchiveFolderPreview = ({
  int tasks,
  int bytes,
  int daysAgo,
  bool group,
});

const _mb = 1024 * 1024;
const _fallback = (tasks: 4, bytes: 5 * _mb ~/ 2, daysAgo: 5, group: false);
const _preview = <String, ArchiveFolderPreview>{
  'İdari işler': (tasks: 11, bytes: 3250586, daysAgo: 0, group: false),
  'Mekanik sistemler': (tasks: 8, bytes: 5557453, daysAgo: 1, group: true),
  'Operasyon': (tasks: 8, bytes: 3250586, daysAgo: 4, group: false),
  'Fuar': (tasks: 4, bytes: 2621440, daysAgo: 5, group: false),
  'Altyapı ve tesisat': (tasks: 14, bytes: 4718592, daysAgo: 23, group: true),
  'Elektrik ve enerji': (tasks: 7, bytes: 3355443, daysAgo: 26, group: true),
  'Satış ve pazarlama': (tasks: 7, bytes: 3774874, daysAgo: 43, group: false),
  'Sistem koordinatörlüğü': (
    tasks: 4,
    bytes: 2202010,
    daysAgo: 75,
    group: false,
  ),
  'Mimari tasarım': (tasks: 5, bytes: 1887437, daysAgo: 89, group: false),
  'Eğitim ve Arge': (tasks: 7, bytes: 1258291, daysAgo: 113, group: false),
  'Ulaşım planlama': (tasks: 4, bytes: 601 * 1024, daysAgo: 166, group: true),
};

ArchiveFolderPreview archiveFolderPreview(String name) =>
    _preview[name] ?? _fallback;
