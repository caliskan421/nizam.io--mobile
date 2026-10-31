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

/// Snackbar servisi (durumsuz). `ScaffoldMessenger` üzerinden gösterilir; `MaterialApp.builder`
/// içindeki PrivacyMask altında kalır, ayrı Overlay/pencere açılmaz. Yeni toast öncekinin yerini
/// alır (kuyruk birikmez).
///
/// Görünüm (prototip `.rp-toast`, bundle.css `.m-toast`): ortada içeriğe sarılan yüzen kutu,
/// köşe `m-r-attach` 14, `ink` zemin + `bg-base` yazı 13/600, `m-sh-float` gölge; ton ikonla
/// (bilgi/başarı/hata) ve ikon renginde ayrışır (karşı temanın `accent-text` / `danger` rengi).
/// Kabukta Scaffold'un alt menüsünün (`NzFloatingNav`) üstünde durur (floating snackbar alt
/// menü yüksekliği kadar yukarıda yerleşir); giriş `easeSheet` ile alttan yükselir.
abstract final class NzToast {
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
    final colors = context.colors;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Zemin kutunun kendisinde; SnackBar yalnız konum/zamanlama taşır.
          backgroundColor: colors.text.withValues(alpha: 0),
          elevation: 0,
          padding: EdgeInsets.zero,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(
            NizamioSpacing.gutter,
            0,
            NizamioSpacing.gutter,
            NizamioSpacing.gapSm,
          ),
          content: NzToastBubble(
            message: message,
            tone: tone,
            actionLabel: actionLabel,
            onAction: onAction == null
                ? null
                : () {
                    messenger.hideCurrentSnackBar();
                    onAction();
                  },
          ),
        ),
        snackBarAnimationStyle: AnimationStyle(
          duration: NzMotion.of(context, NizamioMotion.durSheet),
          reverseDuration: NzMotion.of(context, NizamioMotion.durExit),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, tone: NzToastTone.success);

  /// Metin `errorText`; oturum bitti sınıfı hataları ayıklamak ÇAĞIRANIN işidir (listenErrors).
  static void error(BuildContext context, ApiError error) =>
      show(context, errorText(context.l10n, error), tone: NzToastTone.danger);
}

/// Toast kutusu (servisin çizdiği görünüm; katalog/golden için dışa açık).
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

  // Prototip `.rp-toast` iç boşluğu 12 / 18; giriş kayması 8 px (`m-rise-in`).
  static const _padding = EdgeInsets.symmetric(
    horizontal: NizamioSpacing.gapLg,
    vertical: NizamioSpacing.space3,
  );
  static const _rise = 8.0;

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
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: NzMotion.of(context, NizamioMotion.durSheet),
        curve: NizamioMotion.easeSheet,
        builder: (context, v, child) => Opacity(
          opacity: v.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - v) * _rise),
            child: child,
          ),
        ),
        child: bubble,
      ),
    );
  }
}
