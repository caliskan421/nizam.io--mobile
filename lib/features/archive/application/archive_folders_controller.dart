import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive.dart';
import 'archive_providers.dart';

part 'archive_folders_controller.g.dart';

/// Arşiv klasörleri (koordinatörlük başına bir klasör). Yeniden yükleme yalnız dokunuşla.
@Riverpod(keepAlive: true)
class ArchiveFoldersController extends _$ArchiveFoldersController {
  @override
  Future<List<ArchiveFolder>> build() =>
      ref.read(archiveRepositoryProvider).loadFolders();
}
