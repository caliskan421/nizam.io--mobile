import 'dart:io';

import 'package:crypto/crypto.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';

/// [path] dosyasının içerik özeti (SHA-256, küçük harf onaltılık; `UploadDigest` portunun
/// gerçekleştirmesi). Görev ve arşiv yükleme gönderiminde, boyut/tür ön denetimi geçtikten
/// SONRA çağrılır (sınır dışı dosya hiç okunmaz); sohbet eki özet hesaplamaz. Dosya akışla
/// okunur (belleğe toplanmaz). Yükleme niyeti imzasında ad/boyutla birlikte kullanılır: aynı ad
/// ve boyutta farklı içerik ayrı niyettir, aynı içerik farklı geçici yoldan aynı niyettir
/// (istemci akışları §8; sunucu yükleme tekrarını gövde okumadan metadata'dan tanır).
///
/// [cancelled] her parçadan önce sorulur: true → okuma akışı iptal edilir, null döner
/// (denetleyici kapandı). Okunamayan dosya (silinmiş, erişilemiyor) `client.file_unreadable`.
/// ADR-0002: `crypto` YALNIZ bu dosyada (sınır kuralı F2).
Future<String?> uploadDigest(
  String path, {
  required bool Function() cancelled,
}) async {
  final out = _Last();
  final input = sha256.startChunkedConversion(out);
  try {
    // `await for`'dan erken çıkış aboneliği iptal eder (dosya kapanır).
    await for (final chunk in File(path).openRead()) {
      if (cancelled()) return null;
      input.add(chunk);
    }
  } on FileSystemException {
    throw ApiError(ClientErrorCode.fileUnreadable);
  }
  if (cancelled()) return null;
  input.close();
  return out.value!.toString();
}

/// Özet çıkışı (tek değer).
final class _Last implements Sink<Digest> {
  Digest? value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}
