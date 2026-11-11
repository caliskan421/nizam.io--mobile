import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_error.dart';
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
import '../../application/chat_share_candidates.dart';
import '../../domain/chat.dart';
import '../../domain/chat_share_option.dart';

String shareKindLabel(BuildContext context, ChatRefKind kind) => switch (kind) {
  ChatRefKind.task => context.l10n.uiMessagesComposeShareTask,
  ChatRefKind.department => context.l10n.uiMessagesComposeShareDepartment,
  ChatRefKind.file => context.l10n.uiMessagesComposeShareFile,
};

Future<ChatShareOption?> showChatSharePicker(
  BuildContext context,
  ChatRefKind kind,
) => NzBottomSheet.show<ChatShareOption>(
  context,
  title: shareKindLabel(context, kind),
  description: context.l10n.uiMessagesComposeShareDescription,
  builder: (_) => _SharePicker(kind: kind),
);

class _SharePicker extends ConsumerStatefulWidget {
  const _SharePicker({required this.kind});

  final ChatRefKind kind;

  @override
  ConsumerState<_SharePicker> createState() => _SharePickerState();
}

class _SharePickerState extends ConsumerState<_SharePicker> {
  final _search = TextEditingController();
  final _previous = <ChatShareOption>[];
  String? _cursor;

  void _reset() {
    _previous.clear();
    _cursor = null;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionGenerationProvider, (_, _) => _reset());
    ref.listen(
      scopeStateProvider.select((s) => s.programId),
      (_, _) => _reset(),
    );
    final l = context.l10n;
    final provider = chatShareCandidatesProvider((
      kind: widget.kind,
      query: _search.text,
      cursor: _cursor,
      session: ref.watch(sessionGenerationProvider),
      program: ref.watch(scopeStateProvider.select((s) => s.programId)),
    ));
    final data = ref.watch(provider);
    final page = data.isLoading || data.hasError ? null : data.value;
    final items = <ChatShareOption>[
      ..._previous,
      if (page != null)
        for (final item in page.items)
          if (!_previous.any(item.sameTarget)) item,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space2,
      children: [
        NzTextField(
          label: l.uiMessagesComposeShareSearch,
          controller: _search,
          onChanged: (_) => setState(() {
            _previous.clear();
            _cursor = null;
          }),
        ),
        for (final item in items)
          NzListTile(
            title: item.label,
            leading: NzIcon(switch (item.ref.kind) {
              ChatRefKind.task => NzIcons.tasks,
              ChatRefKind.department => NzIcons.coordinatorships,
              ChatRefKind.file => NzIcons.folder,
            }),
            onTap: () => Navigator.of(context).pop(item),
          ),
        if (data.isLoading) const NzLoader(),
        if (data.error case final error?)
          NzErrorState(
            error: toApiError(error),
            onRetry: () => ref.invalidate(provider),
          )
        else if (!data.isLoading && items.isEmpty)
          NzEmptyState(title: l.uiMessagesComposeShareEmpty),
        if (page?.truncated ?? false)
          NzBanner.warning(message: l.uiMessagesComposePartial),
        if (page?.nextCursor case final cursor?)
          NzButton.secondary(
            label: l.uiMessagesComposeMore,
            onPressed: data.isLoading
                ? null
                : () => setState(() {
                    _previous
                      ..clear()
                      ..addAll(items);
                    _cursor = cursor;
                  }),
          ),
      ],
    );
  }
}
