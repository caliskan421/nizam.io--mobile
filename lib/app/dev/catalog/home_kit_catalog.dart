import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import 'catalog_entry.dart';

// Ana sayfanın kullandığı kit bileşenleri (KPI, hızlı işlem, sıralama, filtre rayı, çubuk,
// menü grubu). Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'home kit';

CatalogEntry _entry(String name, WidgetBuilder builder) =>
    CatalogEntry(group: _group, name: name, builder: builder);

List<CatalogEntry> get homeKitCatalogEntries => [
  _entry(
    'NzKpiTile',
    (context) => NzKpiTile(
      icon: Icons.warning_amber_rounded,
      tone: context.colors.danger,
      valueColor: context.colors.danger,
      label: 'Late',
      value: '15',
      progress: 0.38,
      caption: '38% of open tasks',
      onTap: () {},
    ),
  ),
  _entry(
    'NzActionTile (primary / default)',
    (_) => Row(
      spacing: 8,
      children: [
        Expanded(
          child: NzActionTile(
            icon: Icons.add_rounded,
            label: 'New task',
            primary: true,
            onPressed: () {},
          ),
        ),
        Expanded(
          child: NzActionTile(
            icon: Icons.videocam_outlined,
            label: 'Meeting',
            onPressed: () {},
          ),
        ),
      ],
    ),
  ),
  _entry(
    'NzSplitButton',
    (_) => Align(
      alignment: Alignment.centerLeft,
      child: NzSplitButton(
        label: 'Late',
        semanticLabel: 'Change sort',
        onPressed: () {},
        icon: Icons.keyboard_arrow_down_rounded,
        iconSemanticLabel: 'Flip order',
        onIconPressed: () {},
      ),
    ),
  ),
  _entry(
    'NzFilterRail',
    (_) => NzFilterRail(
      semanticLabel: 'Status',
      selected: 1,
      onSelected: (_) {},
      options: const [
        NzFilterOption(label: 'All', count: 11),
        NzFilterOption(label: 'Late', count: 7),
        NzFilterOption(label: 'On track', count: 4),
        NzFilterOption(label: 'Unassigned', count: 1),
      ],
    ),
  ),
  _entry(
    'NzProgressBar (single / segments)',
    (context) => Column(
      spacing: 12,
      children: [
        NzProgressBar(value: 0.49, color: context.colors.accentText),
        NzProgressBar.segments(
          segments: [
            NzBarSegment(2, context.colors.textFaint),
            NzBarSegment(6, context.colors.inProgress),
            NzBarSegment(2, context.colors.warning),
            NzBarSegment(1, context.colors.accentText),
          ],
        ),
      ],
    ),
  ),
  _entry(
    'NzMenuGroup',
    (_) => NzMenuGroup(
      label: 'tracking',
      rows: [
        NzMenuRow(
          icon: Icons.home_outlined,
          label: 'Home',
          current: true,
          onTap: () {},
        ),
        NzMenuRow(icon: Icons.checklist_rounded, label: 'Tasks', onTap: () {}),
        NzMenuRow(
          icon: Icons.logout_rounded,
          label: 'Sign out',
          danger: true,
          onTap: () {},
        ),
      ],
    ),
  ),
];
