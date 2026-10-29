// Koordinatörlük ek bilgileri (prototip `logic_cdetail.js`; kişi adları prototip, kişi kimlikleri
// görev kataloğuyla aynı). Elle düzenlenebilir; üretim verisi değildir.
// ignore_for_file: lines_longer_than_80_chars
part of 'sample_coordinatorship_profile_repository.dart';

final _profiles = <CoordinatorshipProfile>[
  CoordinatorshipProfile(
    code: 'ALT',
    // Prototip `D` kaydı: 7/12 tamamlandı, 3 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 7,
      total: 12,
      late: 3,
      seasonRatio: 0.41,
    ),
    parent: 'Teknik altyapı',
    founded: DateTime(2026, 6, 10),
    about: 'Havalimanı yerleşkesinin temiz su, atıksu ve arıtma altyapısını kurar; depolama ve hidrofor sistemlerinin montajından ve devreye alınmasından sorumludur.',
    units: const [
      CoordinatorshipUnit(
        name: 'Su ve atıksu hatları',
        leadId: 'av',
        total: 4,
        done: 3,
      ),
      CoordinatorshipUnit(
        name: 'Arıtma tesisi',
        leadId: 'aa',
        total: 3,
        done: 3,
      ),
      CoordinatorshipUnit(
        name: 'Depolama ve hidrofor',
        leadId: 'ko',
        total: 5,
        done: 1,
      ),
    ],
    extraMembers: const [
      'Elif Demir',
      'Emre Kaya',
      'Ayşe Polat',
      'Furkan Çelik',
      'İrem Aksoy',
      'Zeynep Arslan',
    ],
    archiveFiles: 15,
    meetings: 2,
    chatId: 'hid',
    events: [
      CoordinatorshipEvent(
        actorId: 'ko',
        action: 'tarih talebi gönderdi',
        target: 'Hidrofor sistemi kurulumu · 10.09 → 31.10',
        at: DateTime(2026, 10, 19),
      ),
      CoordinatorshipEvent(
        actorId: 'av',
        action: '2 dosya yükledi',
        target: 'Gölgelendirme çalışmaları (kamelya)',
        at: DateTime(2026, 9, 28),
      ),
      CoordinatorshipEvent(
        actorId: 'ko',
        action: 'dosya yükledi',
        target: 'İklimlendirme hesaplarının yapılması',
        at: DateTime(2026, 9, 3),
      ),
      CoordinatorshipEvent(
        actorId: 'aa',
        action: 'görevi tamamladı',
        target: 'Paket arıtma ihalesi',
        at: DateTime(2026, 8, 27),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'MEK',
    // Prototip `D` kaydı: 7/8 tamamlandı, 1 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 7,
      total: 8,
      late: 1,
      seasonRatio: 0.41,
    ),
    parent: 'Teknik altyapı',
    founded: DateTime(2026, 6, 10),
    about: 'Mekanik sistemler koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Asfalt', leadId: 'oh', total: 3, done: 3),
      CoordinatorshipUnit(
        name: 'İklimlendirme',
        leadId: 'my',
        total: 5,
        done: 4,
      ),
    ],
    extraMembers: const [
      'İrem Aksoy',
      'Zeynep Arslan',
      'Mert Şahin',
      'Derya Koç',
    ],
    archiveFiles: 38,
    meetings: 1,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'my',
        action: 'dosya yükledi',
        target: 'Mekanik sistemler · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'my',
        action: 'görev güncelledi',
        target: 'Mekanik sistemler · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'ULA',
    // Prototip `D` kaydı: 1/4 tamamlandı, 3 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 1,
      total: 4,
      late: 3,
      seasonRatio: 0.41,
    ),
    parent: 'Teknik altyapı',
    founded: DateTime(2026, 6, 10),
    about: 'Ulaşım planlama koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(
        name: 'Otopark ve servis',
        leadId: 'so',
        total: 4,
        done: 1,
      ),
    ],
    extraMembers: const ['Can Öztürk', 'Gizem Yalçın', 'Elif Demir'],
    archiveFiles: 0,
    meetings: 0,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'so',
        action: 'dosya yükledi',
        target: 'Ulaşım planlama · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'so',
        action: 'görev güncelledi',
        target: 'Ulaşım planlama · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'ELE',
    // Prototip `D` kaydı: 4/6 tamamlandı, 1 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 4,
      total: 6,
      late: 1,
      seasonRatio: 0.41,
    ),
    parent: 'Teknik altyapı',
    founded: DateTime(2026, 6, 10),
    about: 'Elektrik ve enerji koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Aydınlatma', leadId: 'rk', total: 3, done: 2),
      CoordinatorshipUnit(name: 'Jeneratör', leadId: 'rk', total: 3, done: 2),
    ],
    extraMembers: const [
      'Selin Aydın',
      'Can Öztürk',
      'Gizem Yalçın',
      'Elif Demir',
      'Emre Kaya',
      'Ayşe Polat',
    ],
    archiveFiles: 60,
    meetings: 1,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'rk',
        action: 'dosya yükledi',
        target: 'Elektrik ve enerji · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'rk',
        action: 'görev güncelledi',
        target: 'Elektrik ve enerji · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'İDA',
    // Prototip `D` kaydı: 1/11 tamamlandı, 4 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 1,
      total: 11,
      late: 4,
      seasonRatio: 0.41,
    ),
    parent: 'Etkinlik ve operasyon',
    founded: DateTime(2026, 6, 10),
    about: 'İdari işler koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Zimmet', leadId: null, total: 4, done: 0),
      CoordinatorshipUnit(name: 'Biletleme', leadId: null, total: 4, done: 1),
      CoordinatorshipUnit(name: 'Yemek', leadId: null, total: 3, done: 0),
    ],
    extraMembers: const [],
    archiveFiles: 4,
    meetings: 0,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'ma',
        action: 'dosya yükledi',
        target: 'İdari işler · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'ma',
        action: 'görev güncelledi',
        target: 'İdari işler · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'EĞİ',
    // Prototip `D` kaydı: 2/6 tamamlandı, 2 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 2,
      total: 6,
      late: 2,
      seasonRatio: 0.41,
    ),
    parent: 'Eğitim ve iletişim',
    founded: DateTime(2026, 6, 10),
    about: 'Eğitim ve Arge koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Atölyeler', leadId: 'mk', total: 4, done: 1),
      CoordinatorshipUnit(name: 'Eğitmenler', leadId: 'mk', total: 2, done: 1),
    ],
    extraMembers: const ['Selin Aydın', 'Can Öztürk'],
    archiveFiles: 3,
    meetings: 1,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'mk',
        action: 'dosya yükledi',
        target: 'Eğitim ve Arge · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'mk',
        action: 'görev güncelledi',
        target: 'Eğitim ve Arge · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'OPE',
    // Prototip `D` kaydı: 4/8 tamamlandı, 0 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 4,
      total: 8,
      late: 0,
      seasonRatio: 0.41,
    ),
    parent: 'Etkinlik ve operasyon',
    founded: DateTime(2026, 6, 10),
    about: 'Operasyon koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Vardiya', leadId: 'yc', total: 4, done: 2),
      CoordinatorshipUnit(
        name: 'Saha yönetimi',
        leadId: 'yc',
        total: 4,
        done: 2,
      ),
    ],
    extraMembers: const [
      'Burak Yıldız',
      'Selin Aydın',
      'Can Öztürk',
      'Gizem Yalçın',
      'Elif Demir',
      'Emre Kaya',
      'Ayşe Polat',
      'Furkan Çelik',
      'İrem Aksoy',
      'Zeynep Arslan',
      'Mert Şahin',
      'Derya Koç',
      'Hakan Erdem',
    ],
    archiveFiles: 78,
    meetings: 3,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'yc',
        action: 'dosya yükledi',
        target: 'Operasyon · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'yc',
        action: 'görev güncelledi',
        target: 'Operasyon · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'SAT',
    // Prototip `D` kaydı: 4/7 tamamlandı, 0 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 4,
      total: 7,
      late: 0,
      seasonRatio: 0.41,
    ),
    parent: 'Eğitim ve iletişim',
    founded: DateTime(2026, 6, 10),
    about: 'Satış ve pazarlama koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Sponsorluk', leadId: 'bc', total: 4, done: 2),
      CoordinatorshipUnit(name: 'Kampanyalar', leadId: 'bc', total: 3, done: 2),
    ],
    extraMembers: const ['Mert Şahin'],
    archiveFiles: 1,
    meetings: 0,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'bc',
        action: 'dosya yükledi',
        target: 'Satış ve pazarlama · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'bc',
        action: 'görev güncelledi',
        target: 'Satış ve pazarlama · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'MİM',
    // Prototip `D` kaydı: 3/5 tamamlandı, 0 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 3,
      total: 5,
      late: 0,
      seasonRatio: 0.41,
    ),
    parent: 'Eğitim ve iletişim',
    founded: DateTime(2026, 6, 10),
    about: 'Mimari tasarım koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Yerleşke', leadId: 'eo', total: 3, done: 2),
      CoordinatorshipUnit(
        name: 'Stant tasarımı',
        leadId: 'eo',
        total: 2,
        done: 1,
      ),
    ],
    extraMembers: const ['İrem Aksoy', 'Zeynep Arslan'],
    archiveFiles: 8,
    meetings: 1,
    chatId: 'koord',
    events: [
      CoordinatorshipEvent(
        actorId: 'eo',
        action: 'dosya yükledi',
        target: 'Mimari tasarım · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'eo',
        action: 'görev güncelledi',
        target: 'Mimari tasarım · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'FUA',
    // Prototip `D` kaydı: 2/4 tamamlandı, 1 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 2,
      total: 4,
      late: 1,
      seasonRatio: 0.41,
    ),
    parent: 'Etkinlik ve operasyon',
    founded: DateTime(2026, 6, 10),
    about: 'Fuar koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(
        name: 'Stant ve katılımcı',
        leadId: 'ss',
        total: 4,
        done: 2,
      ),
    ],
    extraMembers: const [],
    archiveFiles: 0,
    meetings: 0,
    chatId: 'fuar',
    events: [
      CoordinatorshipEvent(
        actorId: 'ss',
        action: 'dosya yükledi',
        target: 'Fuar · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'ss',
        action: 'görev güncelledi',
        target: 'Fuar · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
  CoordinatorshipProfile(
    code: 'SİS',
    // Prototip `D` kaydı: 2/4 tamamlandı, 0 geciken; sezon ortalaması %41.
    reported: const CoordinatorshipReport(
      done: 2,
      total: 4,
      late: 0,
      seasonRatio: 0.41,
    ),
    parent: 'Yönetim',
    founded: DateTime(2026, 6, 10),
    about: 'Sistem koordinatörlüğü koordinatörlüğünün sorumluluk alanı ve çalışma kapsamı burada yazar.',
    units: const [
      CoordinatorshipUnit(name: 'Yazılım', leadId: 'ma', total: 3, done: 2),
      CoordinatorshipUnit(
        name: 'Kullanıcı desteği',
        leadId: 'my',
        total: 1,
        done: 0,
      ),
    ],
    extraMembers: const ['Mert Şahin'],
    archiveFiles: 12,
    meetings: 1,
    chatId: 'sis',
    events: [
      CoordinatorshipEvent(
        actorId: 'ma',
        action: 'dosya yükledi',
        target: 'Sistem koordinatörlüğü · haftalık rapor',
        at: DateTime(2026, 10, 14),
      ),
      CoordinatorshipEvent(
        actorId: 'ma',
        action: 'görev güncelledi',
        target: 'Sistem koordinatörlüğü · durum değişikliği',
        at: DateTime(2026, 10, 2),
      ),
    ],
  ),
];
