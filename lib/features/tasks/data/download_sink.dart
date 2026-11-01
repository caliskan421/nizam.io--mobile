import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/task_writes.dart';

/// İndirilen görev dosyasını (akışla) uygulama belgeler klasörüne (`indirilenler/`) yazar (ADR-0002:
/// `path_provider` indirme için). Ad yalnız son yol parçasıdır (yol kaçışı yok; `.`/`..`/boş → `dosya`); aynı ad
/// varsa üzerine yazılır.
class FileDownloadSink implements DownloadSink {
  FileDownloadSink({Future<Directory> Function()? root})
    : _root = root ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _root;

  /// Kayıt adı: yalnız son yol parçası (`/` ve `\` ayırıcı), kırpılmış; boş, `.` ya da `..`
  /// (klasörün kendisi / üstü) → `dosya`.
  static String safeName(String name) {
    final last = name.split(RegExp(r'[/\\]')).last.trim();
    return last.isEmpty || last == '.' || last == '..' ? 'dosya' : last;
  }

  /// Akış önce `<ad>.part` dosyasına parça parça yazılır, bitince asıl ada taşınır; akış
  /// hatasında yarım dosya silinir ve hata fırlar (önceki aynı adlı dosya korunur).
  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    final base = await _root();
    final dir = Directory('${base.path}/indirilenler');
    await dir.create(recursive: true);
    final file = File('${dir.path}/${safeName(name)}');
    final part = File('${file.path}.part');
    final out = part.openWrite();
    try {
      await out.addStream(bytes);
      await out.flush();
      await out.close();
    } on Object {
      await out.close().catchError((Object _) {});
      if (part.existsSync()) await part.delete();
      rethrow;
    }
    await part.rename(file.path);
    return file.path;
  }
}
