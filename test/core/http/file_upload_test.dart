// Elle kurulan multipart yüklemeleri (görev/arşiv `postWorkItemFile`, sohbet
// `postChatAttachment`): seçimden sonra silinmiş ya da okunamayan dosya istek gönderilmeden
// `client.file_unreadable` olur; ham `FileSystemException` sızmaz (Codex tur 4 / N7).
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/file_upload.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';

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
}
