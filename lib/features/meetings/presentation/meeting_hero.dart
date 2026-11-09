import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import '../domain/meeting_status.dart';
import 'meeting_page.dart';
import 'meeting_parts.dart';
import 'meetings_texts.dart';

/// Kimlik (prototip `mdetail` kimlik bölümü): an (bugünse vurgulu), başlık, koordinatörlük
/// kodları + görünürlük hapı, sahip satırı, yer.
class MeetingHero extends ConsumerWidget {
  const MeetingHero({super.key, required this.room});

  final MeetingRoom room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final m = room.meeting;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = dayDiff(meetingDay(m), today) == 0;
    final owner = m.departments
        .where((d) => d.id == m.ownerDepartmentId)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          l.meetingWhenLine(m.meetingDate, today),
          style: t.monoSm.copyWith(
            fontSize: 12,
            color: isToday ? c.accentText : c.textMuted,
          ),
        ),
        Semantics(
          header: true,
          child: Text(
            m.title,
            style: t.titleLg.copyWith(fontSize: 24, height: 30 / 24),
          ),
        ),
        MeetingCodeChips(
          meeting: m,
          label: (d) => meetingDeptLabel(catalog, d),
          trailing: MeetingPill(
            label: m.byPerson
                ? l.uiMeetingsVisPeople
                : m.membersIncluded
                ? l.uiMeetingsVisMembers
                : l.uiMeetingsVisLeads,
            bold: true,
            color: m.membersIncluded ? c.roleMember : c.textMuted,
            fill: m.membersIncluded
                ? c.roleMember.withValues(alpha: .18)
                : c.surfaceOverlay,
          ),
        ),
        Text(
          l.meetingOwnerLine(
            m,
            owner == null
                ? ''
                : '${meetingDeptLabel(catalog, owner)} · '
                      '${meetingDeptName(catalog, owner)}',
            invited: !m.byPerson,
          ),
          style: t.caption.copyWith(color: c.textMuted),
        ),
        if (m.place case final place?)
          Text(
            '${l.uiMeetingsPlacePrefix} $place',
            style: t.caption.copyWith(color: c.textMuted),
          ),
      ],
    );
  }
}

/// Konferans kartı (prototip "Konferans"): durum başlığı ve alt satırı; canlıyken bağlı
/// kişiler (sayı ve avatar yığını, `conference.connected`, COLLABORATION-K78), bittiyse süre ve
/// saat aralığı (`last_conference`, K70). Yönetene başlat/bitir, toplantıyı gören herkese katıl.
/// Katılım ekranı henüz yok (ürün kararı).
class MeetingConferenceCard extends ConsumerWidget {
  const MeetingConferenceCard({
    super.key,
    required this.room,
    required this.actions,
  });

  final MeetingRoom room;
  final MeetingActions actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = room.detail;
    final m = d.meeting;
    final conf = d.conference;
    final manage = room.permissions.canManage;
    final now = DateTime.now();
    final status = room.status(now);
    final summary = room.summary;
    // Hiç gözlenmemiş görüntü (observed_at null) gösterilmez; eski görüntü (K78, > 3 dk) "şu an
    // bağlı" sayılmaz: zamanıyla yazılır, avatar ve "görüşmede" yığını çizilmez.
    final seen = conf?.connected.observedAt == null ? null : conf!.connected;
    final fresh = seen != null && seen.isFreshAt(now);
    final live = status?.phase == MeetingPhase.live;
    final finished = status?.phase == MeetingPhase.finished;
    final late = m.meetingDate.isBefore(now);
    final (String title, String sub, Color subColor) = switch (conf?.status) {
      ConferenceStatus.live => (
        l.uiMeetingsConfLive,
        [
          l.meetingSince(conf!.startedAt),
          if (seen != null) l.meetingConnected(seen, now),
        ].join(' · '),
        c.textMuted,
      ),
      ConferenceStatus.starting || ConferenceStatus.unknown => (
        l.uiMeetingsConfStarting,
        l.uiMeetingsConfStartingSub,
        c.textMuted,
      ),
      ConferenceStatus.ending => (
        l.uiMeetingsConfEnding,
        l.uiMeetingsConfEndingSub,
        c.textMuted,
      ),
      null when finished => (
        l.meetingStatusLabel(status!),
        '${l.meetingTime(summary.conferenceStartedAt!)} – '
            '${l.meetingTime(summary.conferenceEndedAt!)}',
        c.textMuted,
      ),
      null when !d.conferenceAvailable => (
        l.uiMeetingsConfNone,
        l.uiMeetingsConfOff,
        c.textMuted,
      ),
      null => (
        l.uiMeetingsConfNone,
        late ? l.uiMeetingsConfLateSub : l.uiMeetingsConfNoneSub,
        late ? c.warning : c.textMuted,
      ),
    };
    final active = conf != null && conf.status != ConferenceStatus.ending;
    final canStart = manage && !active && d.conferenceAvailable;
    // Canlıyken bağlı kişiler: hesap kimlikleri katılımcı adlarına (yoksa katalog adına) çevrilir.
    final names = {for (final p in d.participants) p.accountId: p.fullName};
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final faces = live && fresh
        ? [
            for (final id in seen.accountIds)
              names[id] ?? catalog?.nameOf(id) ?? l.uiMeetingsUnknownPerson,
          ]
        : const <String>[];
    return Semantics(
      container: true,
      label: l.uiMeetingsConfLabel,
      child: NzCard.outlined(
        padding: const EdgeInsets.all(NizamioSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            Row(
              children: [
                const NzIconTile(icon: NzIcons.video),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Row(
                        children: [
                          if (live) ...[const MeetingLiveDot(), const Gap(7)],
                          Flexible(
                            child: Text(
                              title,
                              style: t.labelLg.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(sub, style: t.caption.copyWith(color: subColor)),
                    ],
                  ),
                ),
                if (faces.isNotEmpty) ...[
                  const Gap(NizamioSpacing.space2),
                  NzAvatarStack(names: faces, max: 5, colored: true),
                ],
              ],
            ),
            if (active || canStart)
              Row(
                spacing: NizamioSpacing.space2,
                children: [
                  if (active && manage)
                    Expanded(
                      child: NzButton.secondary(
                        label: l.uiMeetingsConfEnd,
                        expand: true,
                        onPressed: actions.endConference,
                      ),
                    ),
                  Expanded(
                    child: active
                        ? NzButton.primary(
                            label: l.uiMeetingsConfJoin,
                            icon: NzIcons.video,
                            expand: true,
                            onPressed: actions.joinConference,
                          )
                        : NzButton.primary(
                            label: finished
                                ? l.uiMeetingsConfRestart
                                : l.uiMeetingsConfStart,
                            icon: NzIcons.video,
                            expand: true,
                            onPressed: actions.startConference,
                          ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
