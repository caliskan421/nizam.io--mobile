import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../domain/task_writes.dart';

/// İndirilen görev dosyasını uygulama belgeler klasörüne (`indirilenler/`) yazar (ADR-0002:
/// `path_provider` indirme için). Ad yalnız son yol parçasıdır (yol kaçışı yok); aynı ad
/// varsa üzerine yazılır.
class FileDownloadSink implements DownloadSink {
  FileDownloadSink({Future<Directory> Function()? root})
    : _root = root ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _root;

  @override
  Future<String> save(String name, Uint8List bytes) async {
    final base = await _root();
    final dir = Directory('${base.path}/indirilenler');
    await dir.create(recursive: true);
    final safe = name.split(RegExp(r'[/\\]')).last.trim();
    final file = File('${dir.path}/${safe.isEmpty ? 'dosya' : safe}');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
