part of 'detail_actions.dart';

/// Yükleme kaynağı seçimi: Fotoğraflar (galeri) / Kamera / Dosyalar. Görev ayrıntısı (kanıt) ve
/// arşiv yüklemesi aynı kısayol menüsünü kullanır (tasks açık yüzü). Vazgeçme → null.
Future<UploadOrigin?> showUploadOriginSheet(BuildContext context) async {
  final l = context.l10n;
  UploadOrigin? selected;
  await NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiTasksPickFileAction,
    entries: [
      for (final (o, label, icon) in [
        (UploadOrigin.photos, l.uiTasksPickPhotos, NzIcons.image),
        (UploadOrigin.camera, l.uiTasksPickCamera, NzIcons.camera),
        (UploadOrigin.files, l.uiTasksPickFiles, NzIcons.folder),
      ])
        NzFlyoutItem(label: label, icon: icon, onSelected: () => selected = o),
    ],
  );
  return selected;
}
