part of 'detail_actions.dart';

/// Yükleme kaynağı seçimi: Fotoğraflar (galeri) / Dosyalar. Görev ayrıntısı ve arşiv
/// yüklemesi aynı alt sayfayı kullanır (tasks açık yüzü). Vazgeçme → null.
Future<UploadOrigin?> showUploadOriginSheet(BuildContext context) {
  final l = context.l10n;
  return NzBottomSheet.show<UploadOrigin>(
    context,
    title: l.uiTasksPickFileAction,
    compact: true,
    builder: (sheet) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (o, label, icon) in [
          (UploadOrigin.photos, l.uiTasksPickPhotos, NzIcons.image),
          (UploadOrigin.files, l.uiTasksPickFiles, NzIcons.folder),
        ])
          _ListOption(
            label: label,
            leading: NzIcon(icon, size: NizamioSize.iconSizeSm),
            onTap: () => Navigator.of(sheet).pop(o),
          ),
      ],
    ),
  );
}
