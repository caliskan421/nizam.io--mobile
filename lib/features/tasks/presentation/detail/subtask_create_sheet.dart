import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../task_widgets.dart';

/// Yeni alt görev alt sayfası: başlık + kanıt dosyası zorunlu/opsiyonel radyosu (görev
/// eklemedeki gibi; WORK-K70). Vazgeç/kapatma → null. [initial]: gönderilemeyen önceki ad.
Future<({String title, bool evidenceRequired})?> askNewSubtask(
  BuildContext context, {
  String initial = '',
}) async {
  final l = context.l10n;
  final controller = TextEditingController(text: initial);
  final evidence = ValueNotifier(false);
  ({String title, bool evidenceRequired})? result;
  await NzBottomSheet.show<void>(
    context,
    title: l.uiTasksSubAdd,
    description: l.uiTasksSubsHint,
    actions: (sheet) => nzSheetActions(
      sheet,
      cancel: l.uiTasksCancel,
      ok: l.uiTasksCreate,
      onOk: () {
        final v = controller.text.trim();
        if (v.isEmpty) return;
        result = (title: v, evidenceRequired: evidence.value);
        Navigator.of(sheet).pop();
      },
    ),
    builder: (_) => DisposeWith(
      controller,
      child: DisposeWith(
        evidence,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzTextField(
              label: l.uiTasksSubName,
              controller: controller,
              textInputAction: TextInputAction.done,
            ),
            const Gap(NizamioSpacing.space4),
            TaskFieldLabel(l.uiTasksEvidenceFile),
            ValueListenableBuilder<bool>(
              valueListenable: evidence,
              builder: (_, required, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final v in const [true, false])
                    TaskCheckRow(
                      label: v ? l.uiTasksRequired : l.uiTasksOptional,
                      radio: true,
                      selected: required == v,
                      onTap: () => evidence.value = v,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return result;
}
