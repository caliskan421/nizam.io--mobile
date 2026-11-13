// F3: kamera paketi (image_picker) yalnız yükleme seçicisinin kesin dosyasında; komşu dosya,
// başka feature ve dışa verme yasak (F1 file_picker ile aynı ev, ADR-0002).
import 'package:flutter_test/flutter_test.dart';

import '../../tool/boundaries.dart';

void main() {
  const picker = 'features/tasks/data/file_upload_picker.dart';
  const ip = "import 'package:image_picker/image_picker.dart';";
  List<String> rules(String path, String src) => [
    for (final v in checkSource(path, src)) v.rule,
  ];

  test('F3 image_picker yalnız seçici dosyasında; dışa verilemez', () {
    expect(rules(picker, ip), isEmpty);
    expect(rules('features/messages/presentation/a.dart', ip), ['F3']);
    expect(rules('features/tasks/data/camera_picker.dart', ip), ['F3']);
    expect(rules('core/http/a.dart', ip), ['F3']);
    expect(rules(picker, ip.replaceFirst('import', 'export')), ['F3']);
  });
}
