import 'package:flutter/material.dart';

import '../../i18n/generated/app_localizations.dart';
import '../../theme/generated/tokens.gen.dart';
import '../theme/nz_text_styles.dart';

/// Ekranın tema/yerelleştirme erişim yolu (ADR-0003, A1). `Theme.of(…).extension<…>()` yalnız
/// bu dosyada (U5). `layout` getter'ı A2'de eklenir.
extension NzContext on BuildContext {
  /// Renk rolleri (token).
  NizamioColors get colors => Theme.of(this).extension<NizamioColors>()!;

  /// Anlamsal metin rolleri.
  NzTextStyles get text => Theme.of(this).extension<NzTextStyles>()!;

  /// Material tema (bileşen temaları, ColorScheme).
  ThemeData get theme => Theme.of(this);

  /// ARB metinleri.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
