import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/chats_controller.dart';
import '../../domain/chat.dart';
import '../../domain/chat_logic.dart';
import 'messages_texts.dart';

/// Mesaj işlemleri sayfasının sonucu (sayfa kapandıktan sonra ekran uygular).
sealed class ChatAction {
  const ChatAction();
}

final class ChatActReact extends ChatAction {
  const ChatActReact(this.reaction);
  final ChatReaction reaction;
}

final class ChatActOpenRef extends ChatAction {
  const ChatActOpenRef(this.ref);
  final ChatRef ref;
}

enum ChatSimpleAction { reply, copy, pin, edit, pollResults, toTask, delete }

final class ChatActSimple extends ChatAction {
  const ChatActSimple(this.action);
  final ChatSimpleAction action;
}

/// Mesaja basılı tutunca açılan işlem sayfası (tasarım sistemi `components/ActionSheet`):
/// tepki çubuğu (mesaj başına bir seçim), atıf hapları, hızlı ızgara (Yanıtla, Kopyala,
/// Sabitle, kendi mesajında Düzenle), liste (anket sonuçları, göreve dönüştür, kendi
/// mesajında Sil — `danger`). Seçim sonuç olarak döner.
Future<ChatAction?> showMessageActions(
  BuildContext context, {
  required ChatMessage message,
  required bool mine,
  required bool pinned,
  required TaskCatalog catalog,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<ChatAction>(
    context,
    title: l.uiMessagesMessageActions,
    showHeader: false,
    builder: (sheet) {
      final c = sheet.colors;
      final t = sheet.text;
      void done(ChatAction a) => Navigator.of(sheet).pop(a);
      final refs = refsOf(message, catalog);
      final ownText = mine && message.poll == null;
      Widget quick(IconData icon, String label, ChatSimpleAction a) => Expanded(
        child: Material(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: InkWell(
            onTap: () => done(ChatActSimple(a)),
            borderRadius: BorderRadius.circular(NizamioRadius.group),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
              child: Column(
                children: [
                  NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.text),
                  const Gap(6),
                  Text(label, textAlign: TextAlign.center, style: t.caption),
                ],
              ),
            ),
          ),
        ),
      );
      final listRows = <(IconData, String, ChatSimpleAction, Color)>[
        if (message.poll != null)
          (
            NzIcons.barChart,
            l.uiMessagesPollResults,
            ChatSimpleAction.pollResults,
            c.accentText,
          ),
        if (message.poll == null)
          (
            NzIcons.add,
            l.uiMessagesToTask,
            ChatSimpleAction.toTask,
            c.accentText,
          ),
        if (ownText)
          (
            NzIcons.delete,
            l.uiMessagesDelete,
            ChatSimpleAction.delete,
            c.danger,
          ),
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.gapMd,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.pill),
            ),
            child: Row(
              spacing: NizamioSpacing.space2,
              children: [
                for (final r in ChatReaction.values)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: message.myReaction == r,
                      label: l.reaction(r),
                      excludeSemantics: true,
                      onTap: () => done(ChatActReact(r)),
                      child: Material(
                        color: message.myReaction == r
                            ? c.primary.withValues(alpha: 0.2)
                            : c.surfaceRaised,
                        shape: const StadiumBorder(),
                        child: InkWell(
                          customBorder: const StadiumBorder(),
                          onTap: () => done(ChatActReact(r)),
                          child: SizedBox(
                            height: NizamioSize.tap,
                            child: NzIcon(
                              nzReaction(r)
                                  .icon(selected: message.myReaction == r),
                              size: 22,
                              color: message.myReaction == r
                                  ? c.accentText
                                  : c.text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (refs.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 6,
                children: [
                  for (final r in refs)
                    ActionChip(
                      onPressed: () => done(ChatActOpenRef(r)),
                      avatar: NzIcon(
                        r.kind == ChatRefKind.photo ||
                                r.kind == ChatRefKind.document
                            ? NzIcons.download
                            : refIcon(r.kind),
                        size: 14,
                        color: c.accentText,
                      ),
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          refLabel(
                            r,
                            catalog,
                          ).replaceFirst(RegExp(' · .*'), ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySm,
                        ),
                      ),
                      backgroundColor: c.surfaceRaised,
                      side: BorderSide(color: c.border),
                      shape: const StadiumBorder(),
                    ),
                ],
              ),
            ),
          Row(
            spacing: NizamioSpacing.space2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              quick(NzIcons.reply, l.uiMessagesReply, ChatSimpleAction.reply),
              quick(NzIcons.copy, l.uiMessagesCopy, ChatSimpleAction.copy),
              quick(
                NzIcons.pin,
                pinned ? l.uiMessagesUnpin : l.uiMessagesPin,
                ChatSimpleAction.pin,
              ),
              if (ownText)
                quick(NzIcons.edit, l.uiMessagesEdit, ChatSimpleAction.edit),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.row),
            child: ColoredBox(
              color: c.surfaceRaised,
              child: Column(
                children: [
                  for (var i = 0; i < listRows.length; i++)
                    InkWell(
                      onTap: () => done(ChatActSimple(listRows[i].$3)),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          border: i > 0
                              ? Border(top: BorderSide(color: c.border))
                              : null,
                        ),
                        child: Row(
                          children: [
                            NzIcon(
                              listRows[i].$1,
                              size: NizamioSize.iconSizeSm,
                              color: listRows[i].$4,
                            ),
                            const Gap(NizamioSpacing.space3),
                            Expanded(
                              child: Text(
                                listRows[i].$2,
                                style: t.list.copyWith(
                                  color: listRows[i].$4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Anket sonuçları: soru, seçenek kartları (oy · %, çubuk, oy verenler), henüz oy vermeyenler,
/// Hatırlat / Anketi bitir.
Future<void> showPollResults(
  BuildContext context, {
  required String chatId,
  required String messageId,
  required ValueChanged<String> onToast,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiMessagesPollResults,
    showHeader: false,
    builder: (_) =>
        _PollResults(chatId: chatId, messageId: messageId, onToast: onToast),
  );
}

class _PollResults extends ConsumerWidget {
  const _PollResults({
    required this.chatId,
    required this.messageId,
    required this.onToast,
  });

  final String chatId;
  final String messageId;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final inbox = ref.watch(chatsControllerProvider).value;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final chat = inbox?.chat(chatId);
    final poll = chat?.message(messageId)?.poll;
    if (inbox == null || catalog == null || chat == null || poll == null) {
      return const SizedBox.shrink();
    }
    final pool = inbox.people;
    final me = catalog.person(catalog.me)?.name ?? '';
    final top = poll.options
        .map((o) => o.votes)
        .fold(0, (a, b) => a > b ? a : b);
    var pi = 0;
    final used = <String>{};
    final voterRows = [
      for (var i = 0; i < poll.options.length; i++)
        () {
          final mineHere = poll.mine.contains(i);
          final others = (poll.options[i].votes - (mineHere ? 1 : 0)).clamp(
            0,
            1 << 20,
          );
          return [
            if (mineHere) ('ma', l.uiMessagesYou, chatInitials(me)),
            for (var j = 0; j < others; j++)
              () {
                final id = pool[(pi++) % pool.length];
                used.add(id);
                final name = catalog.person(id)?.name ?? id;
                return (id, name, chatInitials(name));
              }(),
          ];
        }(),
    ];
    final waitN = chat.members - poll.voters;
    final waiting = [
      for (final id in pool)
        if (!used.contains(id)) catalog.person(id)?.name ?? id,
    ].take((chat.members - 10).clamp(0, 1 << 20)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 14,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: NizamioSpacing.space1,
          children: [
            // Prototip: başlıksız sayfada mono "anket sonuçları" etiketi + soru.
            NzKicker(l.uiMessagesPollResultsLc),
            Text(poll.question, style: t.titleSm),
            Text(
              '${poll.meta} · ${poll.ended ? l.uiMessagesConcluded : poll.deadline} · ${l.voters(poll.voters)}',
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ],
        ),
        for (var i = 0; i < poll.options.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: NizamioSpacing.space2,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        poll.options[i].label,
                        style: t.list.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '${poll.options[i].votes} ${l.uiMessagesVotesLc} · %${poll.percent(i)}',
                      style: t.monoSm.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(NizamioRadius.pill),
                  child: LinearProgressIndicator(
                    value: poll.percent(i) / 100,
                    minHeight: 6,
                    backgroundColor: c.surfaceOverlay,
                    color: poll.options[i].votes == top
                        ? c.primary
                        : c.textMuted,
                  ),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (id, name, ini) in voterRows[i])
                      Container(
                        padding: const EdgeInsets.fromLTRB(3, 3, 10, 3),
                        decoration: BoxDecoration(
                          color: c.surfaceOverlay,
                          borderRadius: BorderRadius.circular(
                            NizamioRadius.pill,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NzChatAvatar(
                              initials: ini,
                              tone: personTone(id, name),
                              extent: 22,
                            ),
                            const Gap(6),
                            Text(name, style: t.caption),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        if (waitN > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              border: Border.all(color: c.borderControl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text(
                  '${l.uiMessagesNotVoted} · $waitN',
                  style: t.caption.copyWith(color: c.textMuted),
                ),
                Text(
                  waiting.isEmpty
                      ? l.uiMessagesNotVotedNone
                      : waiting.join(', '),
                  style: t.bodySm.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        Row(
          spacing: NizamioSpacing.space2,
          children: [
            Expanded(
              child: NzButton.secondary(
                label: l.uiMessagesRemind,
                expand: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onToast(l.uiMessagesReminded);
                },
              ),
            ),
            Expanded(
              child: NzButton.primary(
                label: poll.ended ? l.uiMessagesPollEnded : l.uiMessagesEndPoll,
                expand: true,
                onPressed: poll.ended
                    ? null
                    : () {
                        ref
                            .read(chatsControllerProvider.notifier)
                            .endPoll(chatId, messageId);
                        Navigator.of(context).pop();
                        onToast(l.uiMessagesPollConcluded);
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Sohbet bilgisi seçimi.
sealed class ChatInfoAction {
  const ChatInfoAction();
}

final class ChatInfoSearch extends ChatInfoAction {
  const ChatInfoSearch();
}

final class ChatInfoMute extends ChatInfoAction {
  const ChatInfoMute();
}

final class ChatInfoLeave extends ChatInfoAction {
  const ChatInfoLeave();
}

final class ChatInfoOpenRef extends ChatInfoAction {
  const ChatInfoOpenRef(this.ref);
  final ChatRef ref;
}

/// Sohbet bilgisi: büyük avatar, ad, alt satır; Ara / Sessize al / Gruptan çık (Engelle);
/// paylaşılanlar (dokununca hedef); grupta üyeler.
Future<ChatInfoAction?> showChatInfo(
  BuildContext context, {
  required Chat chat,
  required TaskCatalog catalog,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<ChatInfoAction>(
    context,
    title: '${chat.name} ${l.uiMessagesInfo}',
    showHeader: false,
    builder: (sheet) {
      final c = sheet.colors;
      final t = sheet.text;
      void done(ChatInfoAction a) => Navigator.of(sheet).pop(a);
      final person = chat.person;
      final p = person == null ? null : catalog.person(person);
      final sub = chat.group
          ? '${chat.members} ${l.uiMessagesMembersLc} · '
                '${chat.id == 'gen' ? l.uiMessagesAllUsers : l.uiMessagesGroup}'
          : '${p == null ? '' : l.role(p.role)} · ${l.chatSubtitle(chat, catalog.today)}';
      final shared = sharedRefs(chat, catalog);
      final senders = <String>{
        for (final m in chat.messages)
          if (m.from != catalog.me) m.from,
      }.toList();
      final extra = [
        for (final k in ['aa', 'av', 'my', 'mk', 'ss', 'bc'])
          if (!senders.contains(k)) k,
      ];
      final members = [
        catalog.me,
        ...senders,
        ...extra,
      ].take(chat.members.clamp(0, 8)).toList();
      final me = catalog.person(catalog.me)?.name ?? '';
      Widget act(IconData icon, String label, Color color, ChatInfoAction a) =>
          Expanded(
            child: Material(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              child: InkWell(
                onTap: () => done(a),
                borderRadius: BorderRadius.circular(NizamioRadius.group),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      NzIcon(icon, size: NizamioSize.iconSizeSm, color: color),
                      const Gap(6),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: t.caption.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
      String sharedLabel(ChatRef r) => r.kind == ChatRefKind.task
          ? catalog.task(r.id)?.title ?? r.id
          : refLabel(r, catalog);
      String sharedSub(ChatRef r) => switch (r.kind) {
        ChatRefKind.task => '#${r.id}',
        ChatRefKind.coordinatorship => l.uiMessagesRefCoordinatorship,
        ChatRefKind.file =>
          '${l.uiMessagesRefArchive} / ${catalog.coordinatorship(r.coordinatorship ?? '')?.name ?? ''}',
        ChatRefKind.photo => l.uiMessagesPhoto,
        ChatRefKind.document => l.uiMessagesFile,
      };
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space4,
        children: [
          Column(
            spacing: 6,
            children: [
              NzChatAvatar(
                initials: chatInitials(chat.name),
                group: chat.group,
                tone: person == null ? 0 : personTone(person, chat.name),
                extent: 84,
              ),
              Text(chat.name, textAlign: TextAlign.center, style: t.titleSm),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: t.caption.copyWith(color: c.textMuted),
              ),
            ],
          ),
          Row(
            spacing: NizamioSpacing.space2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              act(
                NzIcons.search,
                l.uiMessagesSearchChat,
                c.text,
                const ChatInfoSearch(),
              ),
              act(NzIcons.mute, l.uiMessagesMute, c.text, const ChatInfoMute()),
              act(
                NzIcons.logout,
                chat.group ? l.uiMessagesLeaveGroup : l.uiMessagesBlock,
                c.danger,
                const ChatInfoLeave(),
              ),
            ],
          ),
          if (shared.isNotEmpty)
            _Group(
              label: '${l.uiMessagesShared} · ${shared.length}',
              children: [
                for (final r in shared)
                  InkWell(
                    onTap: () => done(ChatInfoOpenRef(r)),
                    child: _Row(
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: c.surfaceOverlay,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: NzIcon(
                          refIcon(r.kind),
                          size: 15,
                          color: c.accentText,
                        ),
                      ),
                      title: sharedLabel(r),
                      sub: sharedSub(r),
                      trailing: NzIcon(
                        NzIcons.chevronRight,
                        size: 14,
                        color: c.textFaint,
                      ),
                    ),
                  ),
              ],
            ),
          if (chat.group)
            _Group(
              label: '${l.uiMessagesMembers} · ${chat.members}',
              children: [
                for (var i = 0; i < members.length; i++)
                  () {
                    final id = members[i];
                    final isMe = id == catalog.me;
                    final p = catalog.person(id);
                    final name = isMe ? l.uiMessagesYou : p?.name ?? id;
                    return _Row(
                      leading: NzChatAvatar(
                        initials: chatInitials(isMe ? me : name),
                        tone: personTone(id, name),
                        extent: 34,
                      ),
                      title: name,
                      sub: isMe
                          ? me
                          : i < senders.length + 1
                          ? l.uiMessagesWroteHere
                          : l.uiMessagesMember,
                      trailing: p?.role == PersonRole.admin
                          ? Text(
                              l.uiMessagesManager,
                              style: t.monoSm.copyWith(color: c.accentText),
                            )
                          : null,
                    );
                  }(),
              ],
            ),
        ],
      );
    },
  );
}

class _Group extends StatelessWidget {
  const _Group({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            style: context.text.monoSm.copyWith(color: c.textFaint),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: ColoredBox(
            color: c.surfaceRaised,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: i > 0
                          ? Border(top: BorderSide(color: c.border))
                          : null,
                    ),
                    child: children[i],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.leading,
    required this.title,
    required this.sub,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final String sub;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          leading,
          const Gap(NizamioSpacing.gapMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMd,
                ),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.monoSm.copyWith(color: c.textFaint),
                ),
              ],
            ),
          ),
          if (trailing case final w?) ...[const Gap(NizamioSpacing.space2), w],
        ],
      ),
    );
  }
}
