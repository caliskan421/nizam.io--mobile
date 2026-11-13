import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/table_sync_controller.dart';
import '../application/table_view.dart';
import '../application/tables_providers.dart';

/// Tablo ekranının canlı kapsamı: ekran görünürken (kabuğun gizli bölmesinde `TickerMode`
/// kapalıdır) akış denetleyicisini dinler; dinleyen kalmayınca akış kapanır ve presence
/// silinir. Uygulama arka plana geçince ön plan bayrağı düşer (akış + presence kapanır),
/// dönünce yeniden açılır ve imleçten yakalanır.
class TableLiveScope extends ConsumerStatefulWidget {
  const TableLiveScope({super.key, required this.id, required this.child});
  final String id;
  final Widget child;

  @override
  ConsumerState<TableLiveScope> createState() => _TableLiveScopeState();
}

class _TableLiveScopeState extends ConsumerState<TableLiveScope> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: _onState);
  }

  void _onState(AppLifecycleState s) => ref
      .read(tablesForegroundProvider.notifier)
      .set(s == AppLifecycleState.resumed || s == AppLifecycleState.inactive);

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tableLiveVisible(context)) {
      ref.watch(tableSyncControllerProvider(widget.id));
    }
    return widget.child;
  }
}

/// Canlı akışın TEK görünürlük kararı: ekran görünür (kabuğun gizli bölmesinde `TickerMode`
/// kapalıdır). Akışı dinleyen her parça buna uyar; gizli ekran akışı açık tutmaz.
bool tableLiveVisible(BuildContext context) =>
    TickerMode.valuesOf(context).enabled;

/// Bağlantı durumu ve tablodaki diğer kişiler (seçili hücreleri varsa satır/sütun adıyla).
class TableLiveBar extends ConsumerWidget {
  const TableLiveBar({super.key, required this.id, required this.view});
  final String id;
  final TableView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (!tableLiveVisible(context)) return const SizedBox.shrink();
    final live = ref.watch(tableSyncControllerProvider(id));
    final status = switch (live.status) {
      TableLiveStatus.live => NzBadge.success(label: l.uiTablesLive),
      TableLiveStatus.connecting || TableLiveStatus.retrying => NzBadge.warning(
        label: l.uiTablesReconnecting,
      ),
      TableLiveStatus.offline => NzBadge.danger(label: l.uiTablesOffline),
      TableLiveStatus.idle => const SizedBox.shrink(),
    };
    final people = live.participants;
    String where(String? rowId, String? columnId) {
      if (rowId == null || columnId == null) return '';
      final row = view.rows.indexWhere((r) => r.id == rowId);
      final column = view.column(columnId)?.name;
      if (row < 0 || column == null) return '';
      return ' · ${row + 1}. ${l.uiTablesRow}, $column';
    }

    return Row(
      children: [
        status,
        if (people.isNotEmpty) ...[
          const Gap(8),
          Tooltip(
            message: [
              for (final p in people) '${p.name}${where(p.rowId, p.columnId)}',
            ].join('\n'),
            child: NzAvatarStack(
              colored: true,
              names: [for (final p in people) p.name],
              semanticLabel:
                  '${l.uiTablesHere}: ${people.map((p) => p.name).join(', ')}',
            ),
          ),
        ],
      ],
    );
  }
}
