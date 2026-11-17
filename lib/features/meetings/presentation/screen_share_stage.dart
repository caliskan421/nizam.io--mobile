import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../domain/conference.dart';
import 'conference_tiles.dart';

/// Ekran paylaşımı sırasında sahne: paylaşılan ekran büyük alanda, kameralar altta (geniş
/// ekranda sağda) küçük şerit. Kendi paylaşımında ekranın kendisi değil açıklama ve "bitir"
/// gösterilir (ayna etkisi olmaz).
class ScreenShareStage extends StatelessWidget {
  const ScreenShareStage({
    super.key,
    required this.presenter,
    required this.peers,
    required this.names,
    required this.onStop,
  });

  final ConferencePeer presenter;
  final List<ConferencePeer> peers;
  final ConferenceNames names;

  /// Kendi paylaşımını bitir (yalnız [presenter] yerelse kullanılır).
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final side = box.maxWidth >= 700 && box.maxWidth > box.maxHeight;
        final screen = _SharedScreen(
          presenter: presenter,
          names: names,
          onStop: onStop,
        );
        final strip = _Strip(peers: peers, names: names, vertical: side);
        if (side) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: screen),
              const Gap(NizamioSpacing.space3),
              SizedBox(width: 180, child: strip),
            ],
          );
        }
        // Telefonda şerit yüksekliği alana göre: alçak alanda (yatay telefon) daralır.
        final stripHeight = (box.maxHeight * .24).clamp(72.0, 120.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: screen),
            const Gap(NizamioSpacing.space3),
            SizedBox(height: stripHeight, child: strip),
          ],
        );
      },
    );
  }
}

/// Paylaşılan ekran karosu: uzak paylaşım izi (sığdırılmış), iz gelene kadar yükleniyor;
/// kendi paylaşımında açıklama + bitir düğmesi.
class _SharedScreen extends StatelessWidget {
  const _SharedScreen({
    required this.presenter,
    required this.names,
    required this.onStop,
  });

  final ConferencePeer presenter;
  final ConferenceNames names;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final screen = presenter.screen;
    final caption = presenter.isLocal
        ? l.uiMeetingsCallSharingSelf
        : '${names.fullName(presenter)} ${l.uiMeetingsCallSharingTail}';
    final radius = BorderRadius.circular(NizamioRadius.card);
    final Widget content;
    if (presenter.isLocal) {
      content = Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(NizamioSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NzIconTile(icon: NzIcons.screenShare),
              const Gap(NizamioSpacing.space3),
              Text(caption, textAlign: TextAlign.center, style: t.titleMd),
              const Gap(NizamioSpacing.space2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  l.uiMeetingsCallSharingSelfDesc,
                  textAlign: TextAlign.center,
                  style: t.bodySm.copyWith(color: c.textMuted),
                ),
              ),
              const Gap(NizamioSpacing.space4),
              NzButton.secondary(
                label: l.uiMeetingsCallShareStop,
                icon: NzIcons.screenShareStop,
                onPressed: onStop,
              ),
            ],
          ),
        ),
      );
    } else if (screen is lk.VideoTrack) {
      content = lk.VideoTrackRenderer(
        screen,
        key: ValueKey(screen.sid),
        fit: lk.VideoViewFit.contain,
      );
    } else {
      content = const Center(child: NzLoader());
    }
    return Semantics(
      label: caption,
      container: true,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: c.border),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: c.surface,
            child: Stack(
              fit: StackFit.expand,
              children: [
                content,
                if (!presenter.isLocal)
                  Positioned(
                    left: NizamioSpacing.space3,
                    right: NizamioSpacing.space3,
                    top: NizamioSpacing.space3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: c.background,
                          borderRadius: BorderRadius.circular(
                            NizamioRadius.pill,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: NizamioSpacing.space3,
                            vertical: NizamioSpacing.space1,
                          ),
                          child: Text(
                            caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelMd.copyWith(color: c.text),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kamera şeridi: her kişi küçük karo (4:3), kaydırılabilir.
class _Strip extends StatelessWidget {
  const _Strip({
    required this.peers,
    required this.names,
    required this.vertical,
  });

  final List<ConferencePeer> peers;
  final ConferenceNames names;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final extent = vertical ? box.maxWidth * .75 : box.maxHeight * 4 / 3;
        return ListView.separated(
          scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: peers.length,
          separatorBuilder: (_, _) => const Gap(NizamioSpacing.space2),
          itemBuilder: (context, i) => SizedBox(
            width: vertical ? null : extent,
            height: vertical ? extent : null,
            child: ConferenceTile(peer: peers[i], names: names, compact: true),
          ),
        );
      },
    );
  }
}
