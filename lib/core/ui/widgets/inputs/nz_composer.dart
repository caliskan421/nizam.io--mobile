import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';
import '../../theme/nz_surfaces.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';
import '../surfaces/nz_glass.dart';

/// Sohbetin altındaki yazma alanı (tasarım sistemi `components/Composer`, `.m-composer`):
/// cam zemin (`glass-bar`, üstte `border-subtle`), solda ek düğmesi (açıkken 45° döner,
/// `bg-overlay` zemin, `accent-text` ikon), kendiliğinden büyüyen metin alanı (40 → 128 px,
/// 16 px yazı, `bg-raised`, köşe 20), sağda gönder (boşken `bg-raised` küçük, yazı olunca lime
/// tam boy). [header] çubuğun üstündeki şeritlerdir (öneriler, ek paneli, atıf hapları, yanıt /
/// düzenleme bağlamı). Donanım klavyesinde Enter gönderir, Shift+Enter yeni satır.
/// [bottomInset] klavye ya da güvenli alan yüksekliğidir (sayfa `viewInsetsOf` ile verir).
class NzComposer extends StatelessWidget {
  const NzComposer({
    super.key,
    required this.controller,
    required this.hint,
    required this.canSend,
    required this.onSend,
    required this.sendLabel,
    required this.onAttach,
    required this.attachLabel,
    this.attachOpen = false,
    this.focusNode,
    this.header = const [],
    this.bottomInset = 0,
  });

  final TextEditingController controller;
  final String hint;
  final bool canSend;
  final VoidCallback onSend;
  final String sendLabel;
  final VoidCallback onAttach;
  final String attachLabel;
  final bool attachOpen;
  final FocusNode? focusNode;
  final List<Widget> header;
  final double bottomInset;

  /// Metin alanının azami yüksekliği (README: 128 px).
  static const maxInputHeight = 128.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final spring = NzMotion.of(context, NizamioMotion.durSheet);
    final field = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (canSend) onSend();
        },
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NizamioSize.composer,
          maxHeight: maxInputHeight,
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: t.bodyLg,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: t.bodyLg.copyWith(color: c.textFaint),
            filled: true,
            fillColor: c.surfaceRaised,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space4,
              vertical: 9,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NizamioSpacing.space5),
              borderSide: BorderSide(color: c.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NizamioSpacing.space5),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NizamioSpacing.space5),
              borderSide: BorderSide(color: c.borderControl),
            ),
          ),
        ),
      ),
    );
    return NzGlass(
      tone: NzGlassTone.bar,
      edge: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...header,
            Padding(
              // Kaynak: `padding: 8px 10px 26px` (alt pay sayfadan [bottomInset]).
              padding: EdgeInsets.fromLTRB(10, 8, 10, 6 + bottomInset),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Semantics(
                    button: true,
                    expanded: attachOpen,
                    label: attachLabel,
                    excludeSemantics: true,
                    onTap: onAttach,
                    child: AnimatedRotation(
                      turns: attachOpen ? 0.125 : 0,
                      duration: spring,
                      curve: NizamioMotion.easeSpring,
                      child: _Circle(
                        fill: attachOpen ? c.surfaceOverlay : null,
                        onTap: onAttach,
                        // Kaynak ek düğmesi ataçtır (`attach_file` yolu).
                        child: NzIcon(
                          NzIcons.attach,
                          color: attachOpen ? c.accentText : c.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const Gap(NizamioSpacing.space2),
                  Expanded(child: field),
                  const Gap(NizamioSpacing.space2),
                  Semantics(
                    button: true,
                    enabled: canSend,
                    label: sendLabel,
                    excludeSemantics: true,
                    onTap: canSend ? onSend : null,
                    child: AnimatedScale(
                      scale: canSend ? 1 : 0.92,
                      duration: spring,
                      curve: NizamioMotion.easeSpring,
                      child: _Circle(
                        fill: canSend ? c.primary : c.surfaceRaised,
                        onTap: canSend ? onSend : null,
                        child: NzIcon(
                          NzIcons.arrowUp,
                          size: NizamioSize.iconSizeSm + 2,
                          color: canSend ? c.onPrimary : c.textFaint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 40 px görsel, 48 dokunma alanlı yuvarlak düğme.
class _Circle extends StatelessWidget {
  const _Circle({required this.child, required this.onTap, this.fill});

  final Widget child;
  final VoidCallback? onTap;
  final Color? fill;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    // 40 px görsel; dokunma alanı 44 (çubuk satırını büyütmeden).
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: SizedBox.square(
        dimension: NizamioSize.composer,
        child: Material(
          type: MaterialType.circle,
          color: fill ?? context.colors.surface.withValues(alpha: 0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(child: child),
          ),
        ),
      ),
    ),
  );
}

/// Eklenen atıf hapı (`.m-refchip`): `ref-chip` zemin, `accent-text` ikon, `ink` etiket (en çok
/// 180 px), sağda kaldır düğmesi.
class NzRefChip extends StatelessWidget {
  const NzRefChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onRemove,
    required this.removeLabel,
  });

  final String label;
  final IconData icon;
  final VoidCallback onRemove;
  final String removeLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 30),
      padding: const EdgeInsets.only(left: 10, right: 4),
      decoration: BoxDecoration(
        color: c.refChip,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NzIcon(icon, size: 13, color: c.accentText),
          const Gap(6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.caption,
            ),
          ),
          Semantics(
            button: true,
            label: '$removeLabel: $label',
            excludeSemantics: true,
            onTap: onRemove,
            child: InkResponse(
              onTap: onRemove,
              radius: NizamioSpacing.space4,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: NzIcon(NzIcons.close, size: 12, color: c.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Yanıt ya da düzenleme bağlamı şeridi (`.m-composer__ctx`): ikon, 3 px `accent-text` şerit,
/// başlık (`accent-text`) + alıntı metni (tek satır), sağda vazgeç.
class NzComposerContext extends StatelessWidget {
  const NzComposerContext({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    required this.onCancel,
    required this.cancelLabel,
  });

  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onCancel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: NzIcon(
                icon,
                size: NizamioSize.iconSizeSm,
                color: c.accentText,
              ),
            ),
            const Gap(NizamioSpacing.gapMd),
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: c.accentText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(NizamioSpacing.gapMd),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.caption.copyWith(
                      color: c.accentText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySm.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: cancelLabel,
              onPressed: onCancel,
              icon: NzIcon(
                NzIcons.close,
                size: NizamioSize.iconSizeSm,
                color: c.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
