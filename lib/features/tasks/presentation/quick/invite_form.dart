import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/invite_form_controller.dart';
import '../../application/quick_forms_controller.dart';
import '../../application/task_catalog_controller.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'quick_parts.dart';

/// "Kullanıcı ekle" formu: ad soyad, e-posta, rol (yalnız şirket yöneticisine; koordinatörün
/// eklediği kişi üyedir) ve tek koordinatörlük (seçenekler: yöneticide programın bütün,
/// koordinatörde kendi koordinatörlükleri). E-posta var olan hesaba aitse sunucunun aktarım
/// teklifi gösterilir.
class InviteFormBody extends ConsumerStatefulWidget {
  const InviteFormBody({super.key, required this.expansion});

  final ValueNotifier<bool> expansion;

  @override
  ConsumerState<InviteFormBody> createState() => _InviteFormBodyState();
}

class _InviteFormBodyState extends ConsumerState<InviteFormBody> {
  late final _auto = AutoExpand(widget.expansion);
  late final _email = TextEditingController(
    text: ref.read(inviteFormControllerProvider).email,
  );

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      inviteFormControllerProvider.select((f) => f.paneOpen),
      (_, open) => _auto.onPane(opened: open),
    );
    final l = context.l10n;
    final c = context.colors;
    final f = ref.watch(inviteFormControllerProvider);
    final ctl = ref.read(inviteFormControllerProvider.notifier);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final admin = catalog?.access?.companyAdmin ?? false;
    final coords = ref.watch(newTaskCoordinatorshipsProvider);
    final picked = f.coordinatorship;
    final value = picked == null
        ? l.uiTasksPick
        : catalog?.coordinatorship(picked)?.name ?? picked;
    final error = f.error;
    final failure = f.failure;
    final existing = f.offer;

    // Ortak standart: yazı alanları (ad soyad, e-posta) çerçeveli metin alanı; rol ve
    // koordinatörlük satır kartında (etiket solda, değer sağda).
    return QuickFormLayout(
      fields: [
        QuickTitleField(
          label: l.uiTasksIvName,
          hint: l.uiTasksIvNameHint,
          value: f.name,
          autofillHints: const [AutofillHints.name],
          onChanged: ctl.setName,
        ),
        NzTextField.email(
          label: l.uiTasksIvEmail,
          hint: l.uiTasksIvEmailHint,
          controller: _email,
          onChanged: ctl.setEmail,
        ),
      ],
      rows: NzFormRows(
        // Açılır satır indeksi: koordinatörlük (rol satırı yalnız yöneticide, önde).
        expandedIndex: f.paneOpen ? (admin ? 1 : 0) : null,
        onToggle: (_) => ctl.togglePane(),
        rows: [
          if (admin)
            NzFormRow.custom(
              label: l.uiTasksIvRole,
              icon: NzIcons.person,
              trailing: TaskSegmented(
                compact: true,
                semanticLabel: l.uiTasksIvRole,
                labels: [for (final r in InviteRole.values) l.roleLabel(r)],
                selected: f.role.index,
                onSelected: (i) => ctl.setRole(InviteRole.values[i]),
              ),
            ),
          NzFormRow(
            label: l.uiTasksFieldCoord,
            icon: NzIcons.coordinatorships,
            value: value,
            valueSet: picked != null,
            content: QuickPane(
              child: Column(
                children: [
                  for (final co in coords)
                    TaskCheckRow(
                      label: co.name,
                      caption: l.peopleCount(co.team.length),
                      selected: picked == co.code,
                      onTap: () => ctl.pickCoordinatorship(co.code),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      footer: [
        Text(
          l.roleDescription(admin ? f.role : InviteRole.member),
          style: context.text.caption.copyWith(color: c.textMuted),
        ),
        if (existing != null)
          TaskFormError(
            l.inviteExisting(
              existing.fullName.isEmpty ? f.email.trim() : existing.fullName,
            ),
          ),
        if (error != null) TaskFormError(l.inviteError(error)),
        if (failure != null) TaskFormError(l.writeErrorText(failure)),
      ],
    );
  }
}
