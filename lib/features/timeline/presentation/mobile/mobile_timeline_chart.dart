import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'mobile_timeline_layout.dart';
import 'mobile_timeline_painters.dart';
import 'mobile_timeline_strip.dart';

/// Telefonda yatay zaman ekseni, dikey görev satırları; tarih ekseni dikeyde,
/// koordinatörlük etiketleri yatayda sabittir. Seçim ve tarih taslağı controller'dadır.
class MobileTimelineChart extends StatefulWidget {
  const MobileTimelineChart({
    super.key,
    required this.view,
    required this.onSelect,
    required this.onToggleGroup,
    required this.onDrag,
    required this.onBlankTap,
    required this.bottomInset,
    this.canDrag = false,
  });
  final TimelineView view;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<int> onDrag;
  final VoidCallback onBlankTap;
  final double bottomInset;
  final bool canDrag;
  static const horizontalKey = ValueKey('mobile-timeline-scroll-x');
  static const verticalKey = ValueKey('mobile-timeline-scroll-y');
  static ValueKey<String> barKey(String code) =>
      ValueKey('mobile-timeline-bar-$code');
  static ValueKey<String> groupKey(String code) =>
      ValueKey('mobile-timeline-group-$code');
  @override
  State<MobileTimelineChart> createState() => _MobileTimelineChartState();
}

