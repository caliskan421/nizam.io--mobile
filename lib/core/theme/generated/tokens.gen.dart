// BU DOSYA ÜRETİLMİŞTİR — elle düzenlenmez. `make gen` (tool/gen.dart) ile yeniden üretilir.
// Kaynak: docs/design/design sytem/tokens.json (blob 2e1521ab9fe6) + design/mobile-tokens.json
//
// Değerler tasarım sistemi tokens.json'dan; rol eşlemesi ve mobil değerler design/mobile-tokens.json'dan.

import 'package:flutter/material.dart';

/// Anlamsal renk rolleri — Material temasına ThemeExtension olarak eklenir.
@immutable
class NizamioColors extends ThemeExtension<NizamioColors> {
  const NizamioColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceOverlay,
    required this.border,
    required this.borderStrong,
    required this.borderControl,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.primary,
    required this.onPrimary,
    required this.accentText,
    required this.focusRing,
    required this.danger,
    required this.onDanger,
    required this.warning,
    required this.onWarning,
    required this.success,
    required this.info,
    required this.scrim,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceOverlay;
  final Color border;
  final Color borderStrong;
  final Color borderControl;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color primary;
  final Color onPrimary;
  final Color accentText;
  final Color focusRing;
  final Color danger;
  final Color onDanger;
  final Color warning;
  final Color onWarning;
  final Color success;
  final Color info;
  final Color scrim;

