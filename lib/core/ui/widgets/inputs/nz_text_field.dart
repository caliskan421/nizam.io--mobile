import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';
import 'nz_field_errors.dart';
import 'nz_validators.dart';

enum _TextFieldKind { text, email, multiline, number }

/// Tek satır / çok satır metin girdisi. Varyantlar isimli yapıcıdır: [NzTextField] (düz metin),
/// [NzTextField.email], [NzTextField.multiline], [NzTextField.number]; her biri uygun klavyeyi
/// ve otomatik doldurma ipucunu kendisi seçer.
///
/// `NzForm` içinde [name] (= `ApiFieldError.field`) verilirse sunucu alan hatası bu alanda
/// gösterilir ve alan düzenlenince gizlenir; form dışında [fieldError] doğrudan verilir.
/// Hata metni sunucu `message`'ından değil `code`'dan ARB ile gelir.
class NzTextField extends StatefulWidget {
  const NzTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.name,
    this.fieldError,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.size = NzSize.md,
    this.leading,
    this.trailing,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.maxLength,
    this.autofillHints,
  }) : _kind = _TextFieldKind.text;

  /// E-posta: e-posta klavyesi, `AutofillHints.email`, otomatik düzeltme kapalı.
  const NzTextField.email({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.name,
    this.fieldError,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.size = NzSize.md,
    this.leading,
    this.trailing,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.maxLength,
  }) : _kind = _TextFieldKind.email,
       autofillHints = const [AutofillHints.email];

  /// Çok satırlı metin (açıklama, not): 3–6 satır arası büyür; klavye eylemi satır sonudur.
  const NzTextField.multiline({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.name,
    this.fieldError,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.size = NzSize.md,
    this.leading,
    this.trailing,
    this.focusNode,
    this.maxLength,
    this.autofillHints,
  }) : _kind = _TextFieldKind.multiline,
       onSubmitted = null,
       textInputAction = TextInputAction.newline;

  /// Sayı: sayısal klavye, yalnız rakam girilebilir.
  const NzTextField.number({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.name,
    this.fieldError,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.size = NzSize.md,
    this.leading,
    this.trailing,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.maxLength,
  }) : _kind = _TextFieldKind.number,
       autofillHints = null;

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? helper;

  /// Form içindeki alan adı; sunucu `ApiFieldError.field` ile eşleşir.
  final String? name;

  /// Form dışı kullanımda doğrudan verilen sunucu alan hatası.
  final ApiFieldError? fieldError;
  final NzValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final NzSize size;

  /// Girdinin başında (ör. simge).
  final Widget? leading;

  /// Girdinin sonunda (ör. eylem düğmesi).
  final Widget? trailing;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final _TextFieldKind _kind;

  @override
  State<NzTextField> createState() => _NzTextFieldState();
}

class _NzTextFieldState extends State<NzTextField> with NzServerFieldError {
  @override
  String? get serverFieldName => widget.name;

  @override
  ApiFieldError? get explicitFieldError => widget.fieldError;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context, widget.size);
    final multiline = widget._kind == _TextFieldKind.multiline;
    final email = widget._kind == _TextFieldKind.email;
    final number = widget._kind == _TextFieldKind.number;
    final validator = widget.validator;
    final l = context.l10n;
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      style: style.text,
      keyboardType: switch (widget._kind) {
        _TextFieldKind.email => TextInputType.emailAddress,
        _TextFieldKind.multiline => TextInputType.multiline,
        _TextFieldKind.number => TextInputType.number,
        _TextFieldKind.text => TextInputType.text,
      },
      inputFormatters: number ? [FilteringTextInputFormatter.digitsOnly] : null,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      autocorrect: !email,
      enableSuggestions: !email,
      textCapitalization: email
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      minLines: multiline ? 3 : 1,
      maxLines: multiline ? 6 : 1,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helper,
        helperMaxLines: 4,
        errorMaxLines: 4,
        counterText: '',
        prefixIcon: widget.leading,
        suffixIcon: widget.trailing,
        contentPadding: EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space4,
          vertical: style.vertical,
        ),
        constraints: const BoxConstraints(minHeight: NizamioSpacing.space12),
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
  }
}

/// Boyuta göre yazı rolü ve dikey iç boşluk (tek görünüm fark noktası). Dokunma alanı
/// boyuttan bağımsız en az 48'dir (decoration `constraints`).
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
