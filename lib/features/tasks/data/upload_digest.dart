import 'dart:io';

import 'package:crypto/crypto.dart';

/// [path] dosyasının içerik özeti (SHA-256, küçük harf onaltılık). Dosya akışla okunur
/// (belleğe toplanmaz). Yükleme niyeti imzasında ad/boyutla birlikte kullanılır: aynı ad ve
/// boyutta farklı içerik ayrı niyettir, aynı içerik farklı geçici yoldan aynı niyettir
/// (istemci akışları §8; sunucu yükleme tekrarını gövde okumadan metadata'dan tanır).
/// ADR-0002: `crypto` YALNIZ bu dosyada (sınır kuralı F2).
Future<String> uploadDigest(String path) async =>
    (await sha256.bind(File(path).openRead()).first).toString();
