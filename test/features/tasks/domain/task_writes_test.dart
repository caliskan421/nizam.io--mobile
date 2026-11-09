// Yükleme süzgeci: sistem seçicisinin uzantıları yerel tür kümesiyle birebir (seçilebilen her
// uzantı bildirilecek türe eşlenir; küme dışı tür seçilemez ve yine de ön denetim reddeder).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';

void main() {
  test('seçici uzantıları izinli tür kümesine eşlenir', () {
    for (final e in uploadExtensions) {
      expect(uploadContentType(e), isNotNull, reason: e);
    }
    expect(uploadExtensions.toSet(), hasLength(uploadExtensions.length));
  });

  test('küme dışı uzantı (jpeg, exe) türsüz → istek öncesi reddedilir', () {
    for (final e in ['jpeg', 'exe', '']) {
      expect(uploadContentType(e), isNull, reason: e);
      expect(
        UploadSource(path: '/x', name: 'a.$e', sizeBytes: 1).contentType,
        isNull,
      );
    }
  });
}
