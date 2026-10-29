import '../../domain/archive.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Arşiv ekranı backend hazır olmadan kurulsun diye
/// prototipteki 11 klasörü (227 dosya, 559,3 MB) döner; ağ isteği atmaz. Koordinatörler görev
/// kataloğunun prototip kişileridir. Bileşim kökünde (`archive_module.dart`) tek yerde bağlanır.
final class SampleArchiveRepository implements ArchiveRepository {
  const SampleArchiveRepository();

  @override
  Future<List<ArchiveFolder>> loadFolders() async => _folders;
}

const _folders = <ArchiveFolder>[
  ArchiveFolder(
    code: 'OPE',
    name: 'Operasyon',
    files: 78,
    tasks: 53,
    sizeMb: 205.1,
    lastUploadDays: 4,
    leads: ['yc'],
  ),
  ArchiveFolder(
    code: 'MİM',
    name: 'Mimari tasarım',
    files: 8,
    tasks: 5,
    sizeMb: 88.9,
    lastUploadDays: 8,
    leads: ['eo'],
  ),
  ArchiveFolder(
    code: 'ELE',
    name: 'Elektrik ve enerji',
    files: 60,
    tasks: 11,
    sizeMb: 23.2,
    lastUploadDays: 22,
    leads: ['rk'],
  ),
  ArchiveFolder(
    code: 'ALT',
    name: 'Altyapı ve tesisat',
    files: 15,
    tasks: 12,
    sizeMb: 9.8,
    lastUploadDays: 23,
    leads: ['aa', 'av', 'ko'],
  ),
  ArchiveFolder(
    code: 'SİS',
    name: 'Sistem koordinatörlüğü',
    files: 12,
    tasks: 4,
    sizeMb: 0.3,
    lastUploadDays: 23,
    leads: ['ma', 'my'],
  ),
  ArchiveFolder(
    code: 'EĞİ',
    name: 'Eğitim ve Arge',
    files: 3,
    tasks: 3,
    sizeMb: 0.15,
    lastUploadDays: 28,
    leads: ['mk'],
  ),
  ArchiveFolder(
    code: 'MEK',
    name: 'Mekanik sistemler',
    files: 38,
    tasks: 8,
    sizeMb: 229.1,
    lastUploadDays: 37,
    leads: ['my', 'oh'],
  ),
  ArchiveFolder(
    code: 'SAT',
    name: 'Satış ve pazarlama',
    files: 4,
    tasks: 3,
    sizeMb: 0.4,
    lastUploadDays: 43,
    leads: ['bc'],
  ),
  ArchiveFolder(
    code: 'İDA',
    name: 'İdari işler',
    files: 5,
    tasks: 3,
    sizeMb: 1.2,
    lastUploadDays: 1,
    leads: [],
  ),
  ArchiveFolder(
    code: 'ULA',
    name: 'Ulaşım planlama',
    files: 1,
    tasks: 1,
    sizeMb: 0.2,
    lastUploadDays: 15,
    leads: ['so'],
  ),
  ArchiveFolder(
    code: 'FUA',
    name: 'Fuar',
    files: 3,
    tasks: 2,
    sizeMb: 0.9,
    lastUploadDays: 12,
    leads: ['ss'],
  ),
];
