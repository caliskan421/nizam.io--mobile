import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/expected_failure.dart';
import 'archive_folder_sources.dart';
import 'archive_providers.dart';

/// Önizleme bellekte tutulur ve ekran kapandığında bırakılır.
const archiveImagePreviewLimit = 10 * 1024 * 1024;

final archiveImagePreviewProvider = FutureProvider.autoDispose
    .family<Uint8List, ({String folder, String file})>((ref, key) async {
      ref.watch(sessionGenerationProvider);
      ref.watch(scopeStateProvider);
      final folder = await ref.watch(
        archiveFolderContextProvider(key.folder).future,
      );
      if (folder == null) throw ApiError('records.not_authorized');
      final stream = await ref
          .read(archiveRepositoryProvider)
          .downloadFile(key.file, department: folder.department);
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in stream) {
        if (!ref.mounted) throw StateError('preview disposed');
        if (bytes.length + chunk.length > archiveImagePreviewLimit) {
          throw const ArchiveImageTooLarge();
        }
        bytes.add(chunk);
      }
      return bytes.takeBytes();
    });

class ArchiveImageTooLarge implements Exception, ExpectedFailure {
  const ArchiveImageTooLarge();
}
