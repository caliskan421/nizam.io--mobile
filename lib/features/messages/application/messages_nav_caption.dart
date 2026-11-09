import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import 'chat_sync_controller.dart';
import 'chats_controller.dart';

part 'messages_nav_caption.g.dart';

/// Alt menüde bu modül etkinken görünen mono alt yazı ("5 okunmamış"); veri yokken null.
@riverpod
String? messagesNavCaption(Ref ref) {
  ref.watch(chatsControllerProvider);
  final inbox = ref.read(chatsControllerProvider.notifier).visible.value;
  if (inbox == null) return null;
  final l = lookupAppLocalizations(ref.watch(localeProvider));
  return '${inbox.unreadChats} ${l.uiMessagesUnreadLc}';
}

/// Tablet rayındaki Mesajlar rozeti: okunmamış ya da anılan sohbet sayısı (prototip
/// `unread || mention`); veri yokken null.
@riverpod
int? messagesNavBadge(Ref ref) {
  ref.watch(chatsControllerProvider);
  return ref.read(chatsControllerProvider.notifier).visible.value?.unreadChats;
}

/// Ön plana dönüşte Mesajlar rozeti: liste hiç okunmadıysa istek yok; mesaj ekranı akışı
/// tutuyorsa ([ChatSyncController] yaşıyor) akışın açılışı listeyi zaten tazeler, ikinci istek
/// yok; değilse tek `listChats` okuması (hata yutulur, önceki sayı görünür).
Future<void> refreshMessagesBadge(ProviderContainer container) async {
  if (!container.exists(chatsControllerProvider) ||
      container.exists(chatSyncControllerProvider)) {
    return;
  }
  await container.read(chatsControllerProvider.notifier).refresh();
}