  static const light = NizamioColors(
    background: Color(0xFFF6F6F3),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF1F1ED),
    surfaceOverlay: Color(0xFFE7E7E2),
    border: Color(0xFFE5E5DF),
    borderStrong: Color(0xFFD0D0C9),
    borderControl: Color(0xFF96968F),
    text: Color(0xFF161615),
    textMuted: Color(0xFF5C5C57),
    textFaint: Color(0xFF71716B),
    primary: Color(0xFFC8F53C),
    onPrimary: Color(0xFF161615),
    accentText: Color(0xFF4A6A00),
    focusRing: Color(0xFF4A6A00),
    danger: Color(0xFFD02B2B),
    onDanger: Color(0xFFFFFFFF),
    warning: Color(0xFFA86F00),
    onWarning: Color(0xFFFFFFFF),
    success: Color(0xFF4A6A00),
    info: Color(0xFF5C5C57),
    scrim: Color(0x66161615),
  );

  static const dark = NizamioColors(
    background: Color(0xFF0B0B0B),
    surface: Color(0xFF151515),
    surfaceRaised: Color(0xFF1F1F1F),
    surfaceOverlay: Color(0xFF2A2A2A),
    border: Color(0xFF262626),
    borderStrong: Color(0xFF3A3A3A),
    borderControl: Color(0xFF6B6B6B),
    text: Color(0xFFF5F5F5),
    textMuted: Color(0xFFA1A1A1),
    textFaint: Color(0xFF8A8A8A),
    primary: Color(0xFFC8F53C),
    onPrimary: Color(0xFF0B0B0B),
    accentText: Color(0xFFC8F53C),
    focusRing: Color(0xFFC8F53C),
    danger: Color(0xFFFF5A5A),
    onDanger: Color(0xFF0B0B0B),
    warning: Color(0xFFFFD166),
    onWarning: Color(0xFF0B0B0B),
    success: Color(0xFFC8F53C),
    info: Color(0xFFA1A1A1),
    scrim: Color(0x8C000000),
  );

  @override
  NizamioColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceOverlay,
    Color? border,
    Color? borderStrong,
    Color? borderControl,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? primary,
    Color? onPrimary,
    Color? accentText,
    Color? focusRing,
    Color? danger,
    Color? onDanger,
    Color? warning,
    Color? onWarning,
    Color? success,
    Color? info,
    Color? scrim,
  }) {
    return NizamioColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      borderControl: borderControl ?? this.borderControl,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accentText: accentText ?? this.accentText,
      focusRing: focusRing ?? this.focusRing,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      success: success ?? this.success,
      info: info ?? this.info,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  NizamioColors lerp(NizamioColors? other, double t) {
    if (other == null) return this;
    return NizamioColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderControl: Color.lerp(borderControl, other.borderControl, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

/// Gölgeler (CSS blur değeri `blurRadius` olarak taşınır) — ThemeExtension.
@immutable
class NizamioShadows extends ThemeExtension<NizamioShadows> {
  const NizamioShadows({
    required this.float,
    required this.menu,
    required this.drawer,
    required this.sheet,
    required this.thumb,
    required this.knob,
  });

  final List<BoxShadow> float;
  final List<BoxShadow> menu;
  final List<BoxShadow> drawer;
  final List<BoxShadow> sheet;
  final List<BoxShadow> thumb;
  final List<BoxShadow> knob;

  static const light = NizamioShadows(
    float: [
      BoxShadow(
        color: Color(0x24161615),
        offset: Offset(0.0, 10.0),
        blurRadius: 28.0,
        spreadRadius: 0.0,
      ),
    ],
    menu: [
      BoxShadow(
        color: Color(0x29161615),
        offset: Offset(0.0, 20.0),
        blurRadius: 48.0,
        spreadRadius: 0.0,
      ),
    ],
    drawer: [
      BoxShadow(
        color: Color(0x24161615),
        offset: Offset(-24.0, 0.0),
        blurRadius: 60.0,
        spreadRadius: 0.0,
      ),
    ],
    sheet: [
      BoxShadow(
        color: Color(0x24161615),
        offset: Offset(0.0, 24.0),
        blurRadius: 64.0,
        spreadRadius: 0.0,
      ),
    ],
    thumb: [
      BoxShadow(
        color: Color(0x1F161615),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
    ],
    knob: [
      BoxShadow(
        color: Color(0x59000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  static const dark = NizamioShadows(
    float: [
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(0.0, 12.0),
        blurRadius: 32.0,
        spreadRadius: 0.0,
      ),
    ],
    menu: [
      BoxShadow(
        color: Color(0x8C000000),
        offset: Offset(0.0, 20.0),
        blurRadius: 48.0,
        spreadRadius: 0.0,
      ),
    ],
    drawer: [
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(-24.0, 0.0),
        blurRadius: 60.0,
        spreadRadius: 0.0,
      ),
    ],
    sheet: [
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0.0, 24.0),
        blurRadius: 64.0,
        spreadRadius: 0.0,
      ),
    ],
    thumb: [
      BoxShadow(
        color: Color(0x40000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
    ],
    knob: [
      BoxShadow(
        color: Color(0x59000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  @override
  NizamioShadows copyWith({
    List<BoxShadow>? float,
    List<BoxShadow>? menu,
    List<BoxShadow>? drawer,
    List<BoxShadow>? sheet,
    List<BoxShadow>? thumb,
    List<BoxShadow>? knob,
  }) {
    return NizamioShadows(
      float: float ?? this.float,
      menu: menu ?? this.menu,
      drawer: drawer ?? this.drawer,
      sheet: sheet ?? this.sheet,
      thumb: thumb ?? this.thumb,
      knob: knob ?? this.knob,
    );
  }

  @override
  NizamioShadows lerp(NizamioShadows? other, double t) {
    if (other == null) return this;
    return NizamioShadows(
      float: BoxShadow.lerpList(float, other.float, t)!,
      menu: BoxShadow.lerpList(menu, other.menu, t)!,
      drawer: BoxShadow.lerpList(drawer, other.drawer, t)!,
      sheet: BoxShadow.lerpList(sheet, other.sheet, t)!,
      thumb: BoxShadow.lerpList(thumb, other.thumb, t)!,
      knob: BoxShadow.lerpList(knob, other.knob, t)!,
    );
  }
}

/// Boşluk (mantıksal piksel): 4 pt ızgara `spaceN` (mobil) + tasarımın anlamsal boşlukları.
abstract final class NizamioSpacing {
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
  static const double gutter = 16.0;
  static const double gapXs = 4.0;
  static const double gapSm = 8.0;
  static const double gapMd = 10.0;
  static const double gapLg = 18.0;
  static const double gapXl = 24.0;
  static const double rowPad = 14.0;
  static const double cardPad = 16.0;
}

/// Köşe yarıçapları (mantıksal piksel).
abstract final class NizamioRadius {
  static const double bubbleTail = 6.0;
  static const double folder = 10.0;
  static const double tile = 12.0;
  static const double attach = 14.0;
  static const double group = 16.0;
  static const double row = 18.0;
  static const double card = 20.0;
  static const double flyout = 26.0;
  static const double sheet = 28.0;
  static const double pill = 9999.0;
}

/// Sabit ölçüler: dokunma hedefi, çubuk yükseklikleri; ikon ve çizgi kalınlıkları (mobil).
abstract final class NizamioSize {
  static const double tap = 44.0;
  static const double appbar = 56.0;
  static const double nav = 64.0;
  static const double row = 52.0;
  static const double tabH = 36.0;
  static const double composer = 40.0;
  static const double iconSize = 20.0;
  static const double iconSizeSm = 16.0;
  static const double borderWidth = 1.0;
  static const double focusRingWidth = 2.0;
}

/// Arka plan bulanıklığı (backdrop) yarıçapları.
abstract final class NizamioBlur {
  static const double bar = 18.0;
  static const double chat = 20.0;
  static const double float = 22.0;
  static const double menu = 24.0;
  static const double folder = 8.0;
}

/// Tasarım metin stili (kaynak birimleri: px, em). `NzTextStyles` rollere çevirir.
@immutable
class NizamioTypeSpec {
  const NizamioTypeSpec({
    required this.family,
    required this.size,
    required this.lineHeight,
    required this.weight,
    required this.letterSpacingEm,
  });

  final String family;
  final double size;
  final double lineHeight;
  final FontWeight weight;
  final double letterSpacingEm;
}

/// Tipografi: aileler (birincil ad + yedek yığın) ve tasarım metin stilleri.
abstract final class NizamioTypography {
  static const familySans = 'Inter';
  static const familySansFallback = <String>[
    'system-ui',
    '-apple-system',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];
  static const familyDisplay = 'Poppins';
  static const familyDisplayFallback = <String>[
    'Inter',
    'system-ui',
    'sans-serif',
  ];
  static const familyMono = 'Geist Mono';
  static const familyMonoFallback = <String>[
    'ui-monospace',
    'SFMono-Regular',
    'Menlo',
    'monospace',
  ];
  static const greet = NizamioTypeSpec(
    family: familyDisplay,
    size: 30.0,
    lineHeight: 36.0,
    weight: FontWeight.w600,
    letterSpacingEm: -0.015,
  );
  static const kpi = NizamioTypeSpec(
    family: familyDisplay,
    size: 30.0,
    lineHeight: 34.0,
    weight: FontWeight.w600,
    letterSpacingEm: -0.02,
  );
  static const h1 = NizamioTypeSpec(
    family: familyDisplay,
    size: 28.0,
    lineHeight: 34.0,
    weight: FontWeight.w600,
    letterSpacingEm: -0.015,
  );
  static const h1Detail = NizamioTypeSpec(
    family: familyDisplay,
    size: 24.0,
    lineHeight: 30.0,
    weight: FontWeight.w600,
    letterSpacingEm: -0.01,
  );
  static const sheetTitle = NizamioTypeSpec(
    family: familyDisplay,
    size: 20.0,
    lineHeight: 26.0,
    weight: FontWeight.w600,
    letterSpacingEm: 0.0,
  );
  static const titleInput = NizamioTypeSpec(
    family: familyDisplay,
    size: 20.0,
    lineHeight: 28.0,
    weight: FontWeight.w600,
    letterSpacingEm: 0.0,
  );
  static const brand = NizamioTypeSpec(
    family: familyDisplay,
    size: 16.0,
    lineHeight: 20.0,
    weight: FontWeight.w600,
    letterSpacingEm: -0.01,
  );
  static const cardTitle = NizamioTypeSpec(
    family: familySans,
    size: 16.0,
    lineHeight: 22.0,
    weight: FontWeight.w600,
    letterSpacingEm: 0.0,
  );
  static const input = NizamioTypeSpec(
    family: familySans,
    size: 16.0,
    lineHeight: 21.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.0,
  );
  static const message = NizamioTypeSpec(
    family: familySans,
    size: 15.0,
    lineHeight: 21.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.0,
  );
  static const list = NizamioTypeSpec(
    family: familySans,
    size: 15.0,
    lineHeight: 20.0,
    weight: FontWeight.w500,
    letterSpacingEm: 0.0,
  );
  static const body = NizamioTypeSpec(
    family: familySans,
    size: 14.0,
    lineHeight: 20.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.0,
  );
  static const navLabel = NizamioTypeSpec(
    family: familySans,
    size: 13.0,
    lineHeight: 16.0,
    weight: FontWeight.w600,
    letterSpacingEm: 0.0,
  );
  static const tab = NizamioTypeSpec(
    family: familySans,
    size: 13.0,
    lineHeight: 16.0,
    weight: FontWeight.w600,
    letterSpacingEm: 0.0,
  );
  static const caption = NizamioTypeSpec(
    family: familySans,
    size: 12.0,
    lineHeight: 16.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.0,
  );
  static const code = NizamioTypeSpec(
    family: familyMono,
    size: 13.0,
    lineHeight: 20.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.0,
  );
  static const kicker = NizamioTypeSpec(
    family: familyMono,
    size: 12.0,
    lineHeight: 16.0,
    weight: FontWeight.w500,
    letterSpacingEm: 0.02,
  );
  static const monoSm = NizamioTypeSpec(
    family: familyMono,
    size: 11.0,
    lineHeight: 14.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.0,
  );
  static const program = NizamioTypeSpec(
    family: familyMono,
    size: 10.0,
    lineHeight: 13.0,
    weight: FontWeight.w400,
    letterSpacingEm: 0.02,
  );

  /// Bütün tasarım stilleri (ad → stil); dağıtılan yazı tipi ağırlıkları buradan denetlenir.
  static const styles = <String, NizamioTypeSpec>{
    'greet': greet,
    'kpi': kpi,
    'h1': h1,
    'h1Detail': h1Detail,
    'sheetTitle': sheetTitle,
    'titleInput': titleInput,
    'brand': brand,
    'cardTitle': cardTitle,
    'input': input,
    'message': message,
    'list': list,
    'body': body,
    'navLabel': navLabel,
    'tab': tab,
    'caption': caption,
    'code': code,
    'kicker': kicker,
    'monoSm': monoSm,
    'program': program,
  };
}
