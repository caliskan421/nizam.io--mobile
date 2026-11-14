import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator.dart';
import 'home_texts.dart';
import 'home_wide.dart';

/// Koordinatör özet kutuları (yönetici ana sayfasının dili): gecikme, onay bekleyen,
/// tamamlanma (yüzde), devam eden. Dokunma görev listesini ilgili görünümle açar.
List<Widget> homeCoordinatorKpis(
  BuildContext context, {
  required CoordinatorBoard board,
}) {
  final l = context.l10n;
  final c = context.colors;
  final nav = context.appNav;
  final s = board.summary;
  final more = board.truncated ? '≥' : '';
  final open = s.total - s.done;
  double ratio(int a, int b) => b == 0 ? 0 : a / b;
  Widget tile(
    NzGlyph glyph,
    Color tone,
    String label,
    String value,
    double progress,
    NzTaskView view, {
    bool danger = false,
  }) => NzKpiTile(
    glyph: glyph,
    tone: tone,
    label: label,
    value: value,
    valueColor: danger ? c.danger : null,
    progress: progress,
    onTap: () => nav.openTasks(view: view),
    semanticLabel: '$label: $value. ${l.uiHomeOpenList}',
  );
  return [
    tile(
      NzGlyphs.late,
      c.danger,
      l.uiHomeKpiLate,
      '$more${s.late}',
      ratio(s.late, open),
      NzTaskView.late,
      danger: true,
    ),
    tile(
      NzGlyphs.review,
      c.warning,
      l.uiHomeKpiReview,
      '$more${s.review}',
      ratio(s.review, open),
      NzTaskView.review,
    ),
    tile(
      NzGlyphs.done,
      c.taskDone,
      l.uiHomeKpiDone,
      l.percent(ratio(s.done, s.total)),
      ratio(s.done, s.total),
      NzTaskView.done,
    ),
    tile(
      NzGlyphs.inProgress,
      c.inProgress,
      l.uiHomeKpiDoing,
      '$more${s.inProgress}',
      ratio(s.inProgress, s.total),
      NzTaskView.inProgress,
    ),
  ];
}

/// Bekleyen işler (yönetici "Ekip" kutularının dili): onay bekleyen, atanmamış ve bekleyen
/// tarih talebi sayısı; içerik gösterilmez, kutu ilgili listeye götürür (onay kuyruğu, görev
/// listesi atanmamış görünümü, tarih talepleri). Çubuk açık görevlere oranıdır. Dar düzende
/// üç kutu yan yana; [fill] (tablet, ekip yüküyle yan yana çift): üç yatay kutu alt alta,
/// verilen yüksekliği eşit böler.
class HomePendingWork extends ConsumerWidget {
  const HomePendingWork({
    super.key,
    required this.board,
    this.compact = false,
    this.fill = false,
  });

  final CoordinatorBoard board;
  final bool compact;
  final bool fill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final requests = (ref.watch(myDateRequestsProvider).value ?? const [])
        .where((r) => r.isPending)
        .length;
    final open = board.summary.total - board.summary.done;
    final more = board.truncated ? '≥' : '';
    final items = [
      (
        c.warning,
        board.queue.length,
        l.uiHomePendingReview,
        () => showReviewQueueSheet(context),
      ),
      (
        c.info,
        board.unassigned.length,
        l.uiHomeUnassignedTitle,
        () => context.appNav.openTasks(view: NzTaskView.unassigned),
      ),
      (
        c.inProgress,
        requests,
        l.uiHomeKpiDateRequest,
        () => showDateRequestsSheet(context),
      ),
    ];
    final Widget tiles = fill
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: NizamioSpacing.gapMd,
            children: [
              for (final (color, n, label, onTap) in items)
                Expanded(
                  child: _PendingRowTile(
                    color: color,
                    count: '$more$n',
                    label: label,
                    progress: open == 0 ? 0 : n / open,
                    onTap: onTap,
                  ),
                ),
            ],
          )
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: NizamioSpacing.gapMd,
              children: [
                for (final (color, n, label, onTap) in items)
                  Expanded(
                    child: HomeTeamTile(
                      dot: color,
                      bar: color,
                      count: n,
                      prefix: more,
                      total: open,
                      label: label,
                      compact: compact,
                      onTap: onTap,
                    ),
                  ),
              ],
            ),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiHomePendingTitle),
        const Gap(NizamioSpacing.gapMd),
        if (fill) Expanded(child: tiles) else tiles,
      ],
    );
  }
}

