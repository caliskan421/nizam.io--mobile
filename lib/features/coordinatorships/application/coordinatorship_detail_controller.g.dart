// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel bölümünden başlar).

@ProviderFor(CoordinatorshipDetailController)
final coordinatorshipDetailControllerProvider =
    CoordinatorshipDetailControllerFamily._();

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel bölümünden başlar).
final class CoordinatorshipDetailControllerProvider
    extends
        $NotifierProvider<
          CoordinatorshipDetailController,
          CoordinatorshipDetailView
        > {
  /// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
  /// Genel bölümünden başlar).
  CoordinatorshipDetailControllerProvider._({
    required CoordinatorshipDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coordinatorshipDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipDetailControllerHash();

  @override
  String toString() {
    return r'coordinatorshipDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CoordinatorshipDetailController create() => CoordinatorshipDetailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipDetailView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipDetailView>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoordinatorshipDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coordinatorshipDetailControllerHash() =>
    r'2121e75016b61f5fd1521010104d91611042bd87';

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel bölümünden başlar).

final class CoordinatorshipDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CoordinatorshipDetailController,
          CoordinatorshipDetailView,
          CoordinatorshipDetailView,
          CoordinatorshipDetailView,
          String
        > {
  CoordinatorshipDetailControllerFamily._()
    : super(
        retry: null,
        name: r'coordinatorshipDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
  /// Genel bölümünden başlar).

  CoordinatorshipDetailControllerProvider call(String code) =>
      CoordinatorshipDetailControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'coordinatorshipDetailControllerProvider';
}

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel bölümünden başlar).

abstract class _$CoordinatorshipDetailController
    extends $Notifier<CoordinatorshipDetailView> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  CoordinatorshipDetailView build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CoordinatorshipDetailView, CoordinatorshipDetailView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoordinatorshipDetailView, CoordinatorshipDetailView>,
              CoordinatorshipDetailView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
/// Eşzamanlı türetilir: iki kaynak (keepAlive) hazırsa ilk kare doludur; biri hatalıysa hata,
/// biri yükleniyorsa yükleniyor.

@ProviderFor(coordinatorshipDetail)
final coordinatorshipDetailProvider = CoordinatorshipDetailFamily._();

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
/// Eşzamanlı türetilir: iki kaynak (keepAlive) hazırsa ilk kare doludur; biri hatalıysa hata,
/// biri yükleniyorsa yükleniyor.

final class CoordinatorshipDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CoordinatorshipDetail?>,
          AsyncValue<CoordinatorshipDetail?>,
          AsyncValue<CoordinatorshipDetail?>
        >
    with $Provider<AsyncValue<CoordinatorshipDetail?>> {
  /// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
  /// Eşzamanlı türetilir: iki kaynak (keepAlive) hazırsa ilk kare doludur; biri hatalıysa hata,
  /// biri yükleniyorsa yükleniyor.
  CoordinatorshipDetailProvider._({
    required CoordinatorshipDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coordinatorshipDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipDetailHash();

  @override
  String toString() {
    return r'coordinatorshipDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<CoordinatorshipDetail?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<CoordinatorshipDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return coordinatorshipDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CoordinatorshipDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CoordinatorshipDetail?>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoordinatorshipDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coordinatorshipDetailHash() =>
    r'e769aa5e70bf5ab0bd2b22bd84ad6d1dded5d328';

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
/// Eşzamanlı türetilir: iki kaynak (keepAlive) hazırsa ilk kare doludur; biri hatalıysa hata,
/// biri yükleniyorsa yükleniyor.

final class CoordinatorshipDetailFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<CoordinatorshipDetail?>, String> {
  CoordinatorshipDetailFamily._()
    : super(
        retry: null,
        name: r'coordinatorshipDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
  /// Eşzamanlı türetilir: iki kaynak (keepAlive) hazırsa ilk kare doludur; biri hatalıysa hata,
  /// biri yükleniyorsa yükleniyor.

  CoordinatorshipDetailProvider call(String code) =>
      CoordinatorshipDetailProvider._(argument: code, from: this);

  @override
  String toString() => r'coordinatorshipDetailProvider';
}

/// Koordinatörlüğün ([code] = `department_id`) toplantıları, tarihe göre.

@ProviderFor(coordinatorshipMeetings)
final coordinatorshipMeetingsProvider = CoordinatorshipMeetingsFamily._();

/// Koordinatörlüğün ([code] = `department_id`) toplantıları, tarihe göre.

final class CoordinatorshipMeetingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoordMeeting>>,
          List<CoordMeeting>,
          FutureOr<List<CoordMeeting>>
        >
    with
        $FutureModifier<List<CoordMeeting>>,
        $FutureProvider<List<CoordMeeting>> {
  /// Koordinatörlüğün ([code] = `department_id`) toplantıları, tarihe göre.
  CoordinatorshipMeetingsProvider._({
    required CoordinatorshipMeetingsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coordinatorshipMeetingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipMeetingsHash();

  @override
  String toString() {
    return r'coordinatorshipMeetingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CoordMeeting>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoordMeeting>> create(Ref ref) {
    final argument = this.argument as String;
    return coordinatorshipMeetings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoordinatorshipMeetingsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coordinatorshipMeetingsHash() =>
    r'89ae7cc27bac0cfa17323246ef77c353d20d0f1c';

/// Koordinatörlüğün ([code] = `department_id`) toplantıları, tarihe göre.

final class CoordinatorshipMeetingsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CoordMeeting>>, String> {
  CoordinatorshipMeetingsFamily._()
    : super(
        retry: null,
        name: r'coordinatorshipMeetingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Koordinatörlüğün ([code] = `department_id`) toplantıları, tarihe göre.

  CoordinatorshipMeetingsProvider call(String code) =>
      CoordinatorshipMeetingsProvider._(argument: code, from: this);

  @override
  String toString() => r'coordinatorshipMeetingsProvider';
}

/// Koordinatörlüğün arşiv dosyaları (görevleri katalogdan; yeni önce).

@ProviderFor(coordinatorshipFiles)
final coordinatorshipFilesProvider = CoordinatorshipFilesFamily._();

/// Koordinatörlüğün arşiv dosyaları (görevleri katalogdan; yeni önce).

final class CoordinatorshipFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoordFile>>,
          List<CoordFile>,
          FutureOr<List<CoordFile>>
        >
    with $FutureModifier<List<CoordFile>>, $FutureProvider<List<CoordFile>> {
  /// Koordinatörlüğün arşiv dosyaları (görevleri katalogdan; yeni önce).
  CoordinatorshipFilesProvider._({
    required CoordinatorshipFilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'coordinatorshipFilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipFilesHash();

  @override
  String toString() {
    return r'coordinatorshipFilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CoordFile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoordFile>> create(Ref ref) {
    final argument = this.argument as String;
    return coordinatorshipFiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoordinatorshipFilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coordinatorshipFilesHash() =>
    r'61a74645bae9d42d22ae5cc4291509fc8023a540';

/// Koordinatörlüğün arşiv dosyaları (görevleri katalogdan; yeni önce).

final class CoordinatorshipFilesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CoordFile>>, String> {
  CoordinatorshipFilesFamily._()
    : super(
        retry: null,
        name: r'coordinatorshipFilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Koordinatörlüğün arşiv dosyaları (görevleri katalogdan; yeni önce).

  CoordinatorshipFilesProvider call(String code) =>
      CoordinatorshipFilesProvider._(argument: code, from: this);

  @override
  String toString() => r'coordinatorshipFilesProvider';
}
