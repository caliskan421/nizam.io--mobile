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

/// PORT: görevler ekranının departman süzgeçli okuması (`tasks_module.dart`'ta bağlanır).

@ProviderFor(taskListRepository)
final taskListRepositoryProvider = TaskListRepositoryProvider._();

/// PORT: görevler ekranının departman süzgeçli okuması (`tasks_module.dart`'ta bağlanır).

final class TaskListRepositoryProvider
    extends
        $FunctionalProvider<
          TaskListRepository,
          TaskListRepository,
          TaskListRepository
        >
    with $Provider<TaskListRepository> {
  /// PORT: görevler ekranının departman süzgeçli okuması (`tasks_module.dart`'ta bağlanır).
  TaskListRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskListRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskListRepository create(Ref ref) {
    return taskListRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskListRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskListRepository>(value),
    );
  }
}

String _$taskListRepositoryHash() =>
    r'9a5bcb9e7b1bfb6889b94f73f4f1f08b55b3f389';

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

/// PORT: toplantı yazmaları (hızlı toplantı formu, nottan görev). Gerçekleştirme meetings
/// feature'ındadır; bileşim kökünde bağlanır.

@ProviderFor(meetingPlanner)
final meetingPlannerProvider = MeetingPlannerProvider._();

/// PORT: toplantı yazmaları (hızlı toplantı formu, nottan görev). Gerçekleştirme meetings
/// feature'ındadır; bileşim kökünde bağlanır.

final class MeetingPlannerProvider
    extends $FunctionalProvider<MeetingPlanner, MeetingPlanner, MeetingPlanner>
    with $Provider<MeetingPlanner> {
  /// PORT: toplantı yazmaları (hızlı toplantı formu, nottan görev). Gerçekleştirme meetings
  /// feature'ındadır; bileşim kökünde bağlanır.
  MeetingPlannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingPlannerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingPlannerHash();

  @$internal
  @override
  $ProviderElement<MeetingPlanner> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MeetingPlanner create(Ref ref) {
    return meetingPlanner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingPlanner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingPlanner>(value),
    );
  }
}

String _$meetingPlannerHash() => r'aad57cfc5c031795fe4b62aca040e00aa964c892';

/// PORT: kişi kipindeki toplantının program havuzu (`tasks_module.dart`'ta bağlanır).

@ProviderFor(meetingInviteeRepository)
final meetingInviteeRepositoryProvider = MeetingInviteeRepositoryProvider._();

/// PORT: kişi kipindeki toplantının program havuzu (`tasks_module.dart`'ta bağlanır).

final class MeetingInviteeRepositoryProvider
    extends
        $FunctionalProvider<
          MeetingInviteeRepository,
          MeetingInviteeRepository,
          MeetingInviteeRepository
        >
    with $Provider<MeetingInviteeRepository> {
  /// PORT: kişi kipindeki toplantının program havuzu (`tasks_module.dart`'ta bağlanır).
  MeetingInviteeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingInviteeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingInviteeRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeetingInviteeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeetingInviteeRepository create(Ref ref) {
    return meetingInviteeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingInviteeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingInviteeRepository>(value),
    );
  }
}

String _$meetingInviteeRepositoryHash() =>
    r'8a72813fd366ff8ea89263139af25fc40a741a32';

/// PORT: mesajdan görev ("mesajdan görev" kipindeki yeni görev formu). Gerçekleştirme messages
/// feature'ındadır; bileşim kökünde bağlanır.

@ProviderFor(chatTaskPlanner)
final chatTaskPlannerProvider = ChatTaskPlannerProvider._();

/// PORT: mesajdan görev ("mesajdan görev" kipindeki yeni görev formu). Gerçekleştirme messages
/// feature'ındadır; bileşim kökünde bağlanır.

final class ChatTaskPlannerProvider
    extends
        $FunctionalProvider<ChatTaskPlanner, ChatTaskPlanner, ChatTaskPlanner>
    with $Provider<ChatTaskPlanner> {
  /// PORT: mesajdan görev ("mesajdan görev" kipindeki yeni görev formu). Gerçekleştirme messages
  /// feature'ındadır; bileşim kökünde bağlanır.
  ChatTaskPlannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatTaskPlannerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatTaskPlannerHash();

  @$internal
  @override
  $ProviderElement<ChatTaskPlanner> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatTaskPlanner create(Ref ref) {
    return chatTaskPlanner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatTaskPlanner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatTaskPlanner>(value),
    );
  }
}

