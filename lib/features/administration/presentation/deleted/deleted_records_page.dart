import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/page/nz_page.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../domain/deleted_records.dart';
import 'deleted_record_tabs.dart';

/// Silinenler (yalnız şirket yöneticisi): görev, toplantı, koordinatörlük ve kullanıcı
/// sekmeleri; her kayıtta geri yükleme ve kalıcı silme. Tablolar için geri yükleme ucu yok
/// (backend bekliyor), sekmesi yoktur. Geri yükleme reddinde neden ve çözüm gösterilir; çözüm
/// başka sekmedeyse oraya geçilir.
class DeletedRecordsPage extends StatefulWidget {
  const DeletedRecordsPage({super.key});

  @override
  State<DeletedRecordsPage> createState() => _DeletedRecordsPageState();
}

class _DeletedRecordsPageState extends State<DeletedRecordsPage> {
  var _kind = DeletedKind.task;

  void _goTo(DeletedKind k) => setState(() => _kind = k);

  @override
  Widget build(BuildContext context) => NzPage(
    title: 'Silinenler',
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzPillTabs(
          compact: true,
          semanticLabel: 'Silinen kayıt türü',
          tabs: [
            for (final k in DeletedKind.values)
              NzPillTab(label: deletedKindLabel(k)),
          ],
          selected: _kind.index,
          onSelected: (i) => _goTo(DeletedKind.values[i]),
        ),
        const Gap(NizamioSpacing.space3),
        Expanded(
          child: switch (_kind) {
            DeletedKind.task => DeletedTasksTab(onGoTo: _goTo),
            DeletedKind.meeting => DeletedMeetingsTab(onGoTo: _goTo),
            DeletedKind.coordinatorship => DeletedCoordinatorshipsTab(
              onGoTo: _goTo,
            ),
            DeletedKind.user => DeletedUsersTab(onGoTo: _goTo),
          },
        ),
      ],
    ),
  );
}
