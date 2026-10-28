import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
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

class _MessagesPageState extends ConsumerState<MessagesPage> {
  final _search = TextEditingController();
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

  /// Yeni mesaj: kişi seçimi; o kişiyle sohbet varsa açılır, yoksa yer tutucu bildirimi.
  void _newChat() {
    final l = context.l10n;
    final inbox = ref.read(chatsControllerProvider).value;
    final catalog = ref.read(taskCatalogControllerProvider).value;
    if (inbox == null || catalog == null) return;
    final nav = context.appNav;
    void toast(String m) => NzToast.show(context, m);
    NzBottomSheet.show<void>(
      context,
      title: l.uiMessagesNewMessage,
      description: l.uiMessagesNewChatHint,
      builder: (sheet) => NzMenuGroup(
        rows: [
          for (final id in inbox.people)
            if (catalog.person(id) case final p?)
              NzMenuRow(
                icon: Icons.person_outline_rounded,
                label: '${p.name} · ${l.role(p.role)}',
                onTap: () {
                  Navigator.of(sheet).pop();
                  final dm = inbox.chats
                      .where((c) => !c.group && c.person == id)
                      .firstOrNull;
                  if (dm != null) {
                    nav.openChat(dm.id);
                  } else {
                    toast(l.uiMessagesNewChatSoon);
                  }
                },
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != MessagesPage.shellTab || !visible) return;
      _shortcuts();
    });
    final l = context.l10n;
    final view = ref.watch(messagesControllerProvider);
    final inbox = ref.watch(chatsControllerProvider);
    final catalog = ref.watch(taskCatalogControllerProvider);
    void retry() => ref
      ..invalidate(chatsControllerProvider)
      ..invalidate(taskCatalogControllerProvider);
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
        const Gap(NizamioSpacing.space3),
        NzAsyncView<ChatInbox>(
          value: inbox,
          onRetry: retry,
          data: (box) => NzAsyncView<TaskCatalog>(
            value: catalog,
            onRetry: retry,
            data: (cat) => _List(inbox: box, catalog: cat, view: view),
          ),
        ),
      ],
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.inbox, required this.catalog, required this.view});

  final ChatInbox inbox;
  final TaskCatalog catalog;
  final MessagesViewState view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final list = visibleChats(
      inbox.chats,
      filter: view.filter,
      query: view.query,
    );
    final ctrl = ref.read(messagesControllerProvider.notifier);
    final filters = [
      (ChatFilter.all, l.uiMessagesFilterAll, 0),
      (ChatFilter.unread, l.uiMessagesFilterUnread, inbox.unreadChats),
      (ChatFilter.groups, l.uiMessagesFilterGroups, 0),
      (ChatFilter.people, l.uiMessagesFilterPeople, 0),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          label: l.uiMessagesFilters,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 6,
              children: [
                for (final (f, label, n) in filters)
                  _FilterPill(
                    label: label,
                    count: n,
                    selected: view.filter == f,
                    onTap: () => ctrl.setFilter(f),
                  ),
              ],
            ),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        for (final chat in list) _row(context, chat),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space8,
            ),
            child: Text(
              l.uiMessagesEmpty,
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ),
      ],
    );
  }

  Widget _row(BuildContext context, Chat chat) {
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
    final person = chat.person;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: NzChatRow(
        name: chat.name,
        initials: chatInitials(chat.name),
        group: chat.group,
        tone: person == null ? 0 : personTone(person, chat.name),
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
        onTap: () => context.appNav.openChat(chat.id),
      ),
    );
  }
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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
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
