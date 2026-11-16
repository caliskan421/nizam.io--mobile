import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache_owner.dart';
import '../../../core/telemetry/expected_failure.dart';
import 'messages_providers.dart';

/// Sohbette küçük resmi gösterilecek fotoğrafın üst sınırı; büyüğü dosya kartıyla gösterilir.
const chatThumbLimit = 8 * 1024 * 1024;

/// Fotoğraf ekinin baytları (`downloadChatAttachment`; not 32). Balon kaydırma dışına çıkınca
/// iki dakika daha bellekte kalır (geri kaydırmada yeniden indirilmez), sonra bırakılır.
final chatAttachmentThumbProvider = FutureProvider.autoDispose
    .family<Uint8List, String>((ref, attachmentId) async {
      CacheOwnership().watch(ref);
      final link = ref.keepAlive();
      Timer? release;
      ref
        ..onCancel(() {
          release = Timer(const Duration(minutes: 2), link.close);
        })
        ..onResume(() => release?.cancel())
        ..onDispose(() => release?.cancel());
      final stream = await ref
          .read(chatRepositoryProvider)
          .downloadAttachment(attachmentId);
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in stream) {
        if (!ref.mounted) throw StateError('thumb disposed');
        if (bytes.length + chunk.length > chatThumbLimit) {
          throw const ChatThumbTooLarge();
        }
        bytes.add(chunk);
      }
      return bytes.takeBytes();
    });

/// Fotoğraf sınırı aştı: dosya kartına düşülür (beklenen durum, raporlanmaz).
class ChatThumbTooLarge implements Exception, ExpectedFailure {
  const ChatThumbTooLarge();
}
