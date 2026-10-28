import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import 'archive_folders_controller.dart';

part 'archive_nav_caption.g.dart';

/// Alt menüde bu modül etkinken görünen mono alt yazı ("227 dosya"); veri yokken null.
@riverpod
String? archiveNavCaption(Ref ref) {
  final folders = ref.watch(archiveFoldersControllerProvider).value;
  if (folders == null) return null;
  final n = folders.fold<int>(0, (t, f) => t + f.files);
  return '$n ${lookupAppLocalizations(ref.watch(localeProvider)).uiArchiveFilesLc}';
}
