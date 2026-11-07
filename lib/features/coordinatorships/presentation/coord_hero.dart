import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';
import 'coord_texts.dart';

/// Kimlik ve nabız (prototip `.cd-hero`): kod kutucuğu, ad, alt satır, "Görev ata" / "Mesaj",
/// açılır ilerleme kartı. Genişte iki sütun.
class CoordHero extends ConsumerWidget {
  const CoordHero({super.key, required this.detail, required this.pulse});

  final CoordinatorshipDetail detail;
  final CoordPulse pulse;

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
    builder: (context, box) {
      final identity = _Identity(detail: detail);
      final card = _PulseCard(code: detail.stats.code, pulse: pulse);
      if (box.maxWidth >= coordWideWidth) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: NizamioSpacing.gapXl,
          children: [
            Expanded(child: identity),
            Expanded(child: card),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [identity, card],
      );
    },
  );
}

class _Identity extends StatelessWidget {
  const _Identity({required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
    final tag = d.stats.shortCode;
    final parent = d.profile.parent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space4,
      children: [
        Row(
          children: [
            if (tag != null) ...[
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c.surfaceOverlay, c.surfaceRaised],
                  ),
                ),
                child: ExcludeSemantics(
                  child: Text(
                    tag,
                    style: t.monoSm.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: .5,
                      color: c.text,
                    ),
                  ),
                ),
              ),
              const Gap(14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: NizamioSpacing.space1,
                children: [
                  Semantics(
                    header: true,
                    child: Text(d.stats.name, style: t.titleLg),
                  ),
                  Text.rich(
                    TextSpan(
                      text: [
                        if (parent.isNotEmpty) parent,
                        l.coordPeopleCount(d.people),
                        '',
                      ].join(' · '),
                      children: [
                        TextSpan(
                          text: '● ',
                          style: t.caption.copyWith(
                            color: c.accentText,
                            fontSize: 8,
                          ),
                        ),
                        TextSpan(
                          text: l.uiCoordStateActive,
                          style: t.caption.copyWith(color: c.accentText),
                        ),
                      ],
                    ),
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: NizamioSpacing.space2,
          children: [
            Expanded(
              child: NzButton.primary(
                label: l.uiCoordAssignTask,
                icon: NzIcons.add,
                expand: true,
                onPressed: () =>
                    showNewTaskSheet(context, coordinatorship: d.stats.code),
              ),
            ),
            NzButton.secondary(
              label: l.uiCoordMessage,
              icon: NzIcons.messages,
              onPressed: context.appNav.openMessages,
            ),
          ],
        ),
      ],
    );
  }
}

/// Açılır ilerleme kartı (prototip `.cd-pulse`): büyük yüzde, özet ve gecikme satırı, parçalı
/// çubuk; açılınca durum satırları (dokununca Görevler bölümü o süzgeçle açılır).
class _PulseCard extends ConsumerWidget {
  const _PulseCard({required this.code, required this.pulse});

  final String code;
  final CoordPulse pulse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = pulse;
    final provider = coordinatorshipDetailControllerProvider(code);
    final open = ref.watch(provider.select((v) => v.pulseOpen));
    final commands = ref.read(provider.notifier);
    final rows = [
      (l.uiCoordStDone, p.done, c.primary, CoordTaskFilter.done),
      (l.uiCoordStDoing, p.doing, c.inProgress, CoordTaskFilter.open),
      (l.uiCoordStLate, p.late, c.danger, CoordTaskFilter.late),
      (l.uiCoordStTodo, p.todo, c.textFaint, CoordTaskFilter.notStarted),
    ].where((r) => r.$2 > 0).toList();
    return CoordPanel(
      padding: const EdgeInsets.fromLTRB(
        NizamioSpacing.space4,
        NizamioSpacing.space1,
        NizamioSpacing.space4,
        NizamioSpacing.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: open,
            child: InkWell(
              onTap: commands.togglePulse,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NizamioSpacing.space3,
                ),
                child: Row(
                  spacing: 14,
                  children: [
                    Text(
                      l.coordPercent(p.ratio),
                      style: t.displayLg.copyWith(
                        fontSize: 34,
                        height: 38 / 34,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.coordPulseCaption(p),
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                          Text(
                            l.coordPulseFlag(p),
                            style: t.caption.copyWith(
                              color: p.late > 0 ? c.danger : c.textFaint,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: open ? .5 : 0,
                      duration: NizamioMotion.durSheet,
                      child: NzIcon(
                        NzIcons.chevronDown,
                        size: NizamioSize.iconSizeSm,
                        color: c.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          NzProgressBar.segments(
            segments: [
              NzBarSegment(p.done, c.primary),
              NzBarSegment(p.doing, c.inProgress),
              NzBarSegment(p.late, c.danger),
              NzBarSegment(p.todo, c.surfaceOverlay),
            ],
          ),
          NzReveal(
            open: open,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  for (final (i, (label, n, color, filter)) in rows.indexed)
                    _BreakdownRow(
                      first: i == 0,
                      label: label,
                      count: n,
                      color: color,
                      onTap: () => commands.showTasks(filter),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.first,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final bool first;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      label: '$label, $count',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: NizamioSize.tap),
          decoration: BoxDecoration(
            border: first ? null : Border(top: BorderSide(color: c.border)),
          ),
          child: Row(
            spacing: NizamioSpacing.space3,
            children: [
              NzDot(color: color),
              Expanded(child: Text(label, style: t.bodyMd)),
              Text('$count', style: t.monoSm.copyWith(color: c.textMuted)),
              NzIcon(
                NzIcons.chevronRight,
                size: NizamioSize.iconSizeSm,
                color: c.textFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
