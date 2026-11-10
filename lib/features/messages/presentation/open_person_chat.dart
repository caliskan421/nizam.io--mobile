import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../application/chats_controller.dart';
import '../application/messages_providers.dart';

/// Birebir sohbet kimliği yalnız başarılı sunucu yanıtından alınır. Beklerken oturum veya
/// program değişirse yanıt yeni bağlamda gezinme başlatamaz.
Future<void> openPersonChat(BuildContext context, String accountId) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final session = container.read(sessionGenerationProvider);
  final program = container.read(scopeStateProvider).programId;
  try {
    final chat = await container
        .read(chatRepositoryProvider)
        .openDirect(accountId);
    if (!context.mounted ||
        session != container.read(sessionGenerationProvider) ||
        program != container.read(scopeStateProvider).programId) {
      return;
    }
    container.read(chatsControllerProvider.notifier).opened(chat);
    context.appNav.openChat(chat.id);
  } on Object catch (e) {
    if (context.mounted &&
        session == container.read(sessionGenerationProvider) &&
        program == container.read(scopeStateProvider).programId) {
      NzToast.error(context, toApiError(e));
    }
  }
}
