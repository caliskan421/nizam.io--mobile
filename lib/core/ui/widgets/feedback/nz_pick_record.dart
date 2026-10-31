import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

/// Tablet sağ bölmesinde kayıt seçilmemişken gösterilen yer tutucu (prototip
/// `TB_DEF.calendar = 'empty'`): ikon karosu, başlık ve açıklama. Metni çağıran verir.
class NzPickRecord extends StatelessWidget {
  const NzPickRecord({super.key, required this.title, required this.message});

  final String title;
  final String message;

  static const _tile = 56.0;
  static const _textWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: NizamioSpacing.space12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _tile,
              height: _tile,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.surfaceRaised,
                borderRadius: BorderRadius.circular(NizamioRadius.row),
              ),
              child: NzIcon(
                NzIcons.eventAvailable,
                size: NizamioSize.iconSize,
                color: c.textMuted,
              ),
            ),
            const Gap(NizamioSpacing.space3),
            Semantics(
              header: true,
              child: Text(title, textAlign: TextAlign.center, style: t.labelLg),
            ),
            const Gap(NizamioSpacing.space3),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _textWidth),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: t.bodySm.copyWith(
                  fontSize: 13,
                  height: 18 / 13,
                  color: c.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
