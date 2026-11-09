import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/department.dart';
import 'coordinatorships_providers.dart';

part 'coordinatorship_profiles_controller.g.dart';

/// Departman kayıtları (tür, açıklama). Yalnız ayrıntı ekranı izler ve yalnız şirket
/// yöneticisinde (`coordinatorshipDetail`); liste ekranı istek atmaz.
@Riverpod(keepAlive: true)
class CoordinatorshipProfilesController
    extends _$CoordinatorshipProfilesController {
  @override
  Future<List<Department>> build() =>
      ref.read(coordinatorshipProfileRepositoryProvider).load();
}
