import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/conference_controller.dart';
import '../application/meeting_room_controller.dart';
import '../domain/conference.dart';
import 'conference_panel.dart';
import 'conference_tiles.dart';
import 'meeting_parts.dart';
import 'meetings_texts.dart';

/// Görüşme ekranı komutları (alt çubuk, üst satır, uyarı kapatma).
typedef ConferenceCommands = ({
  VoidCallback mic,
  VoidCallback camera,
  VoidCallback flip,
  VoidCallback panel,
  VoidCallback notes,
  VoidCallback minimize,
  VoidCallback leave,
  VoidCallback dismiss,
});

/// Bağlı oda görünümü: üst satır, uyarılar, ızgara, alt çubuk; panel tablette sağ sütun,
/// telefonda alttan açılan sayfa.
class ConferenceStage extends StatelessWidget {
  const ConferenceStage({
    super.key,
    required this.id,
    required this.view,
    required this.title,
    required this.startedAt,
    required this.names,
    required this.panel,
    required this.onPanel,
    required this.commands,
  });

  final String id;
  final ConferenceView view;
  final String title;
  final DateTime? startedAt;
  final ConferenceNames names;
  final MeetingSection? panel;
  final ValueChanged<MeetingSection?> onPanel;
  final ConferenceCommands commands;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final denied =
        view.micIssue == MediaIssue.denied ||
        view.cameraIssue == MediaIssue.denied;
    final missing = view.micIssue == MediaIssue.unavailable
        ? l.uiMeetingsCallNoMic
        : view.cameraIssue == MediaIssue.unavailable
        ? l.uiMeetingsCallNoCamera
        : null;
    final open = panel;
    final sheet = open == null
        ? null
        : ConferencePanel(
            id: id,
            section: open,
            onSection: onPanel,
            onClose: () => onPanel(null),
            peers: view.peers,
            names: names,
          );
    final main = Padding(
      padding: const EdgeInsets.fromLTRB(
        NizamioSpacing.space4,
        NizamioSpacing.space2,
        NizamioSpacing.space4,
        NizamioSpacing.space3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            title: title,
            count: view.peers.length,
            startedAt: startedAt,
            onNotes: commands.notes,
            onMinimize: commands.minimize,
          ),
          if (view.phase == ConferencePhase.reconnecting) ...[
            const Gap(NizamioSpacing.space2),
            NzBanner.warning(message: l.uiMeetingsCallReconnecting),
          ],
          if (denied) ...[
            const Gap(NizamioSpacing.space2),
            _DeniedPanel(onOk: commands.dismiss),
          ] else if (missing != null) ...[
            const Gap(NizamioSpacing.space2),
            NzBanner.info(
              message: missing,
              actionLabel: l.uiMeetingsCallOk,
              onAction: commands.dismiss,
            ),
          ],
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: ConferenceGrid(peers: view.peers, names: names),
          ),
          const Gap(NizamioSpacing.space4),
          _Controls(view: view, panelOpen: open != null, commands: commands),
        ],
      ),
    );
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: main),
          if (sheet != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(left: BorderSide(color: c.border)),
              ),
              child: SizedBox(
                width: 380,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    NizamioSpacing.space4,
                    NizamioSpacing.space2,
                    NizamioSpacing.space2,
                    0,
                  ),
                  child: sheet,
                ),
              ),
            ),
        ],
      );
    }
    // Telefon: panel ızgaranın üstüne alttan açılan sayfa.
    return Stack(
      children: [
        Positioned.fill(child: main),
        if (sheet != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.sizeOf(context).height * .62,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(NizamioRadius.sheet),
                ),
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  NizamioSpacing.space4,
                  NizamioSpacing.space2,
                  NizamioSpacing.space2,
                  0,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: c.borderStrong,
                        borderRadius: BorderRadius.circular(NizamioRadius.pill),
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    Expanded(child: sheet),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Üst satır: "● Canlı" rozeti + "3 / 25", başlık, başlangıç ve süre; sağda notlar ve küçült.
class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.count,
    required this.startedAt,
    required this.onNotes,
    required this.onMinimize,
  });

  final String title;
  final int count;
  final DateTime? startedAt;
  final VoidCallback onNotes;
  final VoidCallback onMinimize;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final at = startedAt;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: NizamioSpacing.space1,
            children: [
              Row(
                children: [
                  ConferenceLiveBadge(label: l.uiMeetingsConfLive),
                  const Gap(NizamioSpacing.space3),
                  Text(
                    '$count / $conferenceCapacity',
                    style: t.monoSm.copyWith(color: c.textMuted),
                  ),
                ],
              ),
              Semantics(
                header: true,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleMd,
                ),
              ),
              if (at != null)
                Text(
                  l.meetingStartedLine(at, DateTime.now()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.monoSm.copyWith(color: c.textMuted),
                ),
            ],
          ),
        ),
        const Gap(NizamioSpacing.space2),
        ConferenceButton(
          icon: NzIcons.document,
          label: l.uiMeetingsCallNotes,
          onPressed: onNotes,
          extent: 48,
        ),
        const Gap(NizamioSpacing.space2),
        ConferenceButton(
          icon: NzIcons.chevronDown,
          label: l.uiMeetingsCallMinimize,
          onPressed: onMinimize,
          extent: 48,
        ),
      ],
    );
  }
}

