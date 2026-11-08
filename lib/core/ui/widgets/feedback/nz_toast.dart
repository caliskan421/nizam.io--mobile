import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../errors/api_error.dart';
import '../../../errors/error_text.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

enum NzToastTone { info, success, danger }

/// Snackbar servisi. `ScaffoldMessenger` üzerinden gösterilir (konum: kabukta alt menünün
/// üstü; `MaterialApp.builder` içindeki PrivacyMask altında kalır, ayrı Overlay/pencere açılmaz).
///
/// Görünüm (prototip `.rp-toast`, bundle.css `.m-toast`): ortada içeriğe sarılan yüzen kutu,
/// köşe `m-r-attach` 14, `ink` zemin + `bg-base` yazı 13/600, `m-sh-float` gölge; ton ikonla
/// (bilgi/başarı/hata) ve ikon renginde ayrışır (karşı temanın `accent-text` / `danger` rengi).
///
/// Hareket (prototip `say`): kutu BİR BÜTÜN olarak aşağıdan hızlıca kayıp gelir, [life] sonra
/// aşağı iner (SnackBar'ın kendi kırparak büyüyen girişi kapalıdır). Görünürken yeni toast
/// gelirse yeniden canlandırılmaz: içerik yerinde değişir ve süre baştan sayılır (aynı düğmeye
/// art arda basmak kutuyu oynatmaz). İnerken gelen toast kutuyu geri çıkarır.
abstract final class NzToast {
  /// Görünürlük süresi (prototip 2400 ms; eylemliyse 3200 ms).
  static const life = Duration(milliseconds: 2400);
  static const lifeWithAction = Duration(milliseconds: 3200);

  /// Ekrandaki toast (yoksa null); yeni çağrı onu günceller.
  static _ToastSlotState? _current;

  static void show(
    BuildContext context,
    String message, {
    NzToastTone tone = NzToastTone.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    assert(
      (actionLabel == null) == (onAction == null),
      'actionLabel ve onAction birlikte verilir',
    );
    final messenger = ScaffoldMessenger.of(context);
    final data = _ToastData(message, tone, actionLabel, onAction);
    final current = _current;
    if (current != null && current.mounted && current.messenger == messenger) {
      current.update(data);
      return;
    }
    final colors = context.colors;
    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Zemin kutunun kendisinde; SnackBar yalnız konum taşır. Süre ve hareket kutunundur:
          // SnackBar'ın zamanlayıcısı devreye girmesin diye uzun, kendi hareketi sıfır, kırpma yok
          // (kutu sınırın dışından kayarak gelir).
          backgroundColor: colors.text.withValues(alpha: 0),
          elevation: 0,
          padding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(hours: 1),
          margin: const EdgeInsets.fromLTRB(
            NizamioSpacing.gutter,
            0,
            NizamioSpacing.gutter,
            NizamioSpacing.gapSm,
          ),
          content: _ToastSlot(messenger: messenger, initial: data),
        ),
        snackBarAnimationStyle: const AnimationStyle(
          duration: Duration.zero,
          reverseDuration: Duration.zero,
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, tone: NzToastTone.success);

  /// Metin `errorText`; oturum bitti sınıfı hataları ayıklamak ÇAĞIRANIN işidir (listenErrors).
  static void error(BuildContext context, ApiError error) =>
      show(context, errorText(context.l10n, error), tone: NzToastTone.danger);
}

@immutable
class _ToastData {
  const _ToastData(this.message, this.tone, this.actionLabel, this.onAction);

  final String message;
  final NzToastTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;
}

/// Toast'ın yaşam döngüsü: giriş, süre sayacı, güncelleme, çıkış ve SnackBar'ın kaldırılması.
class _ToastSlot extends StatefulWidget {
  const _ToastSlot({required this.messenger, required this.initial});

  final ScaffoldMessengerState messenger;
  final _ToastData initial;

