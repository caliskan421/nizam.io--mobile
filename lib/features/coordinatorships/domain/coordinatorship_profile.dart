import 'department.dart';

/// Koordinatörlük ayrıntısının görev kataloğu dışındaki kimlik bilgisinin kaynağı (domain
/// portu; gerçekleştirme `data/`). Sunucuda bu bilgi departman kaydıdır ([Department]: tür,
/// açıklama, kod); kimlik, ad, ekip ve görevler kataloğun (`TaskCatalog`) verisidir. Üst birim,
/// alt birim, kuruluş tarihi, ek üye, ekip sohbeti ve son etkinlik sunucuda yoktur.
abstract interface class CoordinatorshipProfileRepository {
  /// Şirketin departmanları (`GET /v1/departments`, S1, tek istek). Uç yalnız şirket
  /// yöneticisine açıktır (ORGANIZATION-K08); diğer roller için çağrılmaz. Hatalar `ApiError`.
  Future<List<Department>> load();
}