/// "● Canlı" rozeti (toplantı kartı ve mini pencereyle aynı dil).
class ConferenceLiveBadge extends StatelessWidget {
  const ConferenceLiveBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MeetingLiveDot(size: 7),
            const Gap(6),
            Text(
              label,
              style: context.text.labelMd.copyWith(
                color: c.accentText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// İzin reddi açıklaması: nereden açılacağı ve dinleyici olarak kalma.
class _DeniedPanel extends StatelessWidget {
  const _DeniedPanel({required this.onOk});

  final VoidCallback onOk;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NzIcon(NzIcons.warning, color: c.warning),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Text(
                  l.uiMeetingsCallDeniedTitle,
                  style: t.labelLg.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          Text(
            l.uiMeetingsCallDeniedDesc,
            style: t.bodySm.copyWith(color: c.textMuted),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: NzButton.ghost(label: l.uiMeetingsCallOk, onPressed: onOk),
          ),
        ],
      ),
    );
  }
}

/// Alt çubuk: mikrofon, kamera, çevir, panel (açıkken seçili), ayrıl (kırmızı).
class _Controls extends StatelessWidget {
  const _Controls({
    required this.view,
    required this.panelOpen,
    required this.commands,
  });

  final ConferenceView view;
  final bool panelOpen;
  final ConferenceCommands commands;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: NizamioSpacing.space3,
      runSpacing: NizamioSpacing.space2,
      children: [
        ConferenceButton(
          icon: view.micOn ? NzIcons.mic : NzIcons.micOff,
          label: view.micOn ? l.uiMeetingsCallMicOn : l.uiMeetingsCallMicOff,
          onPressed: commands.mic,
        ),
        ConferenceButton(
          icon: view.cameraOn ? NzIcons.video : NzIcons.videoOff,
          label: view.cameraOn ? l.uiMeetingsCallCamOn : l.uiMeetingsCallCamOff,
          onPressed: commands.camera,
        ),
        ConferenceButton(
          icon: NzIcons.flipCamera,
          label: l.uiMeetingsCallFlip,
          onPressed: view.cameraOn ? commands.flip : null,
        ),
        ConferenceButton(
          icon: NzIcons.viewList,
          label: l.uiMeetingsCallPanel,
          tone: panelOpen
              ? ConferenceButtonTone.selected
              : ConferenceButtonTone.normal,
          onPressed: commands.panel,
        ),
        ConferenceButton(
          icon: NzIcons.callEnd,
          label: view.canEnd ? l.uiMeetingsCallEnd : l.uiMeetingsCallLeave,
          tone: ConferenceButtonTone.danger,
          onPressed: commands.leave,
        ),
      ],
    );
  }
}
