import 'package:dio/dio.dart';

import '../domain/coordinatorship_profile.dart';
import '../domain/department.dart';
import 'department_api_repository.dart';

/// [CoordinatorshipProfileRepository]'nin sunucu gerçekleştirmesi: departman listesi
/// [ApiDepartmentRepository.listDepartments] ile okunur (eşleme orada; DTO bu katmanda kalır).
/// Liste en çok 200 satırdır; kesilmede listede olmayan departmanın kaydı yok sayılır.
class ApiCoordinatorshipProfileRepository
    implements CoordinatorshipProfileRepository {
  ApiCoordinatorshipProfileRepository(this.dio);

  /// Doğrulanmış bağın güncel API istemcisi; bağ yoksa null.
  final Dio? Function() dio;

  @override
  Future<List<Department>> load() async =>
      (await ApiDepartmentRepository(dio).listDepartments()).items;
}
