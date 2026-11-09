import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/export/csv_writer.dart';

void main() {
  test(
    'CSV metni alıntılar ve elektronik tablo formüllerini etkisizleştirir',
    () {
      final encoded = csvBytes([
        ['Ad, soyad', 'A "B"', 'İki\nsatır'],
        ['=1+1', '  @SUM(A1)', '-1', '+1', '\t=2'],
      ]);
      expect(encoded.take(3), [0xEF, 0xBB, 0xBF]);
      expect(
        utf8.decode(encoded),
        '"Ad, soyad","A ""B""","İki\nsatır"\r\n'
        '"\'=1+1","\'  @SUM(A1)","\'-1","\'+1","\'\t=2"\r\n',
      );
    },
  );
}
