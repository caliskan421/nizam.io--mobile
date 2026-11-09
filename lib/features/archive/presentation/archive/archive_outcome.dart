import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../tasks/tasks.dart';
import '../../application/archive_actions_controller.dart';
import '../../application/archive_folders_controller.dart';
import '../../application/archive_providers.dart';

/// Arşiv eyleminin sonucunu bildirir: hata → hata metni (`errorText`), başarı → [success]
/// (verilmezse "Kaydedildi"), vazgeçme → sessiz.
void showArchiveOutcome(
  BuildContext context,
  ArchiveOutcome r, {
  String? success,
}) {
  final error = r.error;
  if (error != null) {
    NzToast.error(context, error);
  } else if (r.ok) {
    NzToast.success(context, success ?? context.l10n.uiArchiveSaved);
  }
}

/// Arşiv kaynaklarını yeniden okur (yalnız dokunuşla): kapsamın kaynağı görev kataloğu hatadaysa
/// o da yeniden okunur.
void retryArchive(WidgetRef ref) {
  if (ref.read(taskCatalogControllerProvider).hasError) {
    ref.invalidate(taskCatalogControllerProvider);
  }
  ref
    ..invalidate(archiveScopeProvider)
    ..invalidate(archiveFoldersControllerProvider);
}
