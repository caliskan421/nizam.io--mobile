import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/task_writes.dart';

/// İndirilen görev dosyasını (akışla) uygulama belgeler klasörüne (`indirilenler/`) yazar (ADR-0002:
/// `path_provider` indirme için). Ad yalnız son yol parçasıdır (yol kaçışı yok; `.`/`..`/boş → `dosya`); aynı ad
/// varsa üzerine yazılır. Geçici dosya ayrı ve işleme özgüdür (bkz. [save]).
class FileDownloadSink implements DownloadSink {
  FileDownloadSink({Future<Directory> Function()? root})
    : _root = root ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _root;

  /// Kayıt adı: yalnız son yol parçası (`/` ve `\` ayırıcı), kırpılmış; boş, `.` ya da `..`
  /// (klasörün kendisi / üstü) → `dosya`; geçici alanın adı ([tmpDirName]) → `_` önekli.
  static String safeName(String name) {
    final last = name.split(RegExp(r'[/\\]')).last.trim();
    if (last.isEmpty || last == '.' || last == '..') return 'dosya';
    return last == tmpDirName ? '_$last' : last;
  }

  /// Geçici çalışma alanı: `indirilenler/.tmp/` (kullanıcı dosyalarıyla karışmaz, hedefle aynı dosya
  /// sistemi). Her indirme orada kendine özgü bir klasör alır (`Directory.createTemp`); aynı adlı
  /// eşzamanlı indirmeler ve kullanıcının `<ad>.part` dosyaları birbirine dokunmaz.
  static const tmpDirName = '.tmp';

  /// Akış işleme özgü geçici dosyaya parça parça yazılır, bitince asıl ada taşınır (taşıma
  /// başarısızsa kopyala+sil yedeği). Akış ya da taşıma hatasında geçici alan silinir ve hata
  /// fırlar; yarım dosya kalmaz (önceki aynı adlı dosya korunur).
  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    final base = await _root();
    final dir = Directory('${base.path}/indirilenler');
    final tmpRoot = Directory('${dir.path}/$tmpDirName');
    await tmpRoot.create(recursive: true);
    final file = File('${dir.path}/${safeName(name)}');
    final work = await tmpRoot.createTemp('dl_');
    try {
      final part = File('${work.path}/veri');
      final out = part.openWrite();
      try {
        await out.addStream(bytes);
        await out.flush();
      } finally {
        await out.close().catchError((Object _) {});
      }
      await _move(part, file);
      return file.path;
    } finally {
      await work.delete(recursive: true).catchError((Object _) => work);
    }
  }

  /// Taşıma: önce `rename` (atomik, aynı ad varsa üzerine yazar); başarısızsa (ör. farklı dosya
  /// sistemi) kopyala ve kaynağı sil. Kopya yarıda kalırsa hedefteki yarım dosya silinir.
  static Future<void> _move(File from, File to) async {
    try {
      await from.rename(to.path);
    } on FileSystemException {
      try {
        await from.copy(to.path);
      } on Object {
        if (to.existsSync() &&
            to.statSync().type == FileSystemEntityType.file) {
          await to.delete().catchError((Object _) => to);
        }
        rethrow;
      }
      await from.delete();
    }
  }
}
