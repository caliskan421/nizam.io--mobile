import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../domain/chat_extras.dart';
import 'chats_controller.dart';
import 'messages_providers.dart';

/// [departmentId] koordinatörlüğünün kendiliğinden kurulan grubunun (`auto_department_id`)
/// KAYNAKLI üyeleri (MESSAGING-K04/K05: kaynak = o koordinatörlüğün güncel ekibi; elle
/// eklenenler düşer). `members` ucu kapalı olan üye görünümünde ekibin salt okunur kaynağıdır.
/// Grup kutuda yoksa (kurulmamış ya da kutu tavanda kesildi) `null`. Oturum ya da kapsam
/// okuma sırasında değişirse `client.scope_changed`.
final departmentGroupTeamProvider = FutureProvider.autoDispose
    .family<ChatMembers?, String>((ref, departmentId) async {
      final session = ref.watch(sessionGenerationProvider);
      final scope = ref.watch(scopeStateProvider);
      bool live() =>
          ref.mounted &&
          ref.read(sessionGenerationProvider) == session &&
          ref.read(scopeStateProvider) == scope;
      final inbox = await ref.watch(chatsControllerProvider.future);
      final chat = inbox.departmentGroup(departmentId);
      if (chat == null) return null;
      final all = await ref.read(chatRepositoryProvider).members(chat.id);
      if (!live()) throw ApiError(ClientErrorCode.scopeChanged);
      return ChatMembers(
        items: [
          for (final m in all.items)
            if (m.fromSource) m,
        ],
        truncated: all.truncated,
      );
    });
