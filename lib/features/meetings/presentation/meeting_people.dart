import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/turkish_collation.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import '../domain/meeting.dart';
import 'meeting_page.dart';
import 'meeting_parts.dart';
import 'meetings_texts.dart';

/// Katılımcının listedeki yeri: toplantıya bağlı departmanlardan ekibinde olduğu ilki (sahip
/// önde) ve oradaki rolü; hiçbirinde değilse "Diğer" grubu. Katılımcı satırı sunucuda yalnız
/// kimlik + ad taşır; rol ve departman katalogdaki ekipten okunur.
@immutable
class _Person {
  const _Person(this.p, {required this.lead});

  final MeetingParticipant p;
  final bool lead;
}

/// Kişiler (prototip Kişiler bölümü): katılımcı sayısı + ekle; departman gruplarında önce
/// koordinatörler, üyeler açılır satırda; bağlı koordinatöre çıkar (COLLABORATION-K21).
class MeetingPeople extends ConsumerStatefulWidget {
  const MeetingPeople({super.key, required this.room, required this.actions});

  final MeetingRoom room;
  final MeetingActions actions;

  @override
  ConsumerState<MeetingPeople> createState() => _MeetingPeopleState();
}

class _MeetingPeopleState extends ConsumerState<MeetingPeople> {
  /// Üyeleri açık gruplar (departman kimliği; "Diğer" için boş dize).
  final _open = <String>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final room = widget.room;
    final m = room.meeting;
    final manage = room.permissions.canManageParticipants;
    final placed = <String>{};
    final groups = <(MeetingDepartment?, List<_Person>)>[];
    for (final d in ownerFirst(m)) {
      final team = catalog?.coordinatorship(d.id);
      final ps = <_Person>[
        for (final p in room.detail.participants)
          if (!placed.contains(p.accountId) &&
              (team?.team.contains(p.accountId) ?? false))
            _Person(p, lead: team!.leads.contains(p.accountId)),
      ];
      placed.addAll(ps.map((x) => x.p.accountId));
      if (ps.isNotEmpty) groups.add((d, ps));
    }
    final rest = [
      for (final p in room.detail.participants)
        if (!placed.contains(p.accountId)) _Person(p, lead: false),
    ];
    if (rest.isNotEmpty) groups.add((null, rest));
    final total = room.detail.participants.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        NzKicker(
          '$total ${l.uiMeetingsPeopleTail}',
          action: manage
              ? NzButton.secondary(
                  label: l.uiMeetingsAdd,
                  icon: NzIcons.add,
                  size: NzSize.sm,
                  onPressed: () => _showAdd(context, catalog),
                )
              : null,
        ),
        for (final (d, ps) in groups)
          _group(context, d, ps, catalog, manage: manage),
        if (groups.isEmpty)
          Text(
            l.uiMeetingsPeopleEmpty,
            textAlign: TextAlign.center,
            style: t.caption.copyWith(color: c.textMuted),
          ),
      ],
    );
  }

  Widget _group(
    BuildContext context,
    MeetingDepartment? d,
    List<_Person> ps,
    TaskCatalog? catalog, {
    required bool manage,
  }) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final key = d?.id ?? '';
    int byName(_Person a, _Person b) =>
        compareTurkish(a.p.fullName, b.p.fullName);
    final leads = ps.where((x) => x.lead).toList()..sort(byName);
    final members = ps.where((x) => !x.lead).toList()..sort(byName);
    // Koordinatör yoksa üyeler doğrudan görünür (açılır satır gereksiz).
    final collapse = leads.isNotEmpty && members.isNotEmpty;
    final open = !collapse || _open.contains(key);
    Widget row(_Person x) => _PersonRow(
      name: x.p.fullName,
      role: x.lead ? l.uiMeetingsRoleCoordinator : l.uiMeetingsRoleMember,
      onRemove: manage
          ? () => widget.actions.removeParticipant(x.p.accountId, x.p.fullName)
          : null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Semantics(
            header: true,
            child: Row(
              children: [
                if (d != null) ...[
                  Text(
                    meetingDeptLabel(catalog, d),
                    style: t.monoSm.copyWith(fontSize: 11, color: c.textFaint),
                  ),
                  const Gap(NizamioSpacing.space2),
                ],
                Expanded(
                  child: Text(
                    d == null
                        ? l.uiMeetingsOtherGroup
                        : meetingDeptName(catalog, d),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySm.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '${ps.length}',
                  style: t.monoSm.copyWith(fontSize: 11, color: c.textFaint),
                ),
              ],
            ),
          ),
        ),
        NzMenuGroup(
          rows: [
            for (final x in leads) row(x),
            if (collapse)
              Semantics(
                button: true,
                expanded: open,
                child: InkWell(
                  onTap: () =>
                      setState(() => open ? _open.remove(key) : _open.add(key)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 46),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          AnimatedRotation(
                            turns: open ? .25 : 0,
                            duration: NizamioMotion.durSheet,
                            child: NzIcon(
                              NzIcons.chevronRight,
                              size: NizamioSize.iconSizeSm,
                              color: c.textMuted,
                            ),
                          ),
                          const Gap(NizamioSpacing.space2),
                          Text(
                            '${members.length} ${l.uiMeetingsMembersTail}',
                            style: t.bodySm.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (open)
              for (final x in members) row(x),
          ],
        ),
      ],
    );
  }

  /// Katılımcı ekle: toplantıya bağlı koordinatörlüklerin ekibinden henüz katılımcı olmayanlar
  /// (sunucu ayrıca programın kadrosunu denetler, K21).
  Future<void> _showAdd(BuildContext context, TaskCatalog? catalog) async {
    final l = context.l10n;
    final room = widget.room;
    final seen = {for (final p in room.detail.participants) p.accountId};
    final candidates = [
      for (final d in ownerFirst(room.meeting))
        for (final id
            in catalog?.coordinatorship(d.id)?.team ?? const <String>[])
          if (seen.add(id))
            MeetingParticipant(
              accountId: id,
              fullName: catalog?.nameOf(id) ?? l.uiMeetingsUnknownPerson,
            ),
    ]..sort((a, b) => compareTurkish(a.fullName, b.fullName));
    final picked = await NzBottomSheet.show<List<MeetingParticipant>>(
      context,
      title: l.uiMeetingsAddPeopleTitle,
      description: l.uiMeetingsAddPeopleDesc,
      builder: (_) => _AddPeople(candidates: candidates),
    );
    if (picked == null || picked.isEmpty) return;
    await widget.actions.addParticipants(picked);
  }
}

