import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/telemetry/report_source.dart';
import '../../../../core/telemetry/unexpected_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../application/chat_search_controller.dart';
import '../../application/chat_shared_controller.dart';
import '../../domain/chat.dart';
import 'chat_refs.dart';
import 'messages_texts.dart';

/// Sohbette ara (`listChatMessages?q=`): sonuç en yeniden eskiye; "daha eski sonuçlar" sonraki
/// sayfa. Seçilen sonuç döner (ekran mesaja gider).
Future<ChatMessage?> showChatSearch(BuildContext context, String chatId) =>
    NzBottomSheet.show<ChatMessage>(
      context,
      title: context.l10n.uiMessagesSearchChat,
      builder: (_) => _Search(chatId),
    );

class _Search extends ConsumerStatefulWidget {
  const _Search(this.chatId);

  final String chatId;

  @override
  ConsumerState<_Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<_Search> {
  ChatSearchController get _ctl =>
      ref.read(chatSearchControllerProvider(widget.chatId).notifier);

  Future<void> _run(Future<void> Function() op) async {
    try {
      await op();
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      if (mounted) NzToast.show(context, errorText(context.l10n, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = ref.watch(chatSearchControllerProvider(widget.chatId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        NzSearchField(
          label: l.uiMessagesSearchChat,
          hint: l.uiMessagesSearchInChatHint,
          onSubmitted: (q) => _run(() => _ctl.search(q)),
          onClear: () => _run(() => _ctl.search('')),
        ),
        for (final m in s.results)
          NzListTile(
            title: m.text,
            subtitle:
                '${m.senderName ?? ''} · ${l.listTime(m.at, DateTime.now())}',
            onTap: () => Navigator.of(context).pop(m),
          ),
        if (s.busy) const NzLoader(),
        if (!s.busy && s.query.isNotEmpty && s.results.isEmpty)
          Text(
            l.uiMessagesSearchEmpty,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        if (s.hasMore && !s.busy)
          NzButton.secondary(
            label: l.uiMessagesSearchMore,
            onPressed: () => _run(_ctl.more),
          ),
      ],
    );
  }
}

/// Paylaşılanlar (`listChatRefs`): kart başına tür, başlık ve alt satır; dosya kartı indirir.
Future<void> showChatShared(
  BuildContext context,
  String chatId, {
  required void Function(String refId, String name) onFile,
}) => NzBottomSheet.show<void>(
  context,
  title: context.l10n.uiMessagesShared,
  builder: (_) => _Shared(chatId, onFile),
);

class _Shared extends ConsumerStatefulWidget {
  const _Shared(this.chatId, this.onFile);

  final String chatId;
  final void Function(String refId, String name) onFile;

  @override
  ConsumerState<_Shared> createState() => _SharedState();
}

class _SharedState extends ConsumerState<_Shared> {
  ChatRefKind? _kind;

  Future<void> _run(Future<void> Function() operation) async {
    try {
      await operation();
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      if (mounted) NzToast.show(context, errorText(context.l10n, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = chatSharedControllerProvider(widget.chatId);
    final value = ref.watch(provider);
    final s = value.value;
    const kinds = [
      null,
      ChatRefKind.task,
      ChatRefKind.department,
      ChatRefKind.file,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        NzFilterRail(
          semanticLabel: l.uiMessagesListsSharedKind,
          options: [
            NzFilterOption(label: l.uiMessagesFilterAll),
            NzFilterOption(label: l.uiMessagesRefTask),
            NzFilterOption(label: l.uiMessagesRefDepartment),
            NzFilterOption(label: l.uiMessagesRefFile),
          ],
          selected: kinds.indexOf(_kind),
          onSelected: (i) {
            setState(() => _kind = kinds[i]);
            _run(() => ref.read(provider.notifier).setKind(_kind));
          },
        ),
        if (value.isLoading)
          const NzLoader()
        else if (value.error case final e?)
          NzErrorState(
            error: toApiError(e),
            onRetry: () => ref.invalidate(provider),
          )
        else if (s != null && s.items.isEmpty)
          NzEmptyState(title: l.uiMessagesSharedEmpty),
        if (!value.isLoading && !value.hasError && s != null)
          for (final item in s.items)
            ChatRefTile(
              refId: item.refId,
              kind: item.kind,
              targetId: item.targetId,
              onBeforeOpen: () => Navigator.of(context).pop(),
              onFile: (refId, name) {
                Navigator.of(context).pop();
                widget.onFile(refId, name);
              },
            ),
        if (!value.isLoading && !value.hasError && s?.nextCursor != null)
          NzButton.secondary(
            label: l.uiMessagesMore,
            loading: s!.busy,
            onPressed: s.busy
                ? null
                : () => _run(ref.read(provider.notifier).more),
          ),
      ],
    );
  }
}
