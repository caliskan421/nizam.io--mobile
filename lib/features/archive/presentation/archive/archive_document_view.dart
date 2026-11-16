import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../application/archive_image_preview.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';

/// Görsel ya da PDF önizlemesi (içerik `archiveImagePreviewProvider`'dan; sınır üstü dosya
/// indirilmez). [interactive] false ise dokunuşlar alttaki görünüme geçer (alt sayfada kaydırma
/// ve tam ekran dokunuşu); tam ekranda görsel [InteractiveViewer] ile yakınlaştırılır, PDF
/// görüntüleyici kendi yakınlaştırmasını taşır. [transform] görsel yakınlaştırmasının durumu.
class ArchiveDocumentView extends ConsumerWidget {
  const ArchiveDocumentView({
    super.key,
    required this.folder,
    required this.file,
    this.interactive = false,
    this.transform,
  });
  final String folder;
  final RecordFile file;
  final bool interactive;
  final TransformationController? transform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pdf = file.kind == ArchiveFileKind.pdf;
    final tooLarge = pdf ? l.uiArchivePdfTooLarge : l.uiArchiveImageTooLarge;
    final failure = pdf
        ? l.uiArchivePdfPreviewError
        : l.uiArchiveImagePreviewError;
    if (file.sizeBytes > archiveImagePreviewLimit) {
      return Center(child: Text(tooLarge, textAlign: TextAlign.center));
    }
    final provider = archiveImagePreviewProvider((
      folder: folder,
      file: file.id,
    ));
    final value = ref.watch(provider);
    Widget error(String message) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (value.error is! ArchiveImageTooLarge)
            TextButton(
              onPressed: () => ref.invalidate(provider),
              child: Text(l.uiCommonRetry),
            ),
        ],
      ),
    );
    final view = value.when(
      loading: () => Center(
        child: Semantics(
          label: l.uiFeedbackLoading,
          child: const CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => error(e is ArchiveImageTooLarge ? tooLarge : failure),
      data: (bytes) => pdf
          ? PdfViewer.data(
              bytes,
              key: ValueKey('pdf:${file.id}'),
              sourceName: '$folder/${file.id}',
              maxSizeToCacheOnMemory: archiveImagePreviewLimit,
              params: PdfViewerParams(
                backgroundColor: context.colors.surfaceRaised,
                maxImageBytesCachedOnMemory: 24 * 1024 * 1024,
                errorBannerBuilder: (_, _, _, _) => error(failure),
              ),
            )
          : interactive
          ? InteractiveViewer(
              transformationController: transform,
              maxScale: 6,
              child: Center(
                child: Image.memory(
                  bytes,
                  fit: BoxFit.contain,
                  gaplessPlayback: false,
                  errorBuilder: (_, _, _) => error(failure),
                ),
              ),
            )
          : Image.memory(
              bytes,
              fit: BoxFit.contain,
              cacheWidth: 1600,
              gaplessPlayback: false,
              errorBuilder: (_, _, _) => error(failure),
            ),
    );
    return interactive || value.hasError ? view : IgnorePointer(child: view);
  }
}
