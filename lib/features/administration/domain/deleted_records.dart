/// Silinenler ekranının sekmeleri: sunucuda yumuşak silinip geri yüklenebilen türler
/// (`/v1/admin/deleted|restore|permanent/...`). Tablo yumuşak siliniyor ama geri yükleme ucu
/// yok; sekmesi açılmaz (backend bekliyor).
enum DeletedKind { task, meeting, coordinatorship, user }

/// Geri yükleme ya da kalıcı silme reddinin nedeni ve çözümü; [goTo] çözüm başka sekmedeyse
/// o sekme (ör. görevden önce koordinatörlük geri yüklenir).
typedef DeletedActionBlock = ({String reason, String fix, DeletedKind? goTo});

/// Reddin kullanıcıya açıklaması. [code] sunucu hata kodu; [departmentName] görevin silinmiş
/// koordinatörlüğünün adı (biliniyorsa); [byDepartment] görev koordinatörlüğüyle birlikte
/// silindiyse (ADR-0043: koordinatörlük geri yüklenince kendiliğinden geri gelir). Açıklaması
/// olmayan kodda null (ortak hata metni).
DeletedActionBlock? deletedActionBlock(
  DeletedKind kind,
  String code, {
  String? departmentName,
  bool byDepartment = false,
}) {
  final dept = departmentName == null ? 'görevin' : '"$departmentName"';
  return switch (code) {
    'work.department_unavailable' when byDepartment => (
      reason:
          'Görev koordinatörlüğüyle birlikte silindi; koordinatörlük silinmişken '
          'tek başına geri yüklenemez.',
      fix:
          '$dept koordinatörlüğünü Koordinatörlükler sekmesinden geri yükleyin; '
          'birlikte silinen görevler kendiliğinden geri gelir.',
      goTo: DeletedKind.coordinatorship,
    ),
    'work.department_unavailable' => (
      reason: 'Görevin koordinatörlüğü silinmiş; görev ona geri yüklenemez.',
      fix:
          'Önce $dept koordinatörlüğünü Koordinatörlükler sekmesinden geri '
          'yükleyin, sonra görevi geri yükleyin.',
      goTo: DeletedKind.coordinatorship,
    ),
    'work.not_deleted' ||
    'organization.not_deleted' ||
    'identity.not_deleted' ||
    'collaboration.not_deleted' ||
    'work.permanent_requires_deleted' ||
    'organization.permanent_requires_deleted' ||
    'identity.permanent_requires_deleted' ||
    'collaboration.permanent_requires_deleted' => (
      reason:
          'Kayıt artık silinmişler arasında değil (başka biri geri '
          'yüklemiş olabilir).',
      fix: 'Liste yenilendi; kayıt ilgili modülde görünür.',
      goTo: null,
    ),
    'organization.department_in_use' => (
      reason:
          'Koordinatörlük tablo, proje ya da bekleyen tablo önerisi '
          'kapsamında kullanılıyor.',
      fix:
          'Önce bu kayıtlar tablolardan kaldırılmalı; koordinatörlük silinmiş '
          'olarak kalabilir.',
      goTo: null,
    ),
    'identity.account_referenced' => (
      reason: 'Hesap görev ataması, mesaj, dosya ya da tablo kaydında geçiyor.',
      fix:
          'Geçmiş kayıtlar korunduğu için hesap kalıcı silinemez; silinmiş '
          'olarak kalabilir ya da geri yüklenebilir.',
      goTo: null,
    ),
    'work.constraint_violation' when kind == DeletedKind.task => (
      reason: 'Göreve bağlı başka kayıtlar silmeyi engelliyor.',
      fix: 'Bağlı kayıtları kontrol edip yeniden deneyin.',
      goTo: null,
    ),
    _ => null,
  };
}
