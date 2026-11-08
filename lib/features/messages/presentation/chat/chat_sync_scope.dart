import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/chat_sync_controller.dart';
import '../../application/messages_providers.dart';

/// Mesaj ekranlarının anlık akış kapsamı: ekran görünürken (kabuğun gizli sekmesinde
/// `TickerMode` kapalıdır) akış denetleyicisini dinler; dinleyen kalmayınca akış kapanır.
/// Uygulama arka plana geçince ön plan bayrağı düşer ve akış kapanır, dönünce yeniden açılır.
class ChatSyncScope extends ConsumerStatefulWidget {
  const ChatSyncScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ChatSyncScope> createState() => _ChatSyncScopeState();
}

class _ChatSyncScopeState extends ConsumerState<ChatSyncScope> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: _onState);
  }

  void _onState(AppLifecycleState s) => ref
      .read(chatForegroundProvider.notifier)
      .set(s == AppLifecycleState.resumed || s == AppLifecycleState.inactive);

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TickerMode.valuesOf(context).enabled) {
      ref.watch(chatSyncControllerProvider);
    }
    return widget.child;
  }
}
