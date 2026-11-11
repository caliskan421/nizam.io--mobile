import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_bleed.dart';
import '../../../core/ui/layout/nz_pane.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../application/chat_controller.dart';
import '../application/chat_room_controller.dart';
import '../application/chats_controller.dart';
import '../application/messages_controller.dart';
import '../application/messages_providers.dart';
import '../domain/chat.dart';
import '../domain/chat_logic.dart';
import 'chat/chat_sync_scope.dart';
import 'chat/messages_texts.dart';
import 'chat/new_chat_sheet.dart';

/// Mesajlar (prototip `messages`): başlık + ara + yeni mesaj, süzgeç hapları (Tümü, Okunmamış
/// N, Gruplar, Kişiler), sohbet satırları → sohbet (seçili programın `listChats` sayfaları).
/// Arama bütün sohbet geçmişini sunucuda tarar; haplar yalnız dönen sohbetleri süzer.
/// Alt menüde modül sekmesine yeniden dokunmak kısayol menüsünü açar ("Tümünü okundu say"
/// sunucuda uygular). Yeni mesaj birebir adaylarını ve grup kurmayı açar.
class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 2;

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

/// Tablet kaynak akışı (`flex column; gap 16`, kapalı aramanın `margin-top: -20px`, hap
/// şeridinin `margin-top: -4px`): başlık–süzgeç 8, süzgeç–liste 16 (1180×820'de süzgeç y70,
/// ilk satır y120). Başlık satırı 48'lik dokunma alanıyla kaynağın 44'ünden 4 uzundur; fark
/// ilk boşluktan düşülür.
const double _tabletFilterTop = 8 - (48 - NizamioSize.controlMd);
const double _tabletListTop = NizamioSpacing.space4;

class _MessagesPageState extends ConsumerState<MessagesPage> {
  // Denetleyici durumu sayfadan uzun yaşar (keepAlive): geri dönüşte sorgu kutuda kalır.
  late final _search = TextEditingController(
    text: ref.read(messagesControllerProvider).query,
  );
  final _focus = FocusNode();
  late String _serverQuery;
  Timer? _searchDelay;

  @override
  void initState() {
    super.initState();
    _serverQuery = ref.read(messagesControllerProvider).query.trim();
  }

