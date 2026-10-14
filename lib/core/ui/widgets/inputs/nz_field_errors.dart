import 'package:flutter/widgets.dart';

import '../../../errors/api_error.dart';
import '../../../i18n/generated/app_localizations.dart';
import '../../../i18n/generated/error_messages.gen.dart';
import '../../extensions/context_ext.dart';

/// Sunucu `ApiError.fields[]` → alan hatası eşlemesinin TEK yardımcısı (A4). Eşleme `field`
/// adıyladır; adı hiçbir kayıtlı alana uymayan hata [unmatched]'a düşer ve form düzeyinde
/// gösterilir (yutulmaz). Metin sunucu `message`'ından değil `code`'dan ARB ile gelir.
@immutable
final class NzFieldErrors {
  const NzFieldErrors._(this.byField, this.unmatched);

  static const empty = NzFieldErrors._({}, []);

  /// [error]'ın alan hatalarını [fieldNames] (formdaki kayıtlı alan adları) ile eşler.
  factory NzFieldErrors.resolve(ApiError? error, Set<String> fieldNames) {
    if (error == null || error.fields.isEmpty) return empty;
    final byField = <String, List<ApiFieldError>>{};
    final unmatched = <ApiFieldError>[];
    for (final f in error.fields) {
      if (fieldNames.contains(f.field)) {
        (byField[f.field] ??= []).add(f);
      } else {
        unmatched.add(f);
      }
    }
    return NzFieldErrors._({
      for (final e in byField.entries) e.key: List.unmodifiable(e.value),
    }, List.unmodifiable(unmatched));
  }

  /// Alan adı → o alanın hataları (sunucu sırasıyla).
  final Map<String, List<ApiFieldError>> byField;

  /// Kayıtlı hiçbir alana eşlenmeyen hatalar (form düzeyinde gösterilir).
  final List<ApiFieldError> unmatched;

  /// Tek alan hatasının kullanıcı metni (`code` → ARB). Bilinmeyen kod genel "geçersiz" metnine
  /// düşer; sunucu `message`'ı kullanılmaz.
  static String text(AppLocalizations l, ApiFieldError error) =>
      localizedErrorText(l, error.code) ?? l.uiInputsInvalidValue;

  /// Bir alanın birden çok hatası varsa satır satır birleştirilir.
  static String textAll(AppLocalizations l, Iterable<ApiFieldError> errors) =>
      errors.map((e) => text(l, e)).join('\n');
}

/// Alanların forma kaydolma ve sunucu hatasını okuma sözleşmesi (`NzForm` uygular).
abstract interface class NzFormRegistry {
  void registerField(String name);
  void unregisterField(String name);
}

/// `NzForm`'un alt ağaca verdiği kapsam: alan adı → sunucu hataları. Alanlar bunu
/// [NzServerFieldError] karışımıyla okur.
class NzFormScope extends InheritedWidget {
  const NzFormScope({
    super.key,
    required this.registry,
    required this.errors,
    required super.child,
  });

  final NzFormRegistry registry;
  final NzFieldErrors errors;

  static NzFormScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NzFormScope>();

  @override
  bool updateShouldNotify(NzFormScope oldWidget) =>
      !identical(errors, oldWidget.errors);
}

/// Girdi alanlarının ortak sunucu-hatası davranışı: `name` ile forma kaydolur, form kapsamındaki
/// ya da açıkça verilen ([explicitFieldError]) sunucu hatasını gösterir, kullanıcı alanı
/// düzenleyince o hatayı gizler (yeni gönderimin hatası yeniden gösterilir).
mixin NzServerFieldError<W extends StatefulWidget> on State<W> {
  /// Alanın form içindeki adı (`ApiFieldError.field` ile eşleşir); `null` → forma kaydolmaz.
  String? get serverFieldName;

  /// Form dışı kullanım için doğrudan verilen alan hatası.
  ApiFieldError? get explicitFieldError;

  NzFormScope? _scope;
  String? _registeredName;
  ApiFieldError? _dismissed;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = NzFormScope.maybeOf(context);
    _syncRegistration();
  }

  @override
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncRegistration();
  }

  @override
  void dispose() {
    final name = _registeredName;
    if (name != null) _scope?.registry.unregisterField(name);
    super.dispose();
  }

  void _syncRegistration() {
    final wanted = _scope == null ? null : serverFieldName;
    if (wanted == _registeredName) return;
    final old = _registeredName;
    if (old != null) _scope?.registry.unregisterField(old);
    if (wanted != null) _scope?.registry.registerField(wanted);
    _registeredName = wanted;
  }

  List<ApiFieldError> get _active {
    final explicit = explicitFieldError;
    final all = explicit != null
        ? [explicit]
        : (_scope?.errors.byField[serverFieldName] ?? const <ApiFieldError>[]);
    if (all.isEmpty || identical(all.first, _dismissed)) return const [];
    return all;
  }

  /// Gösterilecek sunucu hatası metni; yoksa `null`.
  String? get serverErrorText {
    final active = _active;
    return active.isEmpty ? null : NzFieldErrors.textAll(context.l10n, active);
  }

  /// Kullanıcı alanı değiştirdi: görünen sunucu hatasını gizler.
  void dismissServerError() {
    final active = _active;
    if (active.isEmpty) return;
    setState(() => _dismissed = active.first);
  }
}
