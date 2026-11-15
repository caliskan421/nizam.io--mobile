import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';

final tableServerPreviewProvider = FutureProvider.autoDispose
    .family<TableDocument, String>((ref, id) async {
      final repository = ref.watch(tablesRepositoryProvider)!;
      // Liste sahipliği ve kapsam değişimi bu okumayı da geçersiz kılar.
      final state = ref.watch(tablesControllerProvider);
      final document = state.document(id);
      if (document == null) throw ApiError('tables.not_found');
      final choices = await ref.watch(tableSharingChoicesProvider.future);
      return repository.read(
        TableLocation(document.programId, document.unit),
        id,
        choices.accountId,
      );
    }, retry: (_, _) => null);

/// Canlı veriyi yerel prototip düzenleyicisinden ayrı, salt okunur gösterir.
class TableServerPreview extends ConsumerWidget {
  const TableServerPreview({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(tableServerPreviewProvider(id));
    return NzPage(
      title: 'Tablo',
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errorText(context.l10n, toApiError(e))),
              TextButton(
                onPressed: () => ref.invalidate(tableServerPreviewProvider(id)),
                child: const Text('Yeniden dene'),
              ),
            ],
          ),
        ),
        data: (d) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(d.title, style: context.text.titleSm),
            const Gap(8),
            Text('Salt okunur önizleme', style: context.text.caption),
            const Gap(16),
            if (d.fields.isEmpty)
              const Text('Henüz sütun eklenmemiş.')
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    for (final f in d.fields) DataColumn(label: Text(f.name)),
                  ],
                  rows: [
                    for (final r in d.rows)
                      DataRow(
                        cells: [
                          for (final f in d.fields)
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 240,
                                ),
                                child: Text(
                                  '${r.cells[TableFieldId(f.id)] ?? '—'}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            if (d.rows.isEmpty) const Text('Henüz kayıt eklenmemiş.'),
            if (d.previewHasMore) const Text('İlk 200 kayıt gösteriliyor.'),
          ],
        ),
      ),
    );
  }
}
