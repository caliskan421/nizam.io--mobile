import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/coordinatorship_form_controller.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/department.dart';

/// Koordinatörlük ekle ([detail] yok) ya da bilgileri düzenle ([detail]) formu (alt sayfa):
/// ad, tür, açıklama. Başarıda sayfa kapanır ve [context] üzerinde bildirim gösterilir.
/// Yalnız şirket yöneticisine açılır (çağıran [canManageCoordinatorshipsProvider] ile süzer).
Future<void> showCoordinatorshipForm(
  BuildContext context,
  WidgetRef ref, {
  CoordinatorshipDetail? detail,
}) {
  ref.read(coordinatorshipFormControllerProvider.notifier).clearError();
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: detail == null ? l.uiCoordFlyAdd : l.uiCoordMenuEdit,
    builder: (_) => _CoordForm(host: context, detail: detail),
  );
}

class _CoordForm extends ConsumerStatefulWidget {
  const _CoordForm({required this.host, this.detail});

  /// Sayfayı açan bağlam (kapanış bildirimi).
  final BuildContext host;
  final CoordinatorshipDetail? detail;

  @override
  ConsumerState<_CoordForm> createState() => _CoordFormState();
}

class _CoordFormState extends ConsumerState<_CoordForm> {
  late final CoordinatorshipDraft _initial = _initialDraft();
  late final _name = TextEditingController(text: _initial.name);
  late final _description = TextEditingController(text: _initial.description);
  late DepartmentKind? _kind = _initial.kind;

  bool get _editing => widget.detail != null;

  /// Düzenlemede ekrandaki ad (programdaki ad) ve departman kaydı; eklemede yarım kalmış
  /// departmanın değerleri ya da boş form (tür varsayılanı koordinatörlük).
  CoordinatorshipDraft _initialDraft() {
    if (widget.detail case final d?) {
      final kind = d.department?.kind;
      return CoordinatorshipDraft(
        name: d.stats.name,
        kind: kind == DepartmentKind.unknown ? null : kind,
        description: d.department?.description ?? '',
      );
    }
    if (ref.read(coordinatorshipFormControllerProvider).pending case final p?) {
      return CoordinatorshipDraft(
        name: p.name,
        kind: p.kind,
        description: p.description ?? '',
      );
    }
    return const CoordinatorshipDraft(
      name: '',
      kind: DepartmentKind.coordinatorship,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final draft = CoordinatorshipDraft(
      name: _name.text.trim(),
      kind: _kind,
      description: _description.text.trim(),
    );
    final ctl = ref.read(coordinatorshipFormControllerProvider.notifier);
    final ok = switch (widget.detail) {
      final d? => await ctl.edit(d.stats.code, initial: _initial, draft: draft),
      null => await ctl.create(draft),
    };
    if (!ok || !mounted) return;
    final l = context.l10n;
    Navigator.of(context).pop();
    final host = widget.host;
    if (host.mounted) {
      NzToast.show(
        host,
        _editing ? l.uiCoordToastSaved : l.uiCoordToastCreated,
        tone: NzToastTone.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = ref.watch(coordinatorshipFormControllerProvider);
    final error = f.error;
    // Oluşturulmuş ama bağlanamamış departman: tür ve açıklama kayıtta; yalnız ad (programdaki
    // ad) değişebilir.
    final pending = !_editing && f.pending != null;
    final locked = f.saving || pending;
    return NzForm(
      onSubmit: _submit,
      serverError: error,
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: NizamioSpacing.space3,
          children: [
            if (pending) NzBanner.warning(message: l.uiCoordFormLinkFailed),
            if (error != null && error.fields.isEmpty)
              NzBanner.danger(message: errorText(l, error)),
            NzTextField(
              label: l.uiCoordFormName,
              name: _editing || pending ? 'display_name' : 'name',
              helper: _editing ? l.uiCoordFormNameEditHelper : null,
              controller: _name,
              enabled: !f.saving,
              maxLength: 120,
              validator: NzValidators.all([
                NzValidators.requiredText,
                (v) => NzValidators.minLength(2)(v?.trim()),
              ]),
            ),
            NzSelect<DepartmentKind>(
              label: l.uiCoordFormKind,
              name: 'kind',
              value: _kind,
              items: [
                NzSelectItem(
                  value: DepartmentKind.coordinatorship,
                  label: l.uiCoordDeptKindCoordinatorship,
                ),
                NzSelectItem(
                  value: DepartmentKind.workingGroup,
                  label: l.uiCoordDeptKindWorkingGroup,
                ),
              ],
              validator: _editing ? null : NzValidators.mustChoose,
              onChanged: locked ? null : (k) => setState(() => _kind = k),
            ),
            NzTextField.multiline(
              label: l.uiCoordFormDescription,
              hint: l.uiCoordFormDescriptionHint,
              name: 'description',
              controller: _description,
              enabled: !locked,
            ),
            NzButton.primary(
              label: _editing
                  ? l.uiCoordFormSave
                  : pending
                  ? l.uiCoordFormLinkRetry
                  : l.uiCoordFormCreate,
              loading: f.saving,
              expand: true,
              onPressed: f.saving
                  ? null
                  : () => NzForm.of(formContext).submit(),
            ),
          ],
        ),
      ),
    );
  }
}
