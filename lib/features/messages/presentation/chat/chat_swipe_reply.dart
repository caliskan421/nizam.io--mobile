import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';

/// Kaydırarak yanıtlama: satır sağa çekildikçe solda yanıt simgesi belirir; [threshold]
/// geçilince hafif titreşim, bırakınca [onReply]. Satır yaylanarak yerine döner. [onReply] null
/// → kaydırma kapalı (gönderilmemiş mesaj). Dikey kaydırmayla çakışmaz (yatay sürükleme).
class ChatSwipeReply extends StatefulWidget {
  const ChatSwipeReply({
    super.key,
    required this.child,
    required this.onReply,
    this.threshold = 64,
  });

  final Widget child;
  final VoidCallback? onReply;
  final double threshold;

  @override
  State<ChatSwipeReply> createState() => _ChatSwipeReplyState();
}

class _ChatSwipeReplyState extends State<ChatSwipeReply>
    with SingleTickerProviderStateMixin {
  late final _back = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  double _dx = 0;
  bool _armed = false;

  /// Çekme direnci: eşikten sonra yavaşlar, en çok eşiğin 1,4 katı.
  double get _max => widget.threshold * 1.4;

  @override
  void initState() {
    super.initState();
    _back.addListener(() => setState(() => _dx = _from * (1 - _back.value)));
  }

  double _from = 0;

  @override
  void dispose() {
    _back.dispose();
    super.dispose();
  }

  void _update(DragUpdateDetails d) {
    _back.stop();
    final next = (_dx + d.delta.dx * (_dx > widget.threshold ? 0.4 : 1)).clamp(
      0.0,
      _max,
    );
    final armed = next >= widget.threshold;
    if (armed && !_armed) HapticFeedback.lightImpact();
    setState(() {
      _dx = next;
      _armed = armed;
    });
  }

  void _end([DragEndDetails? _]) {
    if (_armed) widget.onReply?.call();
    _armed = false;
    _from = _dx;
    _back.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onReply == null) return widget.child;
    final c = context.colors;
    final progress = (_dx / widget.threshold).clamp(0.0, 1.0);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _update,
      onHorizontalDragEnd: _end,
      onHorizontalDragCancel: _end,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Görsel: anlamı uzun basma menüsündeki "Yanıtla" taşır.
          if (_dx > 0)
            Positioned(
              left: NizamioSpacing.space2,
              child: ExcludeSemantics(
                child: Opacity(
                  opacity: progress,
                  child: Transform.scale(
                    scale: 0.6 + 0.4 * progress,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _armed ? c.surfaceOverlay : c.surfaceRaised,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(NizamioSpacing.space2),
                        child: NzIcon(
                          NzIcons.reply,
                          size: NizamioSize.iconSizeSm,
                          color: _armed ? c.text : c.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Transform.translate(offset: Offset(_dx, 0), child: widget.child),
        ],
      ),
    );
  }
}
