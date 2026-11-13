// FileUploadPicker'ın karar mantığı (eklentisiz): kamerayla çekilen fotoğrafın yükleme adı ve
// seçici/kamera hatalarının kullanıcıya gösterilecek istemci koduna eşlenmesi.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/tasks/data/file_upload_picker.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';

void main() {
  group('cameraUploadName', () {
    final at = DateTime(2026, 3, 7, 9, 5, 4);

    test('eklentinin geçici adı yerine zaman damgalı izinli ad', () {
      final name = cameraUploadName('3f2a-uuid.jpg', at);
      expect(name, 'IMG_20260307_090504.jpg');
      final src = UploadSource(path: '/tmp/x', name: name, sizeBytes: 1);
      expect(src.contentType, 'image/jpeg');
    });

    test('jpeg/JPG → jpg; uzantısız kamera çıktısı jpg sayılır', () {
      expect(cameraUploadName('a.JPEG', at), 'IMG_20260307_090504.jpg');
      expect(cameraUploadName('a.JPG', at), 'IMG_20260307_090504.jpg');
      expect(cameraUploadName('a', at), 'IMG_20260307_090504.jpg');
      expect(cameraUploadName('a.', at), 'IMG_20260307_090504.jpg');
    });

    test('küme dışı uzantı korunur (tür ön denetimi reddeder)', () {
      final name = cameraUploadName('a.HEIC', at);
      expect(name, 'IMG_20260307_090504.heic');
      expect(
        UploadSource(path: '/tmp/x', name: name, sizeBytes: 1).contentType,
        isNull,
      );
    });
  });

  group('uploadPickErrorCode', () {
    test('kamera izni reddi ve kısıtı → camera_permission_denied', () {
      for (final code in ['camera_access_denied', 'camera_access_restricted']) {
        expect(
          uploadPickErrorCode(PlatformException(code: code)),
          ClientErrorCode.cameraPermissionDenied,
        );
      }
    });

    test('kamera yok → camera_unavailable', () {
      expect(
        uploadPickErrorCode(PlatformException(code: 'no_available_camera')),
        ClientErrorCode.cameraUnavailable,
      );
    });

    test('diğer platform ve dosya hataları → file_unreadable', () {
      expect(
        uploadPickErrorCode(
          PlatformException(code: 'read_external_storage_denied'),
        ),
        ClientErrorCode.fileUnreadable,
      );
      expect(
        uploadPickErrorCode(const FormatException('x')),
        ClientErrorCode.fileUnreadable,
      );
    });
  });
}
