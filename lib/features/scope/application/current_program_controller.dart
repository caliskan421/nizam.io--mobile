import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../domain/program.dart';
import 'scope_providers.dart';

part 'current_program_controller.g.dart';

/// Kapsamdaki program (`GET /v1/program`, S2): ana sayfada seçili programın adı BU yanıttan
/// gelir — kapsam başlığının isteğe girdiğinin kanıtı. Seçim yoksa (`null`) istek atılmaz;
/// seçim değişince yeniden okunur. Yeniden yükleme yalnız kullanıcı dokunuşuyla.
@riverpod
class CurrentProgramController extends _$CurrentProgramController {
  @override
  Future<Program?> build() {
    final selection = ref.watch(scopeStateProvider);
    if (!selection.hasProgram) return Future.value();
    return ref.read(scopeServiceProvider).currentProgram();
  }
}
