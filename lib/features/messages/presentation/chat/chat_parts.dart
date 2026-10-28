import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_surfaces.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/chat_controller.dart';
import '../../domain/chat.dart';
import '../../domain/chat_logic.dart';
import 'messages_texts.dart';

/// Çocuğunun boyutunu yerleşimden sonra bildirir (cam çubukların altına akış dolgusu için).
class ChatMeasure extends SingleChildRenderObjectWidget {
  const ChatMeasure({super.key, required this.onSize, required super.child});

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      ChatMeasureBox(onSize);

  @override
  void updateRenderObject(BuildContext context, ChatMeasureBox renderObject) =>
      renderObject.onSize = onSize;
}

/// [ChatMeasure] çizim nesnesi.
class ChatMeasureBox extends RenderProxyBox {
  ChatMeasureBox(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _last) {
      _last = size;
      final s = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(s));
    }
  }
}

/// Kişinin sohbet rengi.
Color personColor(BuildContext context, TaskCatalog catalog, String id) =>
    NzChatAvatar.toneColor(
      context,
      personTone(id, catalog.person(id)?.name ?? id),
    );

/// Mesaj gövdesi: satır içi `@bahsetme` / `#GÖREV` (dokununca görev) ve metinde olmayan ek
/// atıflar (ikonlu, vurgulu).
class ChatMessageBody extends StatelessWidget {
  const ChatMessageBody({
    super.key,
    required this.message,
    required this.catalog,
    required this.mentions,
    required this.onOpenTask,
  });

  final ChatMessage message;
  final TaskCatalog catalog;
  final List<String> mentions;
  final ValueChanged<String> onOpenTask;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final base = t.list.copyWith(fontWeight: FontWeight.w400, height: 21 / 15);
    final accent = base.copyWith(
      color: c.accentText,
      fontWeight: FontWeight.w600,
    );
    final mono = t.mono.copyWith(
      color: c.accentText,
      fontWeight: FontWeight.w600,
    );
    final spans = <InlineSpan>[];
    for (final tok in tokenize(message.text, mentions)) {
      switch (tok.kind) {
        case ChatTokenKind.text:
          spans.add(TextSpan(text: tok.text, style: base));
        case ChatTokenKind.mention:
          spans.add(TextSpan(text: tok.text, style: accent));
        case ChatTokenKind.task:
          final code = tok.text.substring(1);
          final known = catalog.task(code) != null;
          spans.add(
            known
                ? WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Semantics(
                      link: true,
                      label: tok.text,
                      excludeSemantics: true,
                      child: GestureDetector(
                        onTap: () => onOpenTask(code),
                        child: Text(tok.text, style: mono),
                      ),
                    ),
                  )
                : TextSpan(text: tok.text, style: mono),
          );
      }
    }
    final extra = extraRefs(message, catalog);
    for (final r in extra) {
      if (spans.isNotEmpty) spans.add(TextSpan(text: ' ', style: base));
      final style = r.kind == ChatRefKind.coordinatorship
          ? accent.copyWith(fontSize: 13)
          : mono;
      spans
        ..add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Icon(refIcon(r.kind), size: 13, color: c.accentText),
            ),
          ),
        )
        ..add(TextSpan(text: refLabel(r, catalog), style: style));
    }
    if (spans.isEmpty) return const SizedBox.shrink();
    return Text.rich(TextSpan(children: spans));
  }
}

/// Balon içi anket: soru, açıklama, seçenekler (dokununca oy; yüzde çubuğu), oy veren sayısı.
class ChatPollView extends StatelessWidget {
  const ChatPollView({super.key, required this.poll, required this.onVote});

  final ChatPoll poll;
  final ValueChanged<int> onVote;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space2,
        children: [
          const Gap(NizamioSpacing.space1),
          Text(
            poll.question,
            style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            '${poll.meta} · ${poll.ended ? l.uiMessagesConcluded : poll.deadline}',
            style: t.caption.copyWith(color: c.textMuted),
          ),
          for (var i = 0; i < poll.options.length; i++)
            _PollOption(
              label: poll.options[i].label,
              percent: poll.percent(i),
              on: poll.mine.contains(i),
              onTap: poll.ended ? null : () => onVote(i),
            ),
          Text(
            l.voters(poll.voters),
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ],
      ),
    );
  }
}

class _PollOption extends StatelessWidget {
  const _PollOption({
    required this.label,
    required this.percent,
    required this.on,
    required this.onTap,
  });

