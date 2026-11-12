import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../domain/chat.dart';
import 'chat_compose_deadline.dart';
import 'chat_compose_lifetime.dart';
import 'messages_texts.dart';

/// Ek menüsünün seçimi: galeriden fotoğraf, cihaz dosyası ya da anket.
enum ChatAttachKind { photos, files, poll, task, department, archive }

/// Yazma alanındaki ek düğmesinin menüsü: görev ayrıntısındaki yüklemeyle aynı kaynak seçimi
/// (Fotoğraflar / Dosyalar) ve (yalnız grupta) anket.
Future<ChatAttachKind?> showAttachMenu(
  BuildContext context, {
  required bool group,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<ChatAttachKind>(
    context,
    title: l.uiMessagesAttach,
    builder: (sheet) => NzMenuGroup(
      rows: [
        NzMenuRow(
          icon: NzIcons.image,
          label: l.uiMessagesAttachPhotos,
          onTap: () => Navigator.of(sheet).pop(ChatAttachKind.photos),
        ),
        NzMenuRow(
          icon: NzIcons.folder,
          label: l.uiMessagesAttachFile,
          onTap: () => Navigator.of(sheet).pop(ChatAttachKind.files),
        ),
        if (group)
          NzMenuRow(
            icon: NzIcons.barChart,
            label: l.uiMessagesAttachPoll,
            onTap: () => Navigator.of(sheet).pop(ChatAttachKind.poll),
          ),
      ],
    ),
  );
}

/// Metin alanının içindeki atıf düğmesi: yalnız var olan kayıtları paylaşır.
Future<ChatAttachKind?> showReferenceMenu(
  BuildContext context, {
  required bool canShare,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<ChatAttachKind>(
    context,
    title: l.uiMessagesReference,
    builder: (sheet) => NzMenuGroup(
      rows: [
        for (final item in [
          (ChatAttachKind.task, l.uiMessagesComposeShareTask, NzIcons.tasks),
          (
            ChatAttachKind.department,
            l.uiMessagesComposeShareDepartment,
            NzIcons.coordinatorships,
          ),
          (
            ChatAttachKind.archive,
            l.uiMessagesComposeShareFile,
            NzIcons.folder,
          ),
        ])
          if (canShare)
            NzMenuRow(
              icon: item.$3,
              label: item.$2,
              onTap: () => Navigator.of(sheet).pop(item.$1),
            )
          else
            Semantics(
              enabled: false,
              child: Opacity(
                opacity: 0.38,
                child: IgnorePointer(
                  child: NzMenuRow(icon: item.$3, label: item.$2, onTap: () {}),
                ),
              ),
            ),
      ],
    ),
  );
}

/// Anket taslağı (soru = mesaj gövdesi).
typedef ChatPollInput = ({String question, PollDraft poll});

/// Anket oluştur: soru, 2–10 seçenek (ekle), tek/çoklu seçim. Geçerli taslak döner.
Future<ChatPollInput?> showPollComposer(BuildContext context) async {
  final input = ValueNotifier<ChatPollInput?>(null);
  return NzBottomSheet.show<ChatPollInput>(
    context,
    title: context.l10n.uiMessagesPollNew,
    builder: (_) => ChatComposeLifetime(
      onDispose: input.dispose,
      child: _PollComposer(input: input),
    ),
    actions: (sheet) => [
      NzButton.secondary(
        label: sheet.l10n.uiMessagesCancel,
        expand: true,
        onPressed: () => Navigator.of(sheet).pop(),
      ),
      ValueListenableBuilder<ChatPollInput?>(
        valueListenable: input,
        builder: (_, value, _) => NzButton.primary(
          label: sheet.l10n.uiMessagesSend,
          expand: true,
          onPressed: value == null
              ? null
              : () {
                  final closes = value.poll.closesAt;
                  if (closes != null && !closes.isAfter(DateTime.now())) {
                    input.value = null;
                    return;
                  }
                  Navigator.of(sheet).pop(value);
                },
        ),
      ),
    ],
  );
}

class _PollComposer extends StatefulWidget {
  const _PollComposer({required this.input});

  final ValueNotifier<ChatPollInput?> input;

  @override
  State<_PollComposer> createState() => _PollComposerState();
}

class _PollComposerState extends State<_PollComposer> {
  final _question = TextEditingController();
  final _options = [TextEditingController(), TextEditingController()];
  var _multi = false;
  DateTime? _closesAt;

  void _change(VoidCallback change) {
    setState(change);
    widget.input.value = _valid
        ? (
            question: _question.text.trim(),
            poll: PollDraft(
              options: _values,
              multi: _multi,
              closesAt: _closesAt,
            ),
          )
        : null;
  }

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
      _question.text.trim().isNotEmpty &&
      PollDraft.valid(_values) &&
      (_closesAt == null || _closesAt!.isAfter(DateTime.now()));

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
          onChanged: (_) => _change(() {}),
        ),
        for (var i = 0; i < _options.length; i++)
          NzTextField(
            label: '${l.uiMessagesPollOption} ${i + 1}',
            controller: _options[i],
            onChanged: (_) => _change(() {}),
          ),
        if (_options.length < PollDraft.maxOptions)
          NzButton.secondary(
            label: l.uiMessagesPollAddOption,
            onPressed: () =>
                _change(() => _options.add(TextEditingController())),
          ),
        NzSwitch(
          label: l.uiMessagesMultiChoice,
          value: _multi,
          onChanged: (v) => _change(() => _multi = v),
        ),
        ChatComposeDeadline(onChanged: (v) => _change(() => _closesAt = v)),
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
