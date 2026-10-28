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
    required this.surfaceTop,
    required this.edgeLight,
    required this.primaryTop,
    required this.buttonTop,
    required this.buttonBottom,
    required this.buttonBorder,
    required this.inProgress,
    required this.onInProgress,
    required this.glassBar,
    required this.glassFloat,
    required this.glassMenu,
    required this.glassEdge,
    required this.glassInk,
    required this.glassInkFaint,
    required this.navHighlight,
    required this.scrimSoft,
    required this.roleAdmin,
    required this.roleCoordinator,
    required this.roleMember,
    required this.avatar1,
    required this.avatar2,
    required this.avatar3,
    required this.avatar4,
    required this.avatar5,
    required this.onAvatar,
    required this.switchKnob,
    required this.ganttTodo,
    required this.ganttDoing,
    required this.ganttReview,
    required this.ganttBack,
    required this.ganttDone,
    required this.ganttLate,
    required this.ganttLateLine,
    required this.ganttInk,
    required this.ganttInkMuted,
    required this.bubbleMine,
    required this.bubbleOther,
    required this.quoteFill,
    required this.refChip,
    required this.dayChip,
    required this.folderBack,
    required this.folderFront,
    required this.folderFrontMid,
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
  final Color surfaceTop;
  final Color edgeLight;
  final Color primaryTop;
  final Color buttonTop;
  final Color buttonBottom;
  final Color buttonBorder;
  final Color inProgress;
  final Color onInProgress;
  final Color glassBar;
  final Color glassFloat;
  final Color glassMenu;
  final Color glassEdge;
  final Color glassInk;
  final Color glassInkFaint;
  final Color navHighlight;
  final Color scrimSoft;
  final Color roleAdmin;
  final Color roleCoordinator;
  final Color roleMember;
  final Color avatar1;
  final Color avatar2;
  final Color avatar3;
  final Color avatar4;
  final Color avatar5;
  final Color onAvatar;
  final Color switchKnob;
  final Color ganttTodo;
  final Color ganttDoing;
  final Color ganttReview;
  final Color ganttBack;
  final Color ganttDone;
  final Color ganttLate;
  final Color ganttLateLine;
  final Color ganttInk;
  final Color ganttInkMuted;
  final Color bubbleMine;
  final Color bubbleOther;
  final Color quoteFill;
  final Color refChip;
  final Color dayChip;
  final Color folderBack;
  final Color folderFront;
  final Color folderFrontMid;

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
    surfaceTop: Color(0xFFFFFFFF),
    edgeLight: Color(0xCCFFFFFF),
    primaryTop: Color(0xFFD8F866),
    buttonTop: Color(0xFFFFFFFF),
    buttonBottom: Color(0xFFF4F4F0),
    buttonBorder: Color(0xFFD5D5CE),
    inProgress: Color(0xFF7A26C1),
    onInProgress: Color(0xFFFFFFFF),
    glassBar: Color(0xC7F6F6F3),
    glassFloat: Color(0xC7FFFFFF),
    glassMenu: Color(0xEBFFFFFF),
    glassEdge: Color(0x1A161615),
    glassInk: Color(0xFF161615),
    glassInkFaint: Color(0xFF71716B),
    navHighlight: Color(0x14161615),
    scrimSoft: Color(0x2E161615),
    roleAdmin: Color(0xFFE57A9A),
    roleCoordinator: Color(0xFF74C27A),
    roleMember: Color(0xFF73A9E3),
    avatar1: Color(0xFFC8F53C),
    avatar2: Color(0xFFB39DFF),
    avatar3: Color(0xFFFFD166),
    avatar4: Color(0xFF6EC1FF),
    avatar5: Color(0xFFFF8A65),
    onAvatar: Color(0xFF121212),
    switchKnob: Color(0xFFFFFFFF),
    ganttTodo: Color(0xFFD3D6DC),
    ganttDoing: Color(0xFFD2A2EE),
    ganttReview: Color(0xFFFFDC85),
    ganttBack: Color(0xFFFFB4A4),
    ganttDone: Color(0xFFD6F56F),
    ganttLate: Color(0xFFFFA0A0),
    ganttLateLine: Color(0xFFD02B2B),
    ganttInk: Color(0xFF17181C),
    ganttInkMuted: Color(0xFF4A4D55),
    bubbleMine: Color(0xFFF3FDD4),
    bubbleOther: Color(0xFFF1F1ED),
    quoteFill: Color(0x0D161615),
    refChip: Color(0xFFECF2D4),
    dayChip: Color(0xD9E7E7E2),
    folderBack: Color(0xFFA8A8A2),
    folderFront: Color(0x99FFFFFF),
    folderFrontMid: Color(0x8CD2D2CC),
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
    surfaceTop: Color(0xFF1C1C1C),
    edgeLight: Color(0x12FFFFFF),
    primaryTop: Color(0xFFD8F866),
    buttonTop: Color(0xFF323232),
    buttonBottom: Color(0xFF262626),
    buttonBorder: Color(0xFF3C3C3C),
    inProgress: Color(0xFF9B30D9),
    onInProgress: Color(0xFFFFFFFF),
    glassBar: Color(0xC70B0B0B),
    glassFloat: Color(0xBD121212),
    glassMenu: Color(0xDB181818),
    glassEdge: Color(0x14FFFFFF),
    glassInk: Color(0xFFF5F5F5),
    glassInkFaint: Color(0xFF8A8A8A),
    navHighlight: Color(0x21FFFFFF),
    scrimSoft: Color(0x47000000),
    roleAdmin: Color(0xFFE57A9A),
    roleCoordinator: Color(0xFF74C27A),
    roleMember: Color(0xFF73A9E3),
    avatar1: Color(0xFFC8F53C),
    avatar2: Color(0xFFB39DFF),
    avatar3: Color(0xFFFFD166),
    avatar4: Color(0xFF6EC1FF),
    avatar5: Color(0xFFFF8A65),
    onAvatar: Color(0xFF121212),
    switchKnob: Color(0xFFFFFFFF),
    ganttTodo: Color(0xFFB4B7BE),
    ganttDoing: Color(0xFFC27CE6),
    ganttReview: Color(0xFFFFD166),
    ganttBack: Color(0xFFFF9A85),
    ganttDone: Color(0xFFC8F53C),
    ganttLate: Color(0xFFFF7D7D),
    ganttLateLine: Color(0xFFFF5A5A),
    ganttInk: Color(0xFF17181C),
    ganttInkMuted: Color(0xFF4A4D55),
    bubbleMine: Color(0xFF414B22),
    bubbleOther: Color(0xFF1F1F1F),
    quoteFill: Color(0x0FFFFFFF),
    refChip: Color(0xFF373D23),
    dayChip: Color(0xCC282828),
    folderBack: Color(0xFF6E6E6E),
    folderFront: Color(0x8CAFAFAF),
    folderFrontMid: Color(0x8C5F5F5F),
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
    Color? surfaceTop,
    Color? edgeLight,
    Color? primaryTop,
    Color? buttonTop,
    Color? buttonBottom,
    Color? buttonBorder,
    Color? inProgress,
    Color? onInProgress,
    Color? glassBar,
    Color? glassFloat,
    Color? glassMenu,
    Color? glassEdge,
    Color? glassInk,
    Color? glassInkFaint,
    Color? navHighlight,
    Color? scrimSoft,
    Color? roleAdmin,
    Color? roleCoordinator,
    Color? roleMember,
    Color? avatar1,
    Color? avatar2,
    Color? avatar3,
    Color? avatar4,
    Color? avatar5,
    Color? onAvatar,
    Color? switchKnob,
    Color? ganttTodo,
    Color? ganttDoing,
    Color? ganttReview,
    Color? ganttBack,
    Color? ganttDone,
    Color? ganttLate,
    Color? ganttLateLine,
    Color? ganttInk,
    Color? ganttInkMuted,
    Color? bubbleMine,
    Color? bubbleOther,
    Color? quoteFill,
    Color? refChip,
    Color? dayChip,
    Color? folderBack,
    Color? folderFront,
    Color? folderFrontMid,
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
      surfaceTop: surfaceTop ?? this.surfaceTop,
      edgeLight: edgeLight ?? this.edgeLight,
      primaryTop: primaryTop ?? this.primaryTop,
      buttonTop: buttonTop ?? this.buttonTop,
      buttonBottom: buttonBottom ?? this.buttonBottom,
      buttonBorder: buttonBorder ?? this.buttonBorder,
      inProgress: inProgress ?? this.inProgress,
      onInProgress: onInProgress ?? this.onInProgress,
      glassBar: glassBar ?? this.glassBar,
      glassFloat: glassFloat ?? this.glassFloat,
      glassMenu: glassMenu ?? this.glassMenu,
      glassEdge: glassEdge ?? this.glassEdge,
      glassInk: glassInk ?? this.glassInk,
      glassInkFaint: glassInkFaint ?? this.glassInkFaint,
      navHighlight: navHighlight ?? this.navHighlight,
      scrimSoft: scrimSoft ?? this.scrimSoft,
      roleAdmin: roleAdmin ?? this.roleAdmin,
      roleCoordinator: roleCoordinator ?? this.roleCoordinator,
      roleMember: roleMember ?? this.roleMember,
      avatar1: avatar1 ?? this.avatar1,
      avatar2: avatar2 ?? this.avatar2,
      avatar3: avatar3 ?? this.avatar3,
      avatar4: avatar4 ?? this.avatar4,
      avatar5: avatar5 ?? this.avatar5,
      onAvatar: onAvatar ?? this.onAvatar,
      switchKnob: switchKnob ?? this.switchKnob,
      ganttTodo: ganttTodo ?? this.ganttTodo,
      ganttDoing: ganttDoing ?? this.ganttDoing,
      ganttReview: ganttReview ?? this.ganttReview,
      ganttBack: ganttBack ?? this.ganttBack,
      ganttDone: ganttDone ?? this.ganttDone,
      ganttLate: ganttLate ?? this.ganttLate,
      ganttLateLine: ganttLateLine ?? this.ganttLateLine,
      ganttInk: ganttInk ?? this.ganttInk,
      ganttInkMuted: ganttInkMuted ?? this.ganttInkMuted,
      bubbleMine: bubbleMine ?? this.bubbleMine,
      bubbleOther: bubbleOther ?? this.bubbleOther,
      quoteFill: quoteFill ?? this.quoteFill,
      refChip: refChip ?? this.refChip,
      dayChip: dayChip ?? this.dayChip,
      folderBack: folderBack ?? this.folderBack,
      folderFront: folderFront ?? this.folderFront,
      folderFrontMid: folderFrontMid ?? this.folderFrontMid,
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
      surfaceTop: Color.lerp(surfaceTop, other.surfaceTop, t)!,
      edgeLight: Color.lerp(edgeLight, other.edgeLight, t)!,
      primaryTop: Color.lerp(primaryTop, other.primaryTop, t)!,
      buttonTop: Color.lerp(buttonTop, other.buttonTop, t)!,
      buttonBottom: Color.lerp(buttonBottom, other.buttonBottom, t)!,
      buttonBorder: Color.lerp(buttonBorder, other.buttonBorder, t)!,
      inProgress: Color.lerp(inProgress, other.inProgress, t)!,
      onInProgress: Color.lerp(onInProgress, other.onInProgress, t)!,
      glassBar: Color.lerp(glassBar, other.glassBar, t)!,
      glassFloat: Color.lerp(glassFloat, other.glassFloat, t)!,
      glassMenu: Color.lerp(glassMenu, other.glassMenu, t)!,
      glassEdge: Color.lerp(glassEdge, other.glassEdge, t)!,
      glassInk: Color.lerp(glassInk, other.glassInk, t)!,
      glassInkFaint: Color.lerp(glassInkFaint, other.glassInkFaint, t)!,
      navHighlight: Color.lerp(navHighlight, other.navHighlight, t)!,
      scrimSoft: Color.lerp(scrimSoft, other.scrimSoft, t)!,
      roleAdmin: Color.lerp(roleAdmin, other.roleAdmin, t)!,
      roleCoordinator: Color.lerp(roleCoordinator, other.roleCoordinator, t)!,
      roleMember: Color.lerp(roleMember, other.roleMember, t)!,
      avatar1: Color.lerp(avatar1, other.avatar1, t)!,
      avatar2: Color.lerp(avatar2, other.avatar2, t)!,
      avatar3: Color.lerp(avatar3, other.avatar3, t)!,
      avatar4: Color.lerp(avatar4, other.avatar4, t)!,
      avatar5: Color.lerp(avatar5, other.avatar5, t)!,
      onAvatar: Color.lerp(onAvatar, other.onAvatar, t)!,
      switchKnob: Color.lerp(switchKnob, other.switchKnob, t)!,
      ganttTodo: Color.lerp(ganttTodo, other.ganttTodo, t)!,
      ganttDoing: Color.lerp(ganttDoing, other.ganttDoing, t)!,
      ganttReview: Color.lerp(ganttReview, other.ganttReview, t)!,
      ganttBack: Color.lerp(ganttBack, other.ganttBack, t)!,
      ganttDone: Color.lerp(ganttDone, other.ganttDone, t)!,
      ganttLate: Color.lerp(ganttLate, other.ganttLate, t)!,
      ganttLateLine: Color.lerp(ganttLateLine, other.ganttLateLine, t)!,
      ganttInk: Color.lerp(ganttInk, other.ganttInk, t)!,
      ganttInkMuted: Color.lerp(ganttInkMuted, other.ganttInkMuted, t)!,
      bubbleMine: Color.lerp(bubbleMine, other.bubbleMine, t)!,
      bubbleOther: Color.lerp(bubbleOther, other.bubbleOther, t)!,
      quoteFill: Color.lerp(quoteFill, other.quoteFill, t)!,
      refChip: Color.lerp(refChip, other.refChip, t)!,
      dayChip: Color.lerp(dayChip, other.dayChip, t)!,
      folderBack: Color.lerp(folderBack, other.folderBack, t)!,
      folderFront: Color.lerp(folderFront, other.folderFront, t)!,
      folderFrontMid: Color.lerp(folderFrontMid, other.folderFrontMid, t)!,
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
    required this.card,
  });

  final List<BoxShadow> float;
  final List<BoxShadow> menu;
  final List<BoxShadow> drawer;
  final List<BoxShadow> sheet;
  final List<BoxShadow> thumb;
  final List<BoxShadow> knob;
  final List<BoxShadow> card;

  static const light = NizamioShadows(
    float: <BoxShadow>[
      BoxShadow(
        color: Color(0x24161615),
        offset: Offset(0.0, 10.0),
        blurRadius: 28.0,
        spreadRadius: 0.0,
      ),
    ],
    menu: <BoxShadow>[
      BoxShadow(
        color: Color(0x29161615),
        offset: Offset(0.0, 20.0),
        blurRadius: 48.0,
        spreadRadius: 0.0,
      ),
    ],
    drawer: <BoxShadow>[
      BoxShadow(
        color: Color(0x24161615),
        offset: Offset(-24.0, 0.0),
        blurRadius: 60.0,
        spreadRadius: 0.0,
      ),
    ],
    sheet: <BoxShadow>[
      BoxShadow(
        color: Color(0x24161615),
        offset: Offset(0.0, 24.0),
        blurRadius: 64.0,
        spreadRadius: 0.0,
      ),
    ],
    thumb: <BoxShadow>[
      BoxShadow(
        color: Color(0x1F161615),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
    ],
    knob: <BoxShadow>[
      BoxShadow(
        color: Color(0x59000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ],
    card: <BoxShadow>[
      BoxShadow(
        color: Color(0x0D161615),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x0F161615),
        offset: Offset(0.0, 6.0),
        blurRadius: 20.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  static const dark = NizamioShadows(
    float: <BoxShadow>[
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(0.0, 12.0),
        blurRadius: 32.0,
        spreadRadius: 0.0,
      ),
    ],
    menu: <BoxShadow>[
      BoxShadow(
        color: Color(0x8C000000),
        offset: Offset(0.0, 20.0),
        blurRadius: 48.0,
        spreadRadius: 0.0,
      ),
    ],
    drawer: <BoxShadow>[
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(-24.0, 0.0),
        blurRadius: 60.0,
        spreadRadius: 0.0,
      ),
    ],
    sheet: <BoxShadow>[
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0.0, 24.0),
        blurRadius: 64.0,
        spreadRadius: 0.0,
      ),
    ],
    thumb: <BoxShadow>[
      BoxShadow(
        color: Color(0x40000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
    ],
    knob: <BoxShadow>[
      BoxShadow(
        color: Color(0x59000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ],
    card: <BoxShadow>[],
  );

  @override
  NizamioShadows copyWith({
    List<BoxShadow>? float,
    List<BoxShadow>? menu,
    List<BoxShadow>? drawer,
    List<BoxShadow>? sheet,
    List<BoxShadow>? thumb,
    List<BoxShadow>? knob,
    List<BoxShadow>? card,
  }) {
    return NizamioShadows(
      float: float ?? this.float,
      menu: menu ?? this.menu,
      drawer: drawer ?? this.drawer,
      sheet: sheet ?? this.sheet,
      thumb: thumb ?? this.thumb,
      knob: knob ?? this.knob,
      card: card ?? this.card,
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
      card: BoxShadow.lerpList(card, other.card, t)!,
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
  static const double controlSm = 36.0;
  static const double controlMd = 44.0;
  static const double controlLg = 52.0;
  static const double iconTile = 36.0;
  static const double iconTileLg = 40.0;
  static const double glassButton = 40.0;
  static const double progress = 4.0;
  static const double progressLg = 6.0;
  static const double dot = 8.0;
  static const double statusDot = 7.0;
  static const double drawerWidth = 318.0;
  static const double flyoutWidth = 248.0;
}

/// Arka plan bulanıklığı (backdrop) yarıçapları.
abstract final class NizamioBlur {
  static const double bar = 18.0;
  static const double chat = 20.0;
  static const double float = 22.0;
  static const double menu = 24.0;
  static const double folder = 8.0;
}

/// Hareket: süre ve eğriler tasarım `components/bundle.css` (`--m-dur-*`, `--m-ease-*`),
/// basma ölçekleri mobil eşleme. Azaltılmış hareket `NzMotion` ile uygulanır.
abstract final class NizamioMotion {
  static const Duration durSheet = Duration(milliseconds: 420);
  static const Duration durExit = Duration(milliseconds: 240);
  static const Duration durNav = Duration(milliseconds: 620);
  static const Duration durPress = Duration(milliseconds: 160);
  static const Cubic easeSheet = Cubic(0.32, 0.72, 0.0, 1.0);
  static const Cubic easeSpring = Cubic(0.34, 1.42, 0.5, 1.0);
  static const Cubic easeOut = Cubic(0.2, 0.8, 0.2, 1.0);
  static const Cubic easeExit = Cubic(0.4, 0.0, 1.0, 1.0);
  static const double pressButton = 0.96;
  static const double pressCard = 0.985;
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
