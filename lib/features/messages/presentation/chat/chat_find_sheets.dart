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
    } on ApiError catch (e) {
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

class _Shared extends ConsumerWidget {
  const _Shared(this.chatId, this.onFile);

  final String chatId;
  final void Function(String refId, String name) onFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(chatSharedControllerProvider(chatId));
    if (value.error case final e?) {
      return NzErrorState(
        error: toApiError(e),
        onRetry: () => ref.invalidate(chatSharedControllerProvider(chatId)),
      );
    }
    final s = value.value;
    if (s == null) return const NzLoader();
    if (s.items.isEmpty) return NzEmptyState(title: l.uiMessagesSharedEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        for (final item in s.items)
          ChatRefTile(
            refId: item.refId,
            kind: item.kind,
            onFile: (refId, name) {
              Navigator.of(context).pop();
              onFile(refId, name);
            },
          ),
        if (s.nextCursor != null)
          NzButton.secondary(
            label: l.uiMessagesMore,
            onPressed: () async {
              try {
                await ref
                    .read(chatSharedControllerProvider(chatId).notifier)
                    .more();
              } on ApiError catch (e) {
                if (context.mounted) {
                  NzToast.show(context, errorText(context.l10n, e));
                }
              }
            },
          ),
      ],
    );
  }
}
