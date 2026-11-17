import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import '../domain/conference.dart';
import '../domain/meeting.dart';
import 'meetings_texts.dart';

/// Görüşmedeki kişinin görünen adı ve rolü. Ad: token adı, yoksa toplantı katılımcısı, yoksa
/// katalog. Rol: kendin için toplantıdaki rolün (`viewer_role`); diğerleri için toplantıya bağlı
/// departmandaki ekip rolü (K72), katılımcı değilse boş.
class ConferenceNames {
  ConferenceNames(this.l, this.room, this.catalog);

  final AppLocalizations l;
  final MeetingRoom? room;
  final TaskCatalog? catalog;

  /// Avatar ve ad (kendin için de gerçek ad).
  String fullName(ConferencePeer p) {
    if (p.name.trim().isNotEmpty) return p.name.trim();
    final listed = room?.detail.participants
        .where((x) => x.accountId == p.id)
        .firstOrNull;
    return listed?.fullName ??
        catalog?.nameOf(p.id) ??
        (p.isLocal ? l.uiMeetingsCallYou : l.uiMeetingsUnknownPerson);
  }

  /// Etiketteki ad (kendin "Sen").
  String label(ConferencePeer p) =>
      p.isLocal ? l.uiMeetingsCallYou : fullName(p);

  String role(ConferencePeer p) {
    final r = room;
    if (r == null) return '';
    if (p.isLocal) return l.meetingRole(r.detail.viewerRole);
    final listed = r.detail.participants
        .where((x) => x.accountId == p.id)
        .firstOrNull;
    if (listed == null) return '';
    final linked = {for (final d in r.meeting.departments) d.id};
    final lead = listed.teams.any(
      (t) => t.coordinator && linked.contains(t.departmentId),
    );
    return l.meetingRole(lead ? MeetingRole.coordinator : MeetingRole.member);
  }
}

/// Avatar tonunun rengi (`avatar1…5`, [NzAvatar.toneOf]).
Color conferenceTone(BuildContext context, String name) {
  final c = context.colors;
  final fills = [c.avatar1, c.avatar2, c.avatar3, c.avatar4, c.avatar5];
  return fills[NzAvatar.toneOf(name) % fills.length];
}

/// Kamerası olmayan karonun zemini: kişinin tonundan ortada yumuşak degrade.
BoxDecoration conferenceBackdrop(BuildContext context, String name) =>
    BoxDecoration(
      gradient: RadialGradient(
        center: const Alignment(0, -0.25),
        radius: 0.95,
        colors: [
          conferenceTone(context, name).withValues(alpha: .26),
          context.colors.surface,
        ],
      ),
    );

/// Katılımcı ızgarası: telefonda iki sütun (tek kişide tam), geniş ekranda kişi sayısına göre
/// 2–4 sütun; kutular sığarsa alanı doldurur, sığmazsa kaydırılır.
class ConferenceGrid extends StatelessWidget {
  const ConferenceGrid({super.key, required this.peers, required this.names});

  final List<ConferencePeer> peers;
  final ConferenceNames names;

  static int columnsFor(int n, {required bool wide}) {
    if (n <= 1) return 1;
    if (!wide || n <= 4) return 2;
    if (n <= 9) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        const gap = NizamioSpacing.space3;
        const minHeight = 160.0;
        final n = math.max(peers.length, 1);
        final cols = columnsFor(n, wide: box.maxWidth >= 700);
        final rows = (n / cols).ceil();
        final width = (box.maxWidth - gap * (cols - 1)) / cols;
        final fit = (box.maxHeight - gap * (rows - 1)) / rows;
        // Tek satırda kutu en çok 4:3'ten uzun olmaz (geniş ekranda iki kişi yan yana).
        final height = math.max(math.min(fit, width * 1.6), minHeight);
        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: fit >= minHeight
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: gap,
            crossAxisSpacing: gap,
            childAspectRatio: width / height,
          ),
          itemCount: peers.length,
          itemBuilder: (context, i) =>
              ConferenceTile(peer: peers[i], names: names),
        );
      },
    );
  }
}

/// Katılımcı karosu: video ya da degrade zemin + baş harfli avatar; altta "Ad Rol"; konuşan
/// vurgulu (birincil renk çerçeve); kamera kapalıysa sağ üstte simge. [compact] ekran paylaşımı
/// şeridi içindir: küçük avatar, dar kenar boşluğu, rol yok.
class ConferenceTile extends StatelessWidget {
  const ConferenceTile({
    super.key,
    required this.peer,
    required this.names,
    this.compact = false,
  });

  final ConferencePeer peer;
  final ConferenceNames names;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final name = names.fullName(peer);
    final role = compact ? '' : names.role(peer);
    final video = peer.video;
    final inset = compact ? NizamioSpacing.space2 : NizamioSpacing.space3;
    final radius = BorderRadius.circular(NizamioRadius.card);
    return Semantics(
      label: [names.label(peer), role].where((x) => x.isNotEmpty).join(' · '),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: peer.speaking ? c.primary : c.border,
            width: peer.speaking ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (video is lk.VideoTrack && peer.cameraOn)
                ColoredBox(
                  color: c.surface,
                  child: lk.VideoTrackRenderer(
                    video,
                    key: ValueKey(video.sid),
                    fit: lk.VideoViewFit.cover,
                  ),
                )
              else
                DecoratedBox(
                  decoration: conferenceBackdrop(context, name),
                  child: Center(
                    child: NzAvatar.initials(
                      name: name,
                      tone: NzAvatar.toneOf(name),
                      extent: compact ? NzAvatarSize.md : NzAvatarSize.profile,
                    ),
                  ),
                ),
              if (!peer.cameraOn)
                Positioned(
                  top: inset,
                  right: inset,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.background,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: NzIcon(
                        NzIcons.videoOff,
                        size: 14,
                        color: c.text,
                        semanticLabel: l.uiMeetingsCallCameraOff,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: inset,
                right: inset,
                bottom: inset,
                child: Row(
                  children: [
                    if (!peer.micOn) ...[
                      NzIcon(
                        NzIcons.micOff,
                        size: 14,
                        color: c.danger,
                        semanticLabel: l.uiMeetingsCallMuted,
                      ),
                      const Gap(NizamioSpacing.space1),
                    ],
                    Flexible(
                      child: Text(
                        names.label(peer),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.labelMd.copyWith(
                          color: c.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (role.isNotEmpty) ...[
                      const Gap(6),
                      Text(
                        role,
                        maxLines: 1,
                        style: t.caption.copyWith(color: c.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ConferenceButtonTone { normal, selected, danger }

/// Görüşme çubuğunun yuvarlak düğmesi (kontrol çubuğu ve mini pencere): nötr dolgu, seçili
/// (açık panel) ters renk, ayrıl kırmızı. Kendi ipucu katmanı yoktur (mini pencere uygulama
/// kökünde, Overlay dışında çizilir); adı [label] ile okunur.
class ConferenceButton extends StatelessWidget {
  const ConferenceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tone = ConferenceButtonTone.normal,
    this.extent = 56,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final ConferenceButtonTone tone;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, ink) = switch (tone) {
      ConferenceButtonTone.normal => (c.surfaceRaised, c.text),
      ConferenceButtonTone.selected => (c.text, c.background),
      ConferenceButtonTone.danger => (c.danger, c.onDanger),
    };
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: enabled ? fill : fill.withValues(alpha: .5),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: extent,
            height: extent,
            child: Center(
              child: NzIcon(
                icon,
                size: extent * .4,
                color: enabled ? ink : ink.withValues(alpha: .5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
