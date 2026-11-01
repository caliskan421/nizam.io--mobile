import 'package:file_picker/file_picker.dart';

import '../domain/task_writes.dart';

/// [UploadPicker]'ın sistem seçicisi gerçekleştirmesi (ADR-0002: `file_picker` YALNIZ bu
/// dosyada — sınır kuralı F1). İnce sarmalayıcıdır: tek dosya, süzgeç izinli uzantılar
/// ([uploadExtensions], `FileType.custom`; foto kitaplığı kullanılmaz). Ağ yok, içerik
/// okunmaz ve günlüğe yazılmaz; tür/boyut ön denetimi denetleyicide ([UploadSource]).
/// Yerel yolu olmayan seçim (yalnız URI) yüklenemez → vazgeçilmiş sayılır.
class FileUploadPicker implements UploadPicker {
  const FileUploadPicker();

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick() async {
    final f = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: uploadExtensions,
    );
    final path = f?.path;
    if (f == null || path == null) return null;
    final size = f.lengthSync() ?? await f.length();
    if (size == null) return null;
    return UploadSource(path: path, name: f.name, sizeBytes: size);
  }
}
