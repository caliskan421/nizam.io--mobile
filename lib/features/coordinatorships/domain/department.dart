import 'package:meta/meta.dart';

import '../../scope/scope.dart' show DepartmentRole;

/// Departman türü. Mobilde "koordinatörlük" denen birim sunucuda `kind: koordinatorluk`
/// departmandır; `calisma_grubu` ikinci türdür. Yanıtta tür serbest dizgedir; tanımsız
/// değer [unknown] olur.
enum DepartmentKind {
  coordinatorship('koordinatorluk'),
  workingGroup('calisma_grubu'),
  unknown(null);

  const DepartmentKind(this.wire);

  /// Sözleşmedeki değer; [unknown] için `null`.
  final String? wire;

  /// Sunucu dizgesinden; `null` ya da tanımsız değer [unknown].
  static DepartmentKind fromWire(String? value) {
    for (final k in values) {
      if (k.wire != null && k.wire == value) return k;
    }
    return unknown;
  }
}

/// Departman üyeliğinin durumu (`RosterMember.status`).
enum MemberStatus { active, deleted, unknown }

/// Departman (sunucu varlığı; `GET /v1/departments`, oluşturma/güncelleme yanıtı).
///
/// Birleştirme notu: `CoordinatorshipProfile.code`/`about` bu varlığın [code]/[description]
/// alanlarıyla örtüşür; profilin geri kalanı (üst birim, kuruluş, alt birimler, ek üyeler,
/// sohbet, etkinlik) sunucuda yoktur. Profil kimlik taşımadığı ve zorunlu alanlarının sunucu
/// karşılığı olmadığı için ayrı tutuldu — entegrasyonda karar.
@immutable
final class Department {
  const Department({
    required this.id,
    required this.name,
    required this.kind,
    this.code,
    this.description,
  });

  final String id;
  final String name;
  final DepartmentKind kind;

  /// İsteğe bağlı kısa kod (yalnız şirket yöneticisinin departman listesinde gelir).
  final String? code;
  final String? description;

  @override
  bool operator ==(Object other) =>
      other is Department &&
      other.id == id &&
      other.name == name &&
      other.kind == kind &&
      other.code == code &&
      other.description == description;

  @override
  int get hashCode => Object.hash(id, name, kind, code, description);
}

/// Departmana atanabilir hesap (`GET /v1/departments/{id}/assignable`).
@immutable
final class AssignableAccount {
  AssignableAccount({
    required this.accountId,
    required this.fullName,
    required List<String> roles,
  }) : roles = List.unmodifiable(roles);

  final String accountId;
  final String fullName;

  /// Hesabın hedef departman dışındaki rol bağları (sunucu biçimi `"departman:rol"`, olduğu
  /// gibi).
  final List<String> roles;
}

/// Üyelik ya da koordinatörlük ataması sonucu (`Membership`, `CoordinatorResult`).
@immutable
final class Membership {
  const Membership({
    required this.membershipId,
    required this.departmentId,
    required this.accountId,
    required this.role,
    this.changed,
  });

  final String membershipId;
  final String departmentId;
  final String accountId;
  final DepartmentRole role;

  /// Yalnız koordinatör atamasında: rol gerçekten değişti mi (`null` → üyelik ataması).
  final bool? changed;

  @override
  bool operator ==(Object other) =>
      other is Membership &&
      other.membershipId == membershipId &&
      other.departmentId == departmentId &&
      other.accountId == accountId &&
      other.role == role &&
      other.changed == changed;

  @override
  int get hashCode =>
      Object.hash(membershipId, departmentId, accountId, role, changed);
}

/// Rol değişikliği / üye ya da koordinatör çıkarma sonucu (`MembershipChange`).
@immutable
final class MembershipChange {
  const MembershipChange({
    required this.membershipId,
    required this.unassignedTasks,
    required this.warning,
  });

  final String membershipId;

  /// Değişiklik yüzünden ataması kalkan görev sayısı.
  final int unassignedTasks;

  /// Görev etkisi uyarısı.
  final bool warning;

  @override
  bool operator ==(Object other) =>
      other is MembershipChange &&
      other.membershipId == membershipId &&
      other.unassignedTasks == unassignedTasks &&
      other.warning == warning;

  @override
  int get hashCode => Object.hash(membershipId, unassignedTasks, warning);
}

/// Departmanın görev özeti (`GET /v1/departments/{id}/task-summary`).
///
/// Birleştirme notu: `CoordinatorshipReport` (done/total/late/seasonRatio) ile örtüşür ama
/// sunucu gecikme sayısı ve sezon oranı vermez; o tipin zorunlu alanları doldurulamadığı için
/// ayrı tutuldu. [completedItems] ↔ `done`, [activeItems] + [completedItems] ↔ `total`
/// (entegrasyonda karar).
@immutable
final class DepartmentTaskSummary {
  const DepartmentTaskSummary({
    required this.departmentId,
    required this.activeItems,
    required this.completedItems,
  });

  final String departmentId;
  final int activeItems;
  final int completedItems;

  @override
  bool operator ==(Object other) =>
      other is DepartmentTaskSummary &&
      other.departmentId == departmentId &&
      other.activeItems == activeItems &&
      other.completedItems == completedItems;

  @override
  int get hashCode => Object.hash(departmentId, activeItems, completedItems);
}
