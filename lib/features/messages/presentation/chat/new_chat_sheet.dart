import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/new_chat_controller.dart';
import '../../domain/chat.dart';
import 'messages_texts.dart';

/// Yeni sohbet: birebir adaylar (`purpose=direct`) ve "Yeni grup" (ad + `purpose=group`
/// adaylarından üye seçimi). Listede olmayan kişi için "neden yazamıyorum" metni, kırpılmış
/// listede "ilk 200 kişi" bilgisi (§10.6). Açılan ya da kurulan sohbetin kimliği döner.
Future<String?> showNewChatSheet(BuildContext context) =>
    NzBottomSheet.show<String>(
      context,
      title: context.l10n.uiMessagesNewMessage,
      builder: (_) => const _NewChat(),
    );

class _NewChat extends ConsumerStatefulWidget {
  const _NewChat();

  @override
  ConsumerState<_NewChat> createState() => _NewChatState();
}

class _NewChatState extends ConsumerState<_NewChat> {
  final _name = TextEditingController();
  final _members = <String>{};
  var _group = false;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _run(Future<Chat> Function() action) async {
    setState(() => _busy = true);
    try {
      final chat = await action();
      if (mounted) Navigator.of(context).pop(chat.id);
    } on ApiError catch (e) {
      if (mounted) NzToast.show(context, errorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) =>
      _group ? _groupForm(context) : _direct(context);

  Widget _direct(BuildContext context) {
    final l = context.l10n;
    const purpose = ChatCandidatePurpose.direct;
    final value = ref.watch(newChatControllerProvider(purpose));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        NzListTile(
          title: l.uiMessagesNewGroup,
          leading: NzIcon(NzIcons.add, color: context.colors.accentText),
          onTap: () => setState(() => _group = true),
        ),
        _candidates(
          context,
          value,
          purpose,
          (c) => NzListTile(
            title: c.name,
            subtitle: c.role == null ? null : l.candidateRole(c.role!),
            leading: _avatar(c),
            onTap: _busy
                ? null
                : () => _run(
                    () => ref
                        .read(newChatControllerProvider(purpose).notifier)
                        .openDirect(c.accountId),
                  ),
          ),
          footer: l.uiMessagesWhyCannotWrite,
        ),
      ],
    );
  }

  Widget _groupForm(BuildContext context) {
    final l = context.l10n;
    const purpose = ChatCandidatePurpose.group;
    final value = ref.watch(newChatControllerProvider(purpose));
    final name = _name.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space3,
      children: [
        NzTextField(
          label: l.uiMessagesGroupName,
          controller: _name,
          onChanged: (_) => setState(() {}),
        ),
        Text(
          l.uiMessagesNewChatHint,
          style: context.text.monoSm.copyWith(color: context.colors.textFaint),
        ),
        _candidates(
          context,
          value,
          purpose,
          (c) => NzCheckbox(
            label: c.name,
            value: _members.contains(c.accountId),
            labelLeading: _avatar(c),
            onChanged: _busy
                ? null
                : (on) => setState(
                    () => on
                        ? _members.add(c.accountId)
                        : _members.remove(c.accountId),
                  ),
          ),
        ),
        NzButton.primary(
          label: l.uiMessagesCreateGroup,
          expand: true,
          onPressed: _busy || name.isEmpty
              ? null
              : () => _run(
                  () => ref
                      .read(newChatControllerProvider(purpose).notifier)
                      .createGroup(GroupDraft(name: name, memberIds: _members)),
                ),
        ),
      ],
    );
  }

  Widget _candidates(
    BuildContext context,
    AsyncValue<ChatCandidates> value,
    ChatCandidatePurpose purpose,
    Widget Function(ChatCandidate) row, {
    String? footer,
  }) {
    final l = context.l10n;
    final note = context.text.caption.copyWith(color: context.colors.textMuted);
    if (value.error case final e?) {
      return NzErrorState(
        error: toApiError(e),
        onRetry: () => ref.invalidate(newChatControllerProvider(purpose)),
      );
    }
    final list = value.value;
    if (list == null) return const NzLoader();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space1,
      children: [
        for (final c in list.items) row(c),
        if (list.items.isEmpty) Text(l.uiMessagesNoCandidates, style: note),
        if (list.truncated) Text(l.uiMessagesCandidatesTruncated, style: note),
        if (footer != null) Text(footer, style: note),
      ],
    );
  }

  Widget _avatar(ChatCandidate c) => NzChatAvatar(
    initials: chatInitials(c.name),
    tone: personTone(c.name),
    extent: 34,
  );
}
