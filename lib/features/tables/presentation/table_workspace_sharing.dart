import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_avatar.dart';
import '../application/table_detail_controller.dart';
import '../application/table_team_sharing_job.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import 'table_design.dart';
import 'table_sheet_host.dart';
import 'table_workspace_forms.dart';
import 'table_workspace_organize.dart';

Future<void> workspaceSharing(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  await ref.read(tableSharingChoicesProvider.future);
  if (!context.mounted) return;
  final data = ref.read(tableDetailProvider(id)).data;
  if (data == null) return;
  await showTableSheet(
    ref,
    context,
    tableId: id,
    title: 'Paylaş: ${data.document.title}',
    actionsDivider: false,
    actions: (sheet) => [
      TableDesignButton(
        label: 'Bağlantıyı kopyala',
        icon: NzIcons.link,
        onPressed: () => tableUiAction(sheet, () async {
          await Clipboard.setData(ClipboardData(text: '/tables/$id'));
          if (sheet.mounted) NzToast.show(sheet, 'Tablo yolu kopyalandı.');
        }),
      ),
      TableDesignButton(
        label: 'Kapat',
        kind: TableButtonKind.primary,
        onPressed: () => Navigator.of(sheet).pop(),
      ),
    ],
    builder: (_) => _TableShareContent(id: id),
  );
}

class _TableShareContent extends ConsumerStatefulWidget {
  const _TableShareContent({required this.id});
  final String id;
  @override
  ConsumerState<_TableShareContent> createState() => _TableShareContentState();
}

class _TableShareContentState extends ConsumerState<_TableShareContent> {
  final _known = <TablePersonId, TableAccess>{};
  String _query = '';
  Map<TablePersonId, TableAccess>? _teamIntent;
  ({TablePersonId person, TableAccess access})? _intent;
  @override
  void initState() {
    super.initState();
    _known.addAll(
      ref.read(tableDetailProvider(widget.id)).data!.document.people,
    );
  }

