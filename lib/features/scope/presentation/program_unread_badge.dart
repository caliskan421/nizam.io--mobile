import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../messages/messages.dart';

/// Program seçimi sayaç okumasını beklemez; sayı ve bahsetme ayrı anlam taşır.
class ProgramUnreadBadge extends ConsumerWidget {
  const ProgramUnreadBadge({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(chatUnreadBadgesProvider).value;
    final unread = programs?.where((p) => p.programId == programId).firstOrNull;
    if (unread == null || (unread.unreadChats == 0 && !unread.mentioned)) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    return Semantics(
      label: [
        if (unread.unreadChats > 0)
          '${unread.unreadChats} ${l.uiMessagesListsUnreadChats}',
        if (unread.mentioned) l.uiMessagesListsMentioned,
      ].join(', '),
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (unread.unreadChats > 0)
            NzBadge.neutral(label: '${unread.unreadChats}', size: NzSize.sm),
          if (unread.mentioned) const NzBadge.info(label: '@', size: NzSize.sm),
        ],
      ),
    );
  }
}
