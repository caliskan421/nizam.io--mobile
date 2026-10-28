import '../../domain/task_catalog.dart';

part 'sample_task_data.dart';

/// GELİŞTİRME ÖRNEĞİ — gerçek servis değildir. Prototipteki görev kümesini döner; ağ isteği
/// atmaz. Bütün kişi adları kurmacadır. Bileşim kökünde (`tasks_module.dart`) tek yerde
/// bağlanır; backend bağlanınca yalnız o kayıt değişir.
final class SampleTaskCatalogRepository implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    today: _today,
    me: 'ma',
    tasks: _tasks,
    people: _people,
    coordinatorships: _coordinatorships,
  );
}
