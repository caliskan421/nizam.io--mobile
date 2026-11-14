import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/effective_role.dart';
import '../../../core/providers.dart';
import '../../../core/scope/scope_controller.dart';
import '../domain/task_access.dart';
import '../domain/task_catalog.dart';
import '../domain/task_permissions.dart';
import 'task_catalog_controller.dart';

part 'effective_access.g.dart';

/// Etkin görünüm: seçili üçlü (program × rol × koordinatörlük, [ScopeSelection]) ile sunucu
/// erişiminin ([TaskAccess]) birleşimi. Rol ve yetenek kararlarının TEK kaynağı; sayfalar
/// `catalog.access?.companyAdmin` yerine bunu okur.
///
/// Rol ve koordinatörlük seçim geçerliyse seçimdir, değilse [ScopeGrants.resolve] varsayılanı.
/// Bayraklar arayüzü süzer, yetkiyi genişletmez (sunucu her istekte denetler). Erişim
/// bilinmiyorsa ([known] `false`: katalog yüklenmedi ya da program yok) hiçbir yetenek açık
/// değildir (fail-closed); rol yine de seçimden okunur.
@immutable
final class EffectiveAccess {
  const EffectiveAccess._({
    required this.programId,
    required this.role,
    required this.departmentId,
    required this.grants,
    required this.access,
  });

  /// [access] (sunucu, katalogdan) ve [scope] (seçim) birleşimi.
  factory EffectiveAccess.of(TaskAccess? access, ScopeSelection scope) {
    final program = scope.programId;
    final grants = access == null || program == null
        ? ScopeGrants.none
        : access.grantsIn(program);
    final view = access == null || program == null
        ? (role: scope.role ?? EffectiveRole.member, departmentId: null)
        : grants.resolve(scope.role, scope.departmentId);
    return EffectiveAccess._(
      programId: program,
      role: view.role,
      departmentId: view.departmentId,
      grants: grants,
      access: access,
    );
  }

  final String? programId;

  /// Etkin rol.
  final EffectiveRole role;

  /// Etkin koordinatörlük (departman kimliği). Yönetici görünümünde `null` (tüm
  /// koordinatörlükler); Koordinatör/Üye görünümünde rolün seçili ya da ilk satırı.
  final String? departmentId;

  /// Programdaki seçilebilir haklar (seçici listeleri ve `ScopeController` denetimi).
  final ScopeGrants grants;

  /// Sunucu erişimi (ham; yalnız veri yükleme kararları için). Görev başı eylem kararı için
  /// [viewAccess] kullanılır.
  final TaskAccess? access;

  /// Erişim biliniyor mu (katalog yüklü ve program seçili).
  bool get known => access != null && programId != null;

  /// Seçilebilir roller (rol kartı listesi).
  List<EffectiveRole> get roles => grants.roles;

  /// [role] rolünde seçilebilen koordinatörlükler (ad dahil; yöneticide boş).
  List<TeamSeat> departmentsFor(EffectiveRole role) {
    final a = access;
    final p = programId;
    return a == null || p == null ? const [] : a.departmentsFor(p, role);
  }

  /// Etkin koordinatörlüğün adı (yöneticide ya da bilinmiyorsa `null`).
  String? get departmentName {
    for (final s in departmentsFor(role)) {
      if (s.departmentId == departmentId) return s.departmentName;
    }
    return null;
  }

  /// Etkin görünüme izdüşürülmüş erişim ([TaskAccess.viewAs]): `TaskPermissions.of` ve
  /// görev başı kararlar bunu alır; Üye görünümündeki yönetici yönetici eylemi görmez.
  TaskAccess? get viewAccess {
    final a = access;
    final p = programId;
    return a == null || p == null ? null : a.viewAs(p, role);
  }

  // ---- Görünüm --------------------------------------------------------------------------

  bool get isAdminView => known && role == EffectiveRole.admin;
  bool get isCoordinatorView => known && role == EffectiveRole.coordinator;
  bool get isMemberView => known && role == EffectiveRole.member;

  /// Tüm koordinatörlükleri görür (yönetici görünümü); diğerleri [departmentId] gözünden.
  bool get seesAllDepartments => isAdminView;

  // ---- Yetenekler (görünüm düzeyi; görev başı karar `TaskPermissions`) ------------------

  /// Yönetim yüzleri: Kullanıcılar, silinen kayıtlar, raporlar, işlem geçmişi, koordinatörlük
  /// ekle/düzenle, sunucu istatistiği, yönetici kuyrukları (bekleyenler).
  bool get canAdminister => isAdminView;

  /// Ekip yönetimi: üye ekle/davet, ekip yükü (yönetici ya da koordinatör görünümü).
  bool get canManageTeam => isAdminView || isCoordinatorView;

  /// Onaya sunulanı onayla / iade et (koordinatör; birleşik rolde yönetici görünümü de).
  bool get canApprove => isCoordinatorView || (isAdminView && _coordinates);

  /// Görev ata / üstlen (WORK-K10: yalnız kapsam koordinatörü; yönetici tek başına hayır).
  bool get canAssign => isCoordinatorView || (isAdminView && _coordinates);

  /// Yeni görev aç (yönetici ya da koordinatör; üye hayır — WORK-K05).
  bool get canCreateTask => isAdminView || isCoordinatorView;

  /// Tarih talebi aç (yalnız koordinatör).
  bool get canRequestDate => isCoordinatorView || (isAdminView && _coordinates);

  /// Tarih talebini onayla/reddet (yalnız şirket yöneticisi görünümü).
  bool get canReviewDateRequests => isAdminView;

  bool get _coordinates => grants.roles.contains(EffectiveRole.coordinator);

  @override
  bool operator ==(Object other) =>
      other is EffectiveAccess &&
      other.programId == programId &&
      other.role == role &&
      other.departmentId == departmentId &&
      identical(other.access, access);

  @override
  int get hashCode => Object.hash(programId, role, departmentId, access);
}

/// Katalog okuması bitmiş akışlar için (ör. `await taskCatalogControllerProvider.future`
/// sonrası): katalog erişimi + [scope] → etkin görünüm.
extension TaskCatalogView on TaskCatalog {
  EffectiveAccess viewIn(ScopeSelection scope) =>
      EffectiveAccess.of(access, scope);
}

/// Görev başı yetkiler etkin görünümle: `TaskPermissions.of(viewAccess, task)`. Katalog ya da
/// görev yoksa [TaskPermissions.none] (fail-closed). Ayrıntı, zaman çizelgesi ve arşiv
/// önizlemesi bunu kullanır; `TaskPermissions.of(catalog.access, …)` ham erişimdir.
extension TaskCatalogPermissions on TaskCatalog? {
  TaskPermissions permissionsIn(ScopeSelection scope, TaskItem? task) {
    final catalog = this;
    return catalog == null || task == null
        ? const TaskPermissions.none()
        : TaskPermissions.of(catalog.viewIn(scope).viewAccess, task);
  }
}

/// Etkin görünüm (rol, koordinatörlük, yetenek bayrakları). Katalog erişimi ya da seçim
/// değişince yeniden kurulur; görev yazmaları (aynı erişim nesnesi) yeniden kurmaz.
@Riverpod(keepAlive: true)
EffectiveAccess effectiveAccess(Ref ref) => EffectiveAccess.of(
  ref.watch(taskCatalogControllerProvider.select((s) => s.value?.access)),
  ref.watch(scopeStateProvider),
);
