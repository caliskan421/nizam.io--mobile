import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_card.dart';
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
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    final repo = ref.read(archiveRepositoryProvider);
    final sink = ref.read(downloadSinkProvider);
    try {
      final stream = await repo.downloadFile(file.id, department: department);
      if (!mounted ||
          scope != ref.read(scopeStateProvider) ||
          session != ref.read(sessionGenerationProvider)) {
        return;
      }
      await sink.save(file.displayName, stream);
      if (mounted &&
          scope == ref.read(scopeStateProvider) &&
          session == ref.read(sessionGenerationProvider)) {
        NzToast.success(context, context.l10n.uiArchiveSaved);
      }
    } on Object catch (e, st) {
      // Rapor, bağlam korumasından ÖNCE.
      final api = toReportedApiError(e, st, source: ReportSource.archive);
      if (mounted) NzToast.error(context, api);
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
        if (data.files.items.isEmpty)
          Text(l.uiArchiveEmptyFiles, style: context.text.caption),
        if (data.files.items.isNotEmpty)
          NzCard.outlined(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < data.files.items.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: NizamioSize.borderWidth,
                      thickness: NizamioSize.borderWidth,
                      indent: NizamioSpacing.space4,
                      color: context.colors.border,
                    ),
                  _fileRow(
                    context,
                    data.files.items[i],
                    data.department,
                    catalog,
                  ),
                ],
              ],
            ),
          ),
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

  Widget _fileRow(
    BuildContext context,
    RecordFile file,
    String department,
    TaskCatalog? catalog,
  ) {
    final task = catalog?.task(file.workItemId);
    final dot = file.displayName.lastIndexOf('.');
    final extension = dot < 0 ? '' : file.displayName.substring(dot + 1);
    final kind = file.contentType == 'application/pdf'
        ? 'PDF'
        : extension.isNotEmpty && extension.length <= 5
        ? extension.toUpperCase()
        : 'FILE';
    final meta = task == null
        ? '${file.sizeMb.toStringAsFixed(1)} MB'
        : task.title;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => context.appNav.openTask(file.workItemId),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 62),
          child: Padding(
            padding: const EdgeInsets.only(
              left: NizamioSpacing.space4,
              right: NizamioSpacing.space2,
              top: NizamioSpacing.space2,
              bottom: NizamioSpacing.space2,
            ),
            child: Row(
              children: [
                Container(
                  width: NizamioSpacing.space10,
                  height: NizamioSpacing.space10,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(NizamioSpacing.space3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    kind,
                    style: context.text.monoSm.copyWith(
                      fontSize: 10.5,
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.mono.copyWith(
                          fontSize: 12.5,
                          height: 17 / 12.5,
                        ),
                      ),
                      const Gap(NizamioSpacing.space1 / 2),
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.caption.copyWith(
                          fontSize: 12.5,
                          height: 17 / 12.5,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                NzIconButton(
                  icon: NzIcons.download,
                  semanticLabel: context.l10n.uiArchiveDownload,
                  onPressed: _downloading
                      ? null
                      : () => _download(file, department),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
