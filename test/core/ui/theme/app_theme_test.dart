// AppTheme: rol → ColorScheme eşlemesi, uzantılar, TextTheme ve bileşen temaları token'dan.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';
import 'package:nizamio/core/ui/theme/nz_text_styles.dart';

void main() {
  // Yazı tipleri gerçekten varlıktan yüklensin (binding yoksa google_fonts yükleyemez).
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final cases = <(String, Brightness, NizamioColors, ThemeData Function())>[
    ('açık', Brightness.light, NizamioColors.light, AppTheme.light),
    ('koyu', Brightness.dark, NizamioColors.dark, AppTheme.dark),
  ];

  for (final (name, brightness, c, build) in cases) {
    group(name, () {
      late ThemeData t;
      setUp(() => t = build());

      test('ColorScheme roller token\'dan eşlenir (tohum yok)', () {
        final s = t.colorScheme;
        expect(s.brightness, brightness);
        expect(s.primary, c.primary);
        expect(s.onPrimary, c.onPrimary);
        expect(s.secondary, c.accentText);
        expect(s.onSecondary, c.background);
        expect(s.error, c.danger);
        expect(s.onError, c.onDanger);
        expect(s.surface, c.surface);
        expect(s.onSurface, c.text);
        expect(s.onSurfaceVariant, c.textMuted);
        expect(s.outline, c.borderControl);
        expect(s.outlineVariant, c.border);
        expect(s.surfaceContainerLowest, c.background);
        expect(s.surfaceContainerLow, c.surface);
        expect(s.surfaceContainer, c.surfaceRaised);
        expect(s.surfaceContainerHigh, c.surfaceRaised);
        expect(s.surfaceContainerHighest, c.surfaceOverlay);
        expect(s.inverseSurface, c.text);
        expect(s.onInverseSurface, c.background);
        expect(s.scrim, c.scrim);
        // Ters yüzeydeki vurgu karşı modun accentText'i (snackbar eylemi okunur kalır).
        expect(
          s.inversePrimary,
          brightness == Brightness.light
              ? NizamioColors.dark.accentText
              : NizamioColors.light.accentText,
        );
        expect(t.scaffoldBackgroundColor, c.background);
      });

      test('uzantılar kayıtlı ve renkler aynı moddan', () {
        expect(t.extension<NizamioColors>(), same(c));
        expect(
          t.extension<NizamioShadows>(),
          same(
            brightness == Brightness.light
                ? NizamioShadows.light
                : NizamioShadows.dark,
          ),
        );
        final nz = t.extension<NzTextStyles>()!;
        expect(nz.bodyMd.color, c.text);
        expect(nz.mono.color, c.text);
      });

      test('TextTheme aynı rollerden dolar', () {
        final nz = t.extension<NzTextStyles>()!;
        final tt = t.textTheme;
        expect(tt.displayLarge!.fontSize, nz.displayLg.fontSize);
        expect(tt.titleLarge!.fontSize, nz.titleMd.fontSize);
        expect(tt.bodyLarge!.fontSize, nz.bodyLg.fontSize);
        expect(tt.bodyMedium!.fontSize, nz.bodyMd.fontSize);
        expect(tt.bodySmall!.fontSize, nz.bodySm.fontSize);
        expect(tt.labelLarge!.fontSize, nz.labelMd.fontSize);
        expect(tt.bodyMedium!.color, c.text);
      });

      test('bileşen temaları token yarıçap/boşluk/renk kullanır', () {
        final filled = t.filledButtonTheme.style!;
        expect(filled.minimumSize!.resolve({}), const Size(0, NizamioSize.tap));
        expect(filled.backgroundColor!.resolve({}), c.primary);
        expect(
          filled.backgroundColor!.resolve({WidgetState.pressed}),
          c.primary,
        );
        expect(filled.foregroundColor!.resolve({}), c.onPrimary);
        expect(
          filled.backgroundColor!.resolve({WidgetState.disabled})!.a,
          lessThan(0.2),
        );
        expect(
          filled.shape!.resolve({}),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NizamioRadius.group),
          ),
        );

        final outlined = t.outlinedButtonTheme.style!;
        expect(outlined.side!.resolve({})!.color, c.borderControl);
        expect(
          outlined.side!.resolve({WidgetState.focused})!.color,
          c.focusRing,
        );
        expect(outlined.foregroundColor!.resolve({}), c.text);

        final input = t.inputDecorationTheme;
        expect(input.fillColor, c.surface);
        expect(
          (input.enabledBorder! as OutlineInputBorder).borderSide.color,
          c.borderControl,
        );
        final focused = input.focusedBorder! as OutlineInputBorder;
        expect(focused.borderSide.color, c.focusRing);
        expect(focused.borderSide.width, NizamioSize.focusRingWidth);
        expect(
          (input.errorBorder! as OutlineInputBorder).borderSide.color,
          c.danger,
        );
        expect(input.errorStyle!.color, c.danger);

        final card = t.cardTheme;
        expect(card.color, c.surface);
        expect(
          (card.shape! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(NizamioRadius.card),
        );

        expect(t.dividerTheme.color, c.border);
        expect(t.snackBarTheme.backgroundColor, c.text);
        expect(t.snackBarTheme.contentTextStyle!.color, c.background);
        expect(t.bottomSheetTheme.backgroundColor, c.surface);
        expect(t.bottomSheetTheme.modalBarrierColor, c.scrim);
        expect(t.iconTheme.size, NizamioSize.iconSize);
        expect(t.bottomSheetTheme.showDragHandle, isTrue);
        expect(t.navigationBarTheme.backgroundColor, c.background);
        expect(t.navigationBarTheme.height, NizamioSpacing.space16);
        expect(
          t.navigationBarTheme.iconTheme!.resolve({
            WidgetState.selected,
          })!.color,
          c.accentText,
        );
        expect(t.navigationBarTheme.iconTheme!.resolve({})!.color, c.textMuted);
        expect(t.navigationRailTheme.backgroundColor, c.background);
        expect(t.navigationRailTheme.selectedIconTheme!.color, c.accentText);
        expect(t.navigationRailTheme.unselectedIconTheme!.color, c.textMuted);
      });
    });
  }

  test('açık ve koyu tema farklı renk üretir', () {
    expect(
      AppTheme.light().colorScheme.surface,
      isNot(AppTheme.dark().colorScheme.surface),
    );
  });
}
