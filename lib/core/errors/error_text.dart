import '../i18n/generated/app_localizations.dart';
import '../i18n/generated/error_messages.gen.dart';
import 'api_error.dart';

/// Kullanıcıya gösterilecek metin; bilinmeyen kod (yeni backend etiketi) genel metne düşer.
String errorText(AppLocalizations l, ApiError error) =>
    localizedErrorText(l, error.code) ??
    localizedErrorText(l, 'platform.internal')!;
