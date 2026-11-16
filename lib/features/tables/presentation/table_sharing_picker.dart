import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_expansion_tile.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import 'table_texts.dart';

class TablePermissionControl extends StatelessWidget {
  const TablePermissionControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });
  final TableAccess value;
  final ValueChanged<TableAccess> onChanged;
  final String label;
  @override
  Widget build(BuildContext context) => NzPillTabs(
    compact: true,
    semanticLabel: label,
    tabs: const [
      NzPillTab(label: 'Görüntüleme'),
      NzPillTab(label: 'Düzenleme'),
    ],
    selected: value == TableAccess.edit ? 1 : 0,
    onSelected: (i) => onChanged(i == 0 ? TableAccess.view : TableAccess.edit),
  );
}

/// Oluşturulacak paylaşımın özeti ve rol gruplarından kişi seçimi.
class TableSharingPeople extends StatelessWidget {
  const TableSharingPeople({
    super.key,
    required this.choices,
    required this.people,
    required this.query,
    required this.department,
    required this.prototype,
    required this.onChanged,
    required this.onRemove,
    this.groupByDepartment = true,
    this.selectionLabel = 'Paylaşılan kişiler',
    this.addLabel = 'Kişi ekle',
    this.showOwner = true,
  });
  final TableSharingChoices? choices;
  final Map<TablePersonId, TableAccess> people;
  final String query;
  final String? department;
  final bool prototype;
  final bool groupByDepartment;
  final String selectionLabel;
  final String addLabel;
  final bool showOwner;
  final void Function(TablePersonId, TableAccess) onChanged;
  final ValueChanged<TablePersonId> onRemove;
  String _name(BuildContext c, TablePersonId id) =>
      choices?.people[id] ?? c.l10n.tableDemoPerson(id.value);
  TableSharingRole _role(TablePersonId id, [String? group]) {
    final role = choices?.roles[id] ?? TableSharingRole.unknown;
    if (role == TableSharingRole.admin || group == null) return role;
    final leads = choices?.coordinators[TableDepartmentId(group)];
    if (leads == null) return role;
    return leads.contains(id)
        ? TableSharingRole.coordinator
        : TableSharingRole.member;
  }

