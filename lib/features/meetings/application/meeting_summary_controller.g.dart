// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_summary_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kart başına ayrıntı isteklerinin eşzamanlılık sınırı (ürün kararı: liste ucu sayaç ve
/// konferans taşımaz, kart ayrıntıdan doldurulur; aynı anda en çok 4 istek).

@ProviderFor(meetingDetailPool)
final meetingDetailPoolProvider = MeetingDetailPoolProvider._();

/// Kart başına ayrıntı isteklerinin eşzamanlılık sınırı (ürün kararı: liste ucu sayaç ve
/// konferans taşımaz, kart ayrıntıdan doldurulur; aynı anda en çok 4 istek).

final class MeetingDetailPoolProvider
    extends $FunctionalProvider<RequestPool, RequestPool, RequestPool>
    with $Provider<RequestPool> {
  /// Kart başına ayrıntı isteklerinin eşzamanlılık sınırı (ürün kararı: liste ucu sayaç ve
  /// konferans taşımaz, kart ayrıntıdan doldurulur; aynı anda en çok 4 istek).
  MeetingDetailPoolProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingDetailPoolProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingDetailPoolHash();

  @$internal
  @override
  $ProviderElement<RequestPool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RequestPool create(Ref ref) {
    return meetingDetailPool(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestPool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestPool>(value),
    );
  }
}

String _$meetingDetailPoolHash() => r'aab389cb520023532691c22dea3d23a4ba83fe3a';

/// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
/// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.

@ProviderFor(MeetingSummaryController)
final meetingSummaryControllerProvider = MeetingSummaryControllerFamily._();

/// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
/// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.
final class MeetingSummaryControllerProvider
    extends $AsyncNotifierProvider<MeetingSummaryController, MeetingSummary> {
  /// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
  /// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.
  MeetingSummaryControllerProvider._({
    required MeetingSummaryControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'meetingSummaryControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$meetingSummaryControllerHash();

  @override
  String toString() {
    return r'meetingSummaryControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MeetingSummaryController create() => MeetingSummaryController();

  @override
  bool operator ==(Object other) {
    return other is MeetingSummaryControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$meetingSummaryControllerHash() =>
    r'576ec6ee0ee1832ee3ef8fc8937599196c7d0d07';

/// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
/// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.

final class MeetingSummaryControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MeetingSummaryController,
          AsyncValue<MeetingSummary>,
          MeetingSummary,
          FutureOr<MeetingSummary>,
          String
        > {
  MeetingSummaryControllerFamily._()
    : super(
        retry: null,
        name: r'meetingSummaryControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
  /// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.

  MeetingSummaryControllerProvider call(String id) =>
      MeetingSummaryControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'meetingSummaryControllerProvider';
}

/// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
/// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.

abstract class _$MeetingSummaryController
    extends $AsyncNotifier<MeetingSummary> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<MeetingSummary> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MeetingSummary>, MeetingSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MeetingSummary>, MeetingSummary>,
              AsyncValue<MeetingSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
