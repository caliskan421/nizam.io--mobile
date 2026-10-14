import '../../../i18n/generated/app_localizations.dart';

/// Doğrulayıcının bildirdiği sorun. Kullanıcı metni [text] ile ARB'den gelir (yer tutucusuz);
/// doğrulayıcı kendisi metin taşımaz, böylece dil değişse de aynı doğrulayıcı kullanılır.
enum NzValidationIssue {
  required,
  email,
  tooShort,
  tooLong,
  mismatch,
  mustAccept,
  mustChoose;

  String text(AppLocalizations l) => switch (this) {
    NzValidationIssue.required => l.uiInputsValidationRequired,
    NzValidationIssue.email => l.uiInputsValidationEmail,
    NzValidationIssue.tooShort => l.uiInputsValidationTooShort,
    NzValidationIssue.tooLong => l.uiInputsValidationTooLong,
    NzValidationIssue.mismatch => l.uiInputsValidationMismatch,
    NzValidationIssue.mustAccept => l.uiInputsValidationMustAccept,
    NzValidationIssue.mustChoose => l.uiInputsValidationMustChoose,
  };
}

/// `null` = geçerli. Alan değeri boş olabilir (`null`).
typedef NzValidator<T> = NzValidationIssue? Function(T? value);

/// Alan doğrulayıcıları. Biçim doğrulayıcıları (e-posta, uzunluk) boş değeri geçerli sayar;
/// "boş olamaz" kuralı [requiredText] ile ayrıca verilir ([all] ile birleştirilir).
abstract final class NzValidators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Boşluktan başka bir şey içermeli.
  static NzValidationIssue? requiredText(String? value) =>
      value == null || value.trim().isEmpty ? NzValidationIssue.required : null;

  /// Boş değilse `a@b.c` biçiminde olmalı (ayrıntılı doğrulama sunucuda).
  static NzValidationIssue? email(String? value) {
    final v = value?.trim() ?? '';
    return v.isEmpty || _email.hasMatch(v) ? null : NzValidationIssue.email;
  }

  /// Boş değilse en az [length] karakter.
  static NzValidator<String> minLength(int length) =>
      (value) => value == null || value.isEmpty || value.length >= length
      ? null
      : NzValidationIssue.tooShort;

  /// En çok [length] karakter.
  static NzValidator<String> maxLength(int length) =>
      (value) => value == null || value.length <= length
      ? null
      : NzValidationIssue.tooLong;

  /// Değer [other]()'ın döndürdüğüyle aynı olmalı (parola tekrarı). Boş değer geçerli sayılır.
  static NzValidator<String> matches(String Function() other) =>
      (value) => value == null || value.isEmpty || value == other()
      ? null
      : NzValidationIssue.mismatch;

  /// Onay kutusu zorunlu onay: yalnız `true` geçer.
  static NzValidationIssue? mustAccept(bool? value) =>
      value == true ? null : NzValidationIssue.mustAccept;

  /// Seçim zorunlu: `null` geçmez.
  static NzValidationIssue? mustChoose<T>(T? value) =>
      value == null ? NzValidationIssue.mustChoose : null;

  /// İlk sorunlu doğrulayıcının sonucunu döndürür (sıra önemlidir).
  static NzValidator<T> all<T>(List<NzValidator<T>> validators) => (value) {
    for (final v in validators) {
      final issue = v(value);
      if (issue != null) return issue;
    }
    return null;
  };
}
