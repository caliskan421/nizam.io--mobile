import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  /// Program yokken statik örnek verilerle kabuğa geçer (örnek kapsam; sunucuya istek yok).
  void selectSample() => ref.read(scopeServiceProvider).selectSample();

  /// Seçimi kaldırır ("kapsamı değiştir").
  Future<void> clear() async {
    final service = ref.read(scopeServiceProvider);
    state = await AsyncValue.guard(() async => service.clearSelection());
  }
}
