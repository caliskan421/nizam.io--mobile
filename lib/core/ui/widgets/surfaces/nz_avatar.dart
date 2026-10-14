import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Yuvarlak kimlik görseli: ad/soyaddan baş harfler ya da simge. Ağdan görsel çekmez.
class NzAvatar extends StatelessWidget {
  /// Baş harfler [name]'den türetilir (Türkçe büyük harf kuralı: i → İ, ı → I).
  /// Okuyucu etiketi [name]'dir.
  const NzAvatar.initials({
    super.key,
    required String this.name,
    this.size = NzSize.md,
  }) : icon = null,
       semanticLabel = null;

  /// Simge avatarı; [semanticLabel] verilmezse okuyucudan gizlenir.
  const NzAvatar.icon({
    super.key,
    this.icon = Icons.person_outline,
    this.semanticLabel,
    this.size = NzSize.md,
  }) : name = null;

  /// Yalnız initials'ta dolu.
  final String? name;

  /// Yalnız icon'da dolu.
  final IconData? icon;
  final String? semanticLabel;
  final NzSize size;

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
    final colors = context.colors;
    final shownName = name;
    final Widget inner = shownName != null
        ? Text(
            initialsOf(shownName),
            maxLines: 1,
            style: style.textStyle.copyWith(color: colors.onPrimary),
          )
        : Icon(icon, size: style.iconSize, color: colors.onPrimary);
    return Semantics(
      container: true,
      image: true,
      label: shownName ?? semanticLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: style.diameter,
        height: style.diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
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
