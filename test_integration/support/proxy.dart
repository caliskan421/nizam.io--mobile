// Gerçek backend'in önünde sayan vekil. Her isteği kaydeder ve iletir; istenen yolda yanıtı
// "kaybeder": istek backend'e ulaşır ve işlenir (ör. yenileme rotasyonu gerçekleşir), ama
// istemciye yanıt yerine kopuk bağlantı döner — K-05'in "belirsiz" senaryosunun gerçeği.
import 'dart:async';
import 'dart:io';

class CountingProxy {
  CountingProxy._(this._server, this.target);

  final HttpServer _server;
  final Uri target;
  final List<String> seen = [];
  final List<String> bodies = [];

  /// Yanıtı kaybedilecek yollar.
  final Set<String> dropResponseFor = {};

  final HttpClient _upstream = HttpClient();

  Uri get url =>
      Uri(scheme: target.scheme, host: '127.0.0.1', port: _server.port);

  int count(String method, String path) =>
      seen.where((s) => s == '$method $path').length;

  static Future<CountingProxy> start(Uri target) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final proxy = CountingProxy._(server, target);
    server.listen(proxy._handle);
    return proxy;
  }

  Future<void> _handle(HttpRequest req) async {
    final path = req.uri.path;
    seen.add('${req.method} $path');
    final body = await req.fold<List<int>>([], (a, b) => a..addAll(b));
    bodies.add(String.fromCharCodes(body));
    final up = await _upstream.openUrl(
      req.method,
      target.replace(
        path: path,
        query: req.uri.query.isEmpty ? null : req.uri.query,
      ),
    );
    req.headers.forEach((name, values) {
      if (name == HttpHeaders.hostHeader ||
          name == HttpHeaders.contentLengthHeader) {
        return;
      }
      for (final v in values) {
        up.headers.add(name, v, preserveHeaderCase: true);
      }
    });
    up.contentLength = body.length;
    up.add(body);
    final resp = await up.close();
    final respBody = await resp.fold<List<int>>([], (a, b) => a..addAll(b));
    if (dropResponseFor.contains(path)) {
      // Backend işledi; istemci yanıtı hiç görmez.
      final socket = await req.response.detachSocket(writeHeaders: false);
      socket.destroy();
      return;
    }
    req.response.statusCode = resp.statusCode;
    resp.headers.forEach((name, values) {
      if (name == HttpHeaders.transferEncodingHeader ||
          name == HttpHeaders.contentLengthHeader) {
        return;
      }
      for (final v in values) {
        req.response.headers.add(name, v);
      }
    });
    req.response.contentLength = respBody.length;
    req.response.add(respBody);
    await req.response.close();
  }

  Future<void> close() async {
    _upstream.close(force: true);
    await _server.close(force: true);
  }
}
