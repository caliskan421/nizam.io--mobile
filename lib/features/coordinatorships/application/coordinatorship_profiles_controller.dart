import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/coordinatorship_profile.dart';
import 'coordinatorships_providers.dart';

part 'coordinatorship_profiles_controller.g.dart';

/// Koordinatörlük ek bilgileri (üst birim, alt birimler, açıklama, son etkinlik).
@Riverpod(keepAlive: true)
class CoordinatorshipProfilesController
    extends _$CoordinatorshipProfilesController {
  @override
  Future<List<CoordinatorshipProfile>> build() =>
      ref.read(coordinatorshipProfileRepositoryProvider).load();
}
