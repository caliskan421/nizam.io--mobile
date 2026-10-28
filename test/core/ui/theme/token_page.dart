// Token sayfası (yalnız test): renk rolleri 5x4 ızgara + metin rolleri örneği.
// Golden ve piksel kanıtı aynı ağacı kullanır.
import 'package:flutter/material.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/extensions/context_ext.dart';
import 'package:nizamio/core/ui/theme/app_theme.dart';

const tokenPageKey = ValueKey('token-page');
const tokenPageWidth = 400.0;
const tokenSwatch = 48.0;
const tokenPad = 16.0;
const tokenGap = 8.0;
const tokenColumns = 4;

/// Izgara sırası (`NizamioColors` alan sırası; yarı saydam `scrim` piksel kanıtına girmez).
List<Color> tokenRoles(NizamioColors c) => [
  c.background,
  c.surface,
  c.surfaceRaised,
  c.surfaceOverlay,
  c.border,
  c.borderStrong,
  c.borderControl,
  c.text,
  c.textMuted,
  c.textFaint,
  c.primary,
  c.onPrimary,
  c.accentText,
  c.focusRing,
  c.danger,
  c.onDanger,
  c.warning,
  c.onWarning,
  c.success,
  c.info,
];

/// Rol [i] kutusunun merkezi (boundary yerel koordinatı, mantıksal piksel).
Offset tokenSwatchCenter(int i) => Offset(
  tokenPad + (i % tokenColumns) * (tokenSwatch + tokenGap) + tokenSwatch / 2,
  tokenPad + (i ~/ tokenColumns) * (tokenSwatch + tokenGap) + tokenSwatch / 2,
);

class _TokenPage extends StatelessWidget {
  const _TokenPage();

  @override
  Widget build(BuildContext context) {
    final roles = tokenRoles(context.colors);
    final t = context.text;
    return RepaintBoundary(
      key: tokenPageKey,
      child: Container(
        width: tokenPageWidth,
        padding: const EdgeInsets.all(tokenPad),
        color: context.colors.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var r = 0; r < roles.length ~/ tokenColumns; r++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: r < roles.length ~/ tokenColumns - 1
                      ? tokenGap
                      : tokenPad,
                ),
                child: Row(
                  children: [
                    for (var c = 0; c < tokenColumns; c++)
                      Padding(
                        padding: EdgeInsets.only(
                          right: c < tokenColumns - 1 ? tokenGap : 0,
                        ),
                        child: SizedBox(
                          width: tokenSwatch,
                          height: tokenSwatch,
                          child: ColoredBox(color: roles[r * tokenColumns + c]),
                        ),
                      ),
                  ],
                ),
              ),
            Text('displayLg', style: t.displayLg),
            Text('titleLg', style: t.titleLg),
            Text('titleMd', style: t.titleMd),
            Text('titleSm', style: t.titleSm),
            Text('bodyLg', style: t.bodyLg),
            Text('bodyMd', style: t.bodyMd),
            Text('bodySm', style: t.bodySm),
            Text('labelLg', style: t.labelLg),
            Text('labelMd', style: t.labelMd),
            Text(
              'caption',
              style: t.caption.copyWith(color: context.colors.textMuted),
            ),
            Text('mono', style: t.mono),
            Text('kicker', style: t.kicker),
            Text('monoSm', style: t.monoSm),
            Text('numeral', style: t.numeral),
          ],
        ),
      ),
    );
  }
}

/// Sayfayı [dark] temayla üst-sol köşeye yerleştirir.
Widget tokenPage({required bool dark}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: dark ? AppTheme.dark() : AppTheme.light(),
  home: const Material(
    child: Align(alignment: Alignment.topLeft, child: _TokenPage()),
  ),
);
