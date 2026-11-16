import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/effective_role.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import 'scope_providers.dart';

part 'scope_selection_controller.g.dart';

/// Kapsam seçimi eylemleri. Seçimin sonucu durum değildir: `scopeStateProvider` değişir, faz
/// makinesi (`sessionOpen` ↔ `scoped`) ekranı yönlendirir; durum yalnız eylemin hatasıdır.
@riverpod
class ScopeSelectionController extends _$ScopeSelectionController {
  @override
  FutureOr<void> build() {}

  /// [programId] programını seçer (bellekte).
  Future<void> select(String programId) async {
    final service = ref.read(scopeServiceProvider);
    state = await AsyncValue.guard(() async => service.select(programId));
  }

  /// Etkin rolü seçer (kenar çubuğu rol kartı). Yalnız kullanıcının o programda hak ettiği rol
  /// seçilebilir ([EffectiveAccess.grants]); geçersizse seçim değişmez, `false`. Kabuk yeniden
  /// kurulmaz; rol ve koordinatörlüğe bağlı önbellekler sahip değişimiyle düşer.
  bool selectRole(EffectiveRole role) => ref
      .read(scopeControllerProvider)
      .selectRole(role, ref.read(effectiveAccessProvider).grants);

  /// Koordinatörlüğü seçer (etkin rolün satırlarından biri; yöneticide hayır). Geçersizse
  /// `false`.
  bool selectDepartment(String departmentId) => ref
      .read(scopeControllerProvider)
      .selectDepartment(
        departmentId,
        grants: ref.read(effectiveAccessProvider).grants,
      );

  /// Seçimi kaldırır ("kapsamı değiştir").
  Future<void> clear() async {
    final service = ref.read(scopeServiceProvider);
    state = await AsyncValue.guard(() async => service.clearSelection());
  }
}
