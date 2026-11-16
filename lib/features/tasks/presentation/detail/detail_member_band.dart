import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_glyph.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_detail_controller.dart';
import '../../domain/member_flow.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_permissions.dart';
import '../decision/task_decision_flows.dart';
import 'detail_actions.dart';

/// Görev ayrıntısının üye bandı (tasarım §4.2.2): üyenin bu görevdeki tek sonraki adımı.
/// Başlamadı → "Başla" (ön görev bitmemişse pasif; kilit bandı üstte); devam → "Tamamlandı
/// bildir" (onaya sunma kaplaması); iade → koordinatörün son notu + "Düzeltmeye başla"; onayda
/// → salt okunur "onay bekliyor" + varsa gönderim notu; tamamlandı → bant yok. Düğme yalnız
/// aktörün matrisinde hedef varsa çizilir ([canStartTask], [canSubmitTask]).
class DetailMemberBand extends ConsumerWidget {
  const DetailMemberBand({
    super.key,
    required this.task,
    required this.catalog,
    required this.permissions,
    required this.blocking,
    this.files,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final TaskPermissions permissions;

  /// Bitmemiş ön görev sayısı (kilit).
  final int blocking;

  /// Kanıt dosyası sayısı (ayrıntı okunmadıysa null).
  final int? files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final busy = ref.watch(
      taskDetailControllerProvider(task.code).select((s) => s.busy),
    );
    final flows = TaskDecisionFlows(context, ref, task.code);
    final step = MemberStep.of(task);
    final startable = canStartTask(permissions, task);
    Widget card(List<Widget> children) => NzCard.filled(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
    Widget note(String text, {NzGlyph? glyph, Color? color}) => Row(
      children: [
        if (glyph != null) ...[
          NzGlyphIcon(
            glyph,
            size: NizamioSize.iconSizeSm,
            color: color ?? c.textMuted,
          ),
          const Gap(NizamioSpacing.space2),
        ],
        Expanded(
          child: Text(text, style: t.bodySm.copyWith(color: c.textMuted)),
        ),
      ],
    );
    Widget action(String label, VoidCallback? onPressed) => Padding(
      padding: const EdgeInsets.only(top: NizamioSpacing.space3),
      child: NzButton.primary(
        label: label,
        expand: true,
        loading: busy,
        onPressed: onPressed,
      ),
    );
    switch (step) {
      case MemberStep.start when startable:
        return card([
          note(l.uiTasksBandTodo, glyph: NzGlyphs.notStarted),
          // Kilitliyken düğme pasif (sebep üstteki kilit bandında).
          action(l.uiTasksBandStart, blocking > 0 ? null : flows.start),
        ]);
      case MemberStep.submit when canSubmitTask(permissions, task):
        final actions = TaskDetailActions(context, ref, task.code);
        final n = files;
        return card([
          note(
            [
              l.uiTasksBandDoing,
              if (n != null) '$n ${l.uiTasksBandEvidenceTail}',
            ].join(' · '),
            glyph: NzGlyphs.inProgress,
          ),
          action(
            l.uiTasksSubmitTitle,
            () => flows.submit(
              onUpload: actions.canUpload ? actions.openUpload : null,
            ),
          ),
        ]);
      case MemberStep.fix:
        final why = lastNote(task.noteEntries, me: catalog.me);
        return card([
          note(
            l.uiTasksBandReturned,
            glyph: NzGlyphs.returned,
            color: c.danger,
          ),
          if (why != null) ...[
            const Gap(NizamioSpacing.space2),
            Text(why.text, style: t.bodySm),
          ],
          if (startable) action(l.uiTasksBandFix, flows.start),
        ]);
      case MemberStep.waiting:
        final sent = lastNote(
          task.noteEntries,
          me: catalog.me,
          foreign: false,
          head: l.uiTasksSubmitNoteHead,
        );
        return card([
          note(l.uiTasksBandReview, glyph: NzGlyphs.review, color: c.warning),
          if (sent != null) ...[
            const Gap(NizamioSpacing.space2),
            note(sent.text),
          ],
        ]);
      case _:
        return const SizedBox.shrink();
    }
  }
}
