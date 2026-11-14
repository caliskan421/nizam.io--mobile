import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';

/// Çekmece başlığı (`sidebar-rol.png`): avatar, ad, alt satır ("Koordinatör · Altyapı ve
/// tesisat"), ">" (profil) ve kapat düğmesi. Ad satırına dokunuş profili açar ([onProfile]).
class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader({
    super.key,
    required this.name,
    required this.caption,
    required this.tablet,
    required this.onProfile,
    required this.onClose,
  });

  final String name;

  /// Boşsa "Profil" bağlantı metni gösterilir.
  final String caption;
  final bool tablet;
  final VoidCallback onProfile;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label: '$name, ${l.uiHomeProfile}',
            hint: caption.isEmpty ? null : caption,
            excludeSemantics: true,
            child: InkWell(
              onTap: onProfile,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              child: Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space1),
                child: Row(
                  children: [
                    if (tablet)
                      _TabletAvatar(name: name)
                    else
                      NzAvatar.initials(name: name),
                    const Gap(NizamioSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelLg,
                          ),
                          Text(
                            caption.isEmpty ? l.uiHomeProfile : caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    NzIcon(
                      NzIcons.chevronRight,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        if (tablet)
          _TabletClose(label: l.uiCommonClose, onTap: onClose)
        else
          NzIconButton(
            icon: NzIcons.close,
            semanticLabel: l.uiCommonClose,
            onPressed: onClose,
          ),
      ],
    );
  }
}

/// Tablet çekmecesi hesap avatarı (kaynak `rp-av` 44 / 15: `bg-overlay` daire, `ink` baş harf).
class _TabletAvatar extends StatelessWidget {
  const _TabletAvatar({required this.name});

  final String name;

  static const _extent = 44.0;
  static const _fontSize = 15.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final initials = words.isEmpty
        ? ''
        : words.take(2).map((w) => w.characters.first).join().toUpperCase();
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceOverlay,
          shape: BoxShape.circle,
        ),
        child: SizedBox.square(
          dimension: _extent,
          child: Center(
            child: Text(
              initials,
              style: context.text.labelLg.copyWith(
                fontSize: _fontSize,
                color: c.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tablet çekmecesi kapat düğmesi (kaynak 36 `bg-overlay` daire, 16 X).
class _TabletClose extends StatelessWidget {
  const _TabletClose({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.surfaceOverlay,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: NizamioSize.controlSm,
            child: Center(
              child: NzIcon(
                NzIcons.close,
                size: NizamioSize.iconSizeSm,
                color: c.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
