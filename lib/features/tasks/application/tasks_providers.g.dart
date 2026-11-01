// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).

@ProviderFor(taskCatalogRepository)
final taskCatalogRepositoryProvider = TaskCatalogRepositoryProvider._();

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).

final class TaskCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          TaskCatalogRepository,
          TaskCatalogRepository,
          TaskCatalogRepository
        >
    with $Provider<TaskCatalogRepository> {
  /// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).
  TaskCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskCatalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskCatalogRepository create(Ref ref) {
    return taskCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskCatalogRepository>(value),
    );
  }
}

String _$taskCatalogRepositoryHash() =>
    r'6d0e23a696c86368f3caff7e70c58abf30142216';

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).

@ProviderFor(taskDetailsRepository)
final taskDetailsRepositoryProvider = TaskDetailsRepositoryProvider._();

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).

final class TaskDetailsRepositoryProvider
    extends
        $FunctionalProvider<
          TaskDetailsRepository,
          TaskDetailsRepository,
          TaskDetailsRepository
        >
    with $Provider<TaskDetailsRepository> {
  /// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).
  TaskDetailsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskDetailsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskDetailsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskDetailsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskDetailsRepository create(Ref ref) {
    return taskDetailsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskDetailsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskDetailsRepository>(value),
    );
  }
}

String _$taskDetailsRepositoryHash() =>
    r'b978f27c0a256d8c8b40088a981c52a6d63892d1';

/// PORT: görev yazmalarının kaynağı (`tasks_module.dart`'ta bağlanır; yalnız sunucu).

@ProviderFor(taskWriteRepository)
final taskWriteRepositoryProvider = TaskWriteRepositoryProvider._();

/// PORT: görev yazmalarının kaynağı (`tasks_module.dart`'ta bağlanır; yalnız sunucu).

final class TaskWriteRepositoryProvider
    extends
        $FunctionalProvider<
          TaskWriteRepository,
          TaskWriteRepository,
          TaskWriteRepository
        >
    with $Provider<TaskWriteRepository> {
  /// PORT: görev yazmalarının kaynağı (`tasks_module.dart`'ta bağlanır; yalnız sunucu).
  TaskWriteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskWriteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskWriteRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskWriteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskWriteRepository create(Ref ref) {
    return taskWriteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskWriteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskWriteRepository>(value),
    );
  }
}

String _$taskWriteRepositoryHash() =>
    r'adf7d8aff2050fb745c92eab5ac61b72372a4574';

/// PORT: sistem dosya seçicisi (`tasks_module.dart`'ta `FileUploadPicker` bağlanır).
/// Bağlanmamışsa (testler) "yok" gerçekleştirmesi: form dosya seçtiremez, istek gönderilmez.

@ProviderFor(uploadPicker)
final uploadPickerProvider = UploadPickerProvider._();

/// PORT: sistem dosya seçicisi (`tasks_module.dart`'ta `FileUploadPicker` bağlanır).
/// Bağlanmamışsa (testler) "yok" gerçekleştirmesi: form dosya seçtiremez, istek gönderilmez.

final class UploadPickerProvider
    extends $FunctionalProvider<UploadPicker, UploadPicker, UploadPicker>
    with $Provider<UploadPicker> {
  /// PORT: sistem dosya seçicisi (`tasks_module.dart`'ta `FileUploadPicker` bağlanır).
  /// Bağlanmamışsa (testler) "yok" gerçekleştirmesi: form dosya seçtiremez, istek gönderilmez.
  UploadPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadPickerHash();

  @$internal
  @override
  $ProviderElement<UploadPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UploadPicker create(Ref ref) {
    return uploadPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadPicker>(value),
    );
  }
}

String _$uploadPickerHash() => r'0748ecb6edf44f81d4cb239af148e8348b283698';

/// PORT: indirilen dosyanın kaydı (`tasks_module.dart`'ta bağlanır).

@ProviderFor(downloadSink)
final downloadSinkProvider = DownloadSinkProvider._();

/// PORT: indirilen dosyanın kaydı (`tasks_module.dart`'ta bağlanır).

final class DownloadSinkProvider
    extends $FunctionalProvider<DownloadSink, DownloadSink, DownloadSink>
    with $Provider<DownloadSink> {
  /// PORT: indirilen dosyanın kaydı (`tasks_module.dart`'ta bağlanır).
  DownloadSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadSinkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadSinkHash();

  @$internal
  @override
  $ProviderElement<DownloadSink> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DownloadSink create(Ref ref) {
    return downloadSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadSink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadSink>(value),
    );
  }
}

String _$downloadSinkHash() => r'24a2dcc97c064f09d64a4ecc2e5f31b9973f3c7f';

/// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
/// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
/// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).

@ProviderFor(taskTeam)
final taskTeamProvider = TaskTeamFamily._();

/// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
/// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
/// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).

final class TaskTeamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TeamMember>>,
          List<TeamMember>,
          FutureOr<List<TeamMember>>
        >
    with $FutureModifier<List<TeamMember>>, $FutureProvider<List<TeamMember>> {
  /// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
  /// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
  /// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).
  TaskTeamProvider._({
    required TaskTeamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskTeamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskTeamHash();

  @override
  String toString() {
    return r'taskTeamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TeamMember>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TeamMember>> create(Ref ref) {
    final argument = this.argument as String;
    return taskTeam(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskTeamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskTeamHash() => r'8d61f7dc9268a9f719dbd641d0071b571f0a333b';

/// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
/// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
/// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).

final class TaskTeamFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TeamMember>>, String> {
  TaskTeamFamily._()
    : super(
        retry: null,
        name: r'taskTeamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Departman ekibi ([departmentId]; görev ataması adayları). Yalnız yönetici ya da o
  /// departmanın koordinatörü okur ([TaskAccess.canReadTeamIn]); sunucu kataloğunda yetkisiz
  /// hesapta `listMembers` ÇAĞRILMAZ, `work.not_authorized` döner (üye 403 alırdı).

  TaskTeamProvider call(String departmentId) =>
      TaskTeamProvider._(argument: departmentId, from: this);

  @override
  String toString() => r'taskTeamProvider';
}