String _$chatTaskPlannerHash() => r'cccfe08f9cafdcdf2e3ba2b3aef0e7e187077c1a';

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

/// PORT: yükleme içerik özeti (`tasks_module.dart`'ta `uploadDigest` bağlanır). Yalnız görev
/// ve arşiv yükleme gönderiminde, tür/boyut ön denetiminden sonra okunur.

@ProviderFor(uploadDigester)
final uploadDigesterProvider = UploadDigesterProvider._();

/// PORT: yükleme içerik özeti (`tasks_module.dart`'ta `uploadDigest` bağlanır). Yalnız görev
/// ve arşiv yükleme gönderiminde, tür/boyut ön denetiminden sonra okunur.

final class UploadDigesterProvider
    extends $FunctionalProvider<UploadDigest, UploadDigest, UploadDigest>
    with $Provider<UploadDigest> {
  /// PORT: yükleme içerik özeti (`tasks_module.dart`'ta `uploadDigest` bağlanır). Yalnız görev
  /// ve arşiv yükleme gönderiminde, tür/boyut ön denetiminden sonra okunur.
  UploadDigesterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadDigesterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadDigesterHash();

  @$internal
  @override
  $ProviderElement<UploadDigest> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UploadDigest create(Ref ref) {
    return uploadDigester(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadDigest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadDigest>(value),
    );
  }
}

String _$uploadDigesterHash() => r'c56f95b0664eac7333cba1cacc8524576a2c938a';

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

/// Kişi kipindeki toplantının davet havuzu (toplantı formu ve ayrıntıdaki "katılımcı ekle").
/// Şirket yöneticisi: kataloğun bütün ekipleri (programın departmanları okunur). Koordinatör:
/// kendi ekipleri (katalog) + programın geri kalanı ([MeetingInviteeRepository], koordinatörü
/// olunan ilk departman üzerinden). Havuz okunamazsa ya da koordinatörlük yoksa yalnız
/// katalogdaki ekipler, [MeetingInvitees.partial] ile (ekran kısıtı açıkça yazar).

@ProviderFor(meetingInvitees)
final meetingInviteesProvider = MeetingInviteesProvider._();

/// Kişi kipindeki toplantının davet havuzu (toplantı formu ve ayrıntıdaki "katılımcı ekle").
/// Şirket yöneticisi: kataloğun bütün ekipleri (programın departmanları okunur). Koordinatör:
/// kendi ekipleri (katalog) + programın geri kalanı ([MeetingInviteeRepository], koordinatörü
/// olunan ilk departman üzerinden). Havuz okunamazsa ya da koordinatörlük yoksa yalnız
/// katalogdaki ekipler, [MeetingInvitees.partial] ile (ekran kısıtı açıkça yazar).

final class MeetingInviteesProvider
    extends
        $FunctionalProvider<
          AsyncValue<MeetingInvitees>,
          MeetingInvitees,
          FutureOr<MeetingInvitees>
        >
    with $FutureModifier<MeetingInvitees>, $FutureProvider<MeetingInvitees> {
  /// Kişi kipindeki toplantının davet havuzu (toplantı formu ve ayrıntıdaki "katılımcı ekle").
  /// Şirket yöneticisi: kataloğun bütün ekipleri (programın departmanları okunur). Koordinatör:
  /// kendi ekipleri (katalog) + programın geri kalanı ([MeetingInviteeRepository], koordinatörü
  /// olunan ilk departman üzerinden). Havuz okunamazsa ya da koordinatörlük yoksa yalnız
  /// katalogdaki ekipler, [MeetingInvitees.partial] ile (ekran kısıtı açıkça yazar).
  MeetingInviteesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingInviteesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingInviteesHash();

  @$internal
  @override
  $FutureProviderElement<MeetingInvitees> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MeetingInvitees> create(Ref ref) {
    return meetingInvitees(ref);
  }
}

String _$meetingInviteesHash() => r'2cf73b5e8c623282bd8e5e0a56f092aa3cd59159';