/// Bekleyen iş kutusunun yatay hâli (tablet): solda nokta ve etiket, sağda sayı, altta oran
/// çubuğu; dokunma ilgili listeye götürür.
class _PendingRowTile extends StatelessWidget {
  const _PendingRowTile({
    required this.color,
    required this.count,
    required this.label,
    required this.progress,
    required this.onTap,
  });

  final Color color;
  final String count;
  final String label;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.rowPad),
      onTap: onTap,
      semanticLabel: '$count $label. ${l.uiHomeOpenList}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              NzDot(color: color),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMd.copyWith(color: context.colors.textMuted),
                ),
              ),
              Text(count, style: t.titleMd),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          NzProgressBar(value: progress, color: color),
        ],
      ),
    );
  }
}

/// Ekip yükü (sabit boy; ekip büyüdükçe uzamaz): üstte ekip toplamları (kişi, açık, geciken),
/// tek parçalı durum şeridi ve açıklaması; altta en yüklü dört kişi küçük kutularda (baş
/// harfler, ad, "5 açık · 2 geç"); kalanlar "+N kişi · Ekibim" bağlantısıyla. Kutu kişinin
/// görevlerini açar. Backend koordinatöre yük ucu açmaz; sayım görünen görevlerden
/// ([CoordinatorBoard.load]).
class HomeTeamLoad extends ConsumerWidget {
  const HomeTeamLoad({super.key, required this.board, this.fill = false});

  final CoordinatorBoard board;

  /// Verilen yüksekliği kartla doldurur (yan yana çift).
  final bool fill;

