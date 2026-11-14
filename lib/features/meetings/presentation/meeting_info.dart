import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import 'meeting_parts.dart';
import 'meetings_texts.dart';

/// Bilgi (prototip Bilgi bölümü): sahip, açan, davet türü (`invite_mode`), yer, oluşturulma,
/// görünürlük, konferans, görüntüleyen rolü; koordinatörlük listesi (dokunuş → koordinatörlük
/// ayrıntısı).
class MeetingInfo extends ConsumerWidget {
  const MeetingInfo({super.key, required this.room});

  final MeetingRoom room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final nav = context.appNav;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final m = room.meeting;
    final d = room.detail;
    final owner = m.departments
        .where((x) => x.id == m.ownerDepartmentId)
        .firstOrNull;
    final creator =
        d.participants
            .where((p) => p.accountId == m.createdByAccountId)
            .firstOrNull
            ?.fullName ??
        catalog?.nameOf(m.createdByAccountId) ??
        l.uiMeetingsUnknownPerson;
    final rows = [
      (
        l.uiMeetingsInfoOwner,
        owner == null
            ? '—'
            : '${meetingDeptLabel(catalog, owner)} · '
                  '${meetingDeptName(catalog, owner)}',
      ),
      (l.uiMeetingsInfoCreator, '$creator · ${l.meetingRole(m.createdByRole)}'),
      (l.uiMeetingsInfoInvite, l.meetingInviteKind(m)),
      (l.uiMeetingsInfoCreated, l.meetingDayMonth(m.createdAt)),
      (
        l.uiMeetingsInfoVisibility,
        m.byPerson
            ? l.uiMeetingsVisPeopleLong
            : m.membersIncluded
            ? l.uiMeetingsVisAllLong
            : l.uiMeetingsVisLeadsLong,
      ),
      (
        l.uiMeetingsInfoConference,
        d.conferenceAvailable ? l.uiMeetingsConfInfo : l.uiMeetingsConfInfoOff,
      ),
      (l.uiMeetingsInfoRole, l.meetingRole(d.viewerRole)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        NzMenuGroup(
          rows: [
            for (final (label, value) in rows)
              MeetingInfoRow(label: label, value: value),
            if (m.place case final place?)
              MeetingInfoRow(
                label: l.uiMeetingsInfoPlace,
                value: place,
                tapHint: m.placeLink == null ? null : l.uiMeetingsCopyLink,
                // Bağlantı dış uygulamada açılmaz (url_launcher yalnız mağaza hedefi,
                // ADR-0002); kopyalanır.
                onTap: switch (m.placeLink) {
                  null => null,
                  final link => () async {
                    await Clipboard.setData(
                      ClipboardData(text: link.toString()),
                    );
                    if (context.mounted) {
                      NzToast.show(context, l.uiMeetingsLinkCopied);
                    }
                  },
                },
              ),
          ],
        ),
        NzKicker(l.uiMeetingsCoordsKicker),
        NzMenuGroup(
          rows: [
            for (final x in ownerFirst(m))
              Semantics(
                button: true,
                child: InkWell(
                  onTap: () => nav.openCoordinatorship(x.id),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 44,
                            child: Text(
                              meetingDeptLabel(catalog, x),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.monoSm.copyWith(
                                fontSize: 12,
                                color: c.textMuted,
                              ),
                            ),
                          ),
                          const Gap(NizamioSpacing.space2),
                          Expanded(
                            child: Text(
                              meetingDeptName(catalog, x),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodyMd,
                            ),
                          ),
                          if (x.id == m.ownerDepartmentId) ...[
                            const Gap(NizamioSpacing.space2),
                            MeetingPill(
                              label: l.uiMeetingsOwnerBadge,
                              color: c.text,
                              bold: true,
                            ),
                          ],
                          const Gap(NizamioSpacing.space2),
                          NzIcon(
                            NzIcons.chevronRight,
                            size: NizamioSize.iconSizeSm,
                            color: c.textFaint,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Kişi kipinde departman seti değişmez (K73); not yalnız koordinatörlük kipinde.
        if (!m.byPerson)
          Text(
            l.uiMeetingsCoordNote,
            style: t.caption.copyWith(color: c.textMuted),
          ),
      ],
    );
  }
}
