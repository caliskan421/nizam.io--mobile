import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/archive_folder_controller.dart';
import '../../domain/archive.dart';
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

/// Dosya önizleme alt sayfası: sıra (n / N) + önceki/sonraki, önizleme alanı, ad + tür/boyut,
/// bilgi satırları (görev, etiket, yükleyen, tarih), İndir + etiket / taşı / sil. Liste
/// klasörün güncel süzgecidir; silme dosyayı kaldırır ve sayfayı kapatır.
Future<void> showArchivePreview(
  BuildContext context, {
  required String code,
  required List<ArchiveFile> all,
  required String fileId,
}) {
  final l = context.l10n;
  void toast(String m) => NzToast.show(context, m);
  return NzBottomSheet.show<void>(
    context,
    title: l.uiArchivePreview,
    showHeader: false,
    builder: (_) =>
        _Preview(code: code, all: all, initial: fileId, onToast: toast),
  );
}

class _Preview extends ConsumerStatefulWidget {
  const _Preview({
    required this.code,
    required this.all,
    required this.initial,
    required this.onToast,
  });

  final String code;
  final List<ArchiveFile> all;
  final String initial;
  final ValueChanged<String> onToast;

  @override
  ConsumerState<_Preview> createState() => _PreviewState();
}

class _PreviewState extends ConsumerState<_Preview> {
  late String _id = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = ref.watch(archiveFolderControllerProvider(widget.code));
    final list = view.visible(widget.all);
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
          child: Icon(icon, size: NizamioSize.iconSizeSm, color: c.text),
        ),
      ),
    );
    final facts = <(String, String, Color?)>[
      (l.uiArchiveFactTask, l.short(f.taskTitle), null),
      (l.uiArchiveFactTag, l.tagLabel(f.tag), c.tag(f.tag)),
      (l.uiArchiveFactBy, f.uploadedBy ?? l.uiArchiveUploaderUnknown, null),
      (l.uiArchiveFactDate, l.uploadedAt(f.uploadedAt), null),
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
            round(Icons.chevron_left_rounded, l.uiArchivePrev, () => go(-1)),
            round(Icons.chevron_right_rounded, l.uiArchiveNext, () => go(1)),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        Semantics(
          image: true,
          label: l.uiArchivePreviewArea,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceRaised,
                borderRadius: BorderRadius.circular(NizamioRadius.group),
                border: Border.all(color: c.border),
              ),
              child: Center(
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
        const Gap(NizamioSpacing.space3),
        Text(f.name, style: t.mono),
        const Gap(NizamioSpacing.space1),
        Text(
          '${l.kindLabel(f.kind)} · ${l.size(f.sizeMb, minKb: 12)}',
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
                  Container(
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
                            ],
                          ),
                        ),
                      ],
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
                icon: Icons.download_rounded,
                expand: true,
                onPressed: () =>
                    widget.onToast('${f.name} ${l.uiArchiveDownloading}'),
              ),
            ),
            const Gap(NizamioSpacing.space1),
            NzIconButton.circle(
              icon: Icons.sell_outlined,
              semanticLabel: l.uiArchiveRetag,
              onPressed: () => widget.onToast(l.uiArchiveRetagSoon),
            ),
            NzIconButton.circle(
              icon: Icons.drive_file_move_outline,
              semanticLabel: l.uiArchiveMove,
              onPressed: () => widget.onToast(l.uiArchiveMoveSoon),
            ),
            NzIconButton.circle(
              icon: Icons.delete_outline_rounded,
              semanticLabel: l.uiArchiveDelete,
              onPressed: () {
                ref
                    .read(archiveFolderControllerProvider(widget.code).notifier)
                    .remove(f.id);
                Navigator.of(context).pop();
                widget.onToast(l.uiArchiveDeleted);
              },
            ),
          ],
        ),
      ],
    );
  }
}
