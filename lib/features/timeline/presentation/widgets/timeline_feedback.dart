import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';

/// Belirli süre görünen, süresi dolunca [onDone] çağıran sayfa içi bildirim (prototip `toast`,
/// 2.6 sn). Kabuk dışı tam ekranda kartın/şeridin üstünde kalması için sayfa katmanındadır.
class TimelineToast extends StatefulWidget {
  const TimelineToast({super.key, required this.message, required this.onDone});

  final String message;
  final VoidCallback onDone;

  static const lifetime = Duration(milliseconds: 2600);

  @override
  State<TimelineToast> createState() => _TimelineToastState();
}

class _TimelineToastState extends State<TimelineToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _life;

  @override
  void initState() {
    super.initState();
    _life = AnimationController(vsync: this, duration: TimelineToast.lifetime);
    _life.forward().whenComplete(() {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: IgnorePointer(
      child: Center(
        child: NzToastBubble(
          message: widget.message,
          tone: NzToastTone.success,
        ),
      ),
    ),
  );
}

/// Geri alınabilir kayıt bildirimi (prototip `rp-snack`, 5 sn): başlık, eski → yeni aralık,
/// fark, "Geri al" ve kalan süre çubuğu.
class TimelineUndoSnack extends StatefulWidget {
  const TimelineUndoSnack({
    super.key,
    required this.title,
    required this.from,
    required this.to,
    required this.delta,
    required this.onUndo,
    required this.onExpired,
  });

  final String title;
  final String from;
  final String to;
  final String delta;
  final VoidCallback onUndo;
  final VoidCallback onExpired;

  static const lifetime = Duration(seconds: 5);

  @override
  State<TimelineUndoSnack> createState() => _TimelineUndoSnackState();
}

class _TimelineUndoSnackState extends State<TimelineUndoSnack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _life;

  @override
  void initState() {
    super.initState();
    _life = AnimationController(
      vsync: this,
      duration: TimelineUndoSnack.lifetime,
    );
    _life.forward().whenComplete(() {
      if (mounted) widget.onExpired();
    });
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final fg = c.background;
    final reduced = NzMotion.reduced(context);
    return Semantics(
      liveRegion: true,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.text,
          borderRadius: BorderRadius.circular(NizamioRadius.attach),
          boxShadow: context.shadows.float,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.attach),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 6, 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.redo_rounded,
                      size: NizamioSize.iconSizeSm,
                      color: fg,
                    ),
                    const Gap(NizamioSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelMd.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(3),
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                widget.from,
                                style: t.caption.copyWith(
                                  color: fg.withValues(alpha: 0.75),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: fg,
                                ),
                              ),
                              Text(
                                '→',
                                style: t.caption.copyWith(
                                  color: fg.withValues(alpha: 0.75),
                                ),
                              ),
                              Text(
                                widget.to,
                                style: t.caption.copyWith(
                                  color: fg,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.delta,
                                style: t.caption.copyWith(
                                  color: fg.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onUndo,
                      style: TextButton.styleFrom(
                        foregroundColor: fg,
                        minimumSize: const Size(48, 44),
                        textStyle: t.labelMd.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text(context.l10n.uiTimelineUndo),
                    ),
                  ],
                ),
              ),
              if (!reduced)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedBuilder(
                    animation: _life,
                    builder: (context, _) => FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 1 - _life.value,
                      child: ColoredBox(
                        color: c.accentText,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(height: 3),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