  static const shown = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final nav = context.appNav;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final loaded =
        [
          for (final p in board.load)
            if (p.open > 0) p,
        ]..sort((a, b) {
          final o = b.open.compareTo(a.open);
          return o != 0 ? o : b.late.compareTo(a.late);
        });
    final open = loaded.fold(0, (n, p) => n + p.open);
    final late = loaded.fold(0, (n, p) => n + p.late);
    final review = loaded.fold(0, (n, p) => n + p.review);
    final returned = loaded.fold(0, (n, p) => n + p.returned);
    final doing = loaded.fold(0, (n, p) => n + p.inProgress);
    final returnedColor = c.danger.withValues(alpha: 0.5);
    Widget stat(String value, String label, {bool danger = false}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: t.titleMd.copyWith(color: danger ? c.danger : c.text),
        ),
        Text(label, style: t.caption.copyWith(color: c.textMuted)),
      ],
    );
    Widget legend(Color color, String label, int n) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzDot(color: color),
        const Gap(NizamioSpacing.space1),
        Text('$label $n', style: t.caption.copyWith(color: c.textMuted)),
      ],
    );
    Widget person(TeamLoad p) {
      final name = catalog?.nameOf(p.personId) ?? l.uiTasksUnknownPerson;
      final caption =
          '${p.open} ${l.uiHomeLoadOpenTail}'
          '${p.late > 0 ? ' · ${p.late} ${l.uiHomeLoadLateTail}' : ''}';
      return Semantics(
        button: true,
        label: '$name, $caption',
        excludeSemantics: true,
        child: NzPressable(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => nav.openTasks(people: [p.personId]),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceOverlay,
                borderRadius: BorderRadius.circular(NizamioRadius.tile),
              ),
              child: Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space2),
                child: Row(
                  children: [
                    NzAvatar.initials(name: name, size: NzSize.sm),
                    const Gap(NizamioSpacing.space2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.personId == catalog?.me
                                ? '$name (${l.uiUsersTeamYou})'
                                : name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodyMd.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.monoSm.copyWith(
                              color: p.late > 0 ? c.danger : c.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final top = loaded.take(shown).toList();
    final rest = loaded.length - top.length;
    final body = loaded.isEmpty
        ? Text(l.uiHomeLoadEmpty, style: t.bodyMd.copyWith(color: c.textMuted))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: stat('${loaded.length}', l.uiHomeLoadPeople)),
                  Expanded(child: stat('$open', l.uiHomeLoadOpenTail)),
                  Expanded(
                    child: stat(
                      '$late',
                      l.uiHomeLoadLateTail,
                      danger: late > 0,
                    ),
                  ),
                ],
              ),
              const Gap(NizamioSpacing.space3),
              NzProgressBar.segments(
                segments: [
                  NzBarSegment(doing, c.inProgress),
                  NzBarSegment(review, c.warning),
                  NzBarSegment(returned, returnedColor),
                  NzBarSegment(open - doing - review - returned, c.textFaint),
                ],
              ),
              const Gap(NizamioSpacing.space2),
              Wrap(
                spacing: NizamioSpacing.space3,
                runSpacing: NizamioSpacing.space1,
                children: [
                  legend(c.inProgress, l.uiHomeLoadDoing, doing),
                  legend(c.warning, l.uiHomeLoadReview, review),
                  legend(returnedColor, l.uiHomeLoadReturned, returned),
                ],
              ),
              const Gap(NizamioSpacing.space3),
              for (var i = 0; i < top.length; i += 2) ...[
                if (i > 0) const Gap(NizamioSpacing.space2),
                Row(
                  children: [
                    Expanded(child: person(top[i])),
                    const Gap(NizamioSpacing.space2),
                    Expanded(
                      child: i + 1 < top.length
                          ? person(top[i + 1])
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ],
          );
    final link = Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: nav.openUsers,
        child: Padding(
          padding: const EdgeInsets.only(top: NizamioSpacing.space3),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  rest > 0 ? '+$rest ${l.uiHomeLoadMorePeople}' : '',
                  style: t.caption.copyWith(color: c.textMuted),
                ),
              ),
              Text(
                l.uiHomeModuleTeam,
                style: t.bodyMd.copyWith(color: c.textMuted),
              ),
              NzIcon(
                NzIcons.chevronRight,
                size: NizamioSize.iconSizeSm,
                color: c.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
    final card = NzCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [body, if (fill) const Spacer(), link],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzKicker(l.uiHomeLoadTitle),
        const Gap(NizamioSpacing.gapMd),
        if (fill) Expanded(child: card) else card,
      ],
    );
  }
}

