import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/timeline.dart';
import '../chart/timeline_layout.dart';
import '../timeline_texts.dart';
import 'timeline_controls.dart';

/// Çizelgenin üstüne binen başlık çubuğu (44): koordinatörlük seçici ve Filtre düğmesi
/// (kişi/öncelik seçiliyken etkin süzgeç sayısı rozeti). Sabit yükseklik: metin en çok 1.3×.
class TimelineHeader extends StatelessWidget {
  const TimelineHeader({
    super.key,
    required this.view,
    required this.onCoord,
    required this.onFilter,
  });

  final TimelineView view;
  final VoidCallback onCoord;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final open = view.state.coordMenuOpen;
    // Prototip: rozet kişi/öncelik seçiliyken görünür; sayı durum süzgecini de sayar.
    final n = view.state.filterCount;
    final badge = view.state.hasChips;
    final summary = l.coordSummary(view);
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.background.withValues(alpha: 0.92),
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: SizedBox(
          height: TimelineGeometry.header,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TimelineBarButton(
                    onTap: onCoord,
                    expanded: open,
                    label: '${l.uiTimelineCoord}: $summary',
                    child: Row(
                      children: [
                        Text(
                          l.uiTimelineCoord,
                          style: t.labelMd.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(NizamioSpacing.space2),
                        Expanded(
                          child: Text(
                            summary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.monoSm.copyWith(color: c.textMuted),
                          ),
                        ),
                        AnimatedRotation(
                          turns: open ? 0.5 : 0,
                          duration: NzMotion.of(
                            context,
                            NizamioMotion.durPress,
                          ),
                          child: NzIcon(
                            NzIcons.chevronDown,
                            size: NizamioSize.iconSizeSm,
                            color: c.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                TimelineBarButton(
                  onTap: onFilter,
                  label: l.uiTimelineFilterLabel,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NzIcon(
                        NzIcons.filter,
                        size: NizamioSize.iconSizeSm,
                        color: c.text,
                      ),
                      const Gap(6),
                      Text(l.uiTimelineFilter, style: t.labelMd),
                      if (badge) ...[
                        const Gap(6),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: c.primary,
                            borderRadius: BorderRadius.circular(
                              NizamioRadius.pill,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '$n',
                              style: t.monoSm.copyWith(color: c.onPrimary),
                            ),
                          ),
                        ),
                      ],
                    ],
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

/// Koordinatörlük açılır menüsü (prototip `.rp-pop` listbox; çoklu seçim, "tümü"): sayfa içi
/// katman — arkası (kapatma alanı) saydam; çizelge görünür kalır.
class TimelineCoordMenu extends StatelessWidget {
  const TimelineCoordMenu({
    super.key,
    required this.view,
    required this.onToggle,
    required this.onAll,
    required this.onClose,
  });

  final TimelineView view;
  final ValueChanged<String> onToggle;
  final VoidCallback onAll;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    return Stack(
      children: [
        Positioned.fill(
          child: Semantics(
            button: true,
            label: l.uiCommonClose,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.sizeOf(context).width < 600 ? null : 50,
          bottom: MediaQuery.sizeOf(context).width < 600
              ? 190 + MediaQuery.paddingOf(context).bottom
              : null,
          left: MediaQuery.sizeOf(context).width < 600
              ? 72
              : NizamioSpacing.space3,
          right: NizamioSpacing.space3,
          child: _CoordMenuEntrance(
            child: LayoutBuilder(
              builder: (context, _) => Semantics(
                container: true,
                label: l.uiTimelineCoord,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.surfaceRaised,
                    borderRadius: BorderRadius.circular(NizamioRadius.card),
                    border: Border.all(color: c.borderStrong),
                    boxShadow: context.shadows.sheet,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(NizamioSpacing.space2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.sizeOf(context).height * .42,
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              children: [
                                for (final o in view.coordOptions)
                                  _CoordRow(
                                    option: o,
                                    onTap: () => onToggle(o.code),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(6),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: c.border)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 4, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l.coordFoot(view),
                                    style: t.caption.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                ),
                                TimelineTap(
                                  onTap: onAll,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: NizamioSize.tap,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: NizamioSpacing.space2,
                                      ),
                                      child: Center(
                                        widthFactor: 1,
                                        child: Text(
                                          view.noneSelected
                                              ? l.uiTimelineCoordSelectAll
                                              : l.uiTimelineCoordClear,
                                          style: t.labelMd.copyWith(
                                            color: c.textMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoordRow extends StatelessWidget {
  const _CoordRow({required this.option, required this.onTap});

  final TimelineCoordOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final on = option.selected;
    return Semantics(
      checked: on,
      child: TimelineTap(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space3,
              vertical: NizamioSpacing.space1,
            ),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: on ? c.primary : null,
                    border: on
                        ? null
                        : Border.all(color: c.borderControl, width: 1.5),
                  ),
                  child: SizedBox.square(
                    dimension: 24,
                    child: on
                        ? NzIcon(NzIcons.check, size: 14, color: c.onPrimary)
                        : null,
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Text(
                    option.name,
                    style: t.bodyLg.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Text(
                  '${option.count}',
                  style: t.monoSm.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineFloatingFilters extends StatelessWidget {
  const TimelineFloatingFilters({
    super.key,
    required this.view,
    required this.onFilter,
  });
  final TimelineView view;
  final VoidCallback onFilter;
  @override
  Widget build(BuildContext context) {
    Widget button(
      IconData icon,
      String label,
      VoidCallback onTap,
      int count,
      bool lime,
    ) => Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: '$label · $count',
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Material(
                color: context.colors.surfaceRaised.withValues(alpha: .82),
                shape: CircleBorder(
                  side: BorderSide(color: context.colors.border),
                ),
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                  child: SizedBox.square(
                    dimension: 50,
                    child: Center(
                      child: NzIcon(icon, size: 23, color: context.colors.text),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -3,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                constraints: const BoxConstraints(minWidth: 18),
                decoration: BoxDecoration(
                  // Beyaz zemin iki temada da sabit (anahtar topuzuyla aynı belirteç).
                  color: lime
                      ? context.colors.primary
                      : context.colors.switchKnob,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: context.text.caption.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    return button(
      NzIcons.filter,
      'Filtreler',
      onFilter,
      view.state.filterCount + (view.allSelected ? 0 : 1),
      true,
    );
  }
}

class _CoordMenuEntrance extends StatelessWidget {
  const _CoordMenuEntrance({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 240),
    curve: Curves.easeOutCubic,
    child: child,
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.scale(
        scale: .88 + .12 * value,
        alignment: Alignment.bottomRight,
        child: child,
      ),
    ),
  );
}
