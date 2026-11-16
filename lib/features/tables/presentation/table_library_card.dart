import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/table_card_preview.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import 'table_sheets.dart';
import 'table_texts.dart';

class TableLibraryCard extends ConsumerWidget {
  const TableLibraryCard({
    super.key,
    required this.document,
    required this.onOpen,
  });
  final TableDocument document;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = document;
    final preview = source.remote
        ? ref.watch(tableCardPreviewProvider(source))
        : null;
    final workspace = preview?.value;
    final d = workspace?.document ?? source;
    final fields = d.fields.take(3).toList();
    final choices = ref.watch(tableSharingChoicesProvider).value;
    final owner = source.remote
        ? (source.ownerId == choices?.accountId
              ? 'senin'
              : choices?.people[TablePersonId(source.ownerId)])
        : source.id.startsWith('demo-plan-')
        ? context.l10n.tableDemoPerson('demo-1')
        : 'senin';
    final names = <String>[
      if (source.remote) ...[
        if (source.ownerId == choices?.accountId)
          ?choices!.accountName
        else
          ?owner,
      ] else ...[
        context.l10n.uiTablesOwner,
        ...d.people.keys.map((p) => context.l10n.tableDemoPerson(p.value)),
      ],
    ];
    Widget cell(String text, int index, {bool heading = false}) => Expanded(
      flex: index == 0 ? 3 : 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: heading
              ? context.text.monoSm.copyWith(color: context.colors.textFaint)
              : context.text.caption.copyWith(color: context.colors.textMuted),
        ),
      ),
    );
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final rowHeight = 26 * textScale;
    return NzTap(
      onTap: onOpen,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.colors.text,
                      context.colors.text,
                      context.colors.text.withValues(alpha: 0),
                    ],
                    stops: const [0, .6, 1],
                  ).createShader(bounds),
                  child: ColoredBox(
                    color: context.colors.surfaceRaised,
                    child: SizedBox(
                      height: rowHeight * 4,
                      child: Column(
                        children: [
                          SizedBox(
                            height: rowHeight,
                            child: Row(
                              children: [
                                for (var i = 0; i < fields.length; i++)
                                  cell(fields[i].name, i, heading: true),
                              ],
                            ),
                          ),
                          for (var row = 0; row < 3; row++)
                            Container(
                              height: rowHeight,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: context.colors.border),
                                ),
                              ),
                              child: Row(
                                children: [
                                  for (var i = 0; i < fields.length; i++)
                                    cell(
                                      row >= d.rows.length
                                          ? ''
                                          : workspace != null
                                          ? workspace
                                                .cell(
                                                  d.rows[row].id,
                                                  fields[i].id,
                                                )
                                                .display
                                          : tableCellText(
                                              context,
                                              fields[i],
                                              d.rows[row].cells[TableFieldId(
                                                fields[i].id,
                                              )],
                                              ref
                                                  .read(
                                                    tablesControllerProvider,
                                                  )
                                                  .documents,
                                            ),
                                      i,
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    source.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    preview?.isLoading == true
                        ? 'Önizleme yükleniyor…'
                        : preview?.hasError == true
                        ? 'Önizleme alınamadı'
                        : '${d.rows.length}${workspace?.cursor != null ? '+' : ''} satır · ${d.fields.length} sütun${owner == null ? '' : ' · $owner'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: NzAvatarStack(
                        colored: true,
                        max: 4,
                        names: names.toSet().toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
