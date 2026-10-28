import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import 'catalog_entry.dart';

// Prototip ekranlarının (Görevler, ayrıntı, koordinatörlükler, arşiv, mesajlar) ortak kiti.
// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'prototype kit';

CatalogEntry _entry(String name, WidgetBuilder builder) =>
    CatalogEntry(group: _group, name: name, builder: builder);

Widget _trigger(String label, VoidCallback onPressed) => Align(
  alignment: Alignment.centerLeft,
  child: NzButton.secondary(label: label, onPressed: onPressed),
);

List<CatalogEntry> get prototypeKitCatalogEntries => [
  _entry(
    'NzTopBar.detail (code / title)',
    (_) => SizedBox(
      height: 160,
      child: CustomScrollView(
        slivers: [
          NzTopBar.detail(
            code: 'ALT-7',
            onBack: () {},
            actions: [
              NzIconButton(
                icon: Icons.edit_outlined,
                semanticLabel: 'Edit',
                onPressed: () {},
              ),
              NzIconButton(
                icon: Icons.more_vert_rounded,
                semanticLabel: 'More',
                onPressed: () {},
              ),
            ],
          ),
          NzTopBar.detail(
            title: 'Activity history',
            onBack: () {},
            actions: [
              NzIconButton(
                icon: Icons.download_rounded,
                semanticLabel: 'Download CSV',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  ),
  _entry(
    'NzPageHeader + NzIconButton.circle / circleAccent',
    (context) => NzPageHeader(
      title: 'Tasks',
      subtitle: '11 groups · 76 tasks',
      actions: [
        NzIconButton.circle(
          icon: Icons.search_rounded,
          semanticLabel: 'Search',
          onPressed: () {},
        ),
        NzIconButton.circle(
          icon: Icons.tune_rounded,
          semanticLabel: 'Filters',
          dot: context.colors.accentText,
          onPressed: () {},
        ),
        NzIconButton.circleAccent(
          icon: Icons.add_rounded,
          semanticLabel: 'New task',
          onPressed: () {},
        ),
      ],
    ),
  ),
  _entry('NzPillTabs', (_) => const _PillTabsDemo()),
  _entry(
    'NzSearchField (pill)',
    (_) => const NzSearchField(hint: 'Title, id or person'),
  ),
  _entry('NzFormRows', (_) => const _FormRowsDemo()),
  _entry(
    'NzBottomSheet (description + actions + expandable)',
    (context) => _trigger(
      'Open',
      () => NzBottomSheet.show<void>(
        context,
        title: 'New task',
        description: 'Single-line properties open in place.',
        expandable: true,
        actions: (sheet) => [
          NzButton.secondary(
            label: 'Cancel',
            onPressed: () => Navigator.of(sheet).pop(),
          ),
          NzButton.primary(
            label: 'Create',
            onPressed: () => Navigator.of(sheet).pop(),
          ),
        ],
        builder: (_) => const _FormRowsDemo(),
      ),
    ),
  ),
  _entry(
    'NzStatusLabel (dot / badge)',
    (_) => const Wrap(
      spacing: NizamioSpacing.space4,
      runSpacing: NizamioSpacing.space2,
      children: [
        NzStatusLabel(label: 'Not started', tone: NzTone.neutral),
        NzStatusLabel(label: 'In progress', tone: NzTone.progress),
        NzStatusLabel(label: 'Waiting', tone: NzTone.waiting),
        NzStatusLabel(label: 'Late', tone: NzTone.danger),
        NzStatusLabel(label: 'Done', tone: NzTone.done),
        NzStatusLabel.badge(label: '98 days late', tone: NzTone.danger),
        NzStatusLabel.badge(label: 'Request · 2', tone: NzTone.waiting),
      ],
    ),
  ),
  _entry(
    'NzAvatar tones / sizes + NzAvatarStack',
    (_) => Wrap(
      spacing: NizamioSpacing.space2,
      runSpacing: NizamioSpacing.space2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < NzAvatar.toneCount; i++)
          NzAvatar.initials(name: 'Sample Name', tone: i),
        for (final e in NzAvatarSize.values)
          NzAvatar.initials(
            name: 'Kadir Ozbek',
            extent: e,
            tone: NzAvatar.neutralTone,
          ),
        const NzAvatarStack(
          names: ['Abdullah Ates', 'Ali Avci', 'Kadir Ozbek', 'Merve Koc'],
          colored: true,
        ),
      ],
    ),
  ),
  _entry(
    'NzKicker',
    (_) => NzKicker(
      'all tasks · 76',
      emphasis: true,
      action: TextButton(onPressed: () {}, child: const Text('By due date')),
    ),
  ),
  _entry(
    'NzTaskCard',
    (_) => NzTaskCard(
      code: 'ALT-5',
      group: 'Infrastructure',
      title: 'Pour the water tank foundation concrete',
      statusLabel: 'In progress',
      statusTone: NzTone.progress,
      start: const NzTaskCardDate(caption: 'start', value: '16.06.2026'),
      end: const NzTaskCardDate(
        caption: 'due',
        value: '15.07.2026',
        overdue: true,
      ),
      priorityCaption: 'priority',
      priority: 'High',
      priorityLevel: 3,
      subtaskProgress: 2 / 3,
      subtaskText: '2/3 subtasks',
      assignees: const ['Kadir Ozbek'],
      assigneeText: 'Kadir Ozbek',
      badge: '98 days late',
      onTap: () {},
    ),
  ),
  _entry(
    'NzToast (prototype)',
    (context) => Wrap(
      spacing: NizamioSpacing.space2,
      runSpacing: NizamioSpacing.space2,
      children: [
        for (final tone in NzToastTone.values)
          NzButton.secondary(
            label: tone.name,
            onPressed: () => NzToast.show(context, 'Task created', tone: tone),
          ),
      ],
    ),
  ),
];

class _PillTabsDemo extends StatefulWidget {
  const _PillTabsDemo();

  @override
  State<_PillTabsDemo> createState() => _PillTabsDemoState();
}

class _PillTabsDemoState extends State<_PillTabsDemo> {
  var _a = 0;
  var _b = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      NzPillTabs(
        selected: _a,
        onSelected: (i) => setState(() => _a = i),
        tabs: const [
          NzPillTab(label: 'Active', count: 12),
          NzPillTab(label: 'Done', count: 40),
          NzPillTab(label: 'Deleted', count: 3),
        ],
      ),
      const Gap(NizamioSpacing.space3),
      NzPillTabs(
        selected: _b,
        onSelected: (i) => setState(() => _b = i),
        tabs: const [
          NzPillTab(label: 'List', icon: Icons.view_list_rounded),
          NzPillTab(label: 'Timeline', icon: Icons.view_timeline_outlined),
        ],
      ),
    ],
  );
}

class _FormRowsDemo extends StatefulWidget {
  const _FormRowsDemo();

  @override
  State<_FormRowsDemo> createState() => _FormRowsDemoState();
}

class _FormRowsDemoState extends State<_FormRowsDemo> {
  int? _open;
  var _proof = false;

  @override
  Widget build(BuildContext context) => NzFormRows(
    expandedIndex: _open,
    onToggle: (i) => setState(() => _open = _open == i ? null : i),
    rows: [
      NzFormRow(
        icon: Icons.apartment_outlined,
        label: 'Group',
        value: 'Not selected',
        content: Padding(
          padding: const EdgeInsets.fromLTRB(
            NizamioSpacing.space10,
            0,
            NizamioSpacing.space4,
            NizamioSpacing.space3,
          ),
          child: Text('Options', style: context.text.bodyMd),
        ),
      ),
      const NzFormRow(
        icon: Icons.event_outlined,
        label: 'Due',
        value: '15 Jul',
        valueSet: true,
        content: Text('Calendar'),
      ),
      NzFormRow.toggle(
        icon: Icons.attach_file_rounded,
        label: 'Proof required',
        value: _proof,
        onChanged: (v) => setState(() => _proof = v),
      ),
      const NzFormRow.custom(
        leading: NzPriorityBars(level: 2),
        label: 'Priority',
        trailing: NzStatusLabel(label: 'Medium', tone: NzTone.neutral),
      ),
    ],
  );
}
