import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/domain/turkish_collation.dart';
import '../../../core/providers.dart';
import '../../archive/archive.dart';
import '../../tasks/tasks.dart';
import '../domain/chat.dart';
import '../domain/chat_share_option.dart';
import 'chat_group_sources.dart';

typedef ChatShareQuery = ({
  ChatRefKind kind,
  String query,
  String? cursor,
  int session,
  String? program,
});

/// Seçenekler yalnız seçili programın mevcut, yetkili okuma yüzlerinden gelir.
/// Arşiv imleci sorguya bağlıdır; görev/koordinatörlük katalog tavanı görünür tutulur.
final chatShareCandidatesProvider = FutureProvider.autoDispose
    .family<PageSlice<ChatShareOption>, ChatShareQuery>((ref, input) async {
      final session = ref.watch(sessionGenerationProvider);
      final program = ref.watch(scopeStateProvider.select((s) => s.programId));
      bool current() =>
          ref.mounted &&
          ref.read(sessionGenerationProvider) == session &&
          ref.read(scopeStateProvider).programId == program;
      if (program == null ||
          input.program != program ||
          input.session != session) {
        return PageSlice.empty();
      }
      if (input.kind == ChatRefKind.file) {
        final scope = await ref.watch(archiveScopeProvider.future);
        if (!current()) return PageSlice.empty();
        final repo = ref.read(archiveRepositoryProvider);
        final page = await repo.archiveAttachments(
          department: scope.department,
          filter: ArchiveAttachmentFilter(search: input.query.trim()),
          page: PageRequest(cursor: input.cursor),
        );
        if (!current()) return PageSlice.empty();
        return page.map(
          (f) => ChatShareOption(
            ref: ChatRefDraft(kind: ChatRefKind.file, targetId: f.id),
            label: f.displayName,
          ),
        );
      }
      final query = trLower(input.query.trim());
      if (input.kind == ChatRefKind.department) {
        final groups = await ref.watch(chatGroupSourcesProvider.future);
        if (!current()) return PageSlice.empty();
        return PageSlice(
          items: [
            for (final d in groups.departments)
              if (trLower(d.name).contains(query))
                ChatShareOption(
                  ref: ChatRefDraft(
                    kind: ChatRefKind.department,
                    targetId: d.id,
                  ),
                  label: d.name,
                ),
          ],
          truncated: groups.truncated,
        );
      }
      final catalog = await ref.watch(taskCatalogControllerProvider.future);
      if (!current()) return PageSlice.empty();
      final options = [
        for (final t in catalog.tasks)
          ChatShareOption(
            ref: ChatRefDraft(kind: ChatRefKind.task, targetId: t.id),
            label: t.title,
          ),
      ];
      return PageSlice(
        items: [
          for (final o in options)
            if (trLower(o.label).contains(query)) o,
        ],
        truncated: catalog.truncated,
      );
    });