/// Katılımcı ekleme seçimi (çoklu); "Ekle" seçilenleri döner.
class _AddPeople extends StatefulWidget {
  const _AddPeople({required this.candidates});

  final List<MeetingParticipant> candidates;

  @override
  State<_AddPeople> createState() => _AddPeopleState();
}

class _AddPeopleState extends State<_AddPeople> {
  final _picked = <String>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final people = widget.candidates;
    if (people.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space4),
        child: Text(
          l.uiMeetingsNoCandidates,
          style: context.text.caption.copyWith(color: c.textMuted),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final p in people)
          NzCheckbox(
            label: p.fullName,
            value: _picked.contains(p.accountId),
            onChanged: (v) => setState(
              () => v ? _picked.add(p.accountId) : _picked.remove(p.accountId),
            ),
          ),
        const Gap(NizamioSpacing.space3),
        Row(
          spacing: NizamioSpacing.space2,
          children: [
            for (final b in nzSheetActions(
              context,
              cancel: l.uiMeetingsCancel,
              ok: l.uiMeetingsAdd,
              onOk: _picked.isEmpty
                  ? null
                  : () => Navigator.of(context).pop([
                      for (final p in people)
                        if (_picked.contains(p.accountId)) p,
                    ]),
            ))
              Expanded(child: b),
          ],
        ),
      ],
    );
  }
}

/// Katılımcı satırı (prototip: avatar, ad, rol hapı, çıkar).
class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.name, required this.role, this.onRemove});

  final String name;
  final String role;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 54),
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: onRemove == null ? 14 : 6),
        child: Row(
          children: [
            NzAvatar.initials(
              name: name,
              tone: NzAvatar.toneOf(name),
              extent: NzAvatarSize.md,
            ),
            const Gap(10),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMd,
              ),
            ),
            const Gap(10),
            MeetingPill(label: role),
            if (onRemove case final remove?)
              NzIconButton(
                icon: NzIcons.close,
                semanticLabel: '$name · ${l.uiMeetingsRemovePerson}',
                onPressed: remove,
              ),
          ],
        ),
      ),
    );
  }
}
