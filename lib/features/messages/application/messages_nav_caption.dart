import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import 'chats_controller.dart';

part 'messages_nav_caption.g.dart';

/// Alt menüde bu modül etkinken görünen mono alt yazı ("5 okunmamış"); veri yokken null.
@riverpod
String? messagesNavCaption(Ref ref) {
  final inbox = ref.watch(chatsControllerProvider).value;
  if (inbox == null) return null;
  final l = lookupAppLocalizations(ref.watch(localeProvider));
  return '${inbox.unreadChats} ${l.uiMessagesUnreadLc}';
}

/// Tablet rayındaki Mesajlar rozeti: okunmamış ya da anılan sohbet sayısı (prototip
/// `unread || mention`); veri yokken null.
@riverpod
int? messagesNavBadge(Ref ref) =>
    ref.watch(chatsControllerProvider).value?.unreadChats;
