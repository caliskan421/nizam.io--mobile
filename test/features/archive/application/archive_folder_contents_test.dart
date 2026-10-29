// archiveFolderContents: klasör + görev klasörleri + dosyalar bir kez türetilir; kaynak yoksa null.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/application/archive_folder_contents.dart';
import 'package:nizamio/features/archive/application/archive_folders_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

void main() {
  test(
    'kaynaklar hazır: OPE 78 dosya; aynı örnek yeniden kullanılır',
    () async {
      final h = await pilotHarness(PilotBackend());
      final p = archiveFolderContentsProvider('OPE');
      h.container.listen(p, (_, _) {});
      expect(h.container.read(p), isNull, reason: 'kaynaklar yükleniyor');
      await h.container.read(archiveFoldersControllerProvider.future);
      await h.container.read(taskCatalogControllerProvider.future);
      final a = h.container.read(p);
      expect(a?.folder.code, 'OPE');
      expect(a?.files, hasLength(78));
      expect(a?.groups, isNotEmpty);
      expect(identical(h.container.read(p), a), isTrue, reason: 'önbellek');
    },
  );
}
