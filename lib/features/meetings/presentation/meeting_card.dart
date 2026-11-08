import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_summary_controller.dart';
import '../application/meetings_providers.dart';
import '../domain/meeting.dart';
import '../domain/meeting_status.dart';
import 'meeting_parts.dart';
import 'meetings_texts.dart';

/// Kartın geniş düzen eşiği (prototip `@container (min-width: 620px)`): kutu ortada, sayaçlar
/// ayrı sütunda.
const _wideCard = 620.0;

/// Toplantı kartı (prototip `.rp-mcard`): tarih kutusu (durumlu), başlık, koordinatörlük
/// çipleri, sahip satırı ve sayaçlar (gündem, not, kişi). Liste ucu sayaç ve konferans
/// taşımadığından (COLLABORATION-K51) sayaçlar ve canlı/bekliyor durumu kart başına ayrıntıdan
/// gelir ([meetingSummaryControllerProvider]); gelene kadar iskelet. Silinmiş toplantıda altta
/// "Sildi: … · tarih", geri yükle ve kalıcı sil ([onRestore], [onPurge]; yalnız yönetici).
class MeetingCard extends ConsumerWidget {
  const MeetingCard({
    super.key,
    required this.meeting,
    required this.catalog,
    this.onTap,
    this.onRestore,
    this.onPurge,
  });

  final Meeting meeting;
  final TaskCatalog? catalog;

  /// Silinmiş toplantıda kullanılmaz (açılmaz).
  final VoidCallback? onTap;
  final VoidCallback? onRestore;
  final VoidCallback? onPurge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final m = meeting;
    final deletedAt = m.deletedAt;
    final now = DateTime.now();
    final extras = ref
        .watch(meetingExtrasRepositoryProvider)
        .of(m, DateTime(now.year, now.month, now.day));
    // Silinmiş toplantının ayrıntısı okunamaz (COLLABORATION-K22): sayaç istenmez.
    final summary = deletedAt == null
        ? ref.watch(meetingSummaryControllerProvider(m.id))
        : null;
    final s = summary?.value;
    final status = deletedAt != null
        ? null
        : meetingStatus(
            m,
            now: now,
            conference: s?.conference,
            conferenceKnown: s != null,
            extras: extras,
          );
    final owner = m.departments
        .where((d) => d.id == m.ownerDepartmentId)
        .firstOrNull;
    final ownerLine = l.meetingOwnerLine(
      m,
      owner == null ? '' : meetingDeptName(catalog, owner),
      invited: false,
    );
    // Ayrıntı okunamadıysa sayaç yeri boş kalır (kart yine açılır).
    final showStats = deletedAt == null && !(summary?.hasError ?? false);
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= _wideCard;
        final chips = MeetingCodeChips(
          meeting: m,
          solid: true,
          label: (d) => meetingDeptLabel(catalog, d),
        );
        final ownerText = Text(
          ownerLine,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: t.caption.copyWith(color: c.textMuted),
        );
        final stats = MeetingStats(summary: s, wide: wide);
        final chevron = NzIcon(
          NzIcons.chevronRight,
          size: NizamioSize.iconSizeSm,
          color: c.textFaint,
        );
        final body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: NizamioSpacing.space2,
          children: [
            Text(
              m.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.labelLg.copyWith(
                fontSize: 15.5,
                height: 21 / 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Izgara yarım genişlikte hücreler kurar: geniş kartta 420'de sınırlanır.
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: chips,
            ),
            ownerText,
            if (!wide && showStats) ...[const Gap(2), stats],
          ],
        );
        final row = Padding(
          padding: wide
              ? const EdgeInsets.fromLTRB(16, 16, 20, 16)
              : const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: wide
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              MeetingDateTile(
                at: m.meetingDate,
                width: wide ? 72 : 64,
                status: status,
              ),
              Gap(wide ? 20 : 14),
              Expanded(child: body),
              if (wide && showStats) ...[const Gap(20), stats],
              if (deletedAt == null) ...[
                const Gap(NizamioSpacing.space2),
                if (wide) chevron else const Gap(NizamioSize.iconSizeSm),
              ],
            ],
          ),
        );
        final deletedLine = deletedAt == null
            ? null
            : [
                if (extras.deletedBy case final by?)
                  '${l.uiMeetingsDeletedBy} $by',
                l.meetingDeletedLine(deletedAt),
              ].join(' · ');
        return NzCard.outlined(
          padding: EdgeInsets.zero,
          onTap: deletedAt == null ? onTap : null,
          semanticLabel: [
            m.title,
            '${l.meetingDayMonth(m.meetingDate)} ${l.meetingTime(m.meetingDate)}',
            ?status == null ? null : l.meetingStatusLabel(status),
            ownerLine,
            ?deletedLine,
          ].join(' · '),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dar düzende kutu üstte, ok kartın dikey ortasında (prototip ızgarası).
              if (wide || deletedAt != null)
                row
              else
                Stack(
                  children: [
                    row,
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 14,
                      child: Center(child: chevron),
                    ),
                  ],
                ),
              if (deletedLine != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(wide ? 108 : 92, 0, 10, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          deletedLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                      if (onRestore case final restore?)
                        NzButton.secondary(
                          label: l.uiMeetingsRestore,
                          size: NzSize.sm,
                          onPressed: restore,
                        ),
                      if (onPurge case final purge?)
                        _DangerIcon(label: l.uiMeetingsPurge, onPressed: purge),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Kırmızı çöp düğmesi (kalıcı sil).
class _DangerIcon extends StatelessWidget {
  const _DangerIcon({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: InkResponse(
      onTap: onPressed,
      radius: 24,
      child: SizedBox(
        width: NizamioSize.tap,
        height: NizamioSize.tap,
        child: Center(
          child: NzIcon(
            NzIcons.delete,
            size: NizamioSize.iconSizeSm,
            color: context.colors.danger,
          ),
        ),
      ),
    ),
  );
}
