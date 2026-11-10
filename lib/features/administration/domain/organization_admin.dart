import 'package:meta/meta.dart';

import '../../../core/domain/page_slice.dart';
import '../../coordinatorships/coordinatorships.dart' show DepartmentKind;
import '../../scope/scope.dart' show DepartmentRole;

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

enum AccountStatus { active, disabled, unknown }

final class AccountStatusChange {
  const AccountStatusChange({
    required this.status,
    required this.changed,
    required this.revokedSessions,
  });
  final AccountStatus status;
  final bool changed;
  final int revokedSessions;
}

final class UserRoleCounts {
  const UserRoleCounts({
    required this.all,
    required this.admins,
    required this.coordinators,
    required this.members,
  });
  final int all, admins, coordinators, members;
}

final class UserDirectoryPage extends PageSlice<KnownUser> {
  UserDirectoryPage({
    required super.items,
    required this.total,
    required this.roleCounts,
    super.nextCursor,
    super.truncated,
  });
  final int total;
  final UserRoleCounts roleCounts;
}

/// Bilinen kullanıcı (`GET /v1/admin/users`, `KnownUser`).
@immutable
final class KnownUser {
  KnownUser({
    required this.accountId,
    required this.fullName,
    required List<String> memberships,
    List<UserMembership> teams = const [],
    this.email = '',
    this.companyAdmin = false,
    this.accountStatus = AccountStatus.unknown,
    this.loginLocked = false,
  }) : memberships = List.unmodifiable(memberships),
       teams = List.unmodifiable(teams);

  final String accountId;
  final String fullName;
  final String email;
  final bool companyAdmin;
  final AccountStatus accountStatus;
  final bool loginLocked;

  /// Üyelik etiketleri (sunucu biçimi, olduğu gibi).
  final List<String> memberships;
  final List<UserMembership> teams;
}

/// Typed membership label from the pinned `program:department:role` contract.
@immutable
final class UserMembership {
  const UserMembership({
    required this.programId,
    required this.departmentId,
    required this.role,
    this.programName = '',
    this.displayName = '',
  });
  final String programId;
  final String departmentId;
  final DepartmentRole role;
  final String programName;
  final String displayName;
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
