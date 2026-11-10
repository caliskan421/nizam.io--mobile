import 'dart:ui' show Locale;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import 'task_catalog_controller.dart';

part 'tasks_nav_caption.g.dart';

/// Alt menüde bu modül etkinken görünen mono alt yazı ("76 görev"); katalog yokken null.
/// Uygulama tek dillidir (tr); metin parçası ARB'den.
@riverpod
String? tasksNavCaption(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return null;
  final prefix = catalog.truncated ? '≥' : '';
  return '$prefix${catalog.tasks.length} ${lookupAppLocalizations(const Locale('tr')).uiTasksTasksLc}';
}