  String _roleLabel(TableSharingRole role) => switch (role) {
    TableSharingRole.admin => 'Admin',
    TableSharingRole.coordinator => 'Koordinatör',
    TableSharingRole.member => 'Üye',
    TableSharingRole.unknown => 'Kişi',
  };
  List<TablePersonId> _ordered(
    BuildContext context,
    Iterable<TablePersonId> ids, [
    String? group,
  ]) => ids.toList()
    ..sort((a, b) {
      final rank = _role(a, group).index.compareTo(_role(b, group).index);
      return rank != 0 ? rank : _name(context, a).compareTo(_name(context, b));
    });
  Widget _candidate(BuildContext context, TablePersonId id, [String? group]) {
    void toggle() =>
        people.containsKey(id) ? onRemove(id) : onChanged(id, TableAccess.view);
    return Material(
      type: MaterialType.transparency,
      child: NzTap(
        onTap: toggle,
        child: Padding(
          padding: const EdgeInsets.only(left: NizamioSpacing.space3),
          child: Row(
            children: [
              Expanded(
                child: Text(_name(context, id), style: context.text.labelMd),
              ),
              const Gap(NizamioSpacing.space2),
              Text(
                _roleLabel(_role(id, group)),
                style: context.text.caption.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
              NzCheckCircle(
                value: people.containsKey(id),
                label: '${_name(context, id)} paylaşımı',
                onChanged: toggle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final available =
        (prototype
                ? const [
                    TablePersonId('demo-1'),
                    TablePersonId('demo-2'),
                    TablePersonId('demo-3'),
                    TablePersonId('demo-4'),
                  ]
                : choices?.peopleIn(department).keys.toList() ??
                      <TablePersonId>[])
            .where((id) => _name(context, id).toLowerCase().contains(query))
            .toList();
    final groups = prototype
        ? {const TableDepartmentId('DEMO-A'): context.l10n.tableUnit('DEMO-A')}
        : choices?.departments ?? <TableDepartmentId, String>{};
    bool belongs(TablePersonId id, TableDepartmentId group) =>
        prototype || choices?.memberships[id]?.contains(group.value) == true;
    final ungrouped = available
        .where((id) => !groups.keys.any((g) => belongs(id, g)))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(selectionLabel, style: context.text.labelLg)),
            Text(
              '${people.length + (showOwner ? 1 : 0)} kişi',
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space2),
        if (showOwner)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space2,
            ),
            child: Row(
              children: [
                NzAvatar.initials(
                  name: choices?.accountName ?? 'Sen',
                  extent: NzAvatarSize.list,
                  tone: NzAvatar.neutralTone,
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        choices?.accountName == null
                            ? 'Sen'
                            : '${choices!.accountName} (sen)',
                        style: context.text.labelMd,
                      ),
                      if (choices != null &&
                          _role(TablePersonId(choices!.accountId)) !=
                              TableSharingRole.unknown)
                        Text(
                          _roleLabel(_role(TablePersonId(choices!.accountId))),
                          style: context.text.caption.copyWith(
                            color: context.colors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                const NzBadge.neutral(label: 'Sahip'),
              ],
            ),
          ),
        for (final id in _ordered(context, people.keys))
          _person(context, id, people[id]!),
        const Gap(NizamioSpacing.space4),
        Text(addLabel, style: context.text.labelLg),
        if (available.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space3,
            ),
            child: Text(
              'Eklenecek kişi bulunamadı.',
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
              ),
            ),
          ),
        if (!groupByDepartment)
          for (final id in _ordered(context, available, department))
            _candidate(context, id, department)
        else ...[
          for (final group in groups.entries)
            if (available.any((id) => belongs(id, group.key)))
              Material(
                key: ValueKey(group.key),
                type: MaterialType.transparency,
                child: NzExpansionTile(
                  title: Text(group.value, style: context.text.labelMd),
                  subtitle: Text(
                    '${available.where((id) => belongs(id, group.key) && people.containsKey(id)).length} seçili',
                    style: context.text.caption,
                  ),
                  children: [
                    for (final id in _ordered(
                      context,
                      available.where((id) => belongs(id, group.key)),
                      group.key.value,
                    ))
                      _candidate(context, id, group.key.value),
                  ],
                ),
              ),
          if (ungrouped.isNotEmpty)
            Material(
              key: const ValueKey('ungrouped'),
              type: MaterialType.transparency,
              child: NzExpansionTile(
                title: Text('Diğer kişiler', style: context.text.labelMd),
                children: [
                  for (final id in _ordered(context, ungrouped))
                    _candidate(context, id),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _person(BuildContext context, TablePersonId id, TableAccess access) {
    final name = _name(context, id);
    final identity = Row(
      children: [
        NzAvatar.initials(
          name: name,
          extent: NzAvatarSize.list,
          tone: NzAvatar.neutralTone,
        ),
        const Gap(NizamioSpacing.space3),
        Expanded(
          child: Wrap(
            spacing: NizamioSpacing.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelMd,
              ),
              if (_role(id, department) != TableSharingRole.unknown)
                Text(
                  _roleLabel(_role(id, department)),
                  style: context.text.caption.copyWith(
                    color: context.colors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
    final permission = TablePermissionControl(
      value: access,
      label: '$name erişim yetkisi',
      onChanged: (v) => onChanged(id, v),
    );
    final remove = NzIconButton(
      icon: NzIcons.close,
      semanticLabel: '$name paylaşımını kaldır',
      onPressed: () => onRemove(id),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space2),
        child: LayoutBuilder(
          builder: (context, box) => box.maxWidth >= 440
              ? Row(
                  children: [
                    Expanded(child: identity),
                    const Gap(NizamioSpacing.space2),
                    SizedBox(width: 208, child: permission),
                    remove,
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: identity),
                        remove,
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: permission,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
