import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/archive_actions_controller.dart';
import '../../application/archive_files_controller.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';
import 'archive_document_view.dart';
import 'archive_fullscreen_preview.dart';
import 'archive_outcome.dart';
import 'archive_texts.dart';

/// Dosya türü kutusu (44 px, `bg-overlay`, mono "IMG/DOC/PDF").
class ArchiveKindTile extends StatelessWidget {
  const ArchiveKindTile({super.key, required this.kind});

  final ArchiveFileKind kind;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: Container(
        width: NizamioSize.tap,
        height: NizamioSize.tap,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.surfaceOverlay,
          borderRadius: BorderRadius.circular(NizamioRadius.folder),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            context.l10n.kindShort(kind),
            style: context.text.monoSm.copyWith(color: c.textMuted),
          ),
        ),
      ),
    );
  }
}

/// Dosya önizleme alt sayfası: sıra (n / N) + önceki/sonraki, tür alanı (yana kaydırınca
/// önceki/sonraki dosya, dokununca tam ekran ve yakınlaştırma), ad + tür/boyut, bilgi satırları
/// (görev satırı görevi açar; etiket satırı yetkiliye etiket seçici açar — `retagFile`, yönetici,
/// görevin koordinatörü ya da yükleyen), İndir + taşı (yakında) / sil (yalnız yükleyene). Liste
/// klasörün yüklenmiş, süzgeçten geçmiş dosyalarıdır; silme sunucuda yapılır ve sayfayı kapatır. Sunucu yükleme zamanı vermez (tarih satırı yok).
Future<void> showArchivePreview(
  BuildContext context, {
  required String code,
  required String? Function(String workItemId) taskTitle,
  required String fileId,
  RecordFile? initialFile,
}) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiArchivePreview,
    showHeader: false,
    builder: (_) => _Preview(
      code: code,
      taskTitle: taskTitle,
      initial: fileId,
      initialFile: initialFile,
      host: context,
    ),
  );
}

class _Preview extends ConsumerStatefulWidget {
  const _Preview({
    required this.code,
    required this.taskTitle,
    required this.initial,
    this.initialFile,
    required this.host,
  });

  final String code;
  final String? Function(String workItemId) taskTitle;
  final String initial;
  final RecordFile? initialFile;

  /// Bildirimlerin gösterildiği sayfa bağlamı (alt sayfa kapandıktan sonra da geçerli).
  final BuildContext host;

  @override
  ConsumerState<_Preview> createState() => _PreviewState();
}

class _PreviewState extends ConsumerState<_Preview> {
  late String _id = widget.initial;

  ArchiveActionsController get _ctrl =>
      ref.read(archiveActionsControllerProvider(widget.code).notifier);

  void _toast(String m) {
    if (widget.host.mounted) NzToast.show(widget.host, m);
  }

  Future<void> _download(RecordFile f) async {
    final l = context.l10n;
    _toast('${f.displayName} ${l.uiArchiveDownloading}');
    final r = await _ctrl.downloadFile(f);
    if (widget.host.mounted) showArchiveOutcome(widget.host, r);
  }

