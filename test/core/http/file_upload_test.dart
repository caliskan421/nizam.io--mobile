// Elle kurulan multipart yüklemeleri (görev/arşiv `postWorkItemFile`, sohbet
// `postChatAttachment`): seçimden sonra silinmiş ya da okunamayan dosya istek gönderilmeden
// `client.file_unreadable` olur; ham `FileSystemException` sızmaz (Codex tur 4 / N7). Boyutu
// okunan ama içerik akışı gönderimde hata veren dosya da (bağdaştırıcı akışı tüketirken)
// `client.file_unreadable`'dır, ağ hatası değil; gerçek ağ hatası değişmez (Codex tur 5 / N11).
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/file_upload.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';

/// Gövde akışını gerçek bağdaştırıcı gibi tüketen sahte bağdaştırıcı; [beforeBody] akış
/// okunmadan hemen önce çalışır, [error] doluysa akış yerine o fırlatılır.
class _Consuming implements HttpClientAdapter {
  void Function()? beforeBody;
  Exception? error;
  int bodies = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (error case final e?) throw e;
    beforeBody?.call();
    await requestStream?.drain<void>();
    bodies++;
    return ResponseBody.fromString('{}', 201);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  final unreadable = throwsA(
    isA<ApiError>().having(
      (e) => e.code,
      'code',
      ClientErrorCode.fileUnreadable,
    ),
  );

  test('okunamayan dosya: istek yok, client.file_unreadable', () async {
    final dir = Directory.systemTemp.createTempSync('nz_file_upload_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final path = '${dir.path}/yok.pdf';
    var sent = 0;
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) {
            sent++;
            h.reject(DioException(requestOptions: o));
          },
        ),
      );
    await expectLater(
      postWorkItemFile(
        dio,
        workItemId: 'w1',
        tag: 'plan',
        filePath: path,
        filename: 'yok.pdf',
        contentType: 'application/pdf',
        requestKey: 'k',
      ),
      unreadable,
    );
    await expectLater(
      postChatAttachment(
        dio,
        chatId: 'c1',
        clientMessageId: 'm1',
        filePath: path,
        filename: 'yok.pdf',
        contentType: 'application/pdf',
        extras: const {},
      ),
      unreadable,
    );
    expect(sent, 0);
  });

  test(
    'boyut okunur, içerik akışı gönderimde hata verir: client.file_unreadable; '
    'ağ hatası değişmez',
    () async {
      final dir = Directory.systemTemp.createTempSync('nz_file_stream_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final adapter = _Consuming();
      final dio = Dio()..httpClientAdapter = adapter;
      Future<Object?> work(String path) => postWorkItemFile(
        dio,
        workItemId: 'w1',
        tag: 'plan',
        filePath: path,
        filename: 'r.pdf',
        contentType: 'application/pdf',
        requestKey: 'k',
      );
      Future<Object?> chat(String path) => postChatAttachment(
        dio,
        chatId: 'c1',
        clientMessageId: 'm1',
        filePath: path,
        filename: 'r.pdf',
        contentType: 'application/pdf',
        extras: const {},
      );
      for (final send in [work, chat]) {
        final f = File('${dir.path}/r.pdf')..writeAsBytesSync([1, 2, 3]);
        // Parça kuruldu (boyut okundu); dosya içerik akışı açılmadan silinir.
        adapter.beforeBody = f.deleteSync;
        final e = await send(f.path)
            .then<Object?>((_) => null, onError: (Object e) => e);
        expect(e, isA<DioException>(), reason: 'hata gönderim sırasında');
        expect(toApiError(e!).code, ClientErrorCode.fileUnreadable);
      }
      expect(adapter.bodies, 0);

      adapter
        ..beforeBody = null
        ..error = const SocketException('bağlantı yok');
      final f = File('${dir.path}/r.pdf')..writeAsBytesSync([1, 2, 3]);
      final e = await work(f.path)
          .then<Object?>((_) => null, onError: (Object e) => e);
      expect(toApiError(e!).code, ClientErrorCode.networkError);
    },
  );
}
