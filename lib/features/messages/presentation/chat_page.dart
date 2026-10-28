import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

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
  double _headerH = 0;
  double _composerH = 0;
  bool _nearBottom = true;
  bool _typing = false;
  String? _flash;
  int _sentCount = 0;

  /// Gönderilmiş say (prototip: 500 ms), okundu say (1600 ms), yazıyor (3200 ms).
  static const _sentAfter = Duration(milliseconds: 500);
  static const _readAfter = Duration(milliseconds: 1600);
  static const _typingFor = Duration(milliseconds: 3200);
  static const _flashFor = Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    _draft.addListener(_onDraft);
    _attachQuery.addListener(
      () => ref
          .read(chatControllerProvider(widget.id).notifier)
          .setAttachQuery(_attachQuery.text),
    );
    _scroll.addListener(() {
      final near = !_scroll.hasClients || _scroll.offset < 80;
      if (near != _nearBottom) setState(() => _nearBottom = near);
    });
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
        setState(() => _typing = true);
        _after(_typingFor, () => setState(() => _typing = false));
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

  void _onDraft() => setState(() {});

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _draft.dispose();
    _focus.dispose();
    _attachQuery.dispose();
    _scroll.dispose();
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

  void _jumpTo(String id) {
    final ctx = _keys[id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: NzMotion.of(context, NizamioMotion.durSheet),
        curve: NizamioMotion.easeSheet,
      );
    }
    setState(() => _flash = id);
    _after(_flashFor, () => setState(() => _flash = null));
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
    setState(() => _flash = m.id);
    final mine = m.from == catalog.me;
    final a = await showMessageActions(
      context,
      message: m,
      mine: mine,
      pinned: chat.pins.contains(m.id),
      catalog: catalog,
    );
    if (!mounted) return;
    setState(() => _flash = null);
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
            unawaited(showNewTaskSheet(context, coordinatorship: coord));
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
    final view = ref.watch(chatControllerProvider(widget.id));
    final mentions = mentionNames(catalog, inbox.people);
    final sugs = suggestions(_draft.text, catalog, inbox.people);
    final ctxMsg = view.edit != null
        ? chat.message(view.edit!)
        : view.reply != null
        ? chat.message(view.reply!)
        : null;
    final canSend = _draft.text.trim().isNotEmpty || view.refs.isNotEmpty;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final items = timeline(chat);
    final composer = MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: NzComposer(
        controller: _draft,
        focusNode: _focus,
        hint: l.uiMessagesMessageHint,
        canSend: canSend,
        onSend: () => _send(chat, catalog),
        sendLabel: l.uiMessagesSend,
        onAttach: () {
          _attachQuery.clear();
          _view.toggleAttach();
        },
        attachLabel: l.uiMessagesAttach,
        attachOpen: view.attach != null,
        bottomInset: math.max(keyboard, math.max(safeBottom, 12)),
        header: [
          if (sugs.isNotEmpty)
            ChatSuggestions(
              items: sugs,
              onPick: (s) => _draft.value = TextEditingValue(
                text: s.draft,
                selection: TextSelection.collapsed(offset: s.draft.length),
              ),
            ),
          if (view.attach != null)
            ChatAttachPanel(
              view: view,
              catalog: catalog,
              query: _attachQuery,
              onTab: (t) {
                _attachQuery.clear();
                _view.setAttachTab(t);
              },
              onToggle: _view.toggleRef,
              onPhoto: () => _view.addDevice(photo: true),
              onFile: () => _view.addDevice(photo: false),
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
                      onRemove: () => _view.removeRefAt(i),
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
                if (view.edit != null) _draft.clear();
                _view.clearContext();
              },
            ),
        ],
      ),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            controller: _scroll,
            reverse: true,
            padding: EdgeInsets.fromLTRB(
              12,
              _headerH + NizamioSpacing.space2,
              12,
              _composerH + NizamioSpacing.space3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in items) _item(chat, item, catalog, mentions),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ChatMeasure(
            onSize: (s) {
              if (mounted && s.height != _headerH) {
                setState(() => _headerH = s.height);
              }
            },
            child: ChatHeader(
              chat: chat,
              catalog: catalog,
              typing: _typing,
              pinIndex: view.pin,
              onInfo: () => unawaited(_info(chat, catalog)),
              onSearch: () => _toast(l.uiMessagesSearchChatSoon),
              onNextPin: () {
                final pins = chat.pins;
                if (pins.isEmpty) return;
                _view.nextPin();
                _jumpTo(pins[(view.pin + 1) % pins.length]);
              },
            ),
          ),
        ),
        if (!_nearBottom)
          Positioned(
            right: 14,
            bottom: _composerH + 12,
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
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: c.text,
                    ),
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
              if (mounted && s.height != _composerH) {
                setState(() => _composerH = s.height);
              }
            },
            child: composer,
          ),
        ),
      ],
    );
  }

  Widget _item(
    Chat chat,
    ChatItem item,
    TaskCatalog catalog,
    List<String> mentions,
  ) {
    final l = context.l10n;
    final c = context.colors;
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
        final key = _keys.putIfAbsent(m.id, GlobalKey.new);
        final poll = m.poll;
        return Padding(
          key: key,
          padding: EdgeInsets.only(top: first ? 8 : 2),
          child: NzChatBubble(
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
                    onTap: () => _jumpTo(reply.id),
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
                    onVote: (i) => _chats.vote(widget.id, m.id, i),
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
            flash: _flash == m.id,
            reactions: [
              for (final r in ChatReaction.values)
                if ((m.reactions[r] ?? 0) > 0)
                  NzChatReactionChip(
                    kind: nzReaction(r),
                    count: m.reactions[r]!,
                    mine: m.myReaction == r,
                    semanticLabel: l.reaction(r),
                    onTap: () => _chats.react(widget.id, m.id, r),
                  ),
            ],
            showAvatarSlot: chat.group && !mine,
            avatar: NzChatAvatar(
              initials: chatInitials(name),
              tone: personTone(m.from, name),
              extent: 30,
            ),
            longPressLabel: l.uiMessagesMessageActions,
            onLongPress: () => unawaited(_actions(chat, m, catalog)),
          ),
        );
    }
  }
}
