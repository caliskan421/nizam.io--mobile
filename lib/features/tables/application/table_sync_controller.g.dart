// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
/// görünürken ve uygulama ön plandayken açıktır.
///
/// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
/// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
/// - Presence: bağlıyken 10 sn'de bir ve seçim değişince (en az 1 sn arayla) `POST …/presence`; kapanışta `DELETE`.

@ProviderFor(TableSyncController)
final tableSyncControllerProvider = TableSyncControllerFamily._();

/// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
/// görünürken ve uygulama ön plandayken açıktır.
///
/// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
/// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
/// - Presence: bağlıyken 10 sn'de bir ve seçim değişince (en az 1 sn arayla) `POST …/presence`; kapanışta `DELETE`.
final class TableSyncControllerProvider
    extends $NotifierProvider<TableSyncController, TableLiveState> {
  /// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
  /// görünürken ve uygulama ön plandayken açıktır.
  ///
  /// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
  ///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
  ///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
  ///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
  /// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
  ///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
  ///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
  /// - Presence: bağlıyken 10 sn'de bir ve seçim değişince (en az 1 sn arayla) `POST …/presence`; kapanışta `DELETE`.
  TableSyncControllerProvider._({
    required TableSyncControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tableSyncControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tableSyncControllerHash();

  @override
  String toString() {
    return r'tableSyncControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TableSyncController create() => TableSyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TableLiveState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TableLiveState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TableSyncControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tableSyncControllerHash() =>
    r'15030ec950720afe41f7786dd1ceb9e03a1b7399';

/// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
/// görünürken ve uygulama ön plandayken açıktır.
///
/// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
/// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
/// - Presence: bağlıyken 10 sn'de bir ve seçim değişince (en az 1 sn arayla) `POST …/presence`; kapanışta `DELETE`.

final class TableSyncControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TableSyncController,
          TableLiveState,
          TableLiveState,
          TableLiveState,
          String
        > {
  TableSyncControllerFamily._()
    : super(
        retry: null,
        name: r'tableSyncControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
  /// görünürken ve uygulama ön plandayken açıktır.
  ///
  /// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
  ///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
  ///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
  ///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
  /// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
  ///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
  ///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
  /// - Presence: bağlıyken 10 sn'de bir ve seçim değişince (en az 1 sn arayla) `POST …/presence`; kapanışta `DELETE`.

  TableSyncControllerProvider call(String id) =>
      TableSyncControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'tableSyncControllerProvider';
}

/// Tablo akışının (SSE `streamTableChanges`) TEK bağlantı döngüsü ve presence. Ekran
/// görünürken ve uygulama ön plandayken açıktır.
///
/// - `ready`/`changed(s)` içeriksiz ipuçtur: `s` tüketilmiş imleçten büyükse
///   1 sn birleştirmeden sonra ([tableLiveTimingProvider]) [TableController.catchUp] çalışır; aynı anda tek
///   yakalama uçuştadır, uçuşta gelen ipuçları tek bekleyen yakalamada toplanır (okuma
///   kotası 600/dk). Yeniden bağlanınca `ready` imleçten yakalamayı tetikler.
/// - Kopma: 0–5 sn jitter + üstel geri çekilme (≤60 sn; `core/domain/stream_reconnect`);
///   401/403/404/422 durur, 429 `Retry-After` bekler. Sunucu kapanışı (5 dk bütçe, erişim
///   commit'i, belirteç yenilemesi sonrası gözcü) neden bildirmez: normal yeniden bağlanmadır.
/// - Presence: bağlıyken 10 sn'de bir ve seçim değişince (en az 1 sn arayla) `POST …/presence`; kapanışta `DELETE`.

abstract class _$TableSyncController extends $Notifier<TableLiveState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  TableLiveState build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TableLiveState, TableLiveState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TableLiveState, TableLiveState>,
              TableLiveState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
