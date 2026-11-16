import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../scope/scope.dart' show Program, programListControllerProvider;
import '../../tasks/tasks.dart' show TaskSegmented;
import '../application/coordinatorship_form_controller.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/department.dart';

/// Koordinatörlük ekle ([detail] yok) ya da bilgileri düzenle ([detail]) alt sayfası; hızlı
/// işlem formlarıyla aynı standart: başlık + açıklama, üstte metin alanları (ad, kısa kod,
/// açıklama), altta satır kartı (tür; ad çakışmasında "ekibi kopyala"), altta sabit
/// "Vazgeç / Oluştur". Alanlar `CreateDepartmentRequest` (+ `LinkDepartmentRequest`) ile birebir.
/// Eklemede başarı: bildirim, liste yenilenir (denetleyici) ve yeni koordinatörlük açılır.
/// Yalnız şirket yöneticisine açılır (çağıran [canManageCoordinatorshipsProvider] ile süzer).
Future<void> showCoordinatorshipForm(
  BuildContext context,
  WidgetRef ref, {
  CoordinatorshipDetail? detail,
}) async {
  ref.read(coordinatorshipFormControllerProvider.notifier).clearError();
  final l = context.l10n;
  final nav = context.appNav;
  final form = GlobalKey<_CoordFormState>();
  final created = await NzBottomSheet.show<String>(
    context,
    title: detail == null ? l.uiCoordFlyAdd : l.uiCoordMenuEdit,
    description: detail == null ? l.uiCoordFormDesc : l.uiCoordFormEditDesc,
    expandable: true,
    actions: (sheet) => [
      NzButton.secondary(
        label: l.uiCoordFormCancel,
        expand: true,
        onPressed: () => Navigator.of(sheet).maybePop(),
      ),
      _SubmitButton(form: form, editing: detail != null),
    ],
    builder: (_) => _CoordForm(key: form, detail: detail),
  );
  if (created == null || !context.mounted) return;
  NzToast.show(
    context,
    detail == null ? l.uiCoordToastCreated : l.uiCoordToastSaved,
    tone: NzToastTone.success,
  );
  if (detail == null && created.isNotEmpty) nav.openCoordinatorship(created);
}

/// Alt sabit satırın ana düğmesi: formun durumuna göre Oluştur / Kaydet / bağlamayı tekrar dene
/// / mevcut kaydı kullan.
class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({required this.form, required this.editing});

  final GlobalKey<_CoordFormState> form;
  final bool editing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = ref.watch(coordinatorshipFormControllerProvider);
    final pending = !editing && f.pending != null;
    return NzButton.primary(
      label: f.existingId != null && !editing
          ? l.uiCoordFormExistingConfirm
          : editing
          ? l.uiCoordFormSave
          : pending
          ? l.uiCoordFormLinkRetry
          : l.uiCoordFormCreate,
      loading: f.saving,
      expand: true,
      onPressed: f.saving ? null : () => form.currentState?.submit(),
    );
  }
}

class _CoordForm extends ConsumerStatefulWidget {
  const _CoordForm({super.key, this.detail});

  final CoordinatorshipDetail? detail;

  @override
  ConsumerState<_CoordForm> createState() => _CoordFormState();
}

class _CoordFormState extends ConsumerState<_CoordForm> {
  final _form = GlobalKey<NzFormState>();
  late final CoordinatorshipDraft _initial = _initialDraft();
  late final _name = TextEditingController(text: _initial.name);
  late final _code = TextEditingController(text: _initial.code);
  late final _description = TextEditingController(text: _initial.description);
  late DepartmentKind? _kind = _initial.kind;
  String? _copyFrom;
  bool _copyOpen = false;

  bool get _editing => widget.detail != null;

