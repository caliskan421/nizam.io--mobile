import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_text.dart';
import '../../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../tasks/tasks.dart';
import '../../application/archive_actions_controller.dart';
import '../../application/archive_folder_controller.dart';
import '../../application/archive_folder_sources.dart';
import '../../application/archive_folders_controller.dart';
import 'archive_outcome.dart';
import 'archive_texts.dart';

/// Klasörden dosya yükleme: görev bağlamı seçili görevdir; seçili görev yoksa klasörün dosyalı
/// görevlerinden biri seçtirilir (görev yoksa bilgi). Ardından etiket (sunucunun kapalı
/// kümesi) ve görev ayrıntısıyla aynı kaynak (Fotoğraflar / Dosyalar) seçilip sistem seçicisi
/// açılır. Sonucu bilinmeyen yüklemede bildirim "Yeniden dene" eylemi taşır.
void startArchiveUpload(BuildContext context, WidgetRef ref, String code) {
  final l = context.l10n;
  final ctrl = ref.read(archiveActionsControllerProvider(code).notifier);
  if (ctrl.uploadStart == ArchiveUploadStart.noPicker) {
    NzToast.show(context, l.uiArchivePickerMissing);
    return;
  }
  final task = ref.read(archiveFolderControllerProvider(code)).task;
  if (task != null) {
    _pickTag(context, ctrl, task);
    return;
  }
  final tasks = ref.read(archiveFolderTasksProvider(code)).value ?? const [];
  if (tasks.isEmpty) {
    NzToast.show(context, l.uiArchiveUploadNoTask);
    return;
  }
  NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiArchivePickTask,
    entries: [
      NzFlyoutSection(l.uiArchivePickTask),
      for (final t in tasks)
        NzFlyoutItem(
          label: t.title,
          icon: NzIcons.folder,
          onSelected: () => _pickTag(context, ctrl, t.workItemId),
        ),
    ],
  );
}

/// Arşiv kökünden yükleme: önce görev seçilir (klasörü arşivde olan görevler; aranabilir
/// liste), sonra etiket ve kaynak; dosya `/v1/work-items/{id}/files` ile görevin klasörüne
/// yüklenir. Görevin klasörü koordinatörlüğüdür; üyede tek sanal klasördür ("Görevlerim").
Future<void> startArchiveRootUpload(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final folders = ref.read(archiveFoldersControllerProvider).value ?? const [];
  final catalog = ref.read(taskCatalogControllerProvider).value;
  final virtual = folders.where((f) => f.isVirtual).firstOrNull?.code;
  String? folderOf(TaskItem t) =>
      folders.any((f) => !f.isVirtual && f.code == t.departmentId)
      ? t.departmentId
      : virtual;
  final tasks = [
    for (final t in catalog?.tasks ?? const <TaskItem>[])
      if (folderOf(t) != null) t,
  ];
  if (tasks.isEmpty) {
    NzToast.show(context, l.uiArchiveUploadNoTask);
    return;
  }
  final task = await showTaskPickerSheet(
    context,
    title: l.uiArchivePickTask,
    description: l.uiArchiveUploadTaskDesc,
    tasks: tasks,
    subtitle: (t) => catalog?.coordinatorship(t.coordinatorship)?.name,
  );
  final code = task == null ? null : folderOf(task);
  if (task == null || code == null || !context.mounted) return;
  // Klasör eylem denetleyicisi (autoDispose) yükleme boyunca canlı kalsın; abonelik
  // sayfa kapanınca düşer.
  ref.listenManual(archiveActionsControllerProvider(code), (_, _) {});
  final ctrl = ref.read(archiveActionsControllerProvider(code).notifier);
  if (ctrl.uploadStart == ArchiveUploadStart.noPicker) {
    NzToast.show(context, l.uiArchivePickerMissing);
    return;
  }
  _pickTag(context, ctrl, task.id);
}

void _pickTag(
  BuildContext context,
  ArchiveActionsController ctrl,
  String workItemId,
) {
  final l = context.l10n;
  final c = context.colors;
  NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiArchivePickTag,
    entries: [
      NzFlyoutSection(l.uiArchivePickTag),
      for (final tag in archiveTags)
        NzFlyoutItem(
          label: l.tagLabel(tag),
          dot: c.tag(tag),
          onSelected: () async {
            final origin = await showUploadOriginSheet(context);
            if (origin == null || !context.mounted) return;
            final r = await ctrl.upload(
              workItemId: workItemId,
              tag: tag,
              origin: origin,
            );
            if (context.mounted) _showUploadOutcome(context, ctrl, r);
          },
        ),
    ],
  );
}

/// Yükleme sonucunu bildirir. Sonuç bilinmiyorsa "Yeniden dene" eylemi seçiciyi açmadan aynı
/// niyeti aynı işlem anahtarıyla gönderir (istemci akışları §8).
void _showUploadOutcome(
  BuildContext context,
  ArchiveActionsController ctrl,
  ArchiveOutcome r,
) {
  final l = context.l10n;
  final error = r.error;
  if (error?.code != ClientErrorCode.outcomeUnknown || !ctrl.hasPendingUpload) {
    showArchiveOutcome(context, r, success: l.uiArchiveUploaded);
    return;
  }
  NzToast.show(
    context,
    errorText(l, error!),
    tone: NzToastTone.danger,
    actionLabel: l.uiCommonRetry,
    onAction: () async {
      final again = await ctrl.retryUpload();
      if (context.mounted) _showUploadOutcome(context, ctrl, again);
    },
  );
}