  @override
  State<_ToastSlot> createState() => _ToastSlotState();
}

class _ToastSlotState extends State<_ToastSlot>
    with SingleTickerProviderStateMixin {
  // Hızlı giriş (yumuşak duruş), daha hızlı iniş.
  static const _in = Duration(milliseconds: 260);
  static const _out = Duration(milliseconds: 200);
  static const _inCurve = Cubic(.2, .8, .2, 1);

  late _ToastData _data = widget.initial;
  late final _move = AnimationController(vsync: this);
  Timer? _life;

  ScaffoldMessengerState get messenger => widget.messenger;

  @override
  void initState() {
    super.initState();
    NzToast._current = this;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // İlk kare: bağımlılıklar (hareketi azalt) hazır olunca giriş.
    if (_move.status == AnimationStatus.dismissed && _life == null) _enter();
  }

  void _enter() {
    _move.animateTo(1, duration: NzMotion.of(context, _in), curve: _inCurve);
    _restart();
  }

  void _restart() {
    _life?.cancel();
    _life = Timer(
      _data.onAction == null ? NzToast.life : NzToast.lifeWithAction,
      _exit,
    );
  }

  /// Yeni içerik: yerinde değişir, süre baştan; inerken geldiyse kutu geri çıkar.
  void update(_ToastData data) {
    setState(() => _data = data);
    if (_move.status == AnimationStatus.reverse ||
        _move.status == AnimationStatus.dismissed) {
      _enter();
    } else {
      _restart();
    }
  }

  Future<void> _exit() async {
    _life?.cancel();
    await _move.animateBack(
      0,
      duration: NzMotion.of(context, _out),
      curve: Curves.easeIn,
    );
    // Bu arada güncellendiyse (yeniden çıkıyor) kaldırılmaz.
    if (mounted && _move.isDismissed) messenger.removeCurrentSnackBar();
  }

  @override
  void dispose() {
    _life?.cancel();
    _move.dispose();
    if (identical(NzToast._current, this)) NzToast._current = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    final action = d.onAction;
    return AnimatedBuilder(
      animation: _move,
      builder: (context, child) {
        final v = _move.value;
        return FractionalTranslation(
          translation: Offset(0, (1 - v) * 1.4),
          child: Opacity(opacity: (v * 1.6).clamp(0, 1), child: child),
        );
      },
      child: NzToastBubble(
        message: d.message,
        tone: d.tone,
        actionLabel: d.actionLabel,
        onAction: action == null
            ? null
            : () {
                _exit();
                action();
              },
      ),
    );
  }
}

/// Toast kutusu (servisin çizdiği durağan görünüm; hareket servisindir; katalog/golden için
/// dışa açık).
class NzToastBubble extends StatelessWidget {
  const NzToastBubble({
    super.key,
    required this.message,
    this.tone = NzToastTone.info,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final NzToastTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  // Prototip `.rp-toast` iç boşluğu 12 / 18.
  static const _padding = EdgeInsets.symmetric(
    horizontal: NizamioSpacing.gapLg,
    vertical: NizamioSpacing.space3,
  );

  /// Kutunun zemini (`ink`).
  static Color fill(NizamioColors c) => c.text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = context.theme.brightness == Brightness.dark;
    final inverse = dark ? NizamioColors.light : NizamioColors.dark;
    final foreground = c.background;
    final (icon, iconColor) = switch (tone) {
      NzToastTone.info => (NzIcons.info, foreground),
      NzToastTone.success => (NzIcons.check, inverse.accentText),
      NzToastTone.danger => (NzIcons.error, inverse.danger),
    };
    final style = context.text.labelMd.copyWith(color: foreground);
    final label = actionLabel;
    final bubble = DecoratedBox(
      decoration: BoxDecoration(
        color: fill(c),
        borderRadius: BorderRadius.circular(NizamioRadius.attach),
        boxShadow: context.shadows.float,
      ),
      child: Padding(
        padding: _padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: NzIcon(
                icon,
                color: iconColor,
                size: NizamioSize.iconSizeSm,
              ),
            ),
            const Gap(NizamioSpacing.gapMd),
            Flexible(
              child: Semantics(
                liveRegion: true,
                child: Text(message, style: style),
              ),
            ),
            if (label != null) ...[
              const Gap(NizamioSpacing.space2),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: foreground,
                  textStyle: style,
                  minimumSize: const Size(
                    NizamioSpacing.space12,
                    NizamioSpacing.space12,
                  ),
                  tapTargetSize: MaterialTapTargetSize.padded,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NizamioSpacing.space2,
                  ),
                ),
                child: Text(
                  label,
                  style: style.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: foreground,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
    return Center(child: bubble);
  }
}
