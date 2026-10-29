import 'package:meta/meta.dart';

import '../../coordinatorships/coordinatorships.dart' show DepartmentKind;

/// Yönetim kullanıcı listesinin sıralama alanı (`sort_by`). Sözleşmede serbest dizgedir;
/// kapalı küme backend'dedir (`name`, `created_at`; tanımsız değer 422).
enum UserSortField {
  name('name'),
  createdAt('created_at');

  const UserSortField(this.wire);

  final String wire;
}

/// Sıralama yönü (`sort_order`: `asc` / `desc`).
enum SortDirection { asc, desc }

/// Silinmiş varlığın yaşam döngüsü işlemi sonucu (`restored` / `purged`).
enum LifecycleStatus { restored, purged, unknown }

/// Bilinen kullanıcı (`GET /v1/admin/users`, `KnownUser`).
@immutable
final class KnownUser {
  KnownUser({
    required this.accountId,
    required this.fullName,
    required List<String> memberships,
  }) : memberships = List.unmodifiable(memberships);

  final String accountId;
  final String fullName;

  /// Üyelik etiketleri (sunucu biçimi, olduğu gibi).
  final List<String> memberships;
}

/// Kullanıcı oluşturma/güncelleme/silme sonucu (`UserResult`).
@immutable
final class UserChange {
  UserChange({
    required this.accountId,
    this.membershipId,
    this.created = false,
    this.transferred = false,
    List<String> changedFields = const [],
    this.revokedSessions = 0,
  }) : changedFields = List.unmodifiable(changedFields);

  final String accountId;
  final String? membershipId;

  /// Yeni hesap açıldı mı (yanıtta yoksa `false`).
  final bool created;

  /// Var olan hesap departmana aktarıldı mı (yanıtta yoksa `false`).
  final bool transferred;
  final List<String> changedFields;

  /// Düşürülen oturum sayısı (yanıtta yoksa 0).
  final int revokedSessions;
}

/// Yönetici hesap işlemi sonucu (`AccountResult`). Parolalar hiçbir sonuçta taşınmaz.
@immutable
final class AccountChange {
  const AccountChange({required this.accountId, this.revokedSessions = 0});

  final String accountId;

  /// Düşürülen oturum sayısı; sıfırsa sunucu alanı göndermez → 0.
  final int revokedSessions;

  @override
  bool operator ==(Object other) =>
      other is AccountChange &&
      other.accountId == accountId &&
      other.revokedSessions == revokedSessions;

  @override
  int get hashCode => Object.hash(accountId, revokedSessions);
}

/// Giriş kilitlerinin toplu sıfırlanması sonucu (`LockoutResetResult`).
@immutable
final class LockoutReset {
  const LockoutReset({
    required this.accountsReset,
    required this.attemptsCleared,
  });

  final int accountsReset;
  final int attemptsCleared;

  @override
  bool operator ==(Object other) =>
      other is LockoutReset &&
      other.accountsReset == accountsReset &&
      other.attemptsCleared == attemptsCleared;

  @override
  int get hashCode => Object.hash(accountsReset, attemptsCleared);
}

/// Silinmiş hesap (`DeletedAccount`).
@immutable
final class DeletedAccount {
  const DeletedAccount({required this.accountId, required this.fullName});

  final String accountId;
  final String fullName;

  @override
  bool operator ==(Object other) =>
      other is DeletedAccount &&
      other.accountId == accountId &&
      other.fullName == fullName;

  @override
  int get hashCode => Object.hash(accountId, fullName);
}

/// Silinmiş departman (`DeletedDepartment`).
@immutable
final class DeletedDepartment {
  const DeletedDepartment({
    required this.departmentId,
    required this.name,
    required this.kind,
    this.deletedAt,
    this.code,
  });

  final String departmentId;
  final String name;
  final DepartmentKind kind;

  /// Silinme anı (UTC). Sunucu okuyamadığında boş dizge gönderir → `null`.
  final DateTime? deletedAt;
  final String? code;

  @override
  bool operator ==(Object other) =>
      other is DeletedDepartment &&
      other.departmentId == departmentId &&
      other.name == name &&
      other.kind == kind &&
      other.deletedAt == deletedAt &&
      other.code == code;

  @override
  int get hashCode => Object.hash(departmentId, name, kind, deletedAt, code);
}
