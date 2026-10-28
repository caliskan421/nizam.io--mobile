import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../domain/home_dashboard.dart';
import 'scope_providers.dart';

part 'home_dashboard_controller.g.dart';

/// Ana sayfa özeti. Seçili kapsam değişince yeniden okunur; yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
@riverpod
class HomeDashboardController extends _$HomeDashboardController {
  @override
  Future<HomeDashboard> build() {
    ref.watch(scopeStateProvider);
    return ref.read(homeDashboardRepositoryProvider).load();
  }
}