class _MobileTimelineChartState extends State<MobileTimelineChart> {
  final _h = ScrollController();
  final _v = ScrollController();
  late MobileTimelineLayout _layout = MobileTimelineLayout(widget.view);
  double _viewport = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _today());
  }

  @override
  void didUpdateWidget(MobileTimelineChart old) {
    super.didUpdateWidget(old);
    final previous = _layout;
    _layout = MobileTimelineLayout(widget.view);
    if (old.view.state.scale != widget.view.state.scale) {
      final offset = _h.hasClients ? _h.offset : 0.0;
      final today = previous.todayX - offset;
      final anchor = today > 0 && today < _viewport ? today : _viewport / 2;
      final day =
          (offset + anchor - MobileTimelineLayout.leftPad) / previous.ppd;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _jump(_layout.x(day) - anchor),
      );
    } else if (old.view.state.selected != widget.view.state.selected &&
        widget.view.state.selected != null) {
      final bar = _layout.barOf(widget.view.state.selected!);
      if (bar != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _jump(bar.rect.left - 40);
          if (mounted && _v.hasClients) {
            _v.jumpTo((bar.top - 70).clamp(0.0, _v.position.maxScrollExtent));
          }
        });
      }
    }
  }

  void _jump(double offset) {
    if (mounted && _h.hasClients) {
      _h.jumpTo(offset.clamp(0.0, _h.position.maxScrollExtent));
    }
  }

  void _today() => _jump(_layout.todayX - _viewport * .3);
  @override
  void dispose() {
    _h.dispose();
    _v.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      _viewport = box.maxWidth;
      final l = _layout;
      final height = math.max(
        l.height,
        box.maxHeight - MobileTimelineLayout.axisHeight,
      );
      final selected = widget.view.state.selected;
      return Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              key: MobileTimelineChart.horizontalKey,
              controller: _h,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: math.max(l.width, box.maxWidth),
                height: box.maxHeight,
                child: Column(
                  children: [
                    SizedBox(
                      height: MobileTimelineLayout.axisHeight,
                      width: l.width,
                      child: CustomPaint(
                        painter: MobileTimelineAxisPainter(
                          layout: l,
                          colors: context.colors,
                          style: context.text.monoSm,
                          scroll: _h,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: MobileTimelineChart.verticalKey,
                        controller: _v,
                        physics: const ClampingScrollPhysics(),
                        child: SizedBox(
                          width: l.width,
                          height: height,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: widget.onBlankTap,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: MobileTimelinePainter(
                                      layout: l,
                                      colors: context.colors,
                                      style: context.text.labelMd.copyWith(
                                        fontSize: 12,
                                      ),
                                      scroll: _h,
                                      vertical: _v,
                                      viewportHeight:
                                          box.maxHeight -
                                          MobileTimelineLayout.axisHeight,
                                      viewport: box.maxWidth,
                                    ),
                                  ),
                                ),
                                for (final bar in l.bars)
                                  Positioned.fromRect(
                                    rect: bar.rect.expandToInclude(
                                      Rect.fromLTWH(
                                        bar.rect.right,
                                        bar.rect.top,
                                        bar.requestWidth,
                                        bar.rect.height,
                                      ),
                                    ),
                                    child: Semantics(
                                      key: MobileTimelineChart.barKey(
                                        bar.task.code,
                                      ),
                                      button: true,
                                      selected: selected == bar.task.code,
                                      label: context.l10n.barLabel(
                                        bar.task,
                                        l.view.year,
                                      ),
                                      onTap: () =>
                                          widget.onSelect(bar.task.code),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            widget.onSelect(bar.task.code),
                                        onLongPressStart:
                                            widget.canDrag &&
                                                selected == bar.task.code
                                            ? (_) =>
                                                  widget.onSelect(bar.task.code)
                                            : null,
                                        onLongPressMoveUpdate:
                                            widget.canDrag &&
                                                selected == bar.task.code
                                            ? (details) => widget.onDrag(
                                                (details.offsetFromOrigin.dx /
                                                        l.ppd)
                                                    .round(),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                for (final head in l.heads)
                                  Positioned(
                                    left: 0,
                                    top: head.top,
                                    height: MobileTimelineLayout.groupHeight,
                                    width: l.width,
                                    child: AnimatedBuilder(
                                      animation: _h,
                                      builder: (context, _) => Align(
                                        alignment: Alignment.centerLeft,
                                        child: Transform.translate(
                                          offset: Offset(
                                            _h.hasClients ? _h.offset : 0,
                                            0,
                                          ),
                                          child: SizedBox(
                                            width: math.min(330, box.maxWidth),
                                            height: MobileTimelineLayout
                                                .groupHeight,
                                            child: _GroupLabel(
                                              key: MobileTimelineChart.groupKey(
                                                head.group.code,
                                              ),
                                              view: widget.view,
                                              group: head.group,
                                              onTap: () => widget.onToggleGroup(
                                                head.group.code,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (widget.view.empty)
                                  Positioned(
                                    left: 0,
                                    top: 72,
                                    width: box.maxWidth,
                                    child: AnimatedBuilder(
                                      animation: _h,
                                      builder: (context, _) =>
                                          Transform.translate(
                                            offset: Offset(
                                              _h.hasClients ? _h.offset : 0,
                                              0,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(24),
                                              child: Text(
                                                widget.view.noneSelected
                                                    ? context
                                                          .l10n
                                                          .uiTimelineEmptyNoCoord
                                                    : context
                                                          .l10n
                                                          .uiTimelineEmpty,
                                                style: context.text.bodyMd,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selected == null)
            Positioned(
              left: 10,
              right: 10,
              bottom: 16 + widget.bottomInset,
              child: MobileTimelineStrip(
                layout: l,
                scroll: _h,
                onScrub: _jump,
                onToday: _today,
              ),
            ),
        ],
      );
    },
  );
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({
    super.key,
    required this.view,
    required this.group,
    required this.onTap,
  });
  final TimelineView view;
  final TimelineGroup group;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final open = !view.state.closedGroups.contains(group.code);
    final coord = view.coordinatorships
        .where((c) => c.code == group.code)
        .firstOrNull;
    return Semantics(
      button: true,
      expanded: open,
      label: group.name,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: context.colors.surface,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: open ? 0 : -.25,
                  duration: const Duration(milliseconds: 350),
                  child: NzIcon(
                    NzIcons.chevronDown,
                    size: 18,
                    color: context.colors.textMuted,
                  ),
                ),
                const Gap(6),
                Text(
                  coord?.label ?? group.code,
                  style: context.text.monoSm.copyWith(
                    color: context.colors.textFaint,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    group.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelMd,
                  ),
                ),
                const Gap(6),
                Text(
                  '${group.done}/${group.total}',
                  style: context.text.monoSm.copyWith(
                    color: context.colors.textFaint,
                  ),
                ),
                if (group.late > 0) ...[
                  const Gap(6),
                  Text(
                    '${group.late} ${context.l10n.uiTimelineGanttLateTail}',
                    style: context.text.caption.copyWith(
                      color: context.colors.danger,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
