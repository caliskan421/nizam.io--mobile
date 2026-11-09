import 'package:file_picker/file_picker.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/task_writes.dart';

/// [UploadPicker]'ın sistem seçicisi gerçekleştirmesi (ADR-0002: `file_picker` YALNIZ bu
/// dosyada — sınır kuralı F1). İnce sarmalayıcıdır, tek dosya:
/// - [UploadOrigin.files]: belge seçici, süzgeç izinli uzantılar ([uploadExtensions],
///   `FileType.custom`).
/// - [UploadOrigin.photos]: `FileType.image` — iOS'ta `PHPickerViewController` (kitaplık izni
///   istemez), `compatible` kipi HEIC'i JPEG'e çevirir; Android'de sistem görsel seçicisi
///   (izin yok). Ad [normalizeUploadName] ile izinli yazıma gelir (`IMG_1.JPEG` → `.jpg`);
///   küme dışı tür (HEIC/WEBP) denetleyicinin tür ön denetiminde açıkça reddedilir.
/// Ağ yok; içerik OKUNMAZ (yalnız boyut): özet görev/arşiv gönderiminde, tür/boyut ön
/// denetiminden sonra hesaplanır ([UploadSource]; sohbet eki özet hesaplamaz). Yerel yolu
/// olmayan seçim (yalnız URI) yüklenemez → vazgeçilmiş sayılır. Seçici ya da boyut okuma
/// hatası `client.file_unreadable` olarak düşer (çağıran kullanıcıya gösterir).
class FileUploadPicker implements UploadPicker {
  const FileUploadPicker();

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    try {
      return await _pick(origin);
    } on Exception {
      throw ApiError(ClientErrorCode.fileUnreadable);
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
}
