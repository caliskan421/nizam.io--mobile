import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Prototip avatar ölçüleri (`.rp-av--sm` 26 · `.rp-av` 32 · `--lg` 44 · `--xl` 52).
enum NzAvatarSize {
  sm(26),
  md(32),
  lg(44),
  xl(52);

  const NzAvatarSize(this.diameter);
  final double diameter;
}

/// Yuvarlak kimlik görseli: ad/soyaddan baş harfler ya da simge. Ağdan görsel çekmez.
///
/// Renk: [tone] null → `accent` dolgu (eski görünüm); 0–4 → tasarım avatar sırası
/// (`avatar1…5`, baş harfler `onAvatar`); [neutralTone] → `bg-overlay` + `ink` (prototip `.rp-av`).
/// Kişi başına kararlı renk için `tone: NzAvatar.toneOf(ad)`.
class NzAvatar extends StatelessWidget {
  /// Baş harfler [name]'den türetilir (Türkçe büyük harf kuralı: i → İ, ı → I).
  /// Okuyucu etiketi [name]'dir.
  const NzAvatar.initials({
    super.key,
    required String this.name,
    this.size = NzSize.md,
    this.tone,
    this.extent,
  }) : icon = null,
       semanticLabel = null;

  /// Simge avatarı; [semanticLabel] verilmezse okuyucudan gizlenir.
  const NzAvatar.icon({
    super.key,
    this.icon = Icons.person_outline,
    this.semanticLabel,
    this.size = NzSize.md,
    this.tone,
    this.extent,
  }) : name = null;

  /// Nötr ton (`bg-overlay` zemin, `ink` yazı).
  static const neutralTone = -1;

  /// Renk sırası uzunluğu (`avatar1…5`).
  static const toneCount = 5;

  /// Addan kararlı renk sırası (0–4): adın (küçük harf) kod noktalarından basit özet; aynı kişi her
  /// ekranda aynı rengi alır.
  static int toneOf(String name) {
    final key = name.trim().toLowerCase();
    var sum = 0;
    for (final r in key.runes) {
      sum = (sum * 31 + r) & 0x7fffffff;
    }
    return sum % toneCount;
  }

  /// Yalnız initials'ta dolu.
  final String? name;

  /// Yalnız icon'da dolu.
  final IconData? icon;
  final String? semanticLabel;
  final NzSize size;

  /// null → `accent`; 0–4 → `avatarN`; [neutralTone] → nötr.
  final int? tone;

  /// Prototip ölçüsü; verilirse [size] çapını ezer.
  final NzAvatarSize? extent;

  (Color, Color) _palette(NizamioColors c) {
    final tone = this.tone;
    if (tone == null) return (c.primary, c.onPrimary);
    if (tone < 0) return (c.surfaceOverlay, c.text);
    final fills = [c.avatar1, c.avatar2, c.avatar3, c.avatar4, c.avatar5];
    return (fills[tone % toneCount], c.onAvatar);
  }

  /// Ada göre en çok iki baş harf: ilk sözcük ve (varsa) son sözcük; Türkçe büyük harf.
  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    String first(String w) => _upperTr(String.fromCharCode(w.runes.first));
    return words.length == 1
        ? first(words.first)
        : first(words.first) + first(words.last);
  }

  static String _upperTr(String s) =>
      s.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);
    final (fill, ink) = _palette(context.colors);
    final shownName = name;
    final Widget inner = shownName != null
        ? Text(
            initialsOf(shownName),
            maxLines: 1,
            style: style.textStyle.copyWith(color: ink),
          )
        : Icon(icon, size: style.iconSize, color: ink);
    return Semantics(
      container: true,
      image: true,
      label: shownName ?? semanticLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: style.diameter,
        height: style.diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: Center(
            child: FittedBox(fit: BoxFit.scaleDown, child: inner),
          ),
        ),
      ),
    );
  }

  // Boyut görünümünün tek yeri.
  ({double diameter, TextStyle textStyle, double iconSize}) _resolveStyle(
    BuildContext context,
  ) {
    final text = context.text;
    final extent = this.extent;
    if (extent != null) {
      // `.rp-av` 12/600; büyük boylarda kart başlığı rolü (FittedBox küçültür).
      final role = switch (extent) {
        NzAvatarSize.sm || NzAvatarSize.md => text.caption,
        NzAvatarSize.lg || NzAvatarSize.xl => text.labelLg,
      };
      return (
        diameter: extent.diameter,
        textStyle: role.copyWith(fontWeight: FontWeight.w600),
        iconSize: extent.diameter / 2,
      );
    }
    return (
      diameter: size.pick(
        sm: NizamioSpacing.space8,
        md: NizamioSpacing.space10,
        lg: NizamioSpacing.space16,
      ),
      textStyle: size.pick(
        sm: text.labelMd,
        md: text.labelLg,
        lg: text.titleMd,
      ),
      iconSize: size.pick(
        sm: NizamioSpacing.space5,
        md: NizamioSpacing.space6,
        lg: NizamioSpacing.space8,
      ),
    );
  }
}
