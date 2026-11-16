import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_value_validation.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';

void main() {
  test(
    'boş değerler isteğe bağlı; telefon biçimi yerel ve uluslararası destekler',
    () {
      for (final value in [
        null,
        '',
        '+90 (532) 123-45-67',
        '0532 123 45 67',
        '2121234567',
      ]) {
        expect(
          tableValueIssue(TableFieldType.phone, value),
          isNull,
          reason: '$value',
        );
      }
      for (final value in [
        '123',
        '555abc1234',
        '++905321234567',
        '53+21234567',
        '(532 1234567',
        '1234567890123456',
      ]) {
        expect(
          tableValueIssue(TableFieldType.phone, value),
          TableValueIssue.phone,
          reason: value,
        );
      }
    },
  );
  test('e-posta ad, alan adı ve nokta kuralları', () {
    for (final value in [
      null,
      '',
      'ad.soyad+etiket@ornek.com',
      'ad@alt.ornek.com.tr',
    ]) {
      expect(tableValueIssue(TableFieldType.email, value), isNull);
    }
    for (final value in [
      'ad',
      'ad@',
      'ad@ornek',
      'ad soyad@ornek.com',
      'a..b@ornek.com',
      '.ad@ornek.com',
      'ad@-ornek.com',
    ]) {
      expect(
        tableValueIssue(TableFieldType.email, value),
        TableValueIssue.email,
        reason: value,
      );
    }
  });
  test('taslak türüne göre tüm değişen hücreleri denetler', () {
    const columns = [
      TableColumnState(
        TableField(id: 'p', name: 'Telefon', type: TableFieldType.phone),
        180,
        false,
        'phone',
      ),
      TableColumnState(
        TableField(id: 'n', name: 'Sayı', type: TableFieldType.number),
        180,
        false,
        'number',
      ),
    ];
    expect(tableDraftValid(columns, {const TableFieldId('p'): 'abc'}), isFalse);
    expect(
      tableDraftValid(columns, {
        const TableFieldId('p'): '+90 532 1234567',
        const TableFieldId('n'): const TableDecimal('-12.50'),
      }),
      isTrue,
    );
    expect(
      tableDraftValid(columns, {
        const TableFieldId('n'): const TableDecimal('1e1001'),
      }),
      isFalse,
    );
    expect(
      tableValueIssue(TableFieldType.date, '2026-02-30'),
      TableValueIssue.date,
    );
  });
}
