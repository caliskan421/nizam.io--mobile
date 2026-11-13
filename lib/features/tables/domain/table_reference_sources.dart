import 'package:meta/meta.dart';

import '../../../core/domain/page_slice.dart';
import 'table_models.dart';

/// Referans seçicisinin adayı: hedef kimlik + görünen ad (+ görev adayında dosya listesi için
/// görevin departmanı).
@immutable
final class TableRefCandidate {
  const TableRefCandidate({
    required this.id,
    required this.name,
    this.detail,
    this.departmentId,
  });
  final String id;
  final String name;
  final String? detail;
  final String? departmentId;
}

/// Referans hedef adayları. Görünürlük kuralı sahip modüldedir (backend ADR-0034); aday her
/// tür için o kuralın karşılığı olan MEVCUT uçtan gelir. Kural ile uç birebir örtüşmüyorsa
/// sunucu yazımı 422 `tables.reference_unavailable` ile reddeder (değer geri alınır).
/// Gerçekleştirme `data/table_reference_api_repository.dart`.
abstract interface class TableReferenceSources {
  /// Kişi (paylaşım hedefi kuralı): koordinatörlük tablosunda tablonun departman ekibi
  /// (`listMembers`; yönetici ya da o departmanın koordinatörü çağırabilir, diğerine 403),
  /// kişisel tabloda programda ekip satırı olan hesaplar (`listMeetingParticipantCandidates`;
  /// yönetici ya da programda koordinatör; yalnız üye 403).
  Future<List<TableRefCandidate>> people(TableScope scope);

  /// Departman (departman listesi kuralı): şirket yöneticisine programa bağlı bütün canlı
  /// departmanlar (`listProgramDepartments`), diğerlerine programda ekip satırı olduğu
  /// departmanlar (`myDepartments`); yöneticilik `me` ile.
  Future<List<TableRefCandidate>> departments(TableScope scope);

  /// Görev (tekil görev okuma kuralı): programın görünür görevleri (`listProgramWorkItems`,
  /// imleçli).
  Future<PageSlice<TableRefCandidate>> tasks(
    TableScope scope, {
    PageRequest page = const PageRequest(),
  });

  /// Dosya (indirme kuralı): seçilen görevin dosyaları (`listWorkItemFiles`, görevin kendi
  /// program + departman kapsamıyla).
  Future<List<TableRefCandidate>> files(
    TableScope scope,
    TableRefCandidate task,
  );
}

/// Referans rozetine dokunma kararı.
sealed class TableRefTarget {
  const TableRefTarget();
}

/// Hedef tabloyu aç (aynı program/alan; erişim yoksa tablo ekranı 403/404 durumunu gösterir).
final class OpenTableTarget extends TableRefTarget {
  const OpenTableTarget(this.id);
  final String id;
}

/// Görev ayrıntısını aç.
final class OpenTaskTarget extends TableRefTarget {
  const OpenTaskTarget(this.id);
  final String id;
}

/// Uygulama içi hedef sayfası yok ya da hedef okuyana gizli: yalnız gösterim.
final class NoTarget extends TableRefTarget {
  const NoTarget();
}

/// Gezinme kararı. Gizlenmiş (redakte, `null`) öğe ya da görünen adı olmayan (okuyana
/// görünmeyen) hedef açılmaz. Kişi (yönetim yüzü yalnız yöneticiye), departman ve dosya için
/// genel bir hedef sayfası yok: yalnız gösterim.
TableRefTarget tableRefTarget(
  TableColumnKind kind,
  String? id, {
  required bool visible,
}) {
  if (id == null || id.isEmpty || !visible) return const NoTarget();
  return switch (kind) {
    TableColumnKind.tableReference => OpenTableTarget(id),
    TableColumnKind.taskReference => OpenTaskTarget(id),
    _ => const NoTarget(),
  };
}
