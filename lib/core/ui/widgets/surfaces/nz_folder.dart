import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_pressable.dart';

/// Arşiv klasörü (tasarım sistemi `components/Folder`, bundle.css `.m-folder`): düz
/// `folder-back` sekmeli arka kapak + üstten bulanık cam ön panel (`folder-front →
/// folder-front-mid → bg-base`, üst iç ışık); altında ad (tek satır) ve açıklama ("78 dosya").
/// Klasör gövdesi her zaman aynıdır, renk taşımaz. [small] görev klasörüdür (64×54, ad iki
/// satır). Dokunma alanı bütün kutudur; ekran okuyucuya "ad, açıklama" düğmesi.
class NzFolder extends StatelessWidget {
  const NzFolder({
    super.key,
    required this.name,
    required this.caption,
    required this.onTap,
    this.small = false,
  });

  final String name;
  final String caption;
  final VoidCallback? onTap;
  final bool small;

  /// Büyük klasör çizimi (prototip 84×70; ön panel üstten 22).
  static const Size artSize = Size(84, 70);

  /// Görev klasörü çizimi (prototip 64×54; ön panel üstten 17).
  static const Size artSizeSmall = Size(64, 54);

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    final c = context.colors;
    final size = small ? artSizeSmall : artSize;
    return Semantics(
      button: onTap != null,
      label: '$name, $caption',
      excludeSemantics: true,
      child: NzPressable(
        enabled: onTap != null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NizamioRadius.tile),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: NizamioSize.tap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NzFolderArt(size: size, frontTop: small ? 17 : 22),
                Gap(small ? NizamioSpacing.space2 : NizamioSpacing.gapMd),
                Text(
                  name,
                  maxLines: small ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: (small ? t.caption : t.bodyMd).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
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

/// Yalnız klasör çizimi (arka kapak + cam ön panel); [NzFolder] ve küçük ikon yerleri için.
class NzFolderArt extends StatelessWidget {
  const NzFolderArt({
    super.key,
    this.size = NzFolder.artSize,
    this.frontTop = 22,
  });

  final Size size;

  /// Ön panelin üstten uzaklığı (büyük 22, küçük 17).
  final double frontTop;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(
      size.width < NzFolder.artSize.width
          ? NizamioRadius.folder * 0.8
          : NizamioRadius.folder,
    );
    return ExcludeSemantics(
      child: SizedBox.fromSize(
        size: size,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _FolderBackPainter(c.folderBack)),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: frontTop,
              bottom: 0,
              child: ClipRRect(
                borderRadius: radius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: NizamioBlur.folder,
                    sigmaY: NizamioBlur.folder,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [c.folderFront, c.folderFrontMid, c.background],
                        stops: const [0, 0.45, 1],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: NizamioSize.borderWidth,
                        color: c.edgeLight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Prototip SVG yolu (viewBox 84×70): `M4 6a6 6 0 0 1 6-6h17c2.4 0 3.8.8 5 2.6l2.2 3.2c1 1.5
/// 2 2.2 4 2.2H74a6 6 0 0 1 6 6V62H4z`; çizim kutuya ölçeklenir.
class _FolderBackPainter extends CustomPainter {
  _FolderBackPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 84, size.height / 70);
    final p = Path()
      ..moveTo(4, 6)
      ..arcToPoint(const Offset(10, 0), radius: const Radius.circular(6))
      ..lineTo(27, 0)
      ..cubicTo(29.4, 0, 30.8, 0.8, 32, 2.6)
      ..lineTo(34.2, 5.8)
      ..cubicTo(35.2, 7.3, 36.2, 8, 38.2, 8)
      ..lineTo(74, 8)
      ..arcToPoint(const Offset(80, 14), radius: const Radius.circular(6))
      ..lineTo(80, 62)
      ..lineTo(4, 62)
      ..close();
    canvas.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_FolderBackPainter old) => old.color != color;
}
