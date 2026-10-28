import '../../domain/coordinatorship_profile.dart';

part 'sample_coordinatorship_profile_data.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Prototipteki koordinatörlük ek bilgilerini
/// (üst birim, alt birimler, açıklama, son etkinlik…) döner; ağ isteği atmaz. Bileşim kökünde
/// (`coordinatorships_module.dart`) tek yerde bağlanır.
final class SampleCoordinatorshipProfileRepository
    implements CoordinatorshipProfileRepository {
  @override
  Future<List<CoordinatorshipProfile>> load() async => _profiles;
}
