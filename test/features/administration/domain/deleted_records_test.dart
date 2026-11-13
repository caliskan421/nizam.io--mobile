import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/administration/domain/deleted_records.dart';

void main() {
  test('koordinatörlüğü silinmiş görev önce koordinatörlüğe yönlendirir', () {
    final block = deletedActionBlock(
      DeletedKind.task,
      'work.department_unavailable',
      departmentName: 'Altyapı',
    );
    expect(block?.goTo, DeletedKind.coordinatorship);
    expect(block?.fix, contains('"Altyapı"'));
  });

  test('kullanımdaki koordinatörlük görev sekmesine yönlendirir', () {
    final block = deletedActionBlock(
      DeletedKind.coordinatorship,
      'organization.department_in_use',
    );
    expect(block?.goTo, DeletedKind.task);
  });

  test('silinmiş olmayan kayıt bütün modüllerde aynı açıklamayı alır', () {
    for (final code in [
      'work.not_deleted',
      'organization.not_deleted',
      'identity.not_deleted',
      'collaboration.not_deleted',
    ]) {
      expect(deletedActionBlock(DeletedKind.user, code), isNotNull);
    }
  });

  test('açıklaması olmayan kod null döner (ortak hata metni)', () {
    expect(deletedActionBlock(DeletedKind.task, 'platform.internal'), isNull);
    expect(
      deletedActionBlock(DeletedKind.meeting, 'work.constraint_violation'),
      isNull,
    );
  });
}
