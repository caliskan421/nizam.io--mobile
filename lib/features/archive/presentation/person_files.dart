import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../tasks/tasks.dart';
import '../application/archive_providers.dart';
import '../application/person_files_controller.dart';
import '../domain/records.dart';

/// Hesabın yüklediği, oturumun seçili programda okuyabildiği dosyalar. Kendi kaydırmasını
/// açmaz; profil akışına yerleştirilir. Daha fazla imleci bitene dek korunur.
class PersonFiles extends ConsumerStatefulWidget {
  const PersonFiles({super.key, required this.accountId});
  final String accountId;
  @override
  ConsumerState<PersonFiles> createState() => _PersonFilesState();
}

class _PersonFilesState extends ConsumerState<PersonFiles> {
  bool _downloading = false;

  Future<void> _download(RecordFile file, String department) async {
    if (_downloading) return;
    setState(() => _downloading = true);
    final repo = ref.read(archiveRepositoryProvider);
    final sink = ref.read(downloadSinkProvider);
    try {
      final stream = await repo.downloadFile(file.id, department: department);
      await sink.save(file.displayName, stream);
      if (mounted) NzToast.success(context, context.l10n.uiArchiveSaved);
    } on Object catch (e) {
      if (mounted) NzToast.error(context, toApiError(e));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = personFilesControllerProvider(widget.accountId);
    ref.watch(provider);
    final value = ref.read(provider.notifier).visible;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final l = context.l10n;
    // Yeniden hesaplanan kapsamın önceki dosyaları gösterilmez.
    if (value.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final data = value.value;
    if (data == null) {
      return Column(
        children: [
          Text(errorText(l, toApiError(value.error!))),
          NzButton.secondary(
            label: l.uiCommonRetry,
            onPressed: () {
              ref.invalidate(archiveScopeProvider);
              ref.invalidate(provider);
            },
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space2,
      children: [
        if (data.files.items.isEmpty) Text(l.uiArchiveEmptyFiles),
        for (final file in data.files.items) ...[
          NzListTile(
            title: file.displayName,
            subtitle: catalog?.task(file.workItemId)?.title,
            leading: const NzIcon(NzIcons.file),
            onTap: () => context.appNav.openTask(file.workItemId),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: NzButton.ghost(
              label: l.uiArchiveDownload,
              loading: _downloading,
              onPressed: () => _download(file, data.department),
            ),
          ),
        ],
        if (data.error != null) Text(errorText(l, data.error!)),
        if (data.files.hasMore)
          NzButton.secondary(
            label: l.uiArchiveLoadMore,
            loading: data.loadingMore,
            onPressed: () => ref.read(provider.notifier).loadMore(),
          ),
      ],
    );
  }
}
