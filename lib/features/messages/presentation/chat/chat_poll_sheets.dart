import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../domain/chat.dart';
import 'messages_texts.dart';

/// Ek menüsünün seçimi.
enum ChatAttachKind { file, poll }

/// Yazma alanındaki ek düğmesinin menüsü: dosya ve (yalnız grupta) anket.
Future<ChatAttachKind?> showAttachMenu(
  BuildContext context, {
  required bool group,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<ChatAttachKind>(
    context,
    title: l.uiMessagesAttach,
    compact: true,
    builder: (sheet) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzListTile(
          title: l.uiMessagesAttachFile,
          leading: const NzIcon(NzIcons.file),
          onTap: () => Navigator.of(sheet).pop(ChatAttachKind.file),
        ),
        if (group)
          NzListTile(
            title: l.uiMessagesAttachPoll,
            leading: const NzIcon(NzIcons.barChart),
            onTap: () => Navigator.of(sheet).pop(ChatAttachKind.poll),
          ),
      ],
    ),
  );
}

/// Anket taslağı (soru = mesaj gövdesi).
typedef ChatPollInput = ({String question, PollDraft poll});

/// Anket oluştur: soru, 2–10 seçenek (ekle), tek/çoklu seçim. Geçerli taslak döner.
Future<ChatPollInput?> showPollComposer(BuildContext context) =>
    NzBottomSheet.show<ChatPollInput>(
      context,
      title: context.l10n.uiMessagesPollNew,
      builder: (_) => const _PollComposer(),
    );

class _PollComposer extends StatefulWidget {
  const _PollComposer();

  @override
  State<_PollComposer> createState() => _PollComposerState();
}

class _PollComposerState extends State<_PollComposer> {
  final _question = TextEditingController();
  final _options = [TextEditingController(), TextEditingController()];
  var _multi = false;

  @override
  void dispose() {
    _question.dispose();
    for (final o in _options) {
      o.dispose();
    }
    super.dispose();
  }

  List<String> get _values => [
    for (final o in _options)
      if (o.text.trim().isNotEmpty) o.text.trim(),
  ];

  bool get _valid =>
      _question.text.trim().isNotEmpty && PollDraft.valid(_values);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space3,
      children: [
        NzTextField(
          label: l.uiMessagesPollQuestion,
          controller: _question,
          onChanged: (_) => setState(() {}),
        ),
        for (var i = 0; i < _options.length; i++)
          NzTextField(
            label: '${l.uiMessagesPollOption} ${i + 1}',
            controller: _options[i],
            onChanged: (_) => setState(() {}),
          ),
        if (_options.length < PollDraft.maxOptions)
          NzButton.secondary(
            label: l.uiMessagesPollAddOption,
            onPressed: () =>
                setState(() => _options.add(TextEditingController())),
          ),
        NzSwitch(
          label: l.uiMessagesMultiChoice,
          value: _multi,
          onChanged: (v) => setState(() => _multi = v),
        ),
        NzButton.primary(
          label: l.uiMessagesSend,
          expand: true,
          onPressed: _valid
              ? () => Navigator.of(context).pop((
                  question: _question.text.trim(),
                  poll: PollDraft(options: _values, multi: _multi),
                ))
              : null,
        ),
      ],
    );
  }
}

/// Anket sonuçları: seçenek başına sayı ve oy verenlerin adları (sonuçta oy verenler görünür).
Future<void> showPollResults(BuildContext context, ChatMessage m) {
  final l = context.l10n;
  final poll = m.poll;
  if (poll == null) return Future.value();
  return NzBottomSheet.show<void>(
    context,
    title: l.uiMessagesPollResults,
    description: m.text,
    builder: (sheet) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < poll.options.length; i++)
          NzListTile(
            title: '${poll.options[i].label} · %${poll.percent(i)}',
            subtitle: poll.options[i].voters.isEmpty
                ? l.uiMessagesPollNoVotes
                : [for (final v in poll.options[i].voters) v.name].join(', '),
          ),
        Padding(
          padding: const EdgeInsets.only(top: NizamioSpacing.space2),
          child: Text(
            l.voters(poll.voters),
            style: sheet.text.caption.copyWith(color: sheet.colors.textMuted),
          ),
        ),
      ],
    ),
  );
}
