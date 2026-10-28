import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

/// Görsel durum tonu (README "Durum renkleri"). Yalnız görünüm: hangi iş durumunun hangi tona
/// düştüğü ekranın/feature'ın kararıdır; core görev/rol kavramı taşımaz.
enum NzTone {
  /// Nötr / başlamadı (`ink-faint`).
  neutral,

  /// Devam ediyor (`violet`).
  progress,

  /// Bekliyor, onay/tarih talebi (`gold`).
  waiting,

  /// Gecikme, hata (`danger`).
  danger,

  /// Tamam (`accent-text`).
  done,

  /// Bilgi (nötr ikincil; tasarımda ayrı bilgi rengi yok).
  info;

  /// Tonun işaret rengi (nokta, çubuk, ikon). Küçük metin için doğrudan kullanılmaz
  /// (bkz. docs/design-tokens.md kontrast kararları): metin `text`/`textMuted` kalır.
  Color color(NizamioColors c) => switch (this) {
    NzTone.neutral => c.textFaint,
    NzTone.progress => c.inProgress,
    NzTone.waiting => c.warning,
    NzTone.danger => c.danger,
    NzTone.done => c.accentText,
    NzTone.info => c.info,
  };
}

/// Durum etiketi: renkli nokta + kelime (durum hiçbir zaman yalnız renkle anlatılmaz).
///
/// [NzStatusLabel.badge] yarı saydam ton dolgulu hap rozettir (prototip `.m-late`: "98 gün
/// gecikti", "3 gecikmede"); mono 11. Rozet metni ton rengindedir (prototip); nötr/devam
/// tonlarında küçük metin kontrastı için `textMuted`.
class NzStatusLabel extends StatelessWidget {
  const NzStatusLabel({
    super.key,
    required this.label,
    required this.tone,
    this.muted = false,
  }) : _badge = false;

  const NzStatusLabel.badge({
    super.key,
    required this.label,
    required this.tone,
  }) : muted = false,
       _badge = true;

  final String label;
  final NzTone tone;

  /// Nokta etiketinde kelime `textMuted` (ikincil satırlarda).
  final bool muted;
  final bool _badge;

  // `.m-late` ton dolgusu: color-mix(danger 16%, transparent).
  static const _tintAlpha = 0.16;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final toneColor = tone.color(c);
    if (_badge) {
      final ink = switch (tone) {
        NzTone.neutral || NzTone.info || NzTone.progress => c.textMuted,
        _ => toneColor,
      };
      return DecoratedBox(
        decoration: BoxDecoration(
          color: toneColor.withValues(alpha: _tintAlpha),
          borderRadius: BorderRadius.circular(NizamioRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space2,
            vertical: NizamioSpacing.space1 / 2,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.monoSm.copyWith(color: ink),
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: NzDot(color: toneColor)),
        const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // `.m-status` 12/500: caption + kart başlığı ağırlığından hafif (500).
            style: t.caption.copyWith(
              color: muted ? c.textMuted : c.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Yuvarlak durum noktası (`.m-dot`, varsayılan 8). Görseldir; anlamı yanındaki kelime taşır.
class NzDot extends StatelessWidget {
  const NzDot({super.key, required this.color, this.size = NizamioSize.dot});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}
