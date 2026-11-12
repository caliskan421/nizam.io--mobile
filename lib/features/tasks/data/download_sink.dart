import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/error_reporting.dart';
import '../domain/task_writes.dart';

/// İndirilen görev dosyasını (akışla) uygulama belgeler klasörüne (`indirilenler/`) yazar (ADR-0002:
/// `path_provider` indirme için). Ad yalnız son yol parçasıdır (yol kaçışı yok; `.`/`..`/boş → `dosya`); aynı ad
/// varsa üzerine YAZILMAZ, çakışmasız ad seçilir (`ad (2).pdf`, bkz. [save]). Geçici dosya ayrı ve
/// işleme özgüdür.
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

  /// Çakışmasız ad aramasının üst sınırı (`ad (2)` … `ad (maxCopies)`); aşılırsa hata.
  static const maxCopies = 1000;

  /// [name]'in [n]. kopya adı: uzantıdan önce ` (n)` (`rapor.pdf` → `rapor (2).pdf`); uzantısız
  /// ya da nokta ile başlayan adda sona eklenir (`dosya (2)`, `.profil (2)`).
  static String copyName(String name, int n) {
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return '$name ($n)';
    return '${name.substring(0, dot)} ($n)${name.substring(dot)}';
  }

  /// Akış işleme özgü geçici dosyaya parça parça yazılır, bitince hedef ad AYRILIR (özel
  /// oluşturma: `create(exclusive: true)`; ad doluysa — dosya ya da klasör — sıradaki kopya adı
  /// denenir) ve içerik ayrılan ada atomik `rename` ile taşınır (geçici alan hedefle aynı dosya
  /// sisteminde; kopyalama yedeği yok). Böylece var olan dosya ve eşzamanlı aynı adlı indirme
  /// ezilmez. Akış ya da taşıma hatasında işlemin geçici klasörü ve ayrılan (boş) ad silinir,
  /// başka dosyaya dokunulmaz ve hata fırlar.
  @override
  Future<String> save(String name, Stream<List<int>> bytes) async {
    try {
      return await _save(name, bytes);
    } on FileSystemException catch (e, st) {
      // Yerel dosya sistemi arızası (kota, izin, disk): yalnız tür ve yığın raporlanır;
      // ad ve yol rapora girmez.
      ErrorReporting.report(
        e,
        st,
        kind: ReportKind.storage,
        operation: ReportOperation.fileDownload,
      );
      rethrow;
    }
  }

  Future<String> _save(String name, Stream<List<int>> bytes) async {
    final base = await _root();
    final dir = Directory('${base.path}/indirilenler');
    final tmpRoot = Directory('${dir.path}/$tmpDirName');
    await tmpRoot.create(recursive: true);
    final work = await tmpRoot.createTemp('dl_');
    File? reserved;
    try {
      final part = File('${work.path}/veri');
      final out = part.openWrite();
      try {
        await out.addStream(bytes);
        await out.flush();
      } finally {
        await out.close().catchError((Object _) {});
      }
      final file = reserved = await _reserve(dir, safeName(name));
      await _rename(part, file.path);
      reserved = null;
      return file.path;
    } finally {
      final r = reserved;
      if (r != null) await r.delete().catchError((Object _) => r);
      await work.delete(recursive: true).catchError((Object _) => work);
    }
  }

  /// [dir] içinde [name] ya da ilk boş kopya adını özel oluşturmayla ayırır (yarışta da tek
  /// sahip). Ad doluysa sıradakine geçilir; başka bir dosya sistemi hatası iletilir.
  static Future<File> _reserve(Directory dir, String name) async {
    for (var n = 1; n <= maxCopies; n++) {
      final f = File('${dir.path}/${n == 1 ? name : copyName(name, n)}');
      try {
        return await f.create(exclusive: true);
      } on FileSystemException {
        final taken =
            FileSystemEntity.typeSync(f.path, followLinks: false) !=
            FileSystemEntityType.notFound;
        if (!taken) rethrow;
      }
    }
    throw FileSystemException('indirme adı ayrılamadı', '${dir.path}/$name');
  }
}
