import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_parts.dart';

/// Kimlik (prototip `.cd-hero`): kod kutucuğu, ad, alt satır (üst birim · koordinatörler) ve
/// "Görev ata" / "Mesaj". Genişte düğmeler sol yarıda (prototip iki sütunlu kimlik).
class CoordHero extends StatelessWidget {
  const CoordHero({super.key, required this.detail});

  final CoordinatorshipDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final d = detail;
    final tag = d.stats.shortCode;
    final parent = d.profile.parent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space4,
      children: [
        Row(
          children: [
            if (tag != null) ...[
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                  // Prototip `linear-gradient(160deg, overlay, raised 70%)`.
                  gradient: LinearGradient(
                    begin: const Alignment(-.36, -1),
                    end: const Alignment(.36, 1),
                    colors: [c.surfaceOverlay, c.surfaceRaised],
                    stops: const [0, .7],
                  ),
                ),
                child: ExcludeSemantics(
                  child: Text(
                    tag,
                    style: t.labelLg.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .5,
                      color: c.text,
                    ),
                  ),
                ),
              ),
              const Gap(NizamioSpacing.rowPad),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: NizamioSpacing.space1,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      d.stats.name,
                      style: t.titleLg.copyWith(fontSize: 24, height: 29 / 24),
                    ),
                  ),
                  Text(
                    [
                      if (parent.isNotEmpty) parent,
                      if (d.leads.isEmpty)
                        l.uiCoordNoLead
                      else
                        d.leads.map((p) => p.name).join(',\u2003'),
                    ].join(' · '),
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Prototip `.cd-acts`: "Görev ata" kalan genişlik, "Mesaj" kendi boyu.
        LayoutBuilder(
          builder: (context, box) => Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: box.maxWidth >= coordWideWidth
                  ? (box.maxWidth - NizamioSpacing.gapXl) / 2
                  : box.maxWidth,
              child: Row(
                spacing: NizamioSpacing.space2,
                children: [
                  Expanded(
                    child: NzButton.primary(
                      label: l.uiCoordAssignTask,
                      icon: NzIcons.add,
                      expand: true,
                      onPressed: () => showNewTaskSheet(
                        context,
                        coordinatorship: d.stats.code,
                      ),
                    ),
                  ),
                  NzButton.secondary(
                    label: l.uiCoordMessage,
                    icon: NzIcons.messages,
                    onPressed: context.appNav.openMessages,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