  void _setQuery(String query) {
    _ctrl.setQuery(query);
    _searchDelay?.cancel();
    final next = query.trim();
    if (next.isEmpty) {
      setState(() => _serverQuery = '');
      return;
    }
    _searchDelay = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _serverQuery = next);
    });
  }

  @override
  void dispose() {
    _searchDelay?.cancel();
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  MessagesController get _ctrl => ref.read(messagesControllerProvider.notifier);

  void _toggleSearch() {
    final opening = !ref.read(messagesControllerProvider).searchOpen;
    _ctrl.toggleSearch();
    // Odak (klavye) açılış hareketi bitince NzReveal.onOpened ile gelir.
    if (!opening) {
      _searchDelay?.cancel();
      _serverQuery = '';
      _search.clear();
      _focus.unfocus();
    }
  }

  void _shortcuts() {
    final l = context.l10n;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiMessagesShortcuts,
      entries: [
        NzFlyoutSection(l.uiMessagesSectionMessages),
        NzFlyoutItem(
          label: l.uiMessagesNewMessage,
          icon: NzIcons.edit,
          accent: true,
          onSelected: _newChat,
        ),
        NzFlyoutItem(
          label: l.uiMessagesSearch,
          icon: NzIcons.search,
          onSelected: _toggleSearch,
        ),
        NzFlyoutItem(
          label: l.uiMessagesUnreadOnly,
          icon: NzIcons.clock,
          onSelected: () => _ctrl.setFilter(ChatFilter.unread),
        ),
        NzFlyoutItem(
          label: l.uiMessagesMarkAllRead,
          icon: NzIcons.check,
          onSelected: _markAllRead,
        ),
      ],
    );
  }

  Future<void> _markAllRead() async {
    _ctrl.setFilter(ChatFilter.all);
    try {
      await ref.read(chatsControllerProvider.notifier).markAllRead();
    } on ApiError catch (e) {
      if (mounted) NzToast.show(context, errorText(context.l10n, e));
    }
  }

  /// Yeni mesaj: aday seçimi ya da grup kurma; açılan sohbete gider.
  Future<void> _newChat() async {
    final id = await showNewChatSheet(context);
    if (id != null && mounted) context.appNav.openChat(id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != MessagesPage.shellTab || !visible) return;
      _shortcuts();
    });
    final l = context.l10n;
    final tablet = NzTabletMetrics.tabletVisualAt(
      MediaQuery.sizeOf(context).width,
    );
    final view = ref.watch(messagesControllerProvider);
    ref.watch(chatsControllerProvider);
    // Başka hesabın/programın sohbetleri görünmez (yükleniyor ya da yalnız hata).
    final searching = view.query.trim().isNotEmpty;
    final search = searching && view.query.trim() == _serverQuery
        ? ref.watch(chatInboxSearchProvider(_serverQuery))
        : const AsyncLoading<ChatInbox>();
    // Sorgu/kapsam değişiminde veya hatada Riverpod'un eski değerini gösterme.
    final inbox = !searching
        ? ref.read(chatsControllerProvider.notifier).visible
        : search.isLoading
        ? const AsyncLoading<ChatInbox>()
        : search.hasError
        ? AsyncError<ChatInbox>(search.error!, search.stackTrace!)
        : search;
    void retry() => searching
        ? ref.invalidate(chatInboxSearchProvider(_serverQuery))
        : ref.invalidate(chatsControllerProvider);
    final box = inbox.value;
    final page = NzPage.feed(
      onRetry: retry,
      onRefresh: () async {
        if (searching) {
          await ref
              .refresh(chatInboxSearchProvider(_serverQuery).future)
              .then<void>((_) {});
        } else {
          await ref.read(chatsControllerProvider.notifier).reload();
        }
      },
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiMessagesTitle,
          actions: [
            Semantics(
              selected: view.searchOpen,
              child: NzIconButton.circle(
                icon: NzIcons.search,
                semanticLabel: l.uiMessagesSearch,
                onPressed: _toggleSearch,
              ),
            ),
            NzIconButton.circleAccent(
              icon: NzIcons.edit,
              semanticLabel: l.uiMessagesNewMessage,
              onPressed: _newChat,
            ),
          ],
        ),
        NzReveal(
          open: view.searchOpen,
          onOpened: _focus.requestFocus,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space4),
            child: NzSearchField(
              controller: _search,
              focusNode: _focus,
              onDismiss: () {
                if (ref.read(messagesControllerProvider).searchOpen &&
                    _search.text.trim().isEmpty) {
                  _toggleSearch();
                }
              },
              label: l.uiMessagesSearchHint,
              hint: l.uiMessagesSearchHint,
              onChanged: _setQuery,
            ),
          ),
        ),
        Gap(tablet ? _tabletFilterTop : NizamioSpacing.space3),
        _filters(context, box?.unreadChats ?? 0, view),
        Gap(tablet ? _tabletListTop : NizamioSpacing.space2),
        if (box == null)
          NzAsyncView<ChatInbox>(
            value: inbox,
            onRetry: retry,
            loading: const NzLoader(),
            data: (_) => const SizedBox.shrink(),
          )
        else
          // Sohbet satırları ayrı akış öğeleridir (tembel kurulum; uzun kutuda yalnız
          // görünenler kurulur).
          ..._list(context, box, view),
      ],
    );
    return ChatSyncScope(child: page);
  }

  List<Widget> _list(
    BuildContext context,
    ChatInbox inbox,
    MessagesViewState view,
  ) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final list = visibleChats(inbox.chats, filter: view.filter);
    return [
      for (final (i, chat) in list.indexed)
        _ChatListRow(key: ValueKey(chat.id), chat: chat, index: i),
      if (list.isEmpty)
        NzEmptyState(
          title: view.query.trim().isEmpty || inbox.chats.isNotEmpty
              ? l.uiMessagesEmpty
              : l.uiMessagesListsSearchEmpty,
        ),
      if (inbox.truncated)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space4),
          child: Text(
            view.query.trim().isEmpty
                ? l.uiMessagesListTruncated
                : l.uiMessagesListsSearchTruncated,
            textAlign: TextAlign.center,
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ),
    ];
  }

  Widget _filters(BuildContext context, int unread, MessagesViewState view) {
    final l = context.l10n;
    final filters = [
      (ChatFilter.all, l.uiMessagesFilterAll, 0),
      (ChatFilter.unread, l.uiMessagesFilterUnread, unread),
      (ChatFilter.groups, l.uiMessagesFilterGroups, 0),
      (ChatFilter.people, l.uiMessagesFilterPeople, 0),
    ];
    return Semantics(
      container: true,
      label: l.uiMessagesFilters,
      // Prototip `.rp-wheel`: haplar kenar boşluğunun dışına taşarak kayar.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          spacing: 6,
          children: [
            for (final (f, label, n) in filters)
              _FilterPill(
                label: label,
                count: n,
                selected: view.filter == f,
                onTap: () => _ctrl.setFilter(f),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChatListRow extends ConsumerWidget {
  const _ChatListRow({super.key, required this.chat, required this.index});

  final Chat chat;

  /// Görünen (süzülmüş) listedeki sıra: kaynak kişi avatarı rengi `GC[i % 5]`.
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final last = chat.last;
    final mine = last != null && last.senderId == ref.watch(chatMeProvider);
    final who = last == null
        ? ''
        : mine
        ? '${l.uiMessagesYou}: '
        : chat.group
        ? '${last.senderName.split(' ').first}: '
        : '';
    final body = last == null
        ? l.uiMessagesNoMessages
        : last.deleted
        ? l.uiMessagesDeletedMessage
        : last.text ?? '';
    final preview = who + body.replaceAll(RegExp(r'\s+'), ' ');
    final row = NzChatRow(
      name: chat.name,
      initials: chatInitials(chat.name),
      group: chat.group,
      tone: index % NzAvatar.toneCount,
      online: chat.peerOnline ?? false,
      preview: preview,
      time: l.listTime(last?.at ?? chat.lastActivity, DateTime.now()),
      unread: chat.unread,
      mention: chat.mention,
      // Listede okundu bilgisi yok (tikler yalnız sohbet geçmişinde, §10.4): sunucuda.
      tick: mine && !last.deleted ? NzChatTick.delivered : NzChatTick.none,
      semanticHint: chat.unread > 0
          ? '${chat.unread} ${l.uiMessagesUnreadLc}'
          : null,
      onTap: () {
        // Kaynak `S_chat.load`: açık sohbetin satırına yeniden basmak yazma bağlamını ve
        // okunmamış ayırıcısını da sıfırlar (aynı aile sağlayıcısı aynı karede dinlenir).
        final view = chatControllerProvider(chat.id);
        if (ref.exists(view)) ref.read(view.notifier).open();
        final room = chatRoomControllerProvider(chat.id);
        if (ref.exists(room)) ref.read(room.notifier).reopen();
        context.appNav.openChat(chat.id);
      },
    );
    if (!NzTabletMetrics.tabletVisualAt(MediaQuery.sizeOf(context).width)) {
      return row;
    }
    // Tablet kaynağı: liste `margin: 0 -8px` (satır dolgusu 8 → avatar içerik kenarında).
    return NzHorizontalBleed(bleed: _rowBleed, child: row);
  }

  static const _rowBleed = 8.0;
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  /// Tablet kaynak hapı: yazı 13/20, sayı rozeti 10.5.
  static const double _pillTextSize = 13;
  static const double _pillLine = 20;
  static const double _countTextSize = 10.5;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final tablet = NzTabletMetrics.tabletVisualAt(
      MediaQuery.sizeOf(context).width,
    );
    return Semantics(
      button: true,
      selected: selected,
      label: count > 0 ? '$label $count' : label,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected ? c.text : c.surfaceRaised,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Container(
            constraints: const BoxConstraints(minHeight: 34),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: t.bodySm.copyWith(
                    color: selected ? c.background : c.textMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    // Tablet kaynağı: `font-size: 13px`, satır 20.
                    fontSize: tablet ? _pillTextSize : null,
                    height: tablet ? _pillLine / _pillTextSize : null,
                  ),
                ),
                if (count > 0) ...[
                  const Gap(6),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? c.primary : c.surfaceOverlay,
                      borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    ),
                    child: Text(
                      '$count',
                      style: t.monoSm.copyWith(
                        color: selected ? c.onPrimary : c.text,
                        fontWeight: FontWeight.w600,
                        fontSize: tablet ? _countTextSize : null,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
