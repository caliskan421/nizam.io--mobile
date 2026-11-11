import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/chat_group_sources.dart';
import '../../application/new_chat_controller.dart';
import '../../domain/chat.dart';
import 'chat_group_source_fields.dart';
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

Future<String?> _showNewGroup(BuildContext context) {
  final submit = ValueNotifier<VoidCallback?>(null);
  return NzBottomSheet.show<String>(
    context,
    title: context.l10n.uiMessagesNewGroup,
    builder: (_) => _NewChat(group: true, submit: submit),
    actions: (sheet) => [
      NzButton.secondary(
        label: sheet.l10n.uiMessagesCancel,
        expand: true,
        onPressed: () => Navigator.of(sheet).pop(),
      ),
      ValueListenableBuilder<VoidCallback?>(
        valueListenable: submit,
        builder: (_, create, _) => NzButton.primary(
          label: sheet.l10n.uiMessagesCreateGroup,
          expand: true,
          onPressed: create,
        ),
      ),
    ],
  );
}

class _NewChat extends ConsumerStatefulWidget {
  const _NewChat({this.group = false, this.submit});
  final bool group;
  final ValueNotifier<VoidCallback?>? submit;

  @override
  ConsumerState<_NewChat> createState() => _NewChatState();
}

class _NewChatState extends ConsumerState<_NewChat> {
  final _name = TextEditingController();
  final _members = <String>{};
  var _busy = false;
  var _source = ChatSource.none;
  String? _departmentId;

  void _reset() => setState(() {
    _name.clear();
    _members.clear();
    _source = ChatSource.none;
    _departmentId = null;
  });

  @override
  void dispose() {
    _name.dispose();
    widget.submit?.dispose();
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
  Widget build(BuildContext context) {
    ref.listen(scopeStateProvider, (old, next) {
      if (old?.programId != next.programId) _reset();
    });
    ref.listen(sessionGenerationProvider, (old, next) {
      if (old != next) _reset();
    });
    return Material(
      type: MaterialType.transparency,
      child: widget.group ? _groupForm(context) : _direct(context),
    );
  }

  Widget _direct(BuildContext context) {
    final l = context.l10n;
    const purpose = ChatCandidatePurpose.direct;
    final value = ref.watch(newChatControllerProvider(purpose));
    final program = ref.watch(scopeStateProvider).programId;
    final session = ref.watch(sessionGenerationProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        NzListTile(
          title: l.uiMessagesNewGroup,
          leading: NzIcon(NzIcons.add, color: context.colors.accentText),
          onTap: () async {
            final id = await _showNewGroup(context);
            if (context.mounted && id != null) Navigator.of(context).pop(id);
          },
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
                : () {
                    if (ref.read(scopeStateProvider).programId != program ||
                        ref.read(sessionGenerationProvider) != session) {
                      return;
                    }
                    _run(
                      () => ref
                          .read(newChatControllerProvider(purpose).notifier)
                          .openDirect(c.accountId),
                    );
                  },
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
    final sources = ref.watch(chatGroupSourcesProvider);
    final options = sources.isLoading || sources.hasError
        ? null
        : sources.value;
    final canSource = options?.canCreateSource == true;
    final source = canSource ? _source : ChatSource.none;
    final validDepartment =
        options?.departments.any((d) => d.id == _departmentId) == true;
    final validSource = source != ChatSource.department || validDepartment;
    final program = ref.watch(scopeStateProvider).programId;
    final session = ref.watch(sessionGenerationProvider);
    final canSubmit =
        !_busy &&
        name.isNotEmpty &&
        name.length <= 100 &&
        validSource &&
        (_source == ChatSource.none || canSource);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.submit?.value = canSubmit
          ? () {
              if (ref.read(scopeStateProvider).programId != program ||
                  ref.read(sessionGenerationProvider) != session) {
                return;
              }
              _run(
                () => ref
                    .read(newChatControllerProvider(purpose).notifier)
                    .createGroup(
                      GroupDraft(
                        name: name,
                        memberIds: _members,
                        source: source,
                        sourceDepartmentId: source == ChatSource.department
                            ? _departmentId
                            : null,
                      ),
                    ),
              );
            }
          : null;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space3,
      children: [
        NzTextField(
          label: l.uiMessagesGroupName,
          controller: _name,
          maxLength: 100,
          onChanged: (_) => setState(() {}),
        ),
        if (canSource)
          ChatGroupSourceFields(
            source: source,
            departmentId: validDepartment ? _departmentId : null,
            departments: options!.departments,
            enabled: !_busy,
            onChanged: (source, departmentId) {
              if (ref.read(scopeStateProvider).programId != program ||
                  ref.read(sessionGenerationProvider) != session) {
                return;
              }
              setState(() {
                _source = source;
                _departmentId = departmentId;
              });
            },
          ),
        if (sources.error case final e?)
          NzErrorState(
            error: toApiError(e),
            onRetry: () => ref.invalidate(chatGroupSourcesProvider),
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
    if (value.isLoading) return const NzLoader();
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