  Future<void> _grant(TablePersonId person, TableAccess access) async {
    _intent = (person: person, access: access);
    final controller = ref.read(tableDetailProvider(widget.id).notifier);
    final data = ref.read(tableDetailProvider(widget.id)).data!;
    final choices = ref.read(tableSharingChoicesProvider).value!;
    final team = data.document.teamAccess;
    final teamOpen = team == TableAccess.view || team == TableAccess.edit;
    final plan = <TablePersonId, TableAccess>{
      if (teamOpen)
        for (final id in choices.teamPeopleIn(data.document.unit).keys)
          if (id.value != data.document.ownerId) id: team,
      for (final entry in _known.entries)
        if (entry.key.value != data.document.ownerId)
          entry.key: teamOpen && team.index > entry.value.index
              ? team
              : entry.value,
    };
    if (access == TableAccess.off) {
      plan.remove(person);
    } else {
      plan[person] = access;
    }
    _teamIntent = teamOpen ? Map.unmodifiable(plan) : null;
    final job = teamOpen
        ? TableTeamSharingJob(
            repository: controller.repository,
            location: controller.location,
            table: widget.id,
            people: plan,
            changed: person,
            access: access,
          )
        : null;
    final guard = controller.captureGuard();
    final done = job == null
        ? await controller.send(GrantTableAccess(person.value, access)) != null
        : await workspaceForm(
            context,
            ref,
            widget.id,
            title: 'Kişi bazlı paylaşıma geç',
            save: 'Kişi bazında uygula',
            description: 'Dinamik ekip paylaşımı kapanacak. Aşağıdaki kişilerin izinleri gösterilen şekilde kaydedilecek; sonradan katılanlar otomatik eklenmeyecek. Sunucu mevcut kişisel izinlerin tam listesini sağlamıyor; bu listedeki izinleri değiştirdiğini onaylıyorsun.',
            fields: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final entry in plan.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${choices.people[entry.key] ?? 'Kişi'} · ${entry.value == TableAccess.edit ? 'Düzenler' : 'Görür'}',
                    ),
                  ),
                if (access == TableAccess.off)
                  Text(
                    '${choices.people[person] ?? 'Kişi'} · Erişimi kaldırılacak',
                  ),
              ],
            ),
            submit: () async =>
                await controller.perform(
                  (_) => job.submit(isCurrent: guard),
                  retainOnError: () => job.started,
                ) !=
                null,
          );
    if (!mounted) return;
    if (done) {
      _confirmIntent();
    } else if (!ref.read(tableDetailProvider(widget.id)).pending) {
      _intent = null;
      _teamIntent = null;
    }
  }

  void _confirmIntent() {
    final intent = _intent;
    if (intent == null) return;
    setState(() {
      if (_teamIntent case final people?) {
        _known
          ..clear()
          ..addAll(people);
      }
      _teamIntent = null;
      if (intent.access == TableAccess.off) {
        _known.remove(intent.person);
      } else {
        _known[intent.person] = intent.access;
      }
      _intent = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final state = ref.watch(tableDetailProvider(id));
    final data = state.data;
    final choices = ref.watch(tableSharingChoicesProvider).value;
    if (data == null || choices == null) return const SizedBox.shrink();
    final owner = TablePersonId(data.document.ownerId);
    final canManage = data.document.access == TableAccess.owner;
    final locked = state.busy || state.pending || !canManage;
    final ownerName = owner.value == choices.accountId
        ? choices.accountName ?? 'Sen'
        : choices.people[owner] ?? 'Tablo sahibi';
    String role(TablePersonId person) => switch (choices.roles[person]) {
      TableSharingRole.admin => 'Admin',
      TableSharingRole.coordinator => 'Koordinatör',
      TableSharingRole.member => 'Üye',
      _ => 'Kişi',
    };
    String unit(TablePersonId person) => (choices.memberships[person] ?? {})
        .map((id) => choices.departments[TableDepartmentId(id)])
        .whereType<String>()
        .join(', ');
    Widget person(TablePersonId person, String name, TableAccess access) {
      final me = person.value == choices.accountId;
      final ownerRow = person == owner;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            final identity = Row(
              children: [
                NzAvatar.initials(
                  name: name,
                  extent: NzAvatarSize.md,
                  fillColor: choices.roles[person] == TableSharingRole.admin
                      ? context.colors.roleAdmin
                      : context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name${me ? ' (sen)' : ''}',
                        style: context.text.labelMd,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${role(person)}${unit(person).isEmpty ? '' : ' · ${unit(person)}'}',
                        style: context.text.caption.copyWith(
                          color: context.colors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            );
            final controls = ownerRow
                ? Text(
                    'Sahip',
                    style: context.text.monoSm.copyWith(
                      color: context.colors.textMuted,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 160,
                        child: NzPillTabs(
                          compact: true,
                          semanticLabel: '$name erişim yetkisi',
                          tabs: [
                            NzPillTab(label: 'Düzenler', enabled: !locked),
                            NzPillTab(label: 'Görür', enabled: !locked),
                          ],
                          selected: access == TableAccess.edit ? 0 : 1,
                          onSelected: (i) => _grant(
                            person,
                            i == 0 ? TableAccess.edit : TableAccess.view,
                          ),
                        ),
                      ),
                      NzIconButton(
                        icon: NzIcons.close,
                        semanticLabel: '$name erişimini kaldır',
                        onPressed: locked
                            ? null
                            : () => _grant(person, TableAccess.off),
                      ),
                    ],
                  );
            return box.maxWidth < 390 && !ownerRow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      identity,
                      const Gap(8),
                      Align(alignment: Alignment.centerRight, child: controls),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: identity),
                      const Gap(8),
                      controls,
                    ],
                  );
          },
        ),
      );
    }

    final candidates =
        choices
            .peopleIn(data.document.unit.isEmpty ? null : data.document.unit)
            .entries
            .where(
              (p) =>
                  p.key != owner &&
                  p.value.toLowerCase().contains(_query.toLowerCase()),
            )
            .toList()
          ..sort((a, b) {
            final rank = (choices.roles[a.key]?.index ?? 3).compareTo(
              choices.roles[b.key]?.index ?? 3,
            );
            return rank != 0 ? rank : a.value.compareTo(b.value);
          });
    final team = data.document.teamAccess;
    final displayed = <TablePersonId, TableAccess>{
      if (team == TableAccess.view || team == TableAccess.edit)
        for (final id in choices.teamPeopleIn(data.document.unit).keys)
          if (id != owner) id: team,
      for (final entry in _known.entries)
        entry.key: team.index > entry.value.index ? team : entry.value,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(8),
        Text(
          'Kişi ekle',
          style: context.text.caption.copyWith(color: context.colors.textMuted),
        ),
        const Gap(8),
        NzSearchField(
          label: 'Ad yaz',
          hint: 'Ad yaz',
          onChanged: (v) => setState(() => _query = v),
        ),
        if (_query.isNotEmpty) ...[
          const Gap(12),
          TableDesignCard(
            child: Column(
              children: [
                for (final p in candidates)
                  TableDesignButton(
                    label: '${p.value} · ${role(p.key)}',
                    icon: NzIcons.add,
                    kind: TableButtonKind.plain,
                    onPressed: locked
                        ? null
                        : () => _grant(p.key, TableAccess.view),
                  ),
                if (candidates.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Kişi bulunamadı.'),
                  ),
              ],
            ),
          ),
        ],
        const Gap(20),
        Text(
          'Erişimi doğrulananlar · ${displayed.keys.where((p) => p != owner).length + 1} kişi',
          style: context.text.monoSm.copyWith(color: context.colors.textMuted),
        ),
        const Gap(16),
        TableDesignCard(
          child: Column(
            children: [
              person(owner, ownerName, TableAccess.owner),
              for (final p in displayed.entries.where((p) => p.key != owner))
                person(
                  p.key,
                  choices.people[p.key] ??
                      (p.key.value == choices.accountId
                          ? choices.accountName ?? 'Sen'
                          : 'Kişi'),
                  p.value,
                ),
            ],
          ),
        ),
        const Gap(8),
        Text(
          team == TableAccess.off
              ? 'Tam kişisel erişim listesi bu sunucuda görüntülenemiyor. Bu ekranda doğrulanan kişileri yönetebilirsin.'
              : 'Mevcut ekip üyeleri seçili. Kişiye özel değişiklik ekip paylaşımını kişi bazına çevirir; sonradan katılanlar otomatik eklenmez.',
          style: context.text.caption.copyWith(color: context.colors.textMuted),
        ),
        if (state.error != null) ...[
          const Gap(8),
          Text(errorText(context.l10n, state.error!)),
          if (state.pending)
            TableDesignButton(
              label: 'Kaydı yeniden dene',
              kind: TableButtonKind.plain,
              onPressed: state.busy
                  ? null
                  : () async {
                      final r = await ref
                          .read(tableDetailProvider(id).notifier)
                          .retry();
                      if (mounted && r != null) _confirmIntent();
                    },
            ),
        ],
        const Gap(20),
        Text(
          'Birimler ve program',
          style: context.text.monoSm.copyWith(color: context.colors.textMuted),
        ),
        const Gap(16),
        TableDesignCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NzFormRows(
                rows: [
                  NzFormRow(
                    label: 'Birimler',
                    icon: NzIcons.coordinatorships,
                    value: data.document.unit.isEmpty
                        ? 'Kişisel tablo'
                        : choices.departments[TableDepartmentId(
                                data.document.unit,
                              )] ??
                              'Koordinatörlük',
                    valueSet: true,
                    onTap: data.document.unit.isEmpty && !locked
                        ? () => workspaceTransfer(context, ref, id)
                        : null,
                  ),
                ],
              ),
              if (data.document.unit.isNotEmpty) ...[
                const Gap(8),
                Text(
                  'Bu koordinatörlüğün mevcut ve sonradan katılan üyeleri',
                  style: context.text.caption.copyWith(
                    color: context.colors.textMuted,
                  ),
                ),
                const Gap(8),
                NzPillTabs(
                  compact: true,
                  tabs: [
                    for (final label in ['Kapalı', 'Görür', 'Düzenler'])
                      NzPillTab(label: label, enabled: !locked),
                  ],
                  selected: team == TableAccess.edit
                      ? 2
                      : team == TableAccess.view
                      ? 1
                      : 0,
                  onSelected: (i) => ref
                      .read(tableDetailProvider(id).notifier)
                      .send(
                        SetTableTeam(
                          [
                            TableAccess.off,
                            TableAccess.view,
                            TableAccess.edit,
                          ][i],
                        ),
                      ),
                ),
              ],
              const Gap(16),
              Text('Programdaki herkes', style: context.text.labelMd),
              const Gap(4),
              Text(
                'Yalnızca eklenen kişiler ve açık koordinatörlük paylaşımı',
                style: context.text.caption.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
              const Gap(12),
              NzPillTabs(
                compact: true,
                tabs: const [
                  NzPillTab(label: 'Kapalı'),
                  NzPillTab(label: 'Görür', enabled: false),
                  NzPillTab(label: 'Düzenler', enabled: false),
                ],
                selected: 0,
                onSelected: (_) {},
              ),
              const Gap(8),
              Text(
                'Program geneline paylaşım bu sunucuda kullanılamıyor.',
                style: context.text.caption.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