  /// Düzenlemede ekrandaki ad (programdaki ad) ve departman kaydı; eklemede yarım kalmış
  /// departmanın değerleri ya da boş form (tür varsayılanı koordinatörlük).
  CoordinatorshipDraft _initialDraft() {
    if (widget.detail case final d?) {
      final kind = d.department?.kind;
      return CoordinatorshipDraft(
        name: d.stats.name,
        kind: kind == DepartmentKind.unknown ? null : kind,
        code: d.department?.code ?? '',
        description: d.department?.description ?? '',
      );
    }
    if (ref.read(coordinatorshipFormControllerProvider.notifier).pendingDraft
        case final draft?) {
      return draft;
    }
    if (ref.read(coordinatorshipFormControllerProvider).pending case final p?) {
      return CoordinatorshipDraft(
        name: p.name,
        kind: p.kind,
        code: p.code ?? '',
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
    _code.dispose();
    _description.dispose();
    super.dispose();
  }

  /// Alt satırdaki ana düğme: ad çakışmasında doğrulamasız onay (alanlar kilitli), değilse
  /// form doğrulanıp gönderilir.
  void submit() {
    final f = ref.read(coordinatorshipFormControllerProvider);
    if (!_editing && f.existingId != null) {
      _send(confirmExisting: true);
    } else {
      _form.currentState?.submit();
    }
  }

  Future<void> _send({bool confirmExisting = false}) async {
    final draft = CoordinatorshipDraft(
      name: _name.text.trim(),
      kind: _kind,
      code: _code.text.trim(),
      description: _description.text.trim(),
    );
    final ctl = ref.read(coordinatorshipFormControllerProvider.notifier);
    final ok = switch (widget.detail) {
      final d? => await ctl.edit(d.stats.code, initial: _initial, draft: draft),
      null =>
        confirmExisting
            ? await ctl.confirmExisting(copyMembersFrom: _copyFrom)
            : await ctl.create(draft),
    };
    if (!ok || !mounted) return;
    Navigator.of(context).pop(_editing ? '' : ctl.createdId ?? '');
  }

  ApiError? _mappedFrom;
  ApiError? _mapped;

  /// Kod çakışması (409, alan listesi yok) kod alanının altında gösterilir. Aynı hata için
  /// aynı nesne döner: alan düzenlenince gizlenen sunucu hatası yeniden çizimde geri gelmez.
  ApiError? _fieldMapped(ApiError? e) {
    if (identical(e, _mappedFrom)) return _mapped;
    _mappedFrom = e;
    return _mapped =
        e != null &&
            e.code == 'organization.department_code_conflict' &&
            e.fields.isEmpty
        ? ApiError(
            e.code,
            requestId: e.requestId,
            status: e.status,
            fields: [ApiFieldError(field: 'code', code: e.code, message: '')],
          )
        : e;
  }

  /// Kod isteğe bağlıdır ama kayıtlı kod boşaltılamaz (sunucu boş kodu "değişmez" sayar);
  /// doluysa [DepartmentCode] biçimi.
  NzValidationIssue? _validateCode(String? v) {
    final text = v?.trim() ?? '';
    if (_editing && text.isEmpty && _initial.code.isNotEmpty) {
      return NzValidationIssue.required;
    }
    return DepartmentCode.isValid(text) ? null : NzValidationIssue.invalid;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = ref.watch(coordinatorshipFormControllerProvider);
    final error = _fieldMapped(f.error);
    final existing = !_editing && f.existingId != null;
    // Oluşturulmuş ama bağlanamamış departman: tür, kod ve açıklama kayıtta; yalnız ad
    // (programdaki ad) değişebilir.
    final pending = !_editing && (f.pending != null || existing);
    final locked = f.saving || pending || f.frozen;
    final kinds = [DepartmentKind.coordinatorship, DepartmentKind.workingGroup];
    return NzForm(
      key: _form,
      onSubmit: _send,
      serverError: error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: NizamioSpacing.space3,
        children: [
          if (existing)
            NzBanner.warning(
              message: f.deleted
                  ? l.uiCoordFormExistingDeleted
                  : l.uiCoordFormExisting,
            )
          else if (pending)
            NzBanner.warning(message: l.uiCoordFormLinkFailed),
          if (f.frozen && !pending)
            NzBanner.warning(message: l.uiCoordFormOutcomeUnknown),
          if (error != null && error.fields.isEmpty)
            NzBanner.danger(message: errorText(l, error)),
          NzTextField(
            label: l.uiCoordFormName,
            hint: l.uiCoordFormNameHint,
            name: _editing || pending ? 'display_name' : 'name',
            helper: _editing ? l.uiCoordFormNameEditHelper : null,
            controller: _name,
            enabled: !locked,
            maxLength: 120,
            validator: NzValidators.all([
              NzValidators.requiredText,
              (v) => NzValidators.minLength(2)(v?.trim()),
            ]),
          ),
          NzTextField(
            label: l.uiCoordFormCode,
            hint: l.uiCoordFormCodeHint,
            helper: l.uiCoordFormCodeHelper,
            name: 'code',
            controller: _code,
            enabled: !locked,
            maxLength: 10,
            validator: _validateCode,
          ),
          NzTextField.multiline(
            label: l.uiCoordFormDescription,
            hint: l.uiCoordFormDescriptionHint,
            name: 'description',
            controller: _description,
            enabled: !locked,
          ),
          NzFormRows(
            expandedIndex: existing && _copyOpen ? 1 : null,
            onToggle: (_) => setState(() => _copyOpen = !_copyOpen),
            rows: [
              NzFormRow.custom(
                label: l.uiCoordFormKind,
                icon: NzIcons.coordinatorships,
                trailing: TaskSegmented(
                  compact: true,
                  semanticLabel: l.uiCoordFormKind,
                  labels: [
                    l.uiCoordDeptKindCoordinatorship,
                    l.uiCoordDeptKindWorkingGroup,
                  ],
                  selected: _kind == null ? -1 : kinds.indexOf(_kind!),
                  onSelected: (i) {
                    if (!locked) setState(() => _kind = kinds[i]);
                  },
                ),
              ),
              if (existing) _copyRow(context),
            ],
          ),
        ],
      ),
    );
  }

  /// Ad çakışmasında var olan departman bağlanırken başka programdaki ekibinin kopyası
  /// (`copy_members_from_program_id`); seçenekler kapsamdaki program dışındaki programlar.
  NzFormRow _copyRow(BuildContext context) {
    final l = context.l10n;
    final current = ref.watch(scopeStateProvider).programId;
    final programs = [
      for (final p
          in ref.watch(programListControllerProvider).value?.items ??
              const <Program>[])
        if (p.id != current) p,
    ];
    final picked = programs.where((p) => p.id == _copyFrom).firstOrNull;
    void pick(String? id) => setState(() {
      _copyFrom = id;
      _copyOpen = false;
    });
    return NzFormRow(
      label: l.uiCoordFormCopyTeam,
      icon: NzIcons.person,
      value: picked?.name ?? l.uiCoordFormCopyNone,
      valueSet: picked != null,
      content: Padding(
        padding: const EdgeInsets.fromLTRB(
          NizamioSpacing.gapMd,
          0,
          NizamioSpacing.gapMd,
          NizamioSpacing.gapMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.space2,
          children: [
            Text(
              l.uiCoordFormCopyCaption,
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            NzCheckCircle(
              value: _copyFrom == null,
              label: l.uiCoordFormCopyNone,
              onChanged: () => pick(null),
            ),
            for (final p in programs)
              NzCheckCircle(
                value: _copyFrom == p.id,
                label: p.name,
                onChanged: () => pick(p.id),
              ),
          ],
        ),
      ),
    );
  }
}
