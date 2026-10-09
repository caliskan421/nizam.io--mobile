// Mobil yığından BAĞIMSIZ ham HTTP: web istemcisi gibi davranan çağrılar ve fixture kurulumu
// (fixture yalnız API ile — D-0162). Belirteçler yalnız test belleğindedir.
import 'dart:convert';
import 'dart:io';

class RawResponse {
  RawResponse(this.status, this.json);
  final int status;
  final Object? json;

  Map<String, Object?> get map => json! as Map<String, Object?>;
}

Future<RawResponse> rawRequest(
  String method,
  Uri url, {
  Map<String, String> headers = const {},
  Object? body,
}) async {
  final client = HttpClient();
  try {
    final req = await client.openUrl(method, url);
    headers.forEach(req.headers.set);
    if (body != null) {
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode(body));
    }
    final resp = await req.close();
    final text = await resp.transform(utf8.decoder).join();
    return RawResponse(resp.statusCode, text.isEmpty ? null : jsonDecode(text));
  } finally {
    client.close(force: true);
  }
}

/// Web girişi (X-Nizamio-Client YOK → web sınıfı; oturum belirteci gövdede, yenileme çerezde).
Future<String> webLogin(Uri base, String email, String password) async {
  final r = await rawRequest(
    'POST',
    base.replace(path: '/v1/auth/login'),
    headers: {'X-Requested-With': 'XMLHttpRequest'},
    body: {'email': email, 'password': password},
  );
  if (r.status != 200) throw StateError('web girişi → ${r.status} ${r.json}');
  final token = r.map['token'] as String?;
  if (token == null || r.map['refresh_token'] != null) {
    throw StateError('web girişi beklenen biçimde değil');
  }
  return token;
}

Future<int> meStatus(Uri base, String bearer) async => (await rawRequest(
  'GET',
  base.replace(path: '/v1/me'),
  headers: {'Authorization': 'Bearer $bearer'},
)).status;
