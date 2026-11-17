import 'package:meta/meta.dart';

import '../../../core/errors/api_error.dart';

/// Departman silme etki önizlemesinin program satırı (`DepartmentDeleteImpactProgram`).
@immutable
final class DepartmentImpactProgram {
  const DepartmentImpactProgram({
    required this.programId,
    required this.linked,
    required this.activeItems,
    required this.completedItems,
    required this.deletedItems,
    required this.deletedWithDepartment,
    this.programName,
    this.departmentName,
  });

  final String programId;
  final String? programName;

  /// Departmanın o programdaki adı; bağ yoksa `null`.
  final String? departmentName;
  final bool linked;
  final int activeItems;
  final int completedItems;
  final int deletedItems;
  final int deletedWithDepartment;

  /// Geri alınabilir silmede "Silinenler"e taşınacak görev sayısı.
  int get liveItems => activeItems + completedItems;
}

/// Kalıcı silmenin çözülemeyen engelleri (tablo çekirdeği): sayılar.
@immutable
final class DepartmentPermanentBlockers {
  const DepartmentPermanentBlockers({
    this.tables = 0,
    this.projects = 0,
    this.pendingProposals = 0,
  });

  /// 409 `organization.department_in_use` zarfının `fields[]` girdilerinden
  /// (`field`: tables|projects|pending_proposals, `message`: sayı). Tanımsız alan ve sayı
  /// olmayan ileti yok sayılır.
  factory DepartmentPermanentBlockers.fromFields(List<ApiFieldError> fields) {
    int count(String name) => fields
        .where((f) => f.field == name)
        .map((f) => int.tryParse(f.message.trim()) ?? 0)
        .fold(0, (a, b) => a + b);
    return DepartmentPermanentBlockers(
      tables: count('tables'),
      projects: count('projects'),
      pendingProposals: count('pending_proposals'),
    );
  }

  final int tables;
  final int projects;
  final int pendingProposals;

  bool get any => tables > 0 || projects > 0 || pendingProposals > 0;
}

/// `GET /v1/departments/{id}/delete-impact` (yalnız şirket yöneticisi): okuma anının
/// görüntüsü. Geri alınabilir silme canlı görevleri ([liveItems], bütün programlar)
/// "Silinenler"e taşır; kalıcı silme silinmişler dahil bütün görevleri, dosyaları, program
/// bağlarını ve ekip satırlarını siler. Toplantılar departman adının kopyasıyla kalır.
@immutable
final class DepartmentDeleteImpact {
  const DepartmentDeleteImpact({
    required this.departmentId,
    required this.name,
    required this.deleted,
    required this.programs,
    required this.activeItems,
    required this.completedItems,
    required this.deletedItems,
    required this.deletedWithDepartment,
    required this.fileCount,
    required this.memberCount,
    required this.meetingCount,
    required this.blockers,
    required this.permanentBlocked,
  });

  final String departmentId;

  /// Katalog adı.
  final String name;
  final bool deleted;
  final List<DepartmentImpactProgram> programs;
  final int activeItems;
  final int completedItems;
  final int deletedItems;
  final int deletedWithDepartment;
  final int fileCount;
  final int memberCount;
  final int meetingCount;
  final DepartmentPermanentBlockers blockers;
  final bool permanentBlocked;

  int get liveItems => activeItems + completedItems;

  /// Kalıcı silmede silinecek bütün görevler.
  int get allItems => liveItems + deletedItems;

  /// [programId] dışındaki, görevi ya da bağı olan programlar (silme onlara da dokunur).
  List<DepartmentImpactProgram> otherPrograms(String? programId) => [
    for (final p in programs)
      if (p.programId != programId && (p.linked || p.liveItems > 0)) p,
  ];
}

/// Geri alınabilir silmenin sonucu (`DeleteDepartmentResult`).
typedef DepartmentDeleteResult = ({bool deleted, int workItemsDeleted});

/// Silme onayında yazılması gereken metin: kısa kod varsa kod, yoksa ad.
String deleteConfirmPhrase({String? code, required String name}) {
  final c = code?.trim() ?? '';
  return c.isNotEmpty ? c : name.trim();
}

/// Yazılan onay metni [deleteConfirmPhrase] ile eşleşiyor mu: baş/son boşluk ve harf büyüklüğü
/// yok sayılır (Türkçe İ/ı dahil); boş ifade hiçbir zaman eşleşmez.
bool deleteConfirmMatches(String typed, {String? code, required String name}) {
  final want = _fold(deleteConfirmPhrase(code: code, name: name));
  return want.isNotEmpty && _fold(typed.trim()) == want;
}

String _fold(String s) => s
    .replaceAll('İ', 'i')
    .replaceAll('I', 'ı')
    .toLowerCase()
    .replaceAll('ı', 'i');