  /// Etiket seçici (kapalı küme); seçim sunucuda değişir, listeler yeniden okunur.
  void _retag(RecordFile f) {
    final l = context.l10n;
    final c = context.colors;
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiArchiveRetag,
      entries: [
        NzFlyoutSection(l.uiArchiveRetag),
        for (final tag in archiveTags)
          NzFlyoutItem(
            label: l.tagLabel(tag),
            dot: c.tag(tag),
            onSelected: () async {
              final r = await _ctrl.retagFile(f, tag);
              if (widget.host.mounted) {
                showArchiveOutcome(
                  widget.host,
                  r,
                  success: l.uiArchiveRetagged,
                );
              }
            },
          ),
      ],
    );
  }

  /// Yana kaydırmanın dosya değiştirdiği en düşük hız (px/sn).
  static const _swipeVelocity = 250.0;

  Future<void> _fullscreen(List<RecordFile> list, RecordFile f) async {
    final last = await showArchiveFullscreen(
      context,
      folder: widget.code,
      files: list,
      initial: f.id,
    );
    if (last != null && mounted) setState(() => _id = last);
  }

  Future<void> _delete(RecordFile f) async {
    final l = context.l10n;
    final ok = await NzDialog.confirm(
      context,
      title: l.uiArchiveDelete,
      message: '${f.displayName} · ${l.uiArchiveDeleteConfirm}',
      confirmLabel: l.uiArchiveDeleteOk,
      tone: NzDialogTone.destructive,
    );
    if (!ok || !mounted) return;
    final r = await _ctrl.deleteFile(f);
    if (r.ok && mounted) Navigator.of(context).pop();
    if (widget.host.mounted) {
      showArchiveOutcome(widget.host, r, success: l.uiArchiveDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final loaded =
        ref.watch(archiveFilesControllerProvider(widget.code)).value?.items ??
        const <RecordFile>[];
    final initial = widget.initialFile;
    final list = initial != null && !loaded.any((f) => f.id == initial.id)
        ? [initial, ...loaded]
        : loaded;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final i = list.indexWhere((f) => f.id == _id);
    if (i < 0) return const SizedBox.shrink();
    final f = list[i];
    void go(int d) =>
        setState(() => _id = list[(i + d + list.length) % list.length].id);
    Widget round(IconData icon, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: c.surfaceOverlay,
            shape: BoxShape.circle,
          ),
          child: NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.text),
        ),
      ),
    );
    final uploader = f.uploaderId;
    final title = widget.taskTitle(f.workItemId);
    final task = catalog?.task(f.workItemId);
    void openTask() {
      final code = task?.code;
      if (code == null) return;
      Navigator.of(context).pop();
      if (widget.host.mounted) widget.host.appNav.openTask(code);
    }

    final mine = uploader != null && uploader == catalog?.me;
    // Etkin görünümle (temel yüzey §1): Üye görünümündeki yönetici yönetici eylemi görmez.
    final perms = task == null
        ? null
        : catalog.permissionsIn(ref.watch(scopeStateProvider), task);
    final canRetag =
        mine || (perms?.admin ?? false) || (perms?.coordinator ?? false);
    final facts = <(String, String, Color?, VoidCallback?)>[
      if (title != null)
        (
          l.uiArchiveFactTask,
          l.short(title),
          null,
          task == null ? null : openTask,
        ),
      (
        l.uiArchiveFactTag,
        l.tagLabel(f.tag),
        c.tag(f.tag),
        canRetag ? () => _retag(f) : null,
      ),
      (
        l.uiArchiveFactBy,
        (uploader == null ? null : catalog?.nameOf(uploader)) ??
            l.uiArchiveUploaderUnknown,
        null,
        null,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${i + 1} / ${list.length}',
                style: t.monoSm.copyWith(color: c.textFaint),
              ),
            ),
            round(NzIcons.chevronLeft, l.uiArchivePrev, () => go(-1)),
            round(NzIcons.chevronRight, l.uiArchiveNext, () => go(1)),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        Semantics(
          image: true,
          label: l.uiArchivePreviewArea,
          onTapHint: l.uiArchiveFullscreen,
          child: GestureDetector(
            onTap: () => _fullscreen(list, f),
            onHorizontalDragEnd: list.length < 2
                ? null
                : (d) {
                    final v = d.primaryVelocity ?? 0;
                    if (v.abs() > _swipeVelocity) go(v < 0 ? 1 : -1);
                  },
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.surfaceRaised,
                  borderRadius: BorderRadius.circular(NizamioRadius.group),
                  border: Border.all(color: c.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(NizamioRadius.group),
                  child:
                      f.kind == ArchiveFileKind.image ||
                          f.kind == ArchiveFileKind.pdf
                      ? ArchiveDocumentView(folder: widget.code, file: f)
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: c.surface,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l.kindShort(f.kind),
                              style: t.monoSm.copyWith(color: c.textMuted),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space3),
        Text(f.displayName, style: t.mono),
        const Gap(NizamioSpacing.space1),
        Text(
          '${l.kindLabel(f.kind)} · ${l.size(f.sizeBytes)}',
          style: t.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space3),
        ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.row),
          child: ColoredBox(
            color: c.surfaceRaised,
            child: Column(
              children: [
                for (var k = 0; k < facts.length; k++)
                  InkWell(
                    onTap: facts[k].$4,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: NizamioSize.tap,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: k > 0
                            ? Border(top: BorderSide(color: c.border))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            facts[k].$1,
                            style: t.bodyMd.copyWith(color: c.textMuted),
                          ),
                          const Gap(NizamioSpacing.space3),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (facts[k].$3 case final dot?) ...[
                                  NzDot(color: dot, size: 7),
                                  const Gap(6),
                                ],
                                Flexible(
                                  child: Text(
                                    facts[k].$2,
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyMd,
                                  ),
                                ),
                                if (facts[k].$4 != null) ...[
                                  const Gap(NizamioSpacing.space1),
                                  NzIcon(
                                    NzIcons.chevronRight,
                                    size: NizamioSize.iconSizeSm,
                                    color: c.textMuted,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Gap(NizamioSpacing.space4),
        Row(
          children: [
            Expanded(
              child: NzButton.primary(
                label: l.uiArchiveDownload,
                icon: NzIcons.download,
                expand: true,
                onPressed: () => _download(f),
              ),
            ),
            const Gap(NizamioSpacing.space1),
            NzIconButton.circle(
              icon: NzIcons.folderMove,
              semanticLabel: l.uiArchiveMove,
              onPressed: () => _toast(l.uiArchiveMoveSoon),
            ),
            // Silme yalnız yükleyene açıktır (RECORDS-K10); diğerlerinde düğme yok.
            if (mine)
              NzIconButton.circle(
                icon: NzIcons.delete,
                semanticLabel: l.uiArchiveDelete,
                onPressed: () => _delete(f),
              ),
          ],
        ),
      ],
    );
  }
}
