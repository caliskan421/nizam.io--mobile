import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import 'activity_log_controller.dart';

part 'activity_nav_caption.g.dart';

/// Alt menüde işlem geçmişindeyken görünen mono alt yazı ("38 kayıt"); yüklenmeden null.
@riverpod
String? activityNavCaption(Ref ref) {
  final log = ref.watch(activityLogControllerProvider).value;
  if (log == null) return null;
  final l = lookupAppLocalizations(ref.watch(localeProvider));
  return '${log.entries.length} ${l.uiActivityCountTail}';
}
