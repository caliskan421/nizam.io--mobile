import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/task_writes.dart';

/// İndirilen görev dosyasını (akışla) uygulama belgeler klasörüne (`indirilenler/`) yazar (ADR-0002:
/// `path_provider` indirme için). Ad yalnız son yol parçasıdır (yol kaçışı yok; `.`/`..`/boş → `dosya`); aynı ad
/// varsa üzerine yazılır. Geçici dosya ayrı ve işleme özgüdür (bkz. [save]).
class FileDownloadSink implements DownloadSink {
  FileDownloadSink({
    Future<Directory> Function()? root,
    @visibleForTesting Future<void> Function(File from, String to)? rename,
  }) : _root = root ?? getApplicationDocumentsDirectory,
       _rename = rename ?? _renameFile;

  final Future<Directory> Function() _root;
  final Future<void> Function(File from, String to) _rename;

  static Future<void> _renameFile(File from, String to) => from.rename(to);

  /// Kayıt adı: yalnız son yol parçası (`/` ve `\` ayırıcı), kırpılmış; boş, `.` ya da `..`
  /// (klasörün kendisi / üstü) → `dosya`; geçici alanın adı ([tmpDirName], büyük/küçük harf
  /// duyarsız: `.TMP`, `.Tmp`) → `_` önekli.
  static String safeName(String name) {
    final last = name.split(RegExp(r'[/\\]')).last.trim();
    if (last.isEmpty || last == '.' || last == '..') return 'dosya';
    return last.toLowerCase() == tmpDirName ? '_$last' : last;
  }

  /// Geçici çalışma alanı: `indirilenler/.tmp/` (kullanıcı dosyalarıyla karışmaz, hedefle aynı dosya
  /// sistemi). Her indirme orada kendine özgü bir klasör alır (`Directory.createTemp`); aynı adlı
  /// eşzamanlı indirmeler ve kullanıcının `<ad>.part` dosyaları birbirine dokunmaz.
  static const tmpDirName = '.tmp';

  /// Akış işleme özgü geçici dosyaya parça parça yazılır, bitince asıl ada atomik `rename` ile
  /// taşınır (geçici alan hedefle aynı dosya sisteminde; kopyalama yedeği yok). Akış ya da taşıma
  /// hatasında yalnız işlemin geçici klasörü silinir, hedefe dokunulmaz ve hata fırlar.
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
      await _rename(part, file.path);
      return file.path;
    } finally {
      await work.delete(recursive: true).catchError((Object _) => work);
    }
  }
}
