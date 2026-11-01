import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

part 'task_details_controller.g.dart';

/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz. Rol (tarih talebi yüzü)
/// katalogdaki [TaskCatalog.access]'ten.
///
/// Katalog yeniden kurulunca (invalidate, kapsam değişimi) ayrıntı katalogla birlikte gider;
/// bu yüzden katalog YÜKLEMEYE geçtiğinde ayrıntı da kendini geçersiz kılar ve yeni katalog
/// gelince yeniden okunur. [TaskCatalogController.applyDetails] yükleme üretmez → döngü yok.
@riverpod
Future<void> taskDetails(Ref ref, String code) async {
  ref
    ..watch(scopeStateProvider)
    // Yalnız görevin katalogdaki VARLIĞI izlenir (her katalog değişiminde yeniden okuma yok):
    // yüklü katalogda yokken (ör. kesik katalog reload'u) süzgeçli okuma görevi kataloğa
    // getirince (yok → var) ayrıntı bir kez okunur. Katalog yokken (null) varlık bilinmez;
    // ilk yükleme ayrıca yeniden okutmaz.
    ..listen(
      taskCatalogControllerProvider.select(
        (c) => c.value == null ? null : c.value!.task(code) != null,
      ),
      (prev, next) {
        if (prev == false && next == true) ref.invalidateSelf();
      },
    )
    ..listen(taskCatalogControllerProvider, (prev, next) {
      if (next.isLoading && !(prev?.isLoading ?? false)) ref.invalidateSelf();
    });
  final catalog = await ref.read(taskCatalogControllerProvider.future);
  final task = catalog.task(code);
  if (task == null) return;
  final details = await ref
      .read(taskDetailsRepositoryProvider)
      .load(task, access: catalog.access);
  if (details == null) return;
  ref.read(taskCatalogControllerProvider.notifier).applyDetails(code, details);
}
