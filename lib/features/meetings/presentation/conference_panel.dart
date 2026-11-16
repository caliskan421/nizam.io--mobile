import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/meeting_room_controller.dart';
import '../domain/conference.dart';
import 'conference_tiles.dart';
import 'meeting_agenda.dart';
import 'meeting_notes.dart';
import 'meeting_page.dart';
import 'meetings_texts.dart';

/// Görüşmedeki bölümler (toplantı ayrıntısının sekmeleri; Bilgi yok).
const conferenceSections = [
  MeetingSection.agenda,
  MeetingSection.notes,
  MeetingSection.people,
];

/// Görüşme paneli (tablette sağ sütun, telefonda alt sayfa): toplantı ayrıntısıyla aynı sekme
/// bileşeni ve sayaçlar; Gündem ve Notlar toplantı sayfasındaki bileşenlerin kendisidir (aynı
/// yazma eylemleri), Kişiler görüşmede olanlardır.
class ConferencePanel extends ConsumerWidget {
  const ConferencePanel({
    super.key,
    required this.id,
    required this.section,
    required this.onSection,
    required this.onClose,
    required this.peers,
    required this.names,
  });

  final String id;
  final MeetingSection section;
  final ValueChanged<MeetingSection> onSection;
  final VoidCallback onClose;
  final List<ConferencePeer> peers;
  final ConferenceNames names;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final room = ref.watch(meetingRoomControllerProvider(id)).value;
    final filter = ref
        .watch(meetingDetailViewControllerProvider(id))
        .noteFilter;
    final d = room?.detail;
    String? count(MeetingSection s) => switch (s) {
      MeetingSection.agenda when d != null =>
        '${d.agenda.where((a) => a.isChecked).length}/${d.agenda.length}',
      MeetingSection.notes when room != null => '${room.notes.length}',
      MeetingSection.people => '${peers.length}',
      _ => null,
    };
    final actions = MeetingActions(context, ref, id);
    return Semantics(
      container: true,
      label: l.uiMeetingsCallPanel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: NzPillTabs(
                  semanticLabel: l.uiMeetingsCallPanel,
                  compact: true,
                  selected: conferenceSections.indexOf(section),
                  onSelected: (i) => onSection(conferenceSections[i]),
                  tabs: [
                    for (final s in conferenceSections)
                      NzPillTab(
                        label: l.meetingSectionLabel(s),
                        countText: count(s),
                      ),
                  ],
                ),
              ),
              NzIconButton(
                icon: NzIcons.close,
                semanticLabel: l.uiMeetingsCallPanelClose,
                onPressed: onClose,
              ),
            ],
          ),
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: SingleChildScrollView(
              key: PageStorageKey(section),
              padding: const EdgeInsets.only(bottom: NizamioSpacing.space4),
              child: switch (section) {
                _ when room == null => const SizedBox.shrink(),
                MeetingSection.agenda => MeetingAgenda(
                  room: room,
                  actions: actions,
                ),
                MeetingSection.notes => MeetingNotes(
                  room: room,
                  filter: filter,
                  actions: actions,
                ),
                _ => _InCall(peers: peers, names: names),
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// "görüşmede" listesi: avatar, ad (kendin "Sen"), rol.
class _InCall extends StatelessWidget {
  const _InCall({required this.peers, required this.names});

  final List<ConferencePeer> peers;
  final ConferenceNames names;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.uiMeetingsCallInCall,
          style: t.monoSm.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space2),
        for (final p in peers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                NzAvatar.initials(
                  name: names.fullName(p),
                  tone: NzAvatar.toneOf(names.fullName(p)),
                  extent: NzAvatarSize.list,
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        names.label(p),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMd,
                      ),
                      if (names.role(p) case final role when role.isNotEmpty)
                        Text(
                          role,
                          style: t.caption.copyWith(color: c.textMuted),
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
