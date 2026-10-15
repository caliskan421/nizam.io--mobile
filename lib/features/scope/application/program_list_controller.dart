import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../domain/program.dart';
import 'scope_providers.dart';

part 'program_list_controller.g.dart';

/// Program seçim ekranının listesi (`GET /v1/programs`, düz liste + `truncated`). Hata
/// [ApiError]'dır (`program.not_authorized` dahil); yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
@riverpod
class ProgramListController extends _$ProgramListController {
  @override
  Future<PageSlice<Program>> build() =>
      ref.read(scopeServiceProvider).programs();
}
