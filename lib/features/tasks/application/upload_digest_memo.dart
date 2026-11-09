import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_writes.dart';
import 'tasks_providers.dart';

/// Görev ayrıntısı yüklemesinin son özeti. Sonucu bilinmeyen yüklemenin aynı taslakla yeniden
/// gönderimi ("yeniden dene") saklı niyeti özetiyle kullanır, dosyayı yeniden okumaz; yeniden
/// seçim yeni bir [UploadSource] nesnesidir, özet yeniden hesaplanır ve imza karşılaştırılır.
final class UploadDigestMemo {
  (UploadSource, String)? _last;

  /// [file]'ın özeti: aynı seçim (aynı nesne) için saklı değer; değilse [uploadDigesterProvider]
  /// okur. [ref] kapanınca (denetleyici atıldı) okuma durur, null döner ve saklanmaz.
  /// Okunamayan dosya `client.file_unreadable` fırlatır.
  Future<String?> of(Ref ref, UploadSource file) async {
    final last = _last;
    if (last != null && identical(last.$1, file)) return last.$2;
    final value = await ref.read(uploadDigesterProvider)(
      file.path,
      cancelled: () => !ref.mounted,
    );
    if (value != null) _last = (file, value);
    return value;
  }
}
