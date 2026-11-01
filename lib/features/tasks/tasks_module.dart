import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/scope/scope_controller.dart';
import 'application/task_sources.dart';
import 'application/tasks_providers.dart';
import 'data/download_sink.dart';
import 'data/file_upload_picker.dart';
import 'data/sample/sample_task_catalog_repository.dart';
import 'data/task_catalog_api_repository.dart';
import 'data/task_details_api_repository.dart';
import 'data/task_write_api_repository.dart';
import 'domain/task_catalog.dart';
import 'domain/task_details.dart';
import 'domain/task_writes.dart';

/// tasks modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerTasksModule(GetIt locator, {required Dio? Function() apiDio}) {
  // Sunucu programı seçiliyse sunucu kataloğu; örnek kapsamda geliştirme örneği.
  locator
    ..registerLazySingleton<TaskCatalogRepository>(
      () => TaskCatalogSource(
        scope: locator<ScopeController>(),
        server: () {
          final dio = apiDio();
          return dio == null
              ? null
              : ApiTaskCatalogRepository(
                  dio,
                  programId: () => locator<ScopeController>().current.programId,
                  departmentId: () =>
                      locator<ScopeController>().current.departmentId,
                  correctDepartment: (id) =>
                      locator<ScopeController>().selectDepartment(id),
                );
        },
        sample: SampleTaskCatalogRepository(),
      ),
    )
    ..registerLazySingleton<TaskDetailsRepository>(
      () => TaskDetailsSource(
        scope: locator<ScopeController>(),
        server: () {
          final dio = apiDio();
          return dio == null ? null : ApiTaskDetailsRepository(dio);
        },
      ),
    )
    ..registerLazySingleton<TaskWriteRepository>(
      () => TaskWriteSource(
        server: () {
          final dio = apiDio();
          return dio == null ? null : ApiTaskWriteRepository(dio);
        },
      ),
    )
    ..registerLazySingleton<DownloadSink>(FileDownloadSink.new)
    ..registerLazySingleton<UploadPicker>(() => const FileUploadPicker());
}

/// tasks'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> tasksOverrides(GetIt locator) => [
  taskCatalogRepositoryProvider.overrideWith(
    (ref) => locator<TaskCatalogRepository>(),
  ),
  taskDetailsRepositoryProvider.overrideWith(
    (ref) => locator<TaskDetailsRepository>(),
  ),
  taskWriteRepositoryProvider.overrideWith(
    (ref) => locator<TaskWriteRepository>(),
  ),
  downloadSinkProvider.overrideWith((ref) => locator<DownloadSink>()),
  uploadPickerProvider.overrideWith((ref) => locator<UploadPicker>()),
];
