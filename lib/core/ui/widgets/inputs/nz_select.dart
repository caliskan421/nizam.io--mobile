import 'package:flutter/material.dart';

import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';
import 'nz_field_errors.dart';
import 'nz_validators.dart';

/// [NzSelect] seçeneği: değer ve kullanıcıya görünen etiket (çağıran ARB'den verir).
@immutable
class NzSelectItem<T> {
  const NzSelectItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// Açılır liste seçimi. Denetimli bileşendir ([value] çağıranındır); `NzForm` içinde
/// [validator] (ör. `NzValidators.mustChoose`) ve sunucu alan hatası ([name]/[fieldError])
/// desteklenir. Etiket, seçili değer ve düğme rolü tek anlamsal düğümde okunur.
class NzSelect<T> extends StatefulWidget {
  const NzSelect({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.helper,
    this.leading,
    this.name,
    this.fieldError,
    this.validator,
    this.size = NzSize.md,
  });

  final String label;
  final List<NzSelectItem<T>> items;
  final T? value;

  /// `null` → devre dışı.
  final ValueChanged<T?>? onChanged;

  /// Seçim yokken gösterilir (verilmezse etiket yer tutucu olur).
  final String? hint;
  final String? helper;
  final Widget? leading;
  final String? name;
  final ApiFieldError? fieldError;
  final NzValidator<T>? validator;
  final NzSize size;

  @override
  State<NzSelect<T>> createState() => _NzSelectState<T>();
}

class _NzSelectState<T> extends State<NzSelect<T>> with NzServerFieldError {
  final _focus = FocusNode();

  // Kullanıcının az önce seçtiği değer: çağıranın yeniden kurması bir kare sonra olduğundan
  // doğrulama (didChange anında) bunu okur; bir sonraki kurmada atılır.
  ({T? value})? _latest;

  @override
  void didUpdateWidget(NzSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _latest = null;
  }

  @override
  String? get serverFieldName => widget.name;

  @override
  ApiFieldError? get explicitFieldError => widget.fieldError;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = _resolveStyle(context, widget.size);
    final onChanged = widget.onChanged;
    final hint = widget.hint;
    return FormField<T>(
      initialValue: widget.value,
      forceErrorText: serverErrorText,
      // Değer çağıranındır; doğrulama her zaman güncel değeri okur.
      validator: (_) => widget.validator
          ?.call(_latest == null ? widget.value : _latest!.value)
          ?.text(l),
      builder: (field) => MergeSemantics(
        child: InputDecorator(
          isEmpty: widget.value == null && hint == null,
          isFocused: _focus.hasFocus,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helper,
            helperMaxLines: 4,
            errorText: field.errorText,
            errorMaxLines: 4,
            enabled: onChanged != null,
            prefixIcon: widget.leading,
            contentPadding: EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space4,
              vertical: style.vertical,
            ),
            constraints: const BoxConstraints(
              minHeight: NizamioSpacing.space12,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: widget.value,
              isExpanded: true,
              focusNode: _focus,
              style: style.text.copyWith(color: context.colors.text),
              dropdownColor: context.colors.background,
              borderRadius: BorderRadius.circular(NizamioRadius.radiusLg),
              itemHeight: null,
              hint: hint == null
                  ? null
                  : Text(hint, overflow: TextOverflow.ellipsis),
              items: [
                for (final item in widget.items)
                  DropdownMenuItem<T>(
                    value: item.value,
                    enabled: item.enabled,
                    child: Text(item.label, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: onChanged == null
                  ? null
                  : (v) {
                      dismissServerError();
                      _latest = (value: v);
                      field.didChange(v);
                      onChanged(v);
                    },
            ),
          ),
        ),
      ),
    );
  }
}

/// Boyuta göre yazı rolü ve dikey iç boşluk (tek görünüm fark noktası).
({TextStyle text, double vertical}) _resolveStyle(
  BuildContext context,
  NzSize size,
) => (
  text: size.pick(
    sm: context.text.bodySm,
    md: context.text.bodyMd,
    lg: context.text.bodyLg,
  ),
  vertical: size.pick(
    sm: NizamioSpacing.space3,
    md: NizamioSpacing.space3,
    lg: NizamioSpacing.space4,
  ),
);
