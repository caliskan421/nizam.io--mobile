import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_texts.dart';
import 'coord_widgets.dart';

void _toast(BuildContext context, String message) =>
    NzToast.show(context, message);

/// Genel sekmesi: özet (açık / geciken / tamamlanma + çubuk + not), dikkat gerektirenler,
/// kısayollar (zaman çizelgesi, arşiv klasörü, toplantılar, birim raporu).
class CoordGeneralTab extends StatelessWidget {
  const CoordGeneralTab({super.key, required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final nav = context.appNav;
    final d = detail;
    final s = d.stats;
    final name = s.name;
    // Prototip KPI'ları görev listesine gider; "geciken" gecikenler görünümüyle açılır
    // (görev listesinde koordinatörlük süzgeci gezinme niyetinde yok).
    void lateTasks() => nav.openTasks(view: NzTaskView.late);
    final kpis = [
      (l.uiCoordKpiOpen, '${s.open}', c.text, nav.openTasks),
      (
        l.uiCoordKpiLate,
        '${s.late}',
        s.late > 0 ? c.danger : c.text,
        lateTasks,
      ),
      (l.uiCoordKpiDone, l.coordPercent(s.ratio), c.text, nav.openTasks),
    ];
    final links = [
      (
        NzIcons.timeline,
        l.uiCoordLinkTimeline,
        '${s.total} ${l.uiCoordTasksTail}',
        () => nav.openTimeline(coordinatorship: s.code),
      ),
      (
        NzIcons.folder,
        l.uiCoordLinkArchive,
        l.coordFiles(d.profile.archiveFiles),
        () => nav.openArchiveFolder(s.code),
      ),
      (
        NzIcons.event,
        l.uiCoordLinkMeetings,
        l.coordMeetings(d.profile.meetings),
        () => _toast(context, '$name ${l.uiCoordToastMeetingsTail}'),
      ),
      (
        NzIcons.download,
        l.uiCoordLinkReport,
        l.uiCoordReportFormat,
        () => _toast(context, '$name ${l.uiCoordToastReportTail}'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          label: l.uiCoordSummary,
          explicitChildNodes: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.row),
            child: ColoredBox(
              color: c.surfaceRaised,
              child: Padding(
                padding: const EdgeInsets.all(NizamioSpacing.cardPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (i, (label, value, color, onTap))
                              in kpis.indexed)
                            Expanded(
                              child: _Kpi(
                                label: label,
                                value: value,
                                color: color,
                                divided: i > 0,
                                onTap: onTap,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(NizamioSpacing.rowPad),
                    NzProgressBar(value: s.ratio, color: c.accentText),
                    const Gap(NizamioSpacing.space2),
                    Text(
                      l.coordPctNote(d),
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (d.attention.isNotEmpty) ...[
          const Gap(NizamioSpacing.gapXl),
          NzKicker(
            l.uiCoordAttention,
            action: CoordLink(label: l.uiCoordAllTasks, onTap: lateTasks),
          ),
          const Gap(NizamioSpacing.space2),
          CoordGroup(
            children: [
              for (final a in d.attention)
                CoordRow(
                  minHeight: 58,
                  semanticLabel:
                      '${a.title}. ${l.coordAttentionWho(a)}. ${l.coordDaysLate(a)}',
                  onTap: () => nav.openTask(a.code),
                  child: Row(
                    children: [
                      NzDot(color: c.danger),
                      const Gap(NizamioSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: NizamioSpacing.space1 / 2,
                          children: [
                            Text(
                              a.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodyMd.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              l.coordAttentionWho(a),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.caption.copyWith(color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Gap(NizamioSpacing.space3),
                      Text(
                        l.coordDaysLate(a),
                        style: t.monoSm.copyWith(color: c.danger),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
        const Gap(NizamioSpacing.gapXl),
        Semantics(
          container: true,
          label: l.uiCoordShortcutsLabel,
          explicitChildNodes: true,
          child: CoordGroup(
            children: [
              for (final (icon, label, note, onTap) in links)
                CoordRow(
                  semanticLabel: '$label, $note',
                  vertical: NizamioSpacing.space1,
                  onTap: onTap,
                  child: Row(
                    children: [
                      NzIcon(
                        icon,
                        size: NizamioSize.iconSizeSm,
                        color: c.textMuted,
                      ),
                      const Gap(NizamioSpacing.space3),
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMd,
                        ),
                      ),
                      const Gap(NizamioSpacing.space2),
                      Text(note, style: t.caption.copyWith(color: c.textMuted)),
                      const Gap(NizamioSpacing.space2),
                      NzIcon(
                        NzIcons.chevronRight,
                        size: NizamioSize.iconSizeSm,
                        color: c.textFaint,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.label,
    required this.value,
    required this.color,
    required this.divided,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final bool divided;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      label: '$value $label',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: divided
                ? Border(
                    left: BorderSide(
                      color: c.border,
                      width: NizamioSize.borderWidth,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: divided ? NizamioSpacing.rowPad : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: t.numeral.copyWith(color: color)),
                Text(label, style: t.caption.copyWith(color: c.textMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Birimler sekmesi: alt birimler (ad, sorumlu, "3/4", çubuk) + "Ekle".
class CoordUnitsTab extends StatelessWidget {
  const CoordUnitsTab({super.key, required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
    final name = d.stats.name;
    String leadOf(String? id) =>
        [
          ...d.stats.leads,
          ...d.stats.members,
        ].where((p) => p.id == id).firstOrNull?.name ??
        l.uiCoordNoLead;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(
          l.uiCoordUnits,
          action: CoordLink(
            label: l.uiCoordAdd,
            onTap: () => _toast(context, '$name ${l.uiCoordToastAddUnitTail}'),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        CoordGroup(
          children: [
            for (final u in d.profile.units)
              CoordRow(
                semanticLabel:
                    '${u.name}. ${leadOf(u.leadId)}. ${l.coordUnitCount(u)}',
                vertical: NizamioSpacing.space3,
                onTap: () =>
                    _toast(context, '${u.name} ${l.uiCoordToastUnitTail}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodyMd.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                leadOf(u.leadId),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.caption.copyWith(color: c.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const Gap(NizamioSpacing.gapMd),
                        Text(
                          l.coordUnitCount(u),
                          style: t.monoSm.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                    const Gap(NizamioSpacing.space2),
                    NzProgressBar(value: u.ratio, color: c.accentText),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Ekip sekmesi: koordinatörler, açılır üye listesi ("N üye daha" / "Daralt"), "Üye ekle".
class CoordTeamTab extends StatelessWidget {
  const CoordTeamTab({
    super.key,
    required this.detail,
    required this.membersOpen,
    required this.onToggleMembers,
  });

  final CoordinatorshipDetail detail;
  final bool membersOpen;
  final VoidCallback onToggleMembers;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
    final name = d.stats.name;
    Widget person(TeamMember m) => CoordRow(
      minHeight: 56,
      semanticLabel:
          '${m.name}. ${m.unit}. ${m.lead ? l.uiCoordRoleLead : l.uiCoordRoleMember}',
      onTap: () => _toast(context, '${m.name} · ${l.uiCoordToastPersonTail}'),
      child: _PersonLine(
        avatar: NzAvatar.initials(
          name: m.name,
          tone: NzAvatar.neutralTone,
          extent: NzAvatarSize.md,
        ),
        title: m.name,
        subtitle: m.unit,
        role: m.lead ? l.uiCoordRoleLead : l.uiCoordRoleMember,
        roleColor: m.lead ? c.accentText : c.textMuted,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(
          l.coordTeamKicker(d.people),
          action: CoordLink(
            label: l.uiCoordAddMember,
            onTap: () => showInviteSheet(context),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        CoordGroup(
          children: [
            if (d.leads.isEmpty)
              CoordRow(
                minHeight: 56,
                semanticLabel:
                    '${l.uiCoordUnassigned}. ${l.uiCoordUnassignedHint}',
                onTap: () =>
                    _toast(context, '$name ${l.uiCoordToastPickLeadTail}'),
                child: _PersonLine(
                  avatar: const NzAvatar.icon(
                    icon: NzIcons.add,
                    tone: NzAvatar.neutralTone,
                    extent: NzAvatarSize.md,
                  ),
                  title: l.uiCoordUnassigned,
                  subtitle: l.uiCoordUnassignedHint,
                  role: l.uiCoordRoleAssign,
                  roleColor: c.text,
                  roleDot: c.warning,
                ),
              ),
            for (final m in d.leads) person(m),
            if (d.members.isNotEmpty) ...[
              NzReveal(
                open: membersOpen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final m in d.members) ...[
                      Divider(
                        height: NizamioSize.borderWidth,
                        thickness: NizamioSize.borderWidth,
                        color: c.border,
                      ),
                      person(m),
                    ],
                  ],
                ),
              ),
              CoordRow(
                minHeight: 48,
                expanded: membersOpen,
                semanticLabel: membersOpen
                    ? l.uiCoordCollapse
                    : l.coordMoreMembers(d.members.length),
                onTap: onToggleMembers,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        membersOpen
                            ? l.uiCoordCollapse
                            : l.coordMoreMembers(d.members.length),
                        style: t.bodyMd.copyWith(color: c.textMuted),
                      ),
                    ),
                    AnimatedRotation(
                      turns: membersOpen ? 0.5 : 0,
                      duration: NzMotion.of(context, NizamioMotion.durSheet),
                      curve: NizamioMotion.easeSpring,
                      child: NzIcon(
                        NzIcons.chevronDown,
                        size: NizamioSize.iconSizeSm,
                        color: c.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PersonLine extends StatelessWidget {
  const _PersonLine({
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.role,
    required this.roleColor,
    this.roleDot,
  });

  final Widget avatar;
  final String title;
  final String subtitle;
  final String role;
  final Color roleColor;
  final Color? roleDot;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final dot = roleDot;
    return Row(
      children: [
        avatar,
        const Gap(NizamioSpacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodyMd.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.caption.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ),
        const Gap(NizamioSpacing.space3),
        if (dot != null) ...[
          NzDot(color: dot, size: NizamioSize.statusDot),
          const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
        ],
        Text(role, style: t.monoSm.copyWith(color: roleColor)),
      ],
    );
  }
}

/// Hakkında sekmesi: açıklama + bilgiler (üst birim, kuruluş, görünürlük) ve son etkinlik
/// zaman çizgisi.
class CoordAboutTab extends StatelessWidget {
  const CoordAboutTab({super.key, required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
    final facts = [
      (l.uiCoordFactParent, d.profile.parent),
      (l.uiCoordFactFounded, l.coordDate(d.profile.founded)),
      (l.uiCoordFactVisibility, l.uiCoordVisibilityAll),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiCoordAbout),
        const Gap(NizamioSpacing.space2),
        CoordGroup(
          children: [
            Padding(
              padding: const EdgeInsets.all(NizamioSpacing.rowPad),
              child: Text(
                d.profile.about,
                style: t.bodyMd.copyWith(color: c.textMuted),
              ),
            ),
            for (final (k, v) in facts)
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 46),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.rowPad,
                    vertical: NizamioSpacing.space2,
                  ),
                  child: MergeSemantics(
                    child: Row(
                      children: [
                        Text(k, style: t.bodyMd.copyWith(color: c.textMuted)),
                        const Gap(NizamioSpacing.space3),
                        Expanded(
                          child: Text(
                            v,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodyMd,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const Gap(NizamioSpacing.gapXl),
        NzKicker(l.uiCoordFeed),
        const Gap(NizamioSpacing.gapMd),
        for (final (i, f) in d.feed.indexed)
          _FeedRow(item: f, last: i == d.feed.length - 1),
      ],
    );
  }
}

class _FeedRow extends StatelessWidget {
  const _FeedRow({required this.item, required this.last});

  final FeedItem item;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final f = item;
    return MergeSemantics(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: NizamioSpacing.rowPad,
              child: Column(
                children: [
                  const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
                  NzDot(color: c.textMuted, size: NizamioSize.statusDot),
                  const Gap(NizamioSpacing.space1),
                  Expanded(
                    child: last
                        ? const Gap(0)
                        : VerticalDivider(
                            width: NizamioSize.borderWidth,
                            thickness: NizamioSize.borderWidth,
                            color: c.borderStrong,
                          ),
                  ),
                ],
              ),
            ),
            const Gap(NizamioSpacing.space3),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: NizamioSpacing.rowPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: NizamioSpacing.space1 / 2,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: f.who,
                        style: t.caption.copyWith(
                          color: c.text,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${f.action}',
                            style: t.caption.copyWith(
                              color: c.textMuted,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      f.target,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(NizamioSpacing.space3),
            Text(
              l.coordShortDate(f.at),
              style: t.monoSm.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