  final String label;
  final int percent;
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      checked: on,
      label: '$label %$percent',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NizamioSpacing.gapMd),
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: c.quoteFill)),
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percent / 100,
                  child: ColoredBox(
                    color: on
                        ? c.primary.withValues(alpha: 0.26)
                        : c.text.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 36),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: on ? c.primary : null,
                        borderRadius: BorderRadius.circular(5),
                        border: on
                            ? null
                            : Border.all(color: c.borderControl, width: 1.5),
                      ),
                      child: on
                          ? Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: c.onPrimary,
                            )
                          : null,
                    ),
                    const Gap(NizamioSpacing.space2),
                    Expanded(child: Text(label, style: t.bodySm)),
                    Text(
                      '%$percent',
                      style: t.monoSm.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cam üst çubuk: geri, avatar + ad + alt satır (dokununca sohbet bilgisi), sohbette ara;
/// sabit mesaj varsa altında şerit (dokununca sıradaki).
class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.chat,
    required this.catalog,
    required this.typing,
    required this.pinIndex,
    required this.onInfo,
    required this.onSearch,
    required this.onNextPin,
  });

  final Chat chat;
  final TaskCatalog catalog;
  final bool typing;
  final int pinIndex;
  final VoidCallback onInfo;
  final VoidCallback onSearch;
  final VoidCallback onNextPin;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final typer = chat.typing == null
        ? null
        : catalog.person(chat.typing!)?.name.split(' ').first;
    final showTyping = typing && typer != null;
    final sub = showTyping
        ? '$typer ${l.uiMessagesTyping}'
        : l.chatSubtitle(chat, catalog.today);
    final subAccent = showTyping || (!chat.group && chat.online);
    final pins = [for (final id in chat.pins) ?chat.message(id)];
    final pin = pins.isEmpty ? null : pins[pinIndex % pins.length];
    final person = chat.person;
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: NzGlass(
        tone: NzGlassTone.bar,
        edge: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  NizamioSpacing.space1,
                  MediaQuery.paddingOf(context).top + NizamioSpacing.space2,
                  NizamioSpacing.space1,
                  NizamioSpacing.space1,
                ),
                child: Row(
                  children: [
                    NzIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      semanticLabel: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      size: NzSize.sm,
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Semantics(
                        button: true,
                        label:
                            '${chat.name} ${chat.group ? l.uiMessagesGroupInfo : l.uiMessagesPersonInfo}',
                        excludeSemantics: true,
                        child: InkWell(
                          onTap: onInfo,
                          borderRadius: BorderRadius.circular(
                            NizamioRadius.tile,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                NzChatAvatar(
                                  initials: chatInitials(chat.name),
                                  group: chat.group,
                                  tone: person == null
                                      ? 0
                                      : personTone(person, chat.name),
                                  extent: 38,
                                ),
                                const Gap(NizamioSpacing.gapMd),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.list.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (sub.isNotEmpty)
                                        Text(
                                          sub,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.caption.copyWith(
                                            color: subAccent
                                                ? c.accentText
                                                : c.textMuted,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    NzIconButton(
                      icon: Icons.search_rounded,
                      semanticLabel: l.uiMessagesSearchChat,
                      onPressed: onSearch,
                    ),
                  ],
                ),
              ),
              if (pin != null)
                Semantics(
                  button: true,
                  label: '${l.uiMessagesPinned}: ${pin.summary}',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: onNextPin,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 46),
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: c.border)),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 3,
                              decoration: BoxDecoration(
                                color: c.accentText,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const Gap(NizamioSpacing.gapMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pins.length > 1
                                        ? '${l.uiMessagesPinned} ${pinIndex % pins.length + 1}/${pins.length}'
                                        : l.uiMessagesPinned,
                                    style: t.caption.copyWith(
                                      color: c.accentText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    pin.summary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodySm.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(NizamioSpacing.gapMd),
                            Icon(
                              Icons.push_pin_outlined,
                              size: NizamioSize.iconSizeSm,
                              color: c.textFaint,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ek paneli: cihazdan Fotoğraf ve video / Dosya, portal atıfları (Görev, Koordinatörlük,
/// Arşiv sekmeleri, arama, seçilebilir liste).
class ChatAttachPanel extends StatelessWidget {
  const ChatAttachPanel({
    super.key,
    required this.view,
    required this.catalog,
    required this.query,
    required this.onTab,
    required this.onToggle,
    required this.onPhoto,
    required this.onFile,
  });

  final ChatViewState view;
  final TaskCatalog catalog;
  final TextEditingController query;
  final ValueChanged<ChatAttachTab> onTab;
  final ValueChanged<ChatRef> onToggle;
  final VoidCallback onPhoto;
  final VoidCallback onFile;

  /// Sekmenin satırları: (atıf, etiket, alt satır).
  static List<(ChatRef, String, String)> items(
    ChatAttachTab tab,
    TaskCatalog catalog,
    String query,
    String archive,
  ) {
    final q = lowerTr(query.trim());
    bool hit(String s) => q.isEmpty || lowerTr(s).contains(q);
    String coordName(String code) =>
        catalog.coordinatorship(code)?.name ?? code;
    switch (tab) {
      case ChatAttachTab.task:
        return [
          for (final t in catalog.tasks)
            if (hit('${t.code} ${t.title}'))
              (
                ChatRef(ChatRefKind.task, t.code),
                t.title,
                '${t.code} · ${coordName(t.coordinatorship)}',
              ),
        ].take(30).toList();
      case ChatAttachTab.coordinatorship:
        return [
          for (final c in catalog.coordinatorships)
            if (hit(c.name))
              (ChatRef(ChatRefKind.coordinatorship, c.code), c.name, c.code),
        ];
      case ChatAttachTab.archive:
        final files = <(ChatRef, String, String)>[];
        for (final c in catalog.coordinatorships) {
          final withFiles = [
            for (final t in catalog.tasksOf(c.code))
              if (t.files > 0) t,
          ].take(3).toList();
          for (var j = 0; j < withFiles.length; j++) {
            final name =
                '${withFiles[j].code}${j.isOdd ? '_Rapor.docx' : '_saha.jpeg'}';
            files.add((
              ChatRef(ChatRefKind.file, name, coordinatorship: c.code),
              name,
              '$archive / ${c.name}',
            ));
          }
        }
        return [
          for (final f in files)
            if (hit('${f.$2} ${f.$3}')) f,
        ].take(30).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final tab = view.attach ?? ChatAttachTab.task;
    final rows = items(tab, catalog, view.attachQuery, l.uiMessagesRefArchive);
    Widget device(
      IconData icon,
      Color tint,
      String label,
      VoidCallback onTap,
    ) => Expanded(
      child: Material(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(NizamioRadius.attach),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NizamioRadius.attach),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 16, color: tint),
                ),
                const Gap(NizamioSpacing.gapMd),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMd,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: NizamioSpacing.space2,
          children: [
            Row(
              children: [
                device(
                  Icons.image_outlined,
                  c.inProgress,
                  l.uiMessagesPhotoVideo,
                  onPhoto,
                ),
                const Gap(NizamioSpacing.space2),
                device(
                  Icons.insert_drive_file_outlined,
                  c.warning,
                  l.uiMessagesFile,
                  onFile,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Text(
                l.uiMessagesPortalRefs,
                style: t.monoSm.copyWith(color: c.textFaint),
              ),
            ),
            NzPillTabs(
              tabs: [
                NzPillTab(
                  label: l.uiMessagesRefTask,
                  icon: Icons.checklist_rounded,
                ),
                NzPillTab(
                  label: l.uiMessagesRefCoordinatorship,
                  icon: Icons.apartment_rounded,
                ),
                NzPillTab(
                  label: l.uiMessagesRefArchive,
                  icon: Icons.insert_drive_file_outlined,
                ),
              ],
              selected: tab.index,
              onSelected: (i) => onTab(ChatAttachTab.values[i]),
            ),
            NzSearchField(
              controller: query,
              size: NzSize.sm,
              label: switch (tab) {
                ChatAttachTab.task => l.uiMessagesSearchTask,
                ChatAttachTab.coordinatorship =>
                  l.uiMessagesSearchCoordinatorship,
                ChatAttachTab.archive => l.uiMessagesSearchFile,
              },
              hint: switch (tab) {
                ChatAttachTab.task => l.uiMessagesSearchTask,
                ChatAttachTab.coordinatorship =>
                  l.uiMessagesSearchCoordinatorship,
                ChatAttachTab.archive => l.uiMessagesSearchFile,
              },
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  for (final (ref, label, sub) in rows)
                    Semantics(
                      button: true,
                      selected: view.refs.contains(ref),
                      label: '$label, $sub',
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: () => onToggle(ref),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 46),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: c.surfaceOverlay,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Icon(
                                  refIcon(ref.kind),
                                  size: 15,
                                  color: c.accentText,
                                ),
                              ),
                              const Gap(NizamioSpacing.gapMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.bodyMd,
                                    ),
                                    Text(
                                      sub,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.monoSm.copyWith(
                                        color: c.textFaint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (view.refs.contains(ref))
                                Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: c.accentText,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Öneri listesi (`#görev` / `@kişi`): solda mono anahtar, sağda etiket.
class ChatSuggestions extends StatelessWidget {
  const ChatSuggestions({super.key, required this.items, required this.onPick});

  final List<ChatSuggestion> items;
  final ValueChanged<ChatSuggestion> onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 196),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            for (final s in items)
              InkWell(
                onTap: () => onPick(s),
                child: Container(
                  constraints: const BoxConstraints(minHeight: NizamioSize.tap),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          s.key,
                          style: t.monoSm.copyWith(color: c.accentText),
                        ),
                      ),
                      const Gap(NizamioSpacing.gapMd),
                      Expanded(
                        child: Text(
                          s.role == null
                              ? s.label
                              : '${s.label} · ${l.role(s.role!)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMd,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
