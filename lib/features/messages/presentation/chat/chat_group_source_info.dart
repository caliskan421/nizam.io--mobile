import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/providers.dart';
import '../../../../core/telemetry/report_source.dart';
import '../../../../core/telemetry/unexpected_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/chat_group_sources.dart';
import '../../application/chat_members_controller.dart';
import '../../application/chat_room_controller.dart';
import '../../domain/chat.dart';
import 'chat_group_source_fields.dart';

/// Sunucunun sohbet rolü kaynak değişimini açar; kuruculuk tek başına yeterli değildir.
class ChatGroupSourceInfo extends ConsumerStatefulWidget {
  const ChatGroupSourceInfo({super.key, required this.chat});
  final Chat chat;

  @override
  ConsumerState<ChatGroupSourceInfo> createState() =>
      _ChatGroupSourceInfoState();
}

class _ChatGroupSourceInfoState extends ConsumerState<ChatGroupSourceInfo> {
  var _busy = false;

  Future<void> _change({bool close = false}) async {
    final chat = widget.chat;
    final program = ref.read(scopeStateProvider).programId;
    final session = ref.read(sessionGenerationProvider);
    final ctl = ref.read(chatMembersControllerProvider(chat.id).notifier);
    final submit = ValueNotifier<VoidCallback?>(null);
    final pick = close
        ? (await _confirmClose() ? (ChatSource.none, null) : null)
        : await NzBottomSheet.show<(ChatSource, String?)>(
            context,
            title: context.l10n.uiMessagesGroupsChangeSource,
            builder: (_) => _EditSource(chat: chat, submit: submit),
            actions: (sheet) => [
              NzButton.secondary(
                label: sheet.l10n.uiMessagesCancel,
                expand: true,
                onPressed: () => Navigator.of(sheet).pop(),
              ),
              ValueListenableBuilder<VoidCallback?>(
                valueListenable: submit,
                builder: (_, save, _) => NzButton.primary(
                  label: sheet.l10n.uiMessagesSave,
                  expand: true,
                  onPressed: save,
                ),
              ),
            ],
          );
    if (close) submit.dispose();
    if (!mounted ||
        pick == null ||
        ref.read(scopeStateProvider).programId != program ||
        ref.read(sessionGenerationProvider) != session) {
      return;
    }
    // Rol canlı akışla değişmiş olabilir; onaydan sonra güncel sunucu rolünü kullan.
    final current = ref.read(chatRoomControllerProvider(chat.id)).value?.chat;
    if (current?.canModerate != true) return;
    setState(() => _busy = true);
    try {
      await ctl.updateSource(pick.$1, departmentId: pick.$2);
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      if (mounted) NzToast.show(context, errorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirmClose() => NzBottomSheet.show<bool>(
    context,
    title: context.l10n.uiMessagesGroupsCloseSource,
    description: context.l10n.uiMessagesGroupsCloseConfirm,
    builder: (_) => const SizedBox.shrink(),
    actions: (sheet) => nzSheetActions(
      sheet,
      cancel: context.l10n.uiMessagesCancel,
      ok: context.l10n.uiMessagesGroupsCloseSource,
      onOk: () => Navigator.of(sheet).pop(true),
    ),
  ).then((value) => value ?? false);

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final l = context.l10n;
    final sources = ref.watch(chatGroupSourcesProvider);
    final department =
        (sources.isLoading || sources.hasError ? null : sources.value)
            ?.departments
            .where((d) => d.id == chat.sourceDepartmentId)
            .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        NzListTile(
          title: l.uiMessagesGroupsSource,
          subtitle: chat.source == ChatSource.department
              ? '${l.uiMessagesGroupsDepartment} · ${department?.name ?? l.uiMessagesGroupsDepartmentUnavailable}'
              : groupSourceLabel(context, chat.source),
        ),
        // Kendiliğinden kurulan grup korunur: kaynak değişmez/kapanmaz, nedeni yazılır.
        if (chat.auto)
          Text(
            errorText(l, ApiError('messaging.auto_group_protected')),
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          )
        else if (chat.canModerate)
          Semantics(
            enabled: !_busy,
            child: IgnorePointer(
              ignoring: _busy,
              child: Opacity(
                opacity: _busy ? 0.38 : 1,
                child: NzMenuGroup(
                  rows: [
                    NzMenuRow(
                      icon: NzIcons.edit,
                      label: l.uiMessagesGroupsChangeSource,
                      onTap: _change,
                    ),
                    if (chat.source != ChatSource.none)
                      NzMenuRow(
                        icon: NzIcons.close,
                        label: l.uiMessagesGroupsCloseSource,
                        onTap: () => _change(close: true),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EditSource extends ConsumerStatefulWidget {
  const _EditSource({required this.chat, required this.submit});
  final Chat chat;
  final ValueNotifier<VoidCallback?> submit;

  @override
  ConsumerState<_EditSource> createState() => _EditSourceState();
}

class _EditSourceState extends ConsumerState<_EditSource> {
  late var _source = widget.chat.source;
  late String? _departmentId = widget.chat.sourceDepartmentId;
  late final _program = ref.read(scopeStateProvider).programId;
  late final _session = ref.read(sessionGenerationProvider);

  @override
  void dispose() {
    widget.submit.dispose();
    super.dispose();
  }

  void _publish(VoidCallback? save) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.submit.value = save;
    });
  }

  Future<void> _save() async {
    if (_source == ChatSource.none && widget.chat.source != ChatSource.none) {
      final confirmed = await NzBottomSheet.show<bool>(
        context,
        title: context.l10n.uiMessagesGroupsCloseSource,
        description: context.l10n.uiMessagesGroupsCloseConfirm,
        builder: (_) => const SizedBox.shrink(),
        actions: (sheet) => nzSheetActions(
          sheet,
          cancel: context.l10n.uiMessagesCancel,
          ok: context.l10n.uiMessagesGroupsCloseSource,
          onOk: () => Navigator.of(sheet).pop(true),
        ),
      );
      if (!mounted || confirmed != true) return;
    }
    if (mounted) Navigator.of(context).pop((_source, _departmentId));
  }

  @override
  Widget build(BuildContext context) {
    final sources = ref.watch(chatGroupSourcesProvider);
    if (sources.error case final e?) {
      _publish(null);
      return NzErrorState(
        error: toApiError(e),
        onRetry: () => ref.invalidate(chatGroupSourcesProvider),
      );
    }
    final options = sources.isLoading || sources.hasError
        ? null
        : sources.value;
    if (options == null) {
      _publish(null);
      return const NzLoader();
    }
    final sameOwner =
        _program == ref.watch(scopeStateProvider).programId &&
        _session == ref.watch(sessionGenerationProvider);
    final valid =
        _source != ChatSource.department ||
        options.departments.any((d) => d.id == _departmentId);
    final changed =
        _source != widget.chat.source ||
        _departmentId != widget.chat.sourceDepartmentId;
    _publish(valid && changed && sameOwner ? _save : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space3,
      children: [
        ChatGroupSourceFields(
          source: _source,
          departmentId: valid ? _departmentId : null,
          departments: options.departments,
          enabled: sameOwner,
          onChanged: (source, id) => setState(() {
            _source = source;
            _departmentId = id;
          }),
        ),
      ],
    );
  }
}