/// Yaklaşan toplantılar (en çok 3; toplantılar sayfasının "Yaklaşan" sekmesi): o sayfadaki
/// kartın aynısı ([MeetingCard]); boşsa boş metinli kart. Canlı konferansı olan toplantı önceki
/// günden olsa da listede kalır.
class HomeUpcomingMeetings extends ConsumerWidget {
  const HomeUpcomingMeetings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final nav = context.appNav;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    return NzAsyncView<MeetingsBoard>(
      value: ref.watch(meetingsBoardControllerProvider),
      onRetry: () => ref.invalidate(meetingsBoardControllerProvider),
      loading: const NzSkeleton.block(height: 120),
      data: (b) {
        // Toplantılar sayfasının "Yaklaşan" sekmesiyle aynı küme: bugün ve sonrası (saati geçmiş
        // ama başlamamış "bekliyor" dahil); önceki günden sürüp giden canlı toplantı başta.
        final now = DateTime.now();
        final upcoming = b.of(
          MeetingsTab.upcoming,
          DateTime(now.year, now.month, now.day),
        );
        final next = [
          for (final m in b.visible)
            if (isLive(m) && !upcoming.contains(m)) m,
          ...upcoming,
        ];
        if (next.isEmpty) {
          return HomeSectionFrame(
            title: l.uiHomeMeetingsTitle,
            count: 0,
            onAll: nav.openMeetings,
            empty: l.uiHomeMeetingsEmpty,
            children: const [],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzSectionHeader(
              l.uiHomeMeetingsTitle,
              count: next.length,
              onAll: nav.openMeetings,
              allLabel: l.uiHomeSeeAll,
            ),
            const Gap(NizamioSpacing.gapMd),
            for (final (i, m)
                in next.take(HomeCoordinatorFeed.rowsPerSection).indexed) ...[
              if (i > 0) const Gap(NizamioSpacing.gapMd),
              MeetingCard(
                meeting: m,
                catalog: catalog,
                onTap: () => nav.openMeeting(m.id),
              ),
            ],
          ],
        );
      },
    );
  }

  /// Toplantıda canlı konferans var mı (üye yaklaşanlarıyla ortak).
  static bool isLive(Meeting m) =>
      m.summary?.conferenceStatus == SummaryConferenceStatus.live;
}

/// Toplantı satırı: tarih kutusu (gün / mono saat; bugün vurgulu), başlık, koordinatörlük
/// kodları (ilki kalın) + katılımcı sayısı (veride varsa), canlıysa "● Canlı" hapı.
class HomeMeetingRow extends StatelessWidget {
  const HomeMeetingRow({
    super.key,
    required this.meeting,
    required this.now,
    required this.live,
    required this.codes,
    required this.onTap,
  });

  final Meeting meeting;
  final DateTime now;
  final bool live;
  final List<String> codes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final at = meeting.meetingDate.toLocal();
    final today = DateUtils.isSameDay(at, now);
    final people = meeting.summary?.participantCount ?? 0;
    final meta = t.bodyMd.copyWith(color: c.textMuted);
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(NizamioSpacing.space4),
          child: Row(
            children: [
              HomeDateBox(
                top: today
                    ? l.uiMeetingsGroupToday
                    : DateFormat('EEE d', 'tr').format(at),
                bottom: DateFormat.Hm('tr').format(at),
                highlight: today,
              ),
              const Gap(NizamioSpacing.gapMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyLg.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Gap(NizamioSpacing.space1),
                    Text.rich(
                      TextSpan(
                        children: [
                          for (final (i, code) in codes.indexed)
                            TextSpan(
                              text: i == 0 ? code : ' $code',
                              style: i == 0
                                  ? t.bodyMd.copyWith(
                                      fontWeight: FontWeight.w700,
                                    )
                                  : meta,
                            ),
                          if (people > 0)
                            TextSpan(
                              text: ' · $people ${l.uiMeetingsPeopleTail}',
                              style: meta,
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (live) ...[
                const Gap(NizamioSpacing.space2),
                NzDotChip(color: c.success, label: l.uiMeetingsConfLive),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Satır başı tarih kutusu: üstte gün ("Bugün" / "Per 14"), altta mono satır (saat ya da
/// etiket); [highlight] bugünü vurgular.
class HomeDateBox extends StatelessWidget {
  const HomeDateBox({
    super.key,
    required this.top,
    required this.bottom,
    this.highlight = false,
  });

  final String top;
  final String bottom;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlight ? c.primary.withValues(alpha: 0.16) : c.surfaceOverlay,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
      ),
      child: SizedBox(
        width: NizamioSize.controlMd * 1.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space2),
          child: Column(
            children: [
              Text(
                top,
                maxLines: 1,
                style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(bottom, maxLines: 1, style: t.mono),
            ],
          ),
        ),
      ),
    );
  }
}
