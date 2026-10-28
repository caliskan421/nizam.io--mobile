import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';

part 'coordinatorships_nav_caption.g.dart';

/// Alt menüde bu modül etkinken görünen mono alt yazı ("11 koordinatörlük"); katalog
/// yüklenmeden null.
@riverpod
String? coordinatorshipsNavCaption(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return null;
  final l = lookupAppLocalizations(ref.watch(localeProvider));
  return '${catalog.coordinatorships.length} ${l.uiCoordCountTail}';
}
