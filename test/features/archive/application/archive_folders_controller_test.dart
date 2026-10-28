// ArchiveFoldersController: bileşim kökündeki örnek kaynaktan 11 klasör; alt menü alt yazısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/application/archive_folders_controller.dart';
import 'package:nizamio/features/archive/archive.dart';

import '../../pilot_support.dart';

void main() {
  test('örnek: 11 klasör, 227 dosya; alt yazı "227 dosya"', () async {
    final h = await pilotHarness(PilotBackend());
    h.container.listen(archiveNavCaptionProvider, (_, _) {});
    expect(h.container.read(archiveNavCaptionProvider), isNull);
    final folders = await h.container.read(
      archiveFoldersControllerProvider.future,
    );
    expect(folders, hasLength(11));
    expect(folders.fold<int>(0, (t, f) => t + f.files), 227);
    expect(
      folders.fold<double>(0, (t, f) => t + f.sizeMb).toStringAsFixed(1),
      '559.3',
    );
    expect(h.container.read(archiveNavCaptionProvider), '227 dosya');
  });
}
