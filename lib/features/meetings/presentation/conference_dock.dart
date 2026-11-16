import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/active_conference.dart';
import '../application/conference_controller.dart';
import '../application/meeting_room_controller.dart';
import '../domain/conference.dart';
import 'conference_tiles.dart';
import 'meeting_parts.dart';

/// Görüşme ekranı kapalıyken süren görüşmenin yüzen mini penceresi (sağ alt): "● 3/25" rozeti,
/// konuşan (yoksa ilk diğer) kişinin avatarı, toplantı başlığı; mikrofon, büyüt (görüşme
/// ekranına dön), ayrıl. Uygulama kökünde (yönlendiricinin üstünde) çizilir; odada değilken
/// ya da görüşme ekranı açıkken hiçbir şey çizmez.
class ConferenceDock extends ConsumerWidget {
  const ConferenceDock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(activeConferenceControllerProvider).docked;
    if (id == null) return const SizedBox.shrink();
    final pad = MediaQuery.paddingOf(context);
    return Positioned(
      right: NizamioSpacing.space4 + pad.right,
      // Kabuğun yüzen alt menüsünün üstünde.
      bottom: pad.bottom + 96,
      child: _Window(id: id),
    );
  }
}

class _Window extends ConsumerWidget {
  const _Window({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = ref.watch(conferenceControllerProvider(id));
    final ctl = ref.read(conferenceControllerProvider(id).notifier);
    final room = ref.watch(meetingRoomControllerProvider(id)).value;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final names = ConferenceNames(l, room, catalog);
    final peers = view.peers;
    final face =
        peers.where((p) => p.speaking && !p.isLocal).firstOrNull ??
        peers.where((p) => !p.isLocal).firstOrNull ??
        peers.firstOrNull;
    final faceName = face == null ? '' : names.fullName(face);
    return Semantics(
      container: true,
      label: l.uiMeetingsCallLabel,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 196,
          padding: const EdgeInsets.all(NizamioSpacing.space3),
          decoration: conferenceBackdrop(context, faceName).copyWith(
            borderRadius: BorderRadius.circular(NizamioRadius.card),
            border: Border.all(color: c.borderStrong),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.background,
                    borderRadius: BorderRadius.circular(NizamioRadius.pill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const MeetingLiveDot(size: 6),
                        const Gap(5),
                        Text(
                          '${peers.length}/$conferenceCapacity',
                          style: t.monoSm.copyWith(color: c.accentText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(NizamioSpacing.space2),
              if (face != null)
                Center(
                  child: NzAvatar.initials(
                    name: faceName,
                    tone: NzAvatar.toneOf(faceName),
                    extent: NzAvatarSize.profile,
                  ),
                ),
              const Gap(NizamioSpacing.space3),
              Text(
                room?.meeting.title ?? l.uiMeetingsCallLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.labelMd.copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(NizamioSpacing.space2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConferenceButton(
                    icon: view.micOn ? NzIcons.mic : NzIcons.micOff,
                    label: view.micOn
                        ? l.uiMeetingsCallMicOn
                        : l.uiMeetingsCallMicOff,
                    onPressed: ctl.toggleMic,
                    extent: 48,
                  ),
                  ConferenceButton(
                    icon: NzIcons.openFull,
                    label: l.uiMeetingsCallExpand,
                    onPressed: () => context.appNav.openConference(id),
                    extent: 48,
                  ),
                  ConferenceButton(
                    icon: NzIcons.callEnd,
                    label: l.uiMeetingsCallLeave,
                    tone: ConferenceButtonTone.danger,
                    onPressed: ctl.leave,
                    extent: 48,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
