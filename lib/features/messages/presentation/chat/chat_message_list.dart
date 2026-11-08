import 'dart:collection';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/chat_room_controller.dart';
import '../../application/messages_providers.dart';
import '../../domain/chat.dart';
import '../../domain/chat_logic.dart';
import '../../domain/chat_room.dart';
import 'chat_parts.dart';
import 'messages_texts.dart';

/// Mesaj akışı: yukarıdan aşağı (kısa sohbet üstte, uzun sohbet en altta açılır) tembel liste.
/// Yalnız görünen balonlar kurulur; akış öğeleri pencere değişince bir kez türetilir; mesaj
/// kimliğiyle anahtarlı öğeler yeni mesaj gelince yer değiştirir. Pencerenin altında daha eski
/// mesaj varsa başta "Önceki mesajlar" düğmesi (`before` sayfası; görünen konum korunur).
class ChatMessageList extends ConsumerStatefulWidget {
  const ChatMessageList({
    super.key,
    required this.chatId,
    required this.scroll,
    required this.keys,
    required this.order,
    required this.flash,
    required this.headerH,
    required this.composerH,
    required this.onJump,
    required this.onActions,
    required this.onSoon,
  });

  final String chatId;
  final ScrollController scroll;
  final HashMap<String, GlobalKey> keys;
  final HashMap<String, int> order;
  final ValueListenable<String?> flash;
  final ValueListenable<double> headerH;
  final ValueListenable<double> composerH;
  final ValueChanged<String> onJump;
  final void Function(ChatRoom room, ChatMessage m) onActions;

  /// Sonraki pakette bağlanacak eylem (tepki, oy, ek indirme): "yakında" bildirimi.
  final VoidCallback onSoon;

