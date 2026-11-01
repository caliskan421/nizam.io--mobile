import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/quick_forms_controller.dart';
import '../../application/task_catalog_controller.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'quick_parts.dart';

/// "Kullanıcı davet et" formu: ad soyad, e-posta, rol (Üye/Koordinatör/Admin) ve
/// koordinatörlükler (Admin'de kilitli "Tümü").
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
    final coords = catalog?.coordinatorships ?? const <CoordinatorshipRef>[];
    final admin = f.role == InviteRole.admin;
    final value = admin
        ? l.uiTasksViewAll
        : f.coordinatorships.isEmpty
        ? (f.role == InviteRole.coordinator
              ? l.uiTasksPick
              : l.uiTasksOptionalAny)
        : f.coordinatorships.length == 1
        ? catalog?.coordinatorship(f.coordinatorships.first)?.name ??
              f.coordinatorships.first
        : '${f.coordinatorships.length} ${l.uiTasksCoordsLc}';
    final error = f.error;

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
        // Açılır satır indeksi: rol 0, koordinatörlük 1.
        expandedIndex: f.paneOpen && !admin ? 1 : null,
        onToggle: (_) => ctl.togglePane(),
        rows: [
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
            valueSet: !admin && f.coordinatorships.isNotEmpty,
            content: admin
                ? null
                : QuickPane(
                    child: Column(
                      children: [
                        for (final co in coords)
                          TaskCheckRow(
                            label: co.name,
                            caption: l.peopleCount(co.team.length),
                            selected: f.coordinatorships.contains(co.code),
                            onTap: () => ctl.toggleCoordinatorship(co.code),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      footer: [
        Text(
          l.roleDescription(f.role),
          style: context.text.caption.copyWith(color: c.textMuted),
        ),
        if (error != null) TaskFormError(l.inviteError(error)),
      ],
    );
  }
}
