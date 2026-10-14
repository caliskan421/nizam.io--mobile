import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';
import 'nz_field_errors.dart';
import 'nz_validators.dart';

/// Onay kutusu: satırın tamamı dokunma alanıdır (en az 48), etiket kutuyla birlikte okunur.
/// Denetimli bileşendir ([value] çağıranındır); `NzForm` içinde [validator] (ör.
/// `NzValidators.mustAccept`) ve sunucu alan hatası ([name]/[fieldError]) desteklenir.
class NzCheckbox extends StatefulWidget {
  const NzCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.trailing,
    this.name,
    this.fieldError,
    this.validator,
    this.size = NzSize.md,
  });

  final String label;
  final bool value;

  /// `null` → devre dışı.
  final ValueChanged<bool>? onChanged;
  final String? description;

  /// Satırın sonunda (ör. bilgi simgesi).
  final Widget? trailing;
  final String? name;
  final ApiFieldError? fieldError;
  final NzValidator<bool>? validator;
  final NzSize size;

  @override
  State<NzCheckbox> createState() => _NzCheckboxState();
}

class _NzCheckboxState extends State<NzCheckbox> with NzServerFieldError {
  @override
  String? get serverFieldName => widget.name;

  @override
  ApiFieldError? get explicitFieldError => widget.fieldError;

  // Kullanıcının az önce seçtiği değer: çağıranın yeniden kurması bir kare sonra olduğundan
  // doğrulama (didChange anında) bunu okur; bir sonraki kurmada atılır.
  bool? _latest;

  @override
  void didUpdateWidget(NzCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _latest = null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = _resolveStyle(context, widget.size);
    final onChanged = widget.onChanged;
    return FormField<bool>(
      initialValue: widget.value,
      forceErrorText: serverErrorText,
      // Değer çağıranındır; doğrulama her zaman güncel değeri okur.
      validator: (_) =>
          widget.validator?.call(_latest ?? widget.value)?.text(l),
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            value: widget.value,
            onChanged: onChanged == null
                ? null
                : (v) {
                    dismissServerError();
                    _latest = v ?? false;
                    field.didChange(v ?? false);
                    onChanged(v ?? false);
                  },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(widget.label, style: style),
            subtitle: widget.description == null
                ? null
                : Text(widget.description!, style: context.text.bodySm),
            secondary: widget.trailing,
            isError: field.hasError,
          ),
          if (field.errorText != null) ...[
            const Gap(NizamioSpacing.space1),
            Text(
              field.errorText!,
              style: context.text.bodySm.copyWith(color: context.colors.danger),
            ),
          ],
        ],
      ),
    );
  }
}

/// Boyuta göre etiket yazı rolü (tek görünüm fark noktası).
TextStyle _resolveStyle(BuildContext context, NzSize size) => size.pick(
  sm: context.text.bodySm,
  md: context.text.bodyMd,
  lg: context.text.bodyLg,
);
