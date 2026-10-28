// Renk rolü çiftlerinin WCAG 2.x kontrastı (tasarım README'sindeki iddialar doğrudan kabul
// edilmez). Bilinen açıklar docs/design-tokens.md "Açık kararlar"dadır; değer değişirse bu test
// belgeyle birlikte güncellenir.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  for (final (mode, c) in [
    ('açık', NizamioColors.light),
    ('koyu', NizamioColors.dark),
  ]) {
    group(mode, () {
      final grounds = {
        'background': c.background,
        'surface': c.surface,
        'surfaceRaised': c.surfaceRaised,
      };

      test('gövde ve ikincil metin her yüzeyde ≥ 4.5', () {
        for (final MapEntry(:key, :value) in grounds.entries) {
          expect(
            contrast(c.text, value),
            greaterThanOrEqualTo(4.5),
            reason: 'text/$key',
          );
          expect(
            contrast(c.textMuted, value),
            greaterThanOrEqualTo(4.5),
            reason: 'textMuted/$key',
          );
        }
      });

      test('üçüncül metin zemin ve yüzeyde ≥ 4.5', () {
        expect(contrast(c.textFaint, c.background), greaterThanOrEqualTo(4.5));
        expect(contrast(c.textFaint, c.surface), greaterThanOrEqualTo(4.5));
      });

      test('vurgu metni ve hata metni zemin/yüzeyde ≥ 4.5', () {
        for (final MapEntry(:key, :value) in grounds.entries) {
          expect(
            contrast(c.accentText, value),
            greaterThanOrEqualTo(4.5),
            reason: 'accentText/$key',
          );
        }
        expect(contrast(c.danger, c.background), greaterThanOrEqualTo(4.5));
        expect(contrast(c.danger, c.surface), greaterThanOrEqualTo(4.5));
      });

      test('dolgu üstü metin ≥ 4.5 (ana eylem, hata)', () {
        expect(contrast(c.onPrimary, c.primary), greaterThanOrEqualTo(4.5));
        expect(contrast(c.onDanger, c.danger), greaterThanOrEqualTo(4.5));
      });

      test('odak halkası her yüzeyde ≥ 3', () {
        for (final MapEntry(:key, :value) in grounds.entries) {
          expect(
            contrast(c.focusRing, value),
            greaterThanOrEqualTo(3),
            reason: 'focusRing/$key',
          );
        }
      });
    });
  }

  test('koyu: kontrol kenarı ve uyarı rengi eşik üstü', () {
    const c = NizamioColors.dark;
    expect(contrast(c.borderControl, c.background), greaterThanOrEqualTo(3));
    expect(contrast(c.borderControl, c.surface), greaterThanOrEqualTo(3));
    expect(contrast(c.warning, c.surface), greaterThanOrEqualTo(4.5));
    expect(contrast(c.onWarning, c.warning), greaterThanOrEqualTo(4.5));
  });

  // Bilinen açıklar (tasarım kararı bekliyor; sessizce değiştirilmedi).
  test('açık: bilinen eşik altı çiftler belgelenmiş değerlerinde', () {
    const c = NizamioColors.light;
    // README "her iki temada 3:1 üstü" der; gerçek 2.75 / 2.98.
    expect(contrast(c.borderControl, c.background), closeTo(2.75, 0.01));
    expect(contrast(c.borderControl, c.surface), closeTo(2.98, 0.01));
    // gold metin olarak 4.5 altı (büyük metin/ikon için 3 üstü).
    expect(contrast(c.warning, c.surface), closeTo(4.25, 0.01));
    expect(contrast(c.onWarning, c.warning), closeTo(4.25, 0.01));
    // ink-faint bg-raised üzerinde 4.5 altı (README zaten yalnız zemin/yüzey der).
    expect(contrast(c.textFaint, c.surfaceRaised), closeTo(4.34, 0.01));
  });
}
