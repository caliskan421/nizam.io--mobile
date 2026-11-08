import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/theme/nz_surfaces.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/chat_controller.dart';
import '../application/chat_room_controller.dart';
import '../application/messages_providers.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
import 'chat/chat_composer.dart';
import 'chat/chat_message_list.dart';
import 'chat/chat_parts.dart';
import 'chat/chat_sheets.dart';
import 'chat/chat_sync_scope.dart';

/// Sohbet (prototip `chat`; kabuk dışında, alt menü yok): cam üst çubuk (geri, avatar, ad,
/// grup / çevrimiçi / yazıyor…, ara) + sabit mesaj şeridi, gün hapları, okunmamış ayırıcısı,
/// balonlar (gruplanmış köşe, ad, alıntı, ekler, anket, tepkiler), "alta in", yazma alanı
/// (yanıt/düzenleme bağlamı). Basılı tutma işlem sayfasını, üst çubuk sohbet bilgisini açar.
/// Gönderilen mesaj hemen "gönderiliyor" görünür; sunucu yanıtıyla ya da akıştan gelen kopyayla
/// tek balon olarak yerleşir. Tepki, sabitleme, anket, ek, mesajdan görev ve grup üyeliği sonraki
/// pakette ("yakında").
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _draft = TextEditingController();
  final _focus = FocusNode();
  final _scroll = ScrollController();
  final _keys = HashMap<String, GlobalKey>();
  // Sık değişen görünüm durumu dar dinleyicilere bağlıdır (sayfa kökü yeniden kurulmaz):
  // cam çubuk yükseklikleri, "alta in" düğmesi, vurgulanan mesaj.
  final _headerH = ValueNotifier<double>(0);
  final _composerH = ValueNotifier<double>(0);
  final _nearBottom = ValueNotifier<bool>(true);
  final _flash = ValueNotifier<String?>(null);
  Timer? _flashTimer;
  var _lastDraft = '';

  /// Akıştaki sıra; görünmeyen mesaja atlamak için liste yazar.
  final _order = HashMap<String, int>();

  static const _flashFor = Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(
      () => _nearBottom.value =
          !_scroll.hasClients || chatAtEnd(_scroll.position),
    );
    _draft.addListener(_onDraft);
  }

  /// Metin değiştikçe "yazıyor" sinyali (denetleyici en az 3 sn aralıkla gönderir).
  void _onDraft() {
    final text = _draft.text;
    if (text == _lastDraft) return;
    _lastDraft = text;
    final view = ref.read(chatControllerProvider(widget.id));
    if (text.trim().isEmpty || view.edit != null) return;
    _room.typing();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    _draft.dispose();
    _focus.dispose();
    _scroll.dispose();
    _headerH.dispose();
    _composerH.dispose();
    _nearBottom.dispose();
    _flash.dispose();
    super.dispose();
  }

  ChatController get _view =>
      ref.read(chatControllerProvider(widget.id).notifier);
  ChatRoomController get _room =>
      ref.read(chatRoomControllerProvider(widget.id).notifier);

  void _toast(String m) => NzToast.show(context, m);

  void _soon() => _toast(context.l10n.uiMessagesActionSoon);

  void _toBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: NzMotion.of(context, NizamioMotion.durSheet),
      curve: NizamioMotion.easeSheet,
    );
  }

  /// Penceredeki mesaja kaydırıp vurgular. Akış tembel kurulduğundan hedef ekran dışındaysa önce
  /// sırasına göre tahmini konuma atlanır, sonra ortalanır. Pencere dışındaki mesaja gidilmez.
  Future<void> _jumpTo(String id) async {
    _flash.value = id;
    _flashTimer?.cancel();
    _flashTimer = Timer(_flashFor, () {
      if (mounted && _flash.value == id) _flash.value = null;
    });
    final index = _order[id];
    for (var i = 0; i < 4 && _keys[id]?.currentContext == null; i++) {
      if (index == null || !_scroll.hasClients) return;
      final pos = _scroll.position;
      final n = _order.length;
      _scroll.jumpTo(
        (pos.maxScrollExtent * index / math.max(1, n - 1)).clamp(
          pos.minScrollExtent,
          pos.maxScrollExtent,
        ),
      );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }
    final ctx = _keys[id]?.currentContext;
    if (ctx == null || !ctx.mounted) return;
    unawaited(
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: NzMotion.of(context, NizamioMotion.durSheet),
        curve: NizamioMotion.easeSheet,
      ),
    );
  }

  Future<void> _send() async {
    final l = context.l10n;
    final text = _draft.text.trim();
    final view = ref.read(chatControllerProvider(widget.id));
    if (text.isEmpty) return;
    final edit = view.edit;
    if (edit != null) {
      try {
        await _room.edit(edit, text);
        if (!mounted) return;
        _view.clearContext();
        _draft.clear();
      } on ApiError catch (e) {
        // Bayat sürümde mesaj yeniden okundu; taslak ve düzenleme bağlamı kalır.
        if (mounted) _toast(errorText(l, e));
      }
      return;
    }
    _view.clearContext();
    _draft.clear();
    _toBottom();
    final outcome = await _room.send(text, replyTo: view.reply);
    if (!mounted) return;
    switch (outcome) {
      case ChatSendOutcome.sent || ChatSendOutcome.failed:
        return;
      case ChatSendOutcome.deleted:
        if (_draft.text.isEmpty) _draft.text = text;
        _toast(l.uiMessagesMessageRestored);
      case ChatSendOutcome.rejected:
        _toast(errorText(l, ApiError('messaging.idempotency_key_reused')));
      case ChatSendOutcome.blocked:
        _toast(l.uiMessagesPeerLeft);
    }
  }

  Future<void> _actions(ChatRoom room, ChatMessage m) async {
    final l = context.l10n;
    if (m.state == ChatSendState.sending) return;
    final me = ref.read(chatMeProvider);
    final mine = m.senderId == me;
    _flash.value = m.id;
    final a = await showMessageActions(
      context,
      message: m,
      canEdit: mine && m.poll == null && m.attachments.isEmpty,
      canDelete: mine || room.chat.canModerate,
      canRetry: m.failure != 'messaging.idempotency_key_reused',
    );
    if (!mounted) return;
    if (_flash.value == m.id) _flash.value = null;
    switch (a) {
      case null:
        return;
      case ChatActReact():
        _soon();
      case ChatActSimple(:final action):
        switch (action) {
          case ChatSimpleAction.reply:
            _view.reply(m.id);
            _focus.requestFocus();
          case ChatSimpleAction.copy:
            unawaited(Clipboard.setData(ClipboardData(text: m.text)));
            _toast(l.uiMessagesCopied);
          case ChatSimpleAction.edit:
            _view.edit(m.id);
            _draft.text = m.text;
            _focus.requestFocus();
          case ChatSimpleAction.pin ||
              ChatSimpleAction.pollResults ||
              ChatSimpleAction.toTask:
            _soon();
          case ChatSimpleAction.delete:
            try {
              await _room.delete(m.id);
              if (mounted) _toast(l.uiMessagesDeleted);
            } on ApiError catch (e) {
              if (mounted) _toast(errorText(l, e));
            }
          case ChatSimpleAction.retry:
            await _room.retry(m.clientId);
          case ChatSimpleAction.discard:
            _room.discard(m.clientId);
        }
    }
  }

  Future<void> _info(ChatRoom room) async {
    final l = context.l10n;
    final a = await showChatInfo(context, room: room);
    if (!mounted) return;
    switch (a) {
      case null:
        return;
      case ChatInfoSearch():
        _toast(l.uiMessagesSearchChatSoon);
      case ChatInfoLeave():
        _soon();
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(chatRoomControllerProvider(widget.id));
    final Widget body;
    if (room.error case final error?) {
      body = SafeArea(
        child: Center(
          child: NzErrorState(
            error: toApiError(error),
            onRetry: () =>
                ref.invalidate(chatRoomControllerProvider(widget.id)),
          ),
        ),
      );
    } else if (room.value case final r?) {
      body = _chatBody(r);
    } else {
      body = const NzLoader.page();
    }
    return ChatSyncScope(child: NzPage.bare(body: body));
  }

  Widget _chatBody(ChatRoom room) {
    final l = context.l10n;
    final c = context.colors;
    final pins = [
      for (final m in room.messages)
        if (m.pinned) m,
    ]..sort((a, b) => b.pinnedAt!.compareTo(a.pinnedAt!));
    return Stack(
      children: [
        Positioned.fill(
          // Akışta cam gün hapları var: giriş yalnız yükselir.
          child: PageContentEntrance(
            fade: false,
            child: ChatMessageList(
              chatId: widget.id,
              scroll: _scroll,
              keys: _keys,
              order: _order,
              flash: _flash,
              headerH: _headerH,
              composerH: _composerH,
              onJump: (id) => unawaited(_jumpTo(id)),
              onActions: (room, m) => unawaited(_actions(room, m)),
              onSoon: _soon,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ChatMeasure(
            onSize: (s) {
              if (mounted) _headerH.value = s.height;
            },
            child: Consumer(
              builder: (context, ref, _) {
                final pin = ref.watch(
                  chatControllerProvider(widget.id).select((v) => v.pin),
                );
                return ChatHeader(
                  room: room,
                  pins: pins,
                  pinIndex: pin,
                  onInfo: () => unawaited(_info(room)),
                  onSearch: () => _toast(l.uiMessagesSearchChatSoon),
                  onNextPin: () {
                    if (pins.isEmpty) return;
                    _view.nextPin();
                    unawaited(_jumpTo(pins[(pin + 1) % pins.length].id));
                  },
                );
              },
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _nearBottom,
          builder: (context, near, child) => near
              // Yığın boyunu belirlememesi için konumlu boş öğe.
              ? const Positioned(right: 0, bottom: 0, child: SizedBox.shrink())
              : ValueListenableBuilder<double>(
                  valueListenable: _composerH,
                  builder: (context, h, child) =>
                      Positioned(right: 14, bottom: h + 12, child: child!),
                  child: child,
                ),
          child: Semantics(
            button: true,
            label: l.uiMessagesToBottom,
            excludeSemantics: true,
            onTap: _toBottom,
            child: GestureDetector(
              onTap: _toBottom,
              child: NzGlass.circle(
                tone: NzGlassTone.float,
                child: SizedBox.square(
                  dimension: NizamioSize.glassButton,
                  child: NzIcon(NzIcons.chevronDown, color: c.text),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ChatMeasure(
            onSize: (s) {
              if (mounted) _composerH.value = s.height;
            },
            child: ChatComposerArea(
              room: room,
              draft: _draft,
              focus: _focus,
              onSend: () => unawaited(_send()),
              onAttach: _soon,
            ),
          ),
        ),
      ],
    );
  }
}
