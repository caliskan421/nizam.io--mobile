import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/task_writes.dart';

/// [UploadPicker]'ın sistem seçicisi gerçekleştirmesi (ADR-0002: `file_picker` ve
/// `image_picker` YALNIZ bu dosyada — sınır kuralları F1/F3). İnce sarmalayıcıdır, tek dosya:
/// - [UploadOrigin.files]: belge seçici, süzgeç izinli uzantılar ([uploadExtensions],
///   `FileType.custom`).
/// - [UploadOrigin.photos]: `FileType.image` — iOS'ta `PHPickerViewController` (kitaplık izni
///   istemez), `compatible` kipi HEIC'i JPEG'e çevirir; Android'de sistem görsel seçicisi
///   (izin yok). Ad [normalizeUploadName] ile izinli yazıma gelir (`IMG_1.JPEG` → `.jpg`);
///   küme dışı tür (HEIC/WEBP) denetleyicinin tür ön denetiminde açıkça reddedilir.
/// - [UploadOrigin.camera]: `image_picker` ile arka kamera, JPEG (kalite [_cameraQuality],
///   uzun kenar en çok [_cameraMaxSide]); ad [cameraUploadName]. iOS kamera izni sorar
///   (`NSCameraUsageDescription`); Android sistem kamera uygulamasını intent ile açar
///   (Manifest'te CAMERA izni YOK, bilinçli — ADR-0002).
/// Ağ yok; içerik OKUNMAZ (yalnız boyut): özet görev/arşiv gönderiminde, tür/boyut ön
/// denetiminden sonra hesaplanır ([UploadSource]; sohbet eki özet hesaplamaz). Yerel yolu
/// olmayan seçim (yalnız URI) yüklenemez → vazgeçilmiş sayılır. Seçici hatası
/// [uploadPickErrorCode] ile kullanıcıya gösterilecek koda iner.
class FileUploadPicker implements UploadPicker {
  const FileUploadPicker();

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    try {
      return await switch (origin) {
        UploadOrigin.camera => _capture(),
        UploadOrigin.files || UploadOrigin.photos => _pick(origin),
      };
    } on Exception catch (e) {
      throw ApiError(uploadPickErrorCode(e));
    }
  }

  Future<UploadSource?> _pick(UploadOrigin origin) async {
    final photos = origin == UploadOrigin.photos;
    final f = photos
        ? await FilePicker.pickFile(
            type: FileType.image,
            darwinOptions: const DarwinOptions(
              assetRepresentationMode: DarwinAssetRepresentationMode.compatible,
            ),
          )
        : await FilePicker.pickFile(
            type: FileType.custom,
            allowedExtensions: uploadExtensions,
          );
    final path = f?.path;
    if (f == null || path == null) return null;
    final size = f.lengthSync() ?? await f.length();
    if (size == null) return null;
    final name = photos ? normalizeUploadName(f.name) : f.name;
    return UploadSource(path: path, name: name, sizeBytes: size);
  }

  static const _cameraQuality = 85;
  static const _cameraMaxSide = 2560.0;

  /// Kamerayla çekim; kullanıcı kamerayı kapatırsa null (vazgeçildi). iOS'ta cihazda kamera
  /// yoksa (simülatör) eklenti kendi uyarısını gösterip null döner.
  Future<UploadSource?> _capture() async {
    final f = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: _cameraQuality,
      maxWidth: _cameraMaxSide,
      maxHeight: _cameraMaxSide,
      requestFullMetadata: false,
    );
    if (f == null) return null;
    return UploadSource(
      path: f.path,
      name: cameraUploadName(f.name, DateTime.now()),
      sizeBytes: await f.length(),
    );
  }
}

/// Çekilen fotoğrafın yükleme adı: `IMG_yyyyMMdd_HHmmss.<uzantı>` (eklentinin verdiği geçici
/// ad UUID'dir, kullanıcıya anlamsız). Uzantı eklentinin dosyasından [normalizeUploadName] ile
/// alınır (`jpeg` → `jpg`); uzantısız dosya `jpg` sayılır (kamera çıktısı JPEG). Küme dışı
/// uzantı korunur: tür ön denetimi onu açıkça reddeder, yanlış türle gönderilmez.
@visibleForTesting
String cameraUploadName(String pickedName, DateTime at) {
  final n = normalizeUploadName(pickedName);
  final i = n.lastIndexOf('.');
  final ext = i < 0 || i == n.length - 1 ? 'jpg' : n.substring(i + 1);
  String two(int v) => v.toString().padLeft(2, '0');
  final stamp =
      '${at.year}${two(at.month)}${two(at.day)}_'
      '${two(at.hour)}${two(at.minute)}${two(at.second)}';
  return 'IMG_$stamp.$ext';
}

/// Seçici/kamera hatası → kullanıcıya gösterilecek istemci kodu. Kamera izni reddi ya da
/// kısıtı (iOS `camera_access_denied` / `camera_access_restricted`, Android
/// `camera_access_denied`) ayrı, cihazda kamera uygulaması yok (Android
/// `no_available_camera`) ayrı koddur; geri kalan her hata `client.file_unreadable`.
@visibleForTesting
String uploadPickErrorCode(Exception e) => switch (e) {
  PlatformException(
    code: 'camera_access_denied' || 'camera_access_restricted',
  ) =>
    ClientErrorCode.cameraPermissionDenied,
  PlatformException(code: 'no_available_camera') =>
    ClientErrorCode.cameraUnavailable,
  _ => ClientErrorCode.fileUnreadable,
};
