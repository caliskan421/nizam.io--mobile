import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/theme/nz_surfaces.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/chat_controller.dart';
import '../application/chats_controller.dart';
import '../domain/chat.dart';
import '../domain/chat_logic.dart';
import 'chat/chat_parts.dart';
import 'chat/chat_sheets.dart';
import 'chat/messages_texts.dart';

/// Sohbet (prototip `chat`; kabuk dışında, alt menü yok): cam üst çubuk (geri, avatar, ad,
/// üye sayısı / yazıyor…, ara) + sabit mesaj şeridi, gün hapları, okunmamış ayırıcısı,
/// balonlar (gruplanmış köşe, ad + rol, alıntı, satır içi atıflar, anket, tepkiler), "alta in",
/// yazma alanı (öneriler, ek paneli, atıf hapları, yanıt/düzenleme bağlamı). Basılı tutma
/// işlem sayfasını, üst çubuk sohbet bilgisini açar. Gönderilen mesaj bellekte listeye eklenir
/// (tek tik → çift tik → okundu). Yazma alanı klavyeyle yukarı kalkar.
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _draft = TextEditingController();
  final _focus = FocusNode();
  final _attachQuery = TextEditingController();
  final _scroll = ScrollController();
  final _keys = HashMap<String, GlobalKey>();
  final _timers = <Timer>[];
  // Sık değişen görünüm durumu dar dinleyicilere bağlıdır (sayfa kökü yeniden kurulmaz):
  // cam çubuk yükseklikleri, "alta in" düğmesi, yazıyor…, vurgulanan mesaj.
  final _headerH = ValueNotifier<double>(0);
  final _composerH = ValueNotifier<double>(0);
  final _nearBottom = ValueNotifier<bool>(true);
  final _typing = ValueNotifier<bool>(false);
  final _flash = ValueNotifier<String?>(null);

  /// Akıştaki sıra (ters: 0 = en yeni); görünmeyen mesaja atlamak için liste yazar.
  final _order = HashMap<String, int>();
  int _sentCount = 0;

  /// Gönderilmiş say (prototip: 500 ms), okundu say (1600 ms), yazıyor (3200 ms).
  static const _sentAfter = Duration(milliseconds: 500);
  static const _readAfter = Duration(milliseconds: 1600);
  static const _typingFor = Duration(milliseconds: 3200);
  static const _flashFor = Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    _attachQuery.addListener(
      () => ref
          .read(chatControllerProvider(widget.id).notifier)
          .setAttachQuery(_attachQuery.text),
    );
    _scroll.addListener(
      () => _nearBottom.value = !_scroll.hasClients || _scroll.offset < 80,
    );
    unawaited(_open());
  }

  Future<void> _open() async {
    try {
      final inbox = await ref.read(chatsControllerProvider.future);
      if (!mounted) return;
      final chat = inbox.chat(widget.id);
      if (chat == null) return;
      ref.read(chatsControllerProvider.notifier).open(widget.id);
      if (chat.typing != null) {
        _typing.value = true;
        _after(_typingFor, () => _typing.value = false);
      }
    } on Object {
      // Yükleme hatası ekranda NzErrorState ile gösterilir.
    }
  }

  void _after(Duration d, VoidCallback f) => _timers.add(
    Timer(d, () {
      if (mounted) f();
    }),
  );

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _draft.dispose();
    _focus.dispose();
    _attachQuery.dispose();
    _scroll.dispose();
    _headerH.dispose();
    _composerH.dispose();
    _nearBottom.dispose();
    _typing.dispose();
    _flash.dispose();
    super.dispose();
  }

  ChatController get _view =>
      ref.read(chatControllerProvider(widget.id).notifier);
  ChatsController get _chats => ref.read(chatsControllerProvider.notifier);

  void _toast(String m) => NzToast.show(context, m);

  void _toBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: NzMotion.of(context, NizamioMotion.durSheet),
      curve: NizamioMotion.easeSheet,
    );
  }

  /// Mesaja kaydırıp vurgular. Akış tembel kurulduğundan hedef ekran dışındaysa önce sırasına
  /// göre tahmini konuma atlanır (kurulan öğelerle kaydırma boyu netleşir), sonra ortalanır.
  Future<void> _jumpTo(String id) async {
    _flash.value = id;
    _after(_flashFor, () {
      if (_flash.value == id) _flash.value = null;
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

  void _send(Chat chat, TaskCatalog catalog) {
    final text = _draft.text.trim();
    final view = ref.read(chatControllerProvider(widget.id));
    final edit = view.edit;
    if (edit != null) {
      if (text.isEmpty) return;
      _chats.edit(widget.id, edit, text);
      _view.clearContext();
      _draft.clear();
      return;
    }
    if (text.isEmpty && view.refs.isEmpty) return;
    final today = catalog.today;
    _sentCount++;
    final id = _chats.send(
      widget.id,
      from: catalog.me,
      at: DateTime(today.year, today.month, today.day, 10, 14 + _sentCount),
      text: text,
      refs: view.refs,
      replyTo: view.reply,
    );
    _view.sent();
    _attachQuery.clear();
    _draft.clear();
    _toBottom();
    _after(_sentAfter, () => _chats.markSent(widget.id, id));
    _after(_readAfter, () => _chats.markRead(widget.id, id));
  }

  void _openRef(ChatRef r) {
    final nav = context.appNav;
    final l = context.l10n;
    switch (r.kind) {
      case ChatRefKind.task:
        nav.openTask(r.id);
      case ChatRefKind.coordinatorship:
        nav.openCoordinatorship(r.id);
      case ChatRefKind.file:
        nav.openArchiveFolder(r.coordinatorship ?? '');
      case ChatRefKind.photo || ChatRefKind.document:
        _toast('${r.id} ${l.uiMessagesDownloading}');
    }
  }

  Future<void> _actions(Chat chat, ChatMessage m, TaskCatalog catalog) async {
    final l = context.l10n;
    _flash.value = m.id;
    final mine = m.from == catalog.me;
    final a = await showMessageActions(
      context,
      message: m,
      mine: mine,
      pinned: chat.pins.contains(m.id),
      catalog: catalog,
    );
    if (!mounted) return;
    if (_flash.value == m.id) _flash.value = null;
    switch (a) {
      case null:
        return;
      case ChatActReact(:final reaction):
        _chats.react(widget.id, m.id, reaction);
      case ChatActOpenRef(:final ref):
        _openRef(ref);
      case ChatActSimple(:final action):
        switch (action) {
          case ChatSimpleAction.reply:
            _view.reply(m.id);
            _focus.requestFocus();
          case ChatSimpleAction.copy:
            unawaited(Clipboard.setData(ClipboardData(text: m.text)));
            _toast(l.uiMessagesCopied);
          case ChatSimpleAction.pin:
            final pinned = _chats.togglePin(widget.id, m.id);
            _view.resetPin();
            _toast(
              pinned ? l.uiMessagesPinnedToast : l.uiMessagesUnpinnedToast,
            );
          case ChatSimpleAction.edit:
            _view.edit(m.id);
            _draft.text = m.text;
            _focus.requestFocus();
          case ChatSimpleAction.pollResults:
            unawaited(
              showPollResults(
                context,
                chatId: widget.id,
                messageId: m.id,
                onToast: _toast,
              ),
            );
          case ChatSimpleAction.toTask:
            final refs = refsOf(m, catalog);
            final coord =
                refs
                    .where((r) => r.kind == ChatRefKind.coordinatorship)
                    .firstOrNull
                    ?.id ??
                refs
                    .where((r) => r.kind == ChatRefKind.task)
                    .map((r) => catalog.task(r.id)?.coordinatorship)
                    .nonNulls
                    .firstOrNull ??
                refs
                    .where((r) => r.kind == ChatRefKind.file)
                    .firstOrNull
                    ?.coordinatorship;
            // Prototip: mesaj metni (boşluklar tekleşir) başlığı doldurur; hedef sıfırlanır.
            unawaited(
              showNewTaskSheet(
                context,
                coordinatorship: coord,
                resetTarget: true,
                title: m.text.replaceAll(RegExp(r'\s+'), ' '),
              ),
            );
          case ChatSimpleAction.delete:
            _chats.delete(widget.id, m.id);
            _toast(l.uiMessagesDeleted);
        }
    }
  }

  Future<void> _info(Chat chat, TaskCatalog catalog) async {
    final l = context.l10n;
    final a = await showChatInfo(context, chat: chat, catalog: catalog);
    if (!mounted) return;
    switch (a) {
      case null:
        return;
      case ChatInfoSearch():
        _toast(l.uiMessagesSearchChatSoon);
      case ChatInfoMute():
        _chats.mute(widget.id);
        _toast('${chat.name} ${l.uiMessagesMutedTail}');
      case ChatInfoLeave():
        _toast(l.uiMessagesActionSoon);
      case ChatInfoOpenRef(:final ref):
        _openRef(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inbox = ref.watch(chatsControllerProvider);
    final catalog = ref.watch(taskCatalogControllerProvider);
    final error = inbox.error ?? catalog.error;
    final Widget body;
    if (error != null) {
      body = SafeArea(
        child: Center(
          child: NzErrorState(
            error: toApiError(error),
            onRetry: () => ref
              ..invalidate(chatsControllerProvider)
              ..invalidate(taskCatalogControllerProvider),
          ),
        ),
      );
    } else {
      final box = inbox.value;
      final cat = catalog.value;
      final chat = box?.chat(widget.id);
      body = box == null || cat == null
          ? const NzLoader.page()
          : chat == null
          ? SafeArea(
              child: Center(
                child: Text(
                  context.l10n.uiRouterPlaceholder,
                  style: context.text.bodyMd,
                ),
              ),
            )
          : _chatBody(chat, box, cat);
    }
    return NzPage.bare(body: body);
  }

  Widget _chatBody(Chat chat, ChatInbox inbox, TaskCatalog catalog) {
    final l = context.l10n;
    final c = context.colors;
    return Stack(
      children: [
        Positioned.fill(
          child: _MessageList(
            chatId: widget.id,
            catalog: catalog,
            people: inbox.people,
            scroll: _scroll,
            keys: _keys,
            order: _order,
            flash: _flash,
            headerH: _headerH,
            composerH: _composerH,
            onJump: (id) => unawaited(_jumpTo(id)),
            onActions: (chat, m) => unawaited(_actions(chat, m, catalog)),
            onReact: (m, r) => _chats.react(widget.id, m, r),
            onVote: (m, i) => _chats.vote(widget.id, m, i),
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
                return ValueListenableBuilder<bool>(
                  valueListenable: _typing,
                  builder: (context, typing, _) => ChatHeader(
                    chat: chat,
                    catalog: catalog,
                    typing: typing,
                    pinIndex: pin,
                    onInfo: () => unawaited(_info(chat, catalog)),
                    onSearch: () => _toast(l.uiMessagesSearchChatSoon),
                    onNextPin: () {
                      final pins = chat.pins;
                      if (pins.isEmpty) return;
                      _view.nextPin();
                      unawaited(_jumpTo(pins[(pin + 1) % pins.length]));
                    },
                  ),
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
                  child: Icon(Icons.keyboard_arrow_down_rounded, color: c.text),
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
            child: _ComposerArea(
              chat: chat,
              inbox: inbox,
              catalog: catalog,
              draft: _draft,
              focus: _focus,
              attachQuery: _attachQuery,
              onSend: () => _send(chat, catalog),
            ),
          ),
        ),
      ],
    );
  }
}

/// Yazma alanı: taslağı ve yazma durumunu kendisi dinler; tuş vuruşu, öneri, ek paneli ve
/// klavye kalkışı (her kare değişen `viewInsets`) yalnız bu alt ağacı yeniden kurar.
class _ComposerArea extends ConsumerWidget {
  const _ComposerArea({
    required this.chat,
    required this.inbox,
    required this.catalog,
    required this.draft,
    required this.focus,
    required this.attachQuery,
    required this.onSend,
  });

  final Chat chat;
  final ChatInbox inbox;
  final TaskCatalog catalog;
  final TextEditingController draft;
  final FocusNode focus;
  final TextEditingController attachQuery;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final view = ref.watch(chatControllerProvider(chat.id));
    final ctrl = ref.read(chatControllerProvider(chat.id).notifier);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final ctxMsg = view.edit != null
        ? chat.message(view.edit!)
        : view.reply != null
        ? chat.message(view.reply!)
        : null;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: draft,
      builder: (context, value, _) {
        final sugs = suggestions(value.text, catalog, inbox.people);
        final canSend = value.text.trim().isNotEmpty || view.refs.isNotEmpty;
        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: NzComposer(
            controller: draft,
            focusNode: focus,
            hint: l.uiMessagesMessageHint,
            canSend: canSend,
            onSend: onSend,
            sendLabel: l.uiMessagesSend,
            onAttach: () {
              attachQuery.clear();
              ctrl.toggleAttach();
            },
            attachLabel: l.uiMessagesAttach,
            attachOpen: view.attach != null,
            bottomInset: math.max(keyboard, math.max(safeBottom, 12)),
            header: [
              if (sugs.isNotEmpty)
                ChatSuggestions(
                  items: sugs,
                  onPick: (s) => draft.value = TextEditingValue(
                    text: s.draft,
                    selection: TextSelection.collapsed(offset: s.draft.length),
                  ),
                ),
              if (view.attach != null)
                ChatAttachPanel(
                  view: view,
                  catalog: catalog,
                  query: attachQuery,
                  onTab: (t) {
                    attachQuery.clear();
                    ctrl.setAttachTab(t);
                  },
                  onToggle: ctrl.toggleRef,
                  onPhoto: () => ctrl.addDevice(photo: true),
                  onFile: () => ctrl.addDevice(photo: false),
                ),
              if (view.refs.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    spacing: 6,
                    children: [
                      for (var i = 0; i < view.refs.length; i++)
                        NzRefChip(
                          label: refLabel(view.refs[i], catalog),
                          icon: refIcon(view.refs[i].kind),
                          removeLabel: l.uiMessagesRemove,
                          onRemove: () => ctrl.removeRefAt(i),
                        ),
                    ],
                  ),
                ),
              if (ctxMsg != null)
                NzComposerContext(
                  icon: view.edit != null
                      ? Icons.edit_outlined
                      : Icons.reply_rounded,
                  title: view.edit != null
                      ? l.uiMessagesEditMessage
                      : ctxMsg.from == catalog.me
                      ? l.uiMessagesReplySelf
                      : '${catalog.person(ctxMsg.from)?.name ?? ''} ${l.uiMessagesReplyTo}',
                  text: ctxMsg.summary,
                  cancelLabel: l.uiMessagesCancel,
                  onCancel: () {
                    if (view.edit != null) draft.clear();
                    ctrl.clearContext();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Mesaj akışı: ters (0 = en yeni, alta yapışık) tembel liste. Yalnız görünen balonlar
/// kurulur; akış öğeleri sohbet değişince bir kez türetilir; mesaj kimliğiyle anahtarlı
/// öğeler yeni mesaj gelince yer değiştirir (yeniden kurulmaz). Cam çubuk yükseklikleri
/// yalnız dolguyu günceller (liste sliver'ı aynı örnek kalır).
class _MessageList extends ConsumerStatefulWidget {
  const _MessageList({
    required this.chatId,
    required this.catalog,
    required this.people,
    required this.scroll,
    required this.keys,
    required this.order,
    required this.flash,
    required this.headerH,
    required this.composerH,
    required this.onJump,
    required this.onActions,
    required this.onReact,
    required this.onVote,
  });

  final String chatId;
  final TaskCatalog catalog;
  final List<String> people;
  final ScrollController scroll;
  final HashMap<String, GlobalKey> keys;
  final HashMap<String, int> order;
  final ValueListenable<String?> flash;
  final ValueListenable<double> headerH;
  final ValueListenable<double> composerH;
  final ValueChanged<String> onJump;
  final void Function(Chat chat, ChatMessage m) onActions;
  final void Function(String msg, ChatReaction r) onReact;
  final void Function(String msg, int option) onVote;

  @override
  ConsumerState<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<_MessageList> {
  Chat? _chat;
  List<ChatItem> _items = const [];
  List<Key> _itemKeys = const [];
  final _keyIndex = HashMap<Key, int>();
  List<String>? _mentions;

  /// Öğeleri yalnız sohbet nesnesi değişince (yeni mesaj, tepki…) yeniden türetir.
  void _derive(Chat chat) {
    if (identical(chat, _chat)) return;
    _chat = chat;
    _items = timeline(chat).reversed.toList(growable: false);
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
    final chat = ref.watch(
      chatsControllerProvider.select((v) => v.value?.chat(widget.chatId)),
    );
    if (chat == null) return const SizedBox.shrink();
    _derive(chat);
    final mentions = _mentions ??= mentionNames(widget.catalog, widget.people);
    final items = _items;
    final keys = _itemKeys;
    final keyIndex = _keyIndex;
    final list = SliverList.builder(
      itemCount: items.length,
      // Yeni mesaj 0. sıraya girince eski balonlar anahtarıyla yerini bulur.
      findChildIndexCallback: (key) => keyIndex[key],
      itemBuilder: (context, i) => KeyedSubtree(
        key: keys[i],
        child: _item(context, chat, items[i], mentions),
      ),
    );
    return ValueListenableBuilder<double>(
      valueListenable: widget.headerH,
      builder: (context, top, sliver) => ValueListenableBuilder<double>(
        valueListenable: widget.composerH,
        builder: (context, bottom, sliver) => CustomScrollView(
          controller: widget.scroll,
          reverse: true,
          slivers: [
            SliverPadding(
              // SliverPadding kenarları görseldir (ters akışta da üst = üst).
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
        child: sliver,
      ),
      child: list,
    );
  }

  Widget _item(
    BuildContext context,
    Chat chat,
    ChatItem item,
    List<String> mentions,
  ) {
    final l = context.l10n;
    final c = context.colors;
    final catalog = widget.catalog;
    switch (item) {
      case ChatDayItem(:final day):
        return NzChatDayChip(l.dayLabel(day, catalog.today));
      case ChatNewItem():
        return NzChatNewDivider(l.uiMessagesNewMessages);
      case ChatMessageItem(:final message, :final first, :final last):
        final m = message;
        final mine = m.from == catalog.me;
        final person = catalog.person(m.from);
        final name = person?.name ?? m.from;
        final color = personColor(context, catalog, m.from);
        final reply = m.replyTo == null ? null : chat.message(m.replyTo!);
        final poll = m.poll;
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
                m.text,
                ?poll?.question,
                l.time(m.at),
              ].where((s) => s.isNotEmpty).join(', '),
              senderName: chat.group && !mine && first ? name : null,
              senderColor: color,
              senderRole: person == null ? null : l.role(person.role),
              quote: reply == null
                  ? null
                  : NzChatQuote(
                      who: reply.from == catalog.me
                          ? l.uiMessagesYou
                          : catalog.person(reply.from)?.name ?? reply.from,
                      text: reply.summary,
                      color: reply.from == catalog.me
                          ? c.accentText
                          : personColor(context, catalog, reply.from),
                      semanticLabel: l.uiMessagesQuoteJump,
                      onTap: () => widget.onJump(reply.id),
                    ),
              body: ChatMessageBody(
                message: m,
                catalog: catalog,
                mentions: mentions,
                onOpenTask: context.appNav.openTask,
              ),
              extra: poll == null
                  ? null
                  : ChatPollView(
                      poll: poll,
                      onVote: (i) => widget.onVote(m.id, i),
                    ),
              editedLabel: m.edited ? l.uiMessagesEdited : null,
              pinned: chat.pins.contains(m.id),
              time: l.time(m.at),
              tick: !mine
                  ? NzChatTick.none
                  : !m.sent
                  ? NzChatTick.sent
                  : m.read
                  ? NzChatTick.read
                  : NzChatTick.delivered,
              flash: flash,
              reactions: [
                for (final r in ChatReaction.values)
                  if ((m.reactions[r] ?? 0) > 0)
                    NzChatReactionChip(
                      kind: nzReaction(r),
                      count: m.reactions[r]!,
                      mine: m.myReaction == r,
                      semanticLabel: l.reaction(r),
                      onTap: () => widget.onReact(m.id, r),
                    ),
              ],
              showAvatarSlot: chat.group && !mine,
              avatar: NzChatAvatar(
                initials: chatInitials(name),
                tone: personTone(m.from, name),
                extent: 30,
              ),
              longPressLabel: l.uiMessagesMessageActions,
              onLongPress: () => widget.onActions(chat, m),
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