  @override
  ConsumerState<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends ConsumerState<ChatMessageList> {
  /// Akış en altta mı (kullanıcı kaydırmasıyla güncellenir). Yapışıkken içerik, klavye ya da
  /// pencere ölçüsü değişince en alta dönülür; açılışta da en alttan başlanır.
  var _pinned = true;
  var _sticking = false;
  var _loadingOlder = false;

  bool _onScroll(ScrollNotification n) {
    if (n is ScrollUpdateNotification && n.depth == 0) {
      _pinned = chatAtEnd(n.metrics);
    }
    return false;
  }

  bool _onMetrics(ScrollMetricsNotification n) {
    if (_pinned && !_atEndExact(n.metrics)) _stick();
    return false;
  }

  /// Tembel listede uzunluk kuruldukça kesinleşir; birkaç karede en alta yerleşilir.
  void _stick([int tries = 6]) {
    if (_sticking) return;
    _sticking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sticking = false;
      if (!mounted || !widget.scroll.hasClients || !_pinned) return;
      final p = widget.scroll.position;
      if (_atEndExact(p)) return;
      p.jumpTo(p.maxScrollExtent);
      if (tries > 1) _stick(tries - 1);
    });
  }

  /// Eski sayfayı yükler; görünen mesaj yerinde kalsın diye alttan uzaklık korunur.
  Future<void> _older() async {
    if (_loadingOlder) return;
    setState(() => _loadingOlder = true);
    final s = widget.scroll;
    final fromBottom = s.hasClients
        ? s.position.maxScrollExtent - s.position.pixels
        : 0.0;
    await ref
        .read(chatRoomControllerProvider(widget.chatId).notifier)
        .loadOlder();
    if (!mounted) return;
    setState(() => _loadingOlder = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !s.hasClients) return;
      final p = s.position;
      p.jumpTo(
        (p.maxScrollExtent - fromBottom).clamp(
          p.minScrollExtent,
          p.maxScrollExtent,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _stick();
  }

  List<ChatMessage>? _source;
  String? _marker;
  List<ChatItem> _items = const [];
  List<Key> _itemKeys = const [];
  final _keyIndex = HashMap<Key, int>();

  /// Öğeleri yalnız pencere ya da ayırıcı değişince yeniden türetir.
  void _derive(ChatRoom room) {
    if (identical(room.messages, _source) && room.unreadMarker == _marker) {
      return;
    }
    _source = room.messages;
    _marker = room.unreadMarker;
    _items = timeline(
      room.messages,
      unreadMarker: room.unreadMarker,
    ).toList(growable: false);
    _itemKeys = [for (final x in _items) _keyOf(x)];
    _keyIndex.clear();
    widget.order.clear();
    for (var i = 0; i < _items.length; i++) {
      _keyIndex[_itemKeys[i]] = i;
      if (_items[i] case ChatMessageItem(:final message)) {
        widget.order[message.id] = i;
      }
    }
  }

  Key _keyOf(ChatItem item) => switch (item) {
    ChatDayItem(:final day) => ValueKey('day-${day.toIso8601String()}'),
    ChatNewItem() => const ValueKey('new'),
    ChatMessageItem(:final message) => widget.keys.putIfAbsent(
      message.id,
      GlobalKey.new,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(
      chatRoomControllerProvider(widget.chatId).select((v) => v.value),
    );
    if (room == null) return const SizedBox.shrink();
    final me = ref.watch(chatMeProvider);
    _derive(room);
    final items = _items;
    final keys = _itemKeys;
    final keyIndex = _keyIndex;
    final older = room.hasOlder ? 1 : 0;
    final list = SliverList.builder(
      itemCount: items.length + older,
      // Liste değişince (yeni mesaj, ayırıcı) eski balonlar anahtarıyla yerini bulur.
      findChildIndexCallback: (key) {
        final i = keyIndex[key];
        return i == null ? null : i + older;
      },
      itemBuilder: (context, i) {
        if (i < older) {
          return Center(
            child: NzButton.secondary(
              label: context.l10n.uiMessagesOlderMessages,
              onPressed: _loadingOlder ? null : _older,
            ),
          );
        }
        return KeyedSubtree(
          key: keys[i - older],
          child: _item(context, room, items[i - older], me),
        );
      },
    );
    return ValueListenableBuilder<double>(
      valueListenable: widget.headerH,
      builder: (context, top, sliver) => ValueListenableBuilder<double>(
        valueListenable: widget.composerH,
        builder: (context, bottom, sliver) =>
            NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: NotificationListener<ScrollMetricsNotification>(
                onNotification: _onMetrics,
                child: CustomScrollView(
                  controller: widget.scroll,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        12,
                        top + NizamioSpacing.space2,
                        12,
                        bottom + NizamioSpacing.space3,
                      ),
                      sliver: sliver,
                    ),
                  ],
                ),
              ),
            ),
        child: sliver,
      ),
      child: list,
    );
  }

  Widget _item(BuildContext context, ChatRoom room, ChatItem item, String? me) {
    final l = context.l10n;
    final c = context.colors;
    final chat = room.chat;
    switch (item) {
      case ChatDayItem(:final day):
        return NzChatDayChip(l.dayLabel(day, DateTime.now()));
      case ChatNewItem():
        return NzChatNewDivider(l.uiMessagesNewMessages);
      case ChatMessageItem(:final message, :final first, :final last):
        final m = message;
        final mine = m.senderId == me;
        final name = m.senderName ?? (chat.group ? '' : chat.name);
        final quote = m.replyTo;
        final quoteMine = quote?.senderId == me;
        final quoteName = quote?.senderName ?? '';
        final tick = tickOf(m, me: me, room: room);
        return Padding(
          padding: EdgeInsets.only(top: first ? 8 : 2),
          child: _Flash(
            id: m.id,
            flash: widget.flash,
            builder: (flash) => NzChatBubble(
              mine: mine,
              last: last,
              semanticLabel: [
                if (mine) l.uiMessagesYou else name,
                l.summaryOf(m),
                l.time(m.at),
                if (tick == ChatTick.failed) l.uiMessagesSendFailed,
              ].where((s) => s.isNotEmpty).join(', '),
              senderName: chat.group && !mine && first ? name : null,
              senderColor: personColor(context, name),
              quote: quote == null
                  ? null
                  : NzChatQuote(
                      who: quoteMine ? l.uiMessagesYou : quoteName,
                      text: quote.deleted
                          ? l.uiMessagesDeletedMessage
                          : quote.text ??
                                room.message(quote.messageId)?.text ??
                                '',
                      color: quoteMine
                          ? c.accentText
                          : personColor(context, quoteName),
                      semanticLabel: l.uiMessagesQuoteJump,
                      onTap: () => widget.onJump(quote.messageId),
                    ),
              body: ChatMessageBody(
                message: m,
                onAttachment: (_) => widget.onSoon(),
              ),
              extra: m.poll == null
                  ? null
                  : ChatPollView(
                      question: m.text,
                      poll: m.poll!,
                      me: me,
                      onVote: (_) => widget.onSoon(),
                    ),
              editedLabel: tick == ChatTick.failed
                  ? l.uiMessagesSendFailed
                  : m.edited
                  ? l.uiMessagesEdited
                  : null,
              pinned: m.pinned,
              time: l.time(m.at),
              tick: switch (tick) {
                ChatTick.none || ChatTick.failed => NzChatTick.none,
                ChatTick.sending => NzChatTick.sent,
                ChatTick.sent => NzChatTick.delivered,
                ChatTick.read => NzChatTick.read,
              },
              flash: flash,
              reactions: [
                for (final r in m.reactions)
                  if (r.count > 0)
                    NzChatReactionChip(
                      kind: nzReaction(r.kind),
                      count: r.count,
                      mine: r.mine,
                      semanticLabel: l.reaction(r.kind),
                      onTap: widget.onSoon,
                    ),
              ],
              showAvatarSlot: chat.group && !mine,
              avatar: NzChatAvatar(
                initials: chatInitials(name),
                tone: personTone(name),
                extent: 30,
              ),
              longPressLabel: l.uiMessagesMessageActions,
              onLongPress: () => widget.onActions(room, m),
            ),
          ),
        );
    }
  }
}

/// Vurgu dinleyicisi: yalnız kendi mesajının vurgusu değişince yeniden kurulur.
class _Flash extends StatefulWidget {
  const _Flash({required this.id, required this.flash, required this.builder});

  final String id;
  final ValueListenable<String?> flash;
  final Widget Function(bool flash) builder;

  @override
  State<_Flash> createState() => _FlashState();
}

class _FlashState extends State<_Flash> {
  late bool _on = widget.flash.value == widget.id;

  @override
  void initState() {
    super.initState();
    widget.flash.addListener(_changed);
  }

  @override
  void didUpdateWidget(_Flash old) {
    super.didUpdateWidget(old);
    if (old.flash != widget.flash) {
      old.flash.removeListener(_changed);
      widget.flash.addListener(_changed);
    }
    _on = widget.flash.value == widget.id;
  }

  @override
  void dispose() {
    widget.flash.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    final on = widget.flash.value == widget.id;
    if (on != _on) setState(() => _on = on);
  }

  @override
  Widget build(BuildContext context) => widget.builder(_on);
}

/// En alta 80 px'ten yakın ("alta in" düğmesi gizli, yeni içerikte en altta kalınır).
bool chatAtEnd(ScrollMetrics m) => m.maxScrollExtent - m.pixels < 80;

bool _atEndExact(ScrollMetrics m) => m.maxScrollExtent - m.pixels < 0.5;
