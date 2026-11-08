import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/nz_motion.dart';

// İşaretlenen liste maddesinin hareketi (prototip gündem `.ag-t`, `flip`; toplantı gündemi ve
// görev alt görevleri): satır satır soldan sağa çekilen çizgi, işaretlenen maddenin bir süre
// yerinde tutulması ([NzCheckHold]) ve sıralama değişince satırların eski yerinden yenisine
// kayması ([NzFlipSlot]). Hareketi azalt açıkken hiçbiri yoktur: durum anında değişir.

/// İşaretlenen maddenin yerinde bekleme süresi (çizgi çekilirken sıra değişmez).
const nzCheckHold = Duration(milliseconds: 360);

/// Çizgi (`background-size` 0% → 100%, `.38s cubic-bezier(.4,0,.2,1)`).
const _strikeDuration = Duration(milliseconds: 380);
const _strikeCurve = Cubic(.4, 0, .2, 1);

/// Yazı rengi ve satır saydamlığı geçişi (`.3s`).
const nzCheckFade = Duration(milliseconds: 300);

/// FLIP kayması (`560ms cubic-bezier(.22,1.28,.36,1)`; hafif taşmalı).
const _flipDuration = Duration(milliseconds: 560);
const _flipCurve = Cubic(.22, 1.28, .36, 1);

/// Üstü çizili başlık. `text-decoration` yerine her satırın kendi genişliğinde, satır kutusunun
/// %58 yüksekliğinde 1,5 px çizgi çizilir (`box-decoration-break: clone`); çizgi [done] olunca
/// soldan sağa uzar, kalkınca sağdan sola çekilir. Renk [color]'a `.3s`'de geçer, çizgi yazının
/// o anki rengindedir (`currentColor`).
class NzStrikeText extends StatelessWidget {
  const NzStrikeText({
    super.key,
    required this.text,
    required this.style,
    required this.color,
    required this.done,
  });

  final String text;
  final TextStyle style;
  final Color color;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: NzMotion.of(context, nzCheckFade),
      builder: (context, ink, _) {
        final s = style.copyWith(color: ink);
        return TweenAnimationBuilder<double>(
          tween: Tween(end: done ? 1 : 0),
          duration: NzMotion.of(context, _strikeDuration),
          curve: _strikeCurve,
          builder: (context, progress, child) => CustomPaint(
            foregroundPainter: _StrikePainter(
              text: text,
              style: s,
              ink: ink ?? color,
              scaler: scaler,
              direction: direction,
              progress: progress,
            ),
            child: child,
          ),
          child: Text(text, style: s),
        );
      },
    );
  }
}

class _StrikePainter extends CustomPainter {
  _StrikePainter({
    required this.text,
    required this.style,
    required this.ink,
    required this.scaler,
    required this.direction,
    required this.progress,
  });

  final String text;
  final TextStyle style;

  /// Çizgi rengi: yazının o anki rengi.
  final Color ink;
  final TextScaler scaler;
  final TextDirection direction;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final layout = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: direction,
      textScaler: scaler,
    )..layout(maxWidth: size.width);
    final paint = Paint()..color = ink;
    for (final line in layout.computeLineMetrics()) {
      final y = line.baseline - line.ascent + line.height * .58;
      canvas.drawRect(
        Rect.fromLTWH(line.left, y - .75, line.width * progress, 1.5),
        paint,
      );
    }
    layout.dispose();
  }

  @override
  bool shouldRepaint(_StrikePainter old) =>
      old.progress != progress ||
      old.ink != ink ||
      old.text != text ||
      old.style != style ||
      old.scaler != scaler ||
      old.direction != direction;
}

/// FLIP yuvası: [order] (sıralama kuşağı) değişince satırın eski üst konumu ([area]'ya göre)
/// yeniden düzenlemeden ÖNCE ölçülür, yeni düzenden sonra yenisi; aradaki fark (1 px'ten küçükse
/// atlanır) `translateY(dy) → 0` olarak oynatılır. Yeni eklenen satır kaymaz.
class NzFlipSlot extends StatefulWidget {
  const NzFlipSlot({
    super.key,
    required this.order,
    required this.area,
    required this.child,
  });

  final int order;

  /// Ölçüm referansı (satırların ortak kabı).
  final GlobalKey area;
  final Widget child;

  @override
  State<NzFlipSlot> createState() => _NzFlipSlotState();
}

class _NzFlipSlotState extends State<NzFlipSlot>
    with SingleTickerProviderStateMixin {
  late final _move = AnimationController(vsync: this, duration: _flipDuration);
  var _from = 0.0;

  double? _top() {
    final box = context.findRenderObject();
    final area = widget.area.currentContext?.findRenderObject();
    if (box is! RenderBox || area is! RenderBox) return null;
    if (!box.attached || !box.hasSize || !area.attached) return null;
    return box.localToGlobal(Offset.zero, ancestor: area).dy;
  }

  @override
  void didUpdateWidget(NzFlipSlot old) {
    super.didUpdateWidget(old);
    if (old.order == widget.order || NzMotion.reduced(context)) return;
    // Henüz yeniden düzenlenmedi: konum eski sıranındır. Kayma sürüyorsa görünen yer esas.
    final before = _top();
    if (before == null) return;
    final shown = before + _from * (1 - _flipCurve.transform(_move.value));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final after = _top();
      if (after == null) return;
      final dy = shown - after;
      if (dy.abs() < 1) return;
      setState(() => _from = dy);
      _move.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _move,
    builder: (context, child) => Transform.translate(
      offset: Offset(
        0,
        _move.isAnimating ? _from * (1 - _flipCurve.transform(_move.value)) : 0,
      ),
      child: child,
    ),
    child: widget.child,
  );
}

/// İşaret sıralayıcısı (prototip `toggle` + `held`): açık madde işaretlenince [nzCheckHold]
/// boyunca [held]'de tutulur (sıralamada açık sayılır), sonra bırakılır ve [order] artar (satırlar
/// FLIP oynatır). İşaret kaldırma beklemesizdir: madde hemen bırakılır, [order] artar. Ardışık
/// işaretlerde önceki zamanlayıcı iptal edilir, tutulanlar birlikte bırakılır. Hareketi azalt
/// açıkken tutma ve kayma yoktur. [onRelease] zamanlayıcı bırakınca çağrılır (çağıran yeniden
/// çizer); [dispose] zamanlayıcıyı durdurur.
class NzCheckHold {
  NzCheckHold(this.onRelease);

  final VoidCallback onRelease;

  /// Yerinde tutulan madde kimlikleri.
  final held = <String>{};

  /// Sıralama kuşağı ([NzFlipSlot.order]).
  var order = 0;

  Timer? _release;

  /// [id]'nin işareti değişti; [wasDone] işaretten önceki durumdur. Çağıran ardından yeniden
  /// çizer (aynı karede sıralama ve durum birlikte değişir).
  void toggle(String id, {required bool wasDone, required bool reduced}) {
    if (wasDone) {
      held.remove(id);
      if (!reduced) order++;
      return;
    }
    _release?.cancel();
    if (reduced) {
      held.clear();
      return;
    }
    held.add(id);
    _release = Timer(nzCheckHold, () {
      held.clear();
      order++;
      onRelease();
    });
  }

  void dispose() => _release?.cancel();
}
