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
import '../../../../core/ui/widgets/feedback/nz_load_strip.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator.dart';
import 'home_texts.dart';

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

/// Bekleyen işler (tek kart, sekmeli): onay bekleyenler (İade / Onayla), atanmamış (Üstlen /
/// Ata) ve bekleyen tarih taleplerim; sekme başına en çok [HomeCoordinatorFeed.rowsPerSection]
/// satır. "Tümü" seçili sekmenin tam listesini açar. [fill]: bkz. [HomeSectionFrame.fill].
class HomePendingWork extends ConsumerStatefulWidget {
  const HomePendingWork({
    super.key,
    required this.board,
    required this.today,
    this.fill = false,
  });

  final CoordinatorBoard board;
  final DateTime today;
  final bool fill;

  @override
  ConsumerState<HomePendingWork> createState() => _HomePendingWorkState();
}

class _HomePendingWorkState extends ConsumerState<HomePendingWork> {
  var _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final board = widget.board;
    final today = widget.today;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final requests = [
      for (final r
          in ref.watch(myDateRequestsProvider).value ??
              const <DateChangeRequest>[])
        if (r.isPending) r,
    ];
    const n = HomeCoordinatorFeed.rowsPerSection;
    final tabs = [
      (l.uiHomePendingReview, board.queue.length),
      (l.uiHomeUnassignedTitle, board.unassigned.length),
      (l.uiHomeKpiDateRequest, requests.length),
    ];
    final (rows, empty, all) = switch (_tab) {
      0 => (
        [
          for (final task in board.queue.take(n))
            TaskQueueRow(task: task, today: today, flat: true),
        ],
        l.uiHomeQueueEmpty,
        board.queue.length > n ? () => showReviewQueueSheet(context) : null,
      ),
      1 => (
        [
          for (final task in board.unassigned.take(n))
            TaskUnassignedRow(task: task, today: today, flat: true),
        ],
        l.uiHomeUnassignedEmpty,
        board.unassigned.isEmpty
            ? null
            : () => context.appNav.openTasks(view: NzTaskView.unassigned),
      ),
      _ => (
        [
          for (final r in requests.take(n))
            DateRequestRow(
              request: r,
              title: catalog?.task(r.workItemId ?? '')?.title,
              flat: true,
            ),
        ],
        l.uiHomeRequestsEmpty,
        () => showDateRequestsSheet(context),
      ),
    };
    Widget tab(int i) {
      final (label, count) = tabs[i];
      final on = i == _tab;
      return Semantics(
        button: true,
        selected: on,
        label: '$label $count',
        excludeSemantics: true,
        child: NzPressable(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _tab = i),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: on ? c.surfaceOverlay : null,
                borderRadius: BorderRadius.circular(NizamioRadius.pill),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.space3,
                  vertical: NizamioSpacing.space2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: t.list.copyWith(
                        fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                        color: on ? c.text : c.textMuted,
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    if (on && count > 0)
                      NzCountPill.warning(count)
                    else
                      NzCountPill.neutral(count),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final card = NzTableCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(NizamioSpacing.space2),
          // Wrap: dar ekranda alt satıra akar; yan yana çiftin `IntrinsicHeight`'ında ölçülür.
          child: Wrap(
            spacing: NizamioSpacing.space1,
            runSpacing: NizamioSpacing.space1,
            children: [for (var i = 0; i < tabs.length; i++) tab(i)],
          ),
        ),
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space4),
            child: Text(empty, style: t.bodyMd.copyWith(color: c.textMuted)),
          )
        else
          ...rows,
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzSectionHeader(
          l.uiHomePendingTitle,
          onAll: all,
          allLabel: l.uiHomeSeeAll,
        ),
        const Gap(NizamioSpacing.gapMd),
        if (widget.fill) Expanded(child: card) else card,
      ],
    );
  }
}

/// Ekip yükü: kişi başına açık görev şeridi ve "n açık · m geç". Şerit parçaları ayrıktır:
/// geciken (durumdan bağımsız), sonra devam, onayda, iade, başlamadı; şerit boyu en yüklü kişiye
/// göre ölçeklenir (kalanı iz rengi). Backend koordinatöre yük ucu açmaz; sayım görünen
/// görevlerden ([CoordinatorBoard.load], [CoordinatorBoard.tasks]).
class HomeTeamLoad extends ConsumerWidget {
  const HomeTeamLoad({super.key, required this.board, this.fill = false});

  final CoordinatorBoard board;

  /// Bkz. [HomeSectionFrame.fill].
  final bool fill;

  static const maxRows = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final rows = [
      for (final p in board.load)
        if (p.open > 0) p,
    ].take(maxRows).toList();
    // İade: geciken kırmızısının koyu tonu (prototip `.ld-back`).
    final returnedColor = c.danger.withValues(alpha: 0.5);
    final widest = rows.fold(0, (m, p) => p.open > m ? p.open : m);
    List<NzBarSegment> segments(String id, int open) {
      final mine = [
        for (final t in board.tasks)
          if (!t.isDone && t.assignees.contains(id)) t,
      ];
      final late = mine.where(isTaskLate).length;
      int count(TaskStatus s) =>
          mine.where((t) => !isTaskLate(t) && t.status == s).length;
      final doing = count(TaskStatus.inProgress);
      final review = count(TaskStatus.review);
      final returned = count(TaskStatus.returned);
      return [
        NzBarSegment(doing, c.inProgress),
        NzBarSegment(review, c.warning),
        NzBarSegment(late, c.danger),
        NzBarSegment(returned, returnedColor),
        NzBarSegment(open - late - doing - review - returned, c.textFaint),
        NzBarSegment(widest - open, c.surfaceOverlay),
      ];
    }

    Widget legend(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzDot(color: color),
        const Gap(NizamioSpacing.space2),
        Text(label, style: context.text.bodySm.copyWith(color: c.textMuted)),
      ],
    );
    return HomeSectionFrame(
      fill: fill,
      title: l.uiHomeLoadTitle,
      count: rows.length,
      onAll: context.appNav.openUsers,
      allLabel: l.uiHomeModuleTeam,
      empty: l.uiHomeLoadEmpty,
      children: [
        for (final p in rows)
          NzLoadRow(
            name: catalog?.nameOf(p.personId) ?? l.uiTasksUnknownPerson,
            selfLabel: p.personId == catalog?.me ? l.uiUsersTeamYou : null,
            caption:
                '${p.open} ${l.uiHomeLoadOpenTail}'
                '${p.late > 0 ? ' · ${p.late} ${l.uiHomeLoadLateTail}' : ''}',
            captionDanger: p.late > 0,
            segments: segments(p.personId, p.open),
            // Hızlı erişim: kişinin görevleri.
            onTap: () => context.appNav.openTasks(people: [p.personId]),
          ),
        if (rows.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space4),
            child: Wrap(
              spacing: NizamioSpacing.space4,
              runSpacing: NizamioSpacing.space1,
              children: [
                legend(c.inProgress, l.uiHomeLoadDoing),
                legend(c.warning, l.uiHomeLoadReview),
                legend(c.danger, l.uiHomeChipLate),
                legend(returnedColor, l.uiHomeLoadReturned),
              ],
            ),
          ),
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
