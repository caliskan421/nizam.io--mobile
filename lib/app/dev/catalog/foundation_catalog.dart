import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/theme/nz_text_styles.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import 'catalog_entry.dart';

// Tema/yazı tipi temeli (ADR-0003 karar 24): renk rolleri, yüzey katmanları, metin rolleri,
// Türkçe karakterler, rakam hizası, köşe ve gölge. Katalog geliştirici aracıdır; örnek metinler
// ARB'ye girmez.
const _group = 'foundation';

/// Türkçe büyük/küçük harf çiftleri; her rolde aynı satır.
const turkishSample = 'İı Şş Ğğ Çç Öö Üü — Işık, şöyle güzel çiçek';

CatalogEntry _entry(String name, WidgetBuilder builder) =>
    CatalogEntry(group: _group, name: name, builder: builder);

List<(String, Color)> _roles(NizamioColors c) => [
  ('background', c.background),
  ('surface', c.surface),
  ('surfaceRaised', c.surfaceRaised),
  ('surfaceOverlay', c.surfaceOverlay),
  ('border', c.border),
  ('borderStrong', c.borderStrong),
  ('borderControl', c.borderControl),
  ('text', c.text),
  ('textMuted', c.textMuted),
  ('textFaint', c.textFaint),
  ('primary', c.primary),
  ('onPrimary', c.onPrimary),
  ('accentText', c.accentText),
  ('focusRing', c.focusRing),
  ('danger', c.danger),
  ('onDanger', c.onDanger),
  ('warning', c.warning),
  ('onWarning', c.onWarning),
  ('success', c.success),
  ('info', c.info),
  ('scrim', c.scrim),
];

List<(String, TextStyle)> _textRoles(NzTextStyles t) => [
  ('displayLg · m-greet', t.displayLg),
  ('titleLg · m-h1', t.titleLg),
  ('titleMd · m-h1-detail', t.titleMd),
  ('titleSm · m-sheet-title', t.titleSm),
  ('labelLg · m-card-title', t.labelLg),
  ('bodyLg · m-input', t.bodyLg),
  ('bodyMd · m-body', t.bodyMd),
  ('labelMd · m-tab', t.labelMd),
  ('caption · m-caption', t.caption),
  ('mono · m-code', t.mono),
  ('kicker · m-kicker', t.kicker),
  ('monoSm · m-mono-sm', t.monoSm),
];

List<CatalogEntry> get foundationCatalogEntries => [
  _entry('Renk rolleri', (context) {
    final c = context.colors;
    return Wrap(
      spacing: NizamioSpacing.space2,
      runSpacing: NizamioSpacing.space2,
      children: [
        for (final (name, color) in _roles(c))
          SizedBox(
            width: 104,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: NizamioSize.tap,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(color: c.borderStrong),
                    borderRadius: BorderRadius.circular(NizamioRadius.tile),
                  ),
                ),
                const Gap(NizamioSpacing.space1),
                Text(name, style: context.text.monoSm),
              ],
            ),
          ),
      ],
    );
  }),
  _entry('Yüzey katmanları ve metin rolleri', (context) {
    final c = context.colors;
    final t = context.text;
    Widget layer(String name, Color fill, Widget child) => DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(NizamioRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.cardPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: t.kicker.copyWith(color: c.textMuted)),
            const Gap(NizamioSpacing.gapSm),
            Text('Metin · text', style: t.bodyMd),
            Text(
              'İkincil · textMuted',
              style: t.bodyMd.copyWith(color: c.textMuted),
            ),
            Text(
              'Üçüncül · textFaint',
              style: t.bodyMd.copyWith(color: c.textFaint),
            ),
            Text(
              'Vurgu · accentText',
              style: t.bodyMd.copyWith(color: c.accentText),
            ),
            Text('Hata · danger', style: t.bodyMd.copyWith(color: c.danger)),
            Text('Uyarı · warning', style: t.bodyMd.copyWith(color: c.warning)),
            const Gap(NizamioSpacing.gapMd),
            child,
          ],
        ),
      ),
    );
    return layer(
      'background',
      c.background,
      layer(
        'surface',
        c.surface,
        layer(
          'surfaceRaised',
          c.surfaceRaised,
          layer('surfaceOverlay', c.surfaceOverlay, const SizedBox.shrink()),
        ),
      ),
    );
  }),
  _entry('Metin rolleri', (context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in _textRoles(context.text)) ...[
          Text(name, style: context.text.monoSm.copyWith(color: c.textFaint)),
          Text(turkishSample, style: style),
          const Gap(NizamioSpacing.gapMd),
        ],
      ],
    );
  }),
  _entry('Türkçe karakterler (aile × ağırlık)', (context) {
    final t = context.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Poppins 600: İĞÜŞÖÇ ığüşöç', style: t.titleSm),
        Text('Inter 400: İĞÜŞÖÇ ığüşöç', style: t.bodyLg),
        Text(
          'Inter 500: İĞÜŞÖÇ ığüşöç',
          style: t.bodyLg.copyWith(fontWeight: FontWeight.w500),
        ),
        Text('Inter 600: İĞÜŞÖÇ ığüşöç', style: t.labelLg),
        Text('Geist Mono 400: İĞÜŞÖÇ ığüşöç', style: t.mono),
        Text('Geist Mono 500: İĞÜŞÖÇ ığüşöç', style: t.kicker),
      ],
    );
  }),
  _entry('Rakam hizası (tabular)', (context) {
    final t = context.text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final n in ['1.111', '8.888', '10.07', '%49'])
              Text(n, style: t.mono),
          ],
        ),
        const Gap(NizamioSpacing.space6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final n in ['111', '888', '40', '%49'])
              Text(n, style: t.numeral),
          ],
        ),
      ],
    );
  }),
  _entry('Köşe ve gölge', (context) {
    final c = context.colors;
    final s = context.shadows;
    final samples = <(String, double, List<BoxShadow>)>[
      ('tile 12', NizamioRadius.tile, const []),
      ('group 16', NizamioRadius.group, const []),
      ('row 18', NizamioRadius.row, const []),
      ('card 20', NizamioRadius.card, const []),
      ('float', NizamioRadius.card, s.float),
      ('menu', NizamioRadius.flyout, s.menu),
      ('sheet', NizamioRadius.sheet, s.sheet),
      ('pill', NizamioRadius.pill, s.thumb),
    ];
    return Wrap(
      spacing: NizamioSpacing.gapXl,
      runSpacing: NizamioSpacing.gapXl,
      children: [
        for (final (name, radius, shadow) in samples)
          DecoratedBox(
            decoration: BoxDecoration(
              color: c.surface,
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(radius),
              boxShadow: shadow,
            ),
            child: SizedBox(
              width: 96,
              height: 64,
              child: Center(child: Text(name, style: context.text.monoSm)),
            ),
          ),
      ],
    );
  }),
  _entry(
    'Düğme + giriş + kart birlikte',
    (context) => NzCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Giriş yap', style: context.text.titleLg),
          const Gap(NizamioSpacing.gapXl),
          const NzTextField(label: 'E-posta', hint: 'ad.soyad@ornek.org'),
          const Gap(NizamioSpacing.gapMd),
          NzButton.primary(label: 'Giriş yap', expand: true, onPressed: () {}),
          const Gap(NizamioSpacing.gapSm),
          NzButton.secondary(label: 'Vazgeç', expand: true, onPressed: () {}),
        ],
      ),
    ),
  ),
];
