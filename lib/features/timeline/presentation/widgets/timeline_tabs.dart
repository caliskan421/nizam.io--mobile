import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../application/gantt_provider.dart';
import '../../domain/timeline_rules.dart';

/// Koordinatör görünümünün iki sekmesi (koordinatörlüğün görevleri / görevlerim). Seçim
/// [timelineTabProvider]'da; telefon ve tablet aynı kümeyi görür. Başka görünümde boş.
class TimelineTabs extends ConsumerWidget {
  const TimelineTabs({super.key, this.padding = EdgeInsets.zero});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(timelineLensProvider.select((l) => l.tabs))) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final tab = ref.watch(timelineTabProvider);
    return Padding(
      padding: padding,
      child: NzPillTabs(
        semanticLabel: l.uiTimelineTabsLabel,
        selected: tab.index,
        onSelected: (i) => ref
            .read(timelineTabProvider.notifier)
            .select(TimelineTab.values[i]),
        tabs: [
          NzPillTab(label: l.uiTimelineTabDepartment),
          NzPillTab(label: l.uiTimelineTabMine),
        ],
      ),
    );
  }
}
