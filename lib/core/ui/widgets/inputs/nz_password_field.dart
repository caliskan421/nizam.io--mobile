import 'package:flutter/material.dart';

import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';
import 'nz_field_errors.dart';
import 'nz_text_field.dart' show NzFieldLabelAbove;
import 'nz_validators.dart';

enum _PasswordKind { current, newPassword }

/// [NzPasswordField]'ın denetleyicisi: `toString` değeri içermez (log/tanılama dökümü parolayı
/// sızdırmasın). Dışarıdan denetleyici verilecekse bu tür verilir.
class NzPasswordController extends TextEditingController {
  NzPasswordController({super.text});

  @override
  String toString() => 'NzPasswordController(***)';
}

/// Parola girdisi: yazılan karakterler gizlidir, sondaki düğme göster/gizle yapar. Varyantlar:
/// [NzPasswordField] (mevcut parola; `AutofillHints.password`) ve [NzPasswordField.newPassword]
/// (yeni parola; `AutofillHints.newPassword`).
///
/// Değer log'a, `toString`'e ve (gizliyken) anlamsal değere düşmez; öneri/otomatik düzeltme
/// kapalıdır. Sunucu alan hatası eşlemesi [NzTextField] ile aynıdır.
class NzPasswordField extends StatefulWidget {
  const NzPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.name,
    this.fieldError,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.size = NzSize.md,
    this.labelAbove = false,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.invalid = false,
  }) : _kind = _PasswordKind.current;

  const NzPasswordField.newPassword({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.name,
    this.fieldError,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.size = NzSize.md,
    this.labelAbove = false,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.invalid = false,
  }) : _kind = _PasswordKind.newPassword;

  final String label;
  final NzPasswordController? controller;
  final String? hint;
  final String? helper;
  final String? name;
  final ApiFieldError? fieldError;
  final NzValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final NzSize size;

  /// true → etiket alanın üstünde (bkz. `NzTextField.labelAbove`).
  final bool labelAbove;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;

  /// true → alan metinsiz hata görünümünde (tehlike kenarlığı); hata metni başka yerde
  /// gösterildiğinde (ör. giriş formunun altındaki tek ileti, iki alan birden kırmızı).
  final bool invalid;
  final _PasswordKind _kind;

  /// Değer ve denetleyici içermez.
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'NzPasswordField(${_kind.name})';

  @override
  State<NzPasswordField> createState() => _NzPasswordFieldState();
}

class _NzPasswordFieldState extends State<NzPasswordField>
    with NzServerFieldError {
  bool _visible = false;

  @override
  String? get serverFieldName => widget.name;

  @override
  ApiFieldError? get explicitFieldError => widget.fieldError;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      '_NzPasswordFieldState';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final validator = widget.validator;
    final errorTheme = Theme.of(context).inputDecorationTheme;
    final field = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      obscureText: !_visible,
      obscuringCharacter: '•',
      style: _resolveStyle(context, widget.size),
      keyboardType: _visible
          ? TextInputType.visiblePassword
          : TextInputType.text,
      textInputAction: widget.textInputAction,
      autofillHints: [
        switch (widget._kind) {
          _PasswordKind.current => AutofillHints.password,
          _PasswordKind.newPassword => AutofillHints.newPassword,
        },
      ],
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: _visible,
      decoration: InputDecoration(
        labelText: widget.labelAbove ? null : widget.label,
        hintText: widget.hint,
        helperText: widget.helper,
        helperMaxLines: 4,
        errorMaxLines: 4,
        contentPadding: EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space4,
          vertical: widget.size.pick(
            sm: NizamioSpacing.space3,
            md: NizamioSpacing.space3,
            lg: NizamioSpacing.space4,
          ),
        ),
        constraints: const BoxConstraints(minHeight: NizamioSpacing.space12),
        enabledBorder: widget.invalid ? errorTheme.errorBorder : null,
        focusedBorder: widget.invalid ? errorTheme.focusedErrorBorder : null,
        suffixIcon: IconButton(
          tooltip: _visible ? l.uiInputsPasswordHide : l.uiInputsPasswordShow,
          icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          onPressed: widget.enabled
              ? () => setState(() => _visible = !_visible)
              : null,
        ),
      ),
      forceErrorText: serverErrorText,
      validator: validator == null
          ? null
          : (value) => validator(value)?.text(l),
      onChanged: (value) {
        dismissServerError();
        widget.onChanged?.call(value);
      },
      onFieldSubmitted: widget.onSubmitted,
    );
    return widget.labelAbove
        ? NzFieldLabelAbove(label: widget.label, child: field)
        : field;
  }
}

/// Boyuta göre yazı rolü (tek görünüm fark noktası).
TextStyle _resolveStyle(BuildContext context, NzSize size) => size.pick(
  sm: context.text.bodySm,
  md: context.text.bodyMd,
  lg: context.text.bodyLg,
);
