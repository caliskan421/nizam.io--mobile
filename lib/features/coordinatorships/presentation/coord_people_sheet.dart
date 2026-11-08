import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorship_detail_controller.dart';
import '../domain/coordinatorship_board.dart';
import 'coord_detail_texts.dart';
import 'coord_parts.dart';

/// Üyeler bölümü (prototip `tMem`): kişi sayısı + "Üye ekle"; koordinatörler ve üyeler
/// grupları. Satır → kişi alt sayfası.
class CoordMembersTab extends ConsumerWidget {
  const CoordMembersTab({super.key, required this.code, required this.people});

  final String code;
  final List<CoordPerson> people;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final leads = people.where((p) => p.lead).toList();
    final members = people.where((p) => !p.lead).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.gapXl,
      children: [
        CoordSubhead(
          label: Text(
            l.coordPeopleCount(people.length),
            style: context.text.bodySm.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          actions: [
            NzIconButton.circle(
              icon: NzIcons.personAdd,
              semanticLabel: l.uiCoordAddMember,
              onPressed: () => showInviteSheet(context, coordinatorship: code),
            ),
          ],
        ),
        for (final (label, group) in [
          (l.uiCoordGroupLeads, leads),
          (l.uiCoordGroupMembers, members),
        ])
          if (group.isNotEmpty)
            CoordBlock(
              label: l.coordGroupLabel(label, group.length),
              child: CoordRows(
                children: [
                  for (final p in group)
                    CoordPersonRow(
                      person: p,
                      onTap: () => showCoordPersonSheet(context, ref, code, p),
                    ),
                ],
              ),
            ),
        if (people.isEmpty) CoordEmpty(l.uiCoordNoMembers),
      ],
    );
  }
}

/// Kişi alt sayfası (prototip `isPerson`): avatar, ad, rol; açık/geciken sayıları; "Görevlerini
/// gör" (Görevler bölümü kişi süzgeciyle) ve "Mesaj gönder". Rol değiştirme ve çıkarma bu
/// ekranda yok (yönetim yüzü).
Future<void> showCoordPersonSheet(
  BuildContext context,
  WidgetRef ref,
  String code,
  CoordPerson p,
) {
  final l = context.l10n;
  final nav = context.appNav;
  final commands = ref.read(
    coordinatorshipDetailControllerProvider(code).notifier,
  );
  return NzBottomSheet.show<void>(
    context,
    title: p.name,
    showHeader: false,
    builder: (sheet) {
      final c = sheet.colors;
      final t = sheet.text;
      Widget stat(int n, String label, {Color? color}) => Expanded(
        child: CoordPanel(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text('$n', style: t.numeral.copyWith(fontSize: 24, color: color)),
              Text(label, style: t.caption.copyWith(color: c.textMuted)),
            ],
          ),
        ),
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              NzAvatar.initials(name: p.name, extent: NzAvatarSize.xl),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(p.name, style: t.titleMd),
                    Text(
                      p.lead ? l.uiCoordLeadRole : l.uiCoordMemberRole,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(14),
          Row(
            spacing: NizamioSpacing.space2,
            children: [
              stat(p.open, l.uiCoordKpiOpen),
              stat(
                p.late,
                l.uiCoordLateTail,
                color: p.late > 0 ? c.danger : null,
              ),
            ],
          ),
          const Gap(14),
          NzMenuGroup(
            rows: [
              NzMenuRow(
                icon: NzIcons.tasks,
                label: l.uiCoordPersonTasks,
                onTap: () {
                  Navigator.of(sheet).pop();
                  commands.showTasks(CoordTaskFilter.open, person: p.id);
                },
              ),
              NzMenuRow(
                icon: NzIcons.messages,
                label: l.uiCoordPersonMessage,
                onTap: () {
                  Navigator.of(sheet).pop();
                  nav.openMessages();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
