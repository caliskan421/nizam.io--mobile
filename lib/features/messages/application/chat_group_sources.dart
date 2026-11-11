import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/chat.dart';
import 'messages_providers.dart';

/// Programa bağlı bütün kaynak seçenekleri; yetki yalnız görünürlüğü belirler.
final class ChatGroupSources {
  const ChatGroupSources({
    required this.departments,
    required this.canCreateSource,
    this.truncated = false,
  });

  final List<ChatDepartmentOption> departments;
  final bool canCreateSource;
  final bool truncated;
}

final chatGroupSourcesProvider = FutureProvider.autoDispose<ChatGroupSources>((
  ref,
) async {
  final session = ref.watch(sessionGenerationProvider);
  final program = ref.watch(scopeStateProvider.select((s) => s.programId));
  if (program == null || program.isEmpty) {
    return const ChatGroupSources(departments: [], canCreateSource: false);
  }
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  if (!ref.mounted ||
      ref.read(sessionGenerationProvider) != session ||
      ref.read(scopeStateProvider).programId != program) {
    throw ApiError(ClientErrorCode.sessionEnded);
  }
  final departments = await ref
      .read(chatRepositoryProvider)
      .programDepartments();
  if (!ref.mounted ||
      ref.read(sessionGenerationProvider) != session ||
      ref.read(scopeStateProvider).programId != program) {
    throw ApiError(ClientErrorCode.sessionEnded);
  }
  final access = catalog.access;
  return ChatGroupSources(
    departments: departments.items,
    canCreateSource: access?.canCreateAnyIn(program) == true,
    truncated: departments.truncated,
  );
});
