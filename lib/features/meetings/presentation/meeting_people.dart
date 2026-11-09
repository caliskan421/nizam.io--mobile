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

/// Katılımcının listedeki yeri ve oradaki rolü (sunucu `Participant.teams`, COLLABORATION-K72).
@immutable
class _Person {
  const _Person(this.p, {required this.lead});

  final MeetingParticipant p;
  final bool lead;
}

/// Katılımcıları departman gruplarına böler: her kişi ekip satırlarından toplantıya bağlı ilk
/// departmanda (sahip önde), bağlı değilse ilk ekip satırının departmanında, ekip satırı yoksa
/// (yalnız yönetici) "Diğer" grubunda (null) bir kez yer alır. Gruplar: toplantının
/// departmanları sırasıyla, sonra diğer departmanlar görünüş sırasıyla, en sonda "Diğer".
List<(MeetingDepartment?, List<_Person>)> _groupPeople(
  Meeting m,
  List<MeetingParticipant> people,
) {
  final linked = [for (final d in ownerFirst(m)) d.id];
  final placed = [
    for (final p in people)
      (
        p,
        p.teams.where((t) => linked.contains(t.departmentId)).firstOrNull ??
            p.teams.firstOrNull,
      ),
  ];
  final teams = {
    for (final t in placed.map((x) => x.$2).nonNulls) t.departmentId: t,
  };
  final order = [
    for (final id in linked)
      if (teams.containsKey(id)) id,
    for (final id in teams.keys)
      if (!linked.contains(id)) id,
  ];
  final rest = [
    for (final (p, t) in placed)
      if (t == null) _Person(p, lead: false),
  ];
  return [
    for (final id in order)
      (
        m.departments.where((d) => d.id == id).firstOrNull ??
            MeetingDepartment(id: id, name: teams[id]!.departmentName),
        [
          for (final (p, t) in placed)
            if (t?.departmentId == id) _Person(p, lead: t!.coordinator),
        ],
      ),
    if (rest.isNotEmpty) (null, rest),
  ];
}

/// Kişiler (prototip Kişiler bölümü): katılımcı sayısı + ekle; departman gruplarında önce
/// koordinatörler, üyeler açılır satırda; yönetene çıkar (COLLABORATION-K21).
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
    // Kişi kipinde ekleme havuzu programın kişileridir; ekran açıkken önceden okunur.
    if (manage && m.byPerson) ref.watch(meetingInviteesProvider);
    final groups = _groupPeople(m, room.detail.participants);
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

  /// Katılımcı ekle: henüz katılımcı olmayanlar; `coordinatorship` kipinde toplantıya bağlı
  /// koordinatörlüklerin ekibinden, `person` kipinde programın kişilerinden
  /// ([meetingInviteesProvider]; eksik olabilirse açıkça yazılır). Sunucu ayrıca programın
  /// kadrosunu denetler (K21). Ekip satırları yeni satır sunucudan okunana dek havuzdan doldurulur.
  Future<void> _showAdd(BuildContext context, TaskCatalog? catalog) async {
    final l = context.l10n;
    final room = widget.room;
    final m = room.meeting;
    MeetingInvitees? invitees;
    if (m.byPerson) {
      try {
        invitees = await ref.read(meetingInviteesProvider.future);
      } on Object {
        invitees = null; // katalog ekipleri kalır; eksiklik aşağıda yazılır
      }
      if (!context.mounted) return;
    }
    final all =
        invitees?.groups ??
        catalog?.coordinatorships ??
        const <CoordinatorshipRef>[];
    final pool = m.byPerson
        ? all
        : [for (final d in ownerFirst(m)) ?catalog?.coordinatorship(d.id)];
    final seen = {for (final p in room.detail.participants) p.accountId};
    final candidates = [
      for (final co in pool)
        for (final id in co.team)
          if (seen.add(id))
            MeetingParticipant(
              accountId: id,
              fullName:
                  invitees?.nameOf(id) ??
                  catalog?.nameOf(id) ??
                  l.uiMeetingsUnknownPerson,
              teams: [
                for (final x in all)
                  if (x.team.contains(id))
                    ParticipantTeam(
                      departmentId: x.code,
                      departmentName: x.name,
                      coordinator: x.leads.contains(id),
                    ),
              ],
            ),
    ]..sort((a, b) => compareTurkish(a.fullName, b.fullName));
    final picked = await NzBottomSheet.show<List<MeetingParticipant>>(
      context,
      title: l.uiMeetingsAddPeopleTitle,
      description: m.byPerson
          ? l.uiMeetingsAddPeopleDescPerson
          : l.uiMeetingsAddPeopleDesc,
      builder: (_) => _AddPeople(
        candidates: candidates,
        note: m.byPerson && (invitees?.partial ?? true)
            ? l.uiMeetingsPoolPartial
            : null,
      ),
    );
    if (picked == null || picked.isEmpty) return;
    await widget.actions.addParticipants(picked);
  }
}

/// Katılımcı ekleme seçimi (çoklu); "Ekle" seçilenleri döner.
class _AddPeople extends StatefulWidget {
  const _AddPeople({required this.candidates, this.note});

  final List<MeetingParticipant> candidates;

  /// Havuz eksik olabilir uyarısı (yoksa null).
  final String? note;

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
    final note = widget.note == null
        ? null
        : Text(
            widget.note!,
            style: context.text.caption.copyWith(color: c.textMuted),
          );
    if (people.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: NizamioSpacing.space2,
          children: [
            Text(
              l.uiMeetingsNoCandidates,
              style: context.text.caption.copyWith(color: c.textMuted),
            ),
            ?note,
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note != null) ...[note, const Gap(NizamioSpacing.space2)],
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
