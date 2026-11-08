import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/upload_types.dart';

void main() {
  group('normalizeUploadName (galeri adı → izinli yazım)', () {
    test('jpeg/JPG/JPEG → jpg; PNG → png; ad gövdesi korunur', () {
      expect(normalizeUploadName('IMG_0001.jpeg'), 'IMG_0001.jpg');
      expect(normalizeUploadName('IMG_0001.JPG'), 'IMG_0001.jpg');
      expect(normalizeUploadName('Kopya.Foto.JPEG'), 'Kopya.Foto.jpg');
      expect(normalizeUploadName('Ekran.PNG'), 'Ekran.png');
      expect(normalizeUploadName('rapor.pdf'), 'rapor.pdf');
      for (final n in ['IMG_0001.jpeg', 'Ekran.PNG']) {
        final ext = normalizeUploadName(n).split('.').last;
        expect(uploadContentType(ext), isNotNull, reason: n);
      }
    });

    test('küme dışı tür (HEIC/WEBP) dönüşmez, tür denetiminde reddedilir', () {
      expect(normalizeUploadName('IMG_0002.HEIC'), 'IMG_0002.heic');
      expect(uploadContentType('heic'), isNull);
      expect(
        uploadContentType(normalizeUploadName('a.webp').split('.').last),
        isNull,
      );
    });

    test('uzantısız ya da noktayla biten ad olduğu gibi kalır', () {
      expect(normalizeUploadName('foto'), 'foto');
      expect(normalizeUploadName('foto.'), 'foto.');
    });
  });
}
