import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_page.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';
import 'archive_document_view.dart';
import 'archive_texts.dart';

/// Dosyaları tam ekranda açar: yana kaydırarak (ve önceki/sonraki düğmeleriyle) dosyalar
/// arasında geçilir; görsel iki parmakla ya da çift dokunuşla yakınlaştırılır (yakınken sayfa
/// kaydırması kapanır, görsel içinde gezinilir), PDF kendi görüntüleyicisinde yakınlaşır.
/// Kapanınca son görülen dosyanın kimliği döner.
Future<String?> showArchiveFullscreen(
  BuildContext context, {
  required String folder,
  required List<RecordFile> files,
  required String initial,
}) => Navigator.of(context, rootNavigator: true).push<String>(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => _Fullscreen(folder: folder, files: files, initial: initial),
  ),
);

class _Fullscreen extends StatefulWidget {
  const _Fullscreen({
    required this.folder,
    required this.files,
    required this.initial,
  });

  final String folder;
  final List<RecordFile> files;
  final String initial;

  @override
  State<_Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<_Fullscreen> {
  late int _index = widget.files
      .indexWhere((f) => f.id == widget.initial)
      .clamp(0, widget.files.length - 1);
  late final _pages = PageController(initialPage: _index);
  final _transform = TransformationController();
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transform.addListener(() {
      final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
      if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
    });
  }

  @override
  void dispose() {
    _pages.dispose();
    _transform.dispose();
    super.dispose();
  }

  void _go(int d) {
    final n = widget.files.length;
    _pages.jumpToPage((_index + d + n) % n);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final f = widget.files[_index];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(f.id);
      },
      child: NzPage.bare(
        animateContent: false,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.space2,
                  vertical: NizamioSpacing.space1,
                ),
                child: Row(
                  children: [
                    NzIconButton.circle(
                      icon: NzIcons.close,
                      semanticLabel: l.uiCommonClose,
                      onPressed: () => Navigator.of(context).pop(f.id),
                    ),
                    const Gap(NizamioSpacing.space2),
                    Expanded(
                      child: Text(
                        f.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.mono,
                      ),
                    ),
                    if (widget.files.length > 1) ...[
                      Text(
                        '${_index + 1} / ${widget.files.length}',
                        style: t.monoSm.copyWith(color: c.textFaint),
                      ),
                      const Gap(NizamioSpacing.space2),
                      NzIconButton.circle(
                        icon: NzIcons.chevronLeft,
                        semanticLabel: l.uiArchivePrev,
                        onPressed: () => _go(-1),
                      ),
                      NzIconButton.circle(
                        icon: NzIcons.chevronRight,
                        semanticLabel: l.uiArchiveNext,
                        onPressed: () => _go(1),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  physics: _zoomed
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  itemCount: widget.files.length,
                  onPageChanged: (i) {
                    _transform.value = Matrix4.identity();
                    setState(() => _index = i);
                  },
                  itemBuilder: (context, i) {
                    final file = widget.files[i];
                    return switch (file.kind) {
                      ArchiveFileKind.image ||
                      ArchiveFileKind.pdf => ArchiveDocumentView(
                        folder: widget.folder,
                        file: file,
                        interactive: true,
                        transform: i == _index ? _transform : null,
                      ),
                      ArchiveFileKind.document => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l.kindShort(file.kind),
                              style: t.monoSm.copyWith(color: c.textMuted),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                NizamioSpacing.space4,
                              ),
                              child: Text(
                                '${l.kindLabel(file.kind)} · ${l.size(file.sizeBytes)}',
                                style: t.caption.copyWith(color: c.textMuted),
                              ),
                            ),
                            NzButton.secondary(
                              label: l.uiCommonClose,
                              onPressed: () =>
                                  Navigator.of(context).pop(file.id),
                            ),
                          ],
                        ),
                      ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
