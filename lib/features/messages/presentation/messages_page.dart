import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/chat_controller.dart';
import '../application/chats_controller.dart';
import '../application/messages_controller.dart';
import '../domain/chat.dart';
import '../domain/chat_logic.dart';
import 'chat/messages_texts.dart';

/// Mesajlar (prototip `messages`): başlık + ara + yeni mesaj, süzgeç hapları (Tümü, Okunmamış
/// N, Gruplar, Kişiler), sohbet satırları → sohbet. Alt menüde modül sekmesine yeniden
/// dokunmak kısayol menüsünü açar ("Tümünü okundu say" gerçekten uygular).
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

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  MessagesController get _ctrl => ref.read(messagesControllerProvider.notifier);

  void _toggleSearch() {
    final opening = !ref.read(messagesControllerProvider).searchOpen;
    _ctrl.toggleSearch();
    if (opening) {
      _focus.requestFocus();
    } else {
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
          icon: Icons.edit_outlined,
          accent: true,
          onSelected: _newChat,
        ),
        NzFlyoutItem(
          label: l.uiMessagesSearch,
          icon: Icons.search_rounded,
          onSelected: _toggleSearch,
        ),
        NzFlyoutItem(
          label: l.uiMessagesUnreadOnly,
          icon: Icons.schedule_rounded,
          onSelected: () => _ctrl.setFilter(ChatFilter.unread),
        ),
        NzFlyoutItem(
          label: l.uiMessagesMarkAllRead,
          icon: Icons.done_rounded,
          onSelected: () {
            ref.read(chatsControllerProvider.notifier).markAllRead();
            _ctrl.setFilter(ChatFilter.all);
          },
        ),
      ],
    );
  }

  /// Yeni mesaj: prototip gibi yer tutucu bildirimi (sohbet oluşturma sonraki adımda).
  void _newChat() => NzToast.show(context, context.l10n.uiMessagesNewChatSoon);

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
    final inbox = ref.watch(chatsControllerProvider);
    final catalog = ref.watch(taskCatalogControllerProvider);
    void retry() => ref
      ..invalidate(chatsControllerProvider)
      ..invalidate(taskCatalogControllerProvider);
    final box = inbox.value;
    final cat = catalog.value;
    return NzPage.feed(
      onRetry: retry,
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiMessagesTitle,
          actions: [
            Semantics(
              selected: view.searchOpen,
              child: NzIconButton.circle(
                icon: Icons.search_rounded,
                semanticLabel: l.uiMessagesSearch,
                onPressed: _toggleSearch,
              ),
            ),
            NzIconButton.circleAccent(
              icon: Icons.edit_outlined,
              semanticLabel: l.uiMessagesNewMessage,
              onPressed: _newChat,
            ),
          ],
        ),
        NzReveal(
          open: view.searchOpen,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space4),
            child: NzSearchField(
              controller: _search,
              focusNode: _focus,
              label: l.uiMessagesSearchHint,
              hint: l.uiMessagesSearchHint,
              onChanged: _ctrl.setQuery,
              onClear: () => _ctrl.setQuery(''),
            ),
          ),
        ),
        Gap(tablet ? _tabletFilterTop : NizamioSpacing.space3),
        if (box == null || cat == null)
          NzAsyncView<ChatInbox>(
            value: inbox,
            onRetry: retry,
            data: (_) => NzAsyncView<TaskCatalog>(
              value: catalog,
              onRetry: retry,
              data: (_) => const SizedBox.shrink(),
            ),
          )
        else
          // Sohbet satırları ayrı akış öğeleridir (tembel kurulum; uzun kutuda yalnız
          // görünenler kurulur).
          ..._list(context, box, cat, view, tablet: tablet),
      ],
    );
  }

  List<Widget> _list(
    BuildContext context,
    ChatInbox inbox,
    TaskCatalog catalog,
    MessagesViewState view, {
    required bool tablet,
  }) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final list = visibleChats(
      inbox.chats,
      filter: view.filter,
      query: view.query,
    );
    final filters = [
      (ChatFilter.all, l.uiMessagesFilterAll, 0),
      (ChatFilter.unread, l.uiMessagesFilterUnread, inbox.unreadChats),
      (ChatFilter.groups, l.uiMessagesFilterGroups, 0),
      (ChatFilter.people, l.uiMessagesFilterPeople, 0),
    ];
    return [
      Semantics(
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
      ),
      Gap(tablet ? _tabletListTop : NizamioSpacing.space2),
      for (final (i, chat) in list.indexed)
        _ChatListRow(
          key: ValueKey(chat.id),
          chat: chat,
          catalog: catalog,
          index: i,
        ),
      if (list.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space8),
          child: Text(
            l.uiMessagesEmpty,
            textAlign: TextAlign.center,
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ),
    ];
  }
}

class _ChatListRow extends ConsumerWidget {
  const _ChatListRow({
    super.key,
    required this.chat,
    required this.catalog,
    required this.index,
  });

  final Chat chat;
  final TaskCatalog catalog;

  /// Görünen (süzülmüş) listedeki sıra: kaynak kişi avatarı rengi `GC[i % 5]`.
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final last = chat.last;
    final mine = last.from == catalog.me;
    final senderName = catalog.person(last.from)?.name ?? '';
    final who = mine
        ? '${l.uiMessagesYou}: '
        : chat.group
        ? '${senderName.split(' ').first}: '
        : '';
    final body = last.text.isNotEmpty
        ? last.text
        : last.poll?.question ?? last.file?.name ?? '';
    final preview = who + body.replaceAll(RegExp(r'\s+'), ' ');
    final row = NzChatRow(
      name: chat.name,
      initials: chatInitials(chat.name),
      group: chat.group,
      tone: index % NzAvatar.toneCount,
      online: chat.online,
      preview: preview,
      time: l.listTime(last.at, catalog.today),
      unread: chat.unread,
      mention: chat.mention,
      muted: chat.muted,
      tick: !mine
          ? NzChatTick.none
          : last.read
          ? NzChatTick.read
          : NzChatTick.delivered,
      semanticHint: chat.unread > 0
          ? '${chat.unread} ${l.uiMessagesUnreadLc}'
          : null,
      onTap: () {
        // Kaynak `S_chat.load`: açık sohbetin satırına yeniden basmak yazma bağlamını da sıfırlar
        // (ekran yeniden kurulsa da aynı aile sağlayıcısı aynı karede dinlendiği için kalırdı).
        final view = chatControllerProvider(chat.id);
        if (ref.exists(view)) ref.read(view.notifier).open();
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
