// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_query_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner. Ömrü uygulama boyudur: prototipte
/// geçmişten ana sayfaya dönüp yeniden girince tür/kişi/koordinatörlük süzgeci korunur.

@ProviderFor(ActivityQueryController)
final activityQueryControllerProvider = ActivityQueryControllerProvider._();

/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner. Ömrü uygulama boyudur: prototipte
/// geçmişten ana sayfaya dönüp yeniden girince tür/kişi/koordinatörlük süzgeci korunur.
final class ActivityQueryControllerProvider
    extends $NotifierProvider<ActivityQueryController, ActivityQuery> {
  /// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
  /// Süzgeç değişince gösterilen sınır ilk sayfaya döner. Ömrü uygulama boyudur: prototipte
  /// geçmişten ana sayfaya dönüp yeniden girince tür/kişi/koordinatörlük süzgeci korunur.
  ActivityQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityQueryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityQueryControllerHash();

  @$internal
  @override
  ActivityQueryController create() => ActivityQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityQuery>(value),
    );
  }
}

String _$activityQueryControllerHash() =>
    r'520813f439487347603ff12c83b71def240cbfeb';

/// İşlem geçmişi süzgeci ve komutları (tür, arama, kişi, koordinatörlük, daha fazla göster).
/// Süzgeç değişince gösterilen sınır ilk sayfaya döner. Ömrü uygulama boyudur: prototipte
/// geçmişten ana sayfaya dönüp yeniden girince tür/kişi/koordinatörlük süzgeci korunur.

abstract class _$ActivityQueryController extends $Notifier<ActivityQuery> {
  ActivityQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ActivityQuery, ActivityQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityQuery, ActivityQuery>,
              ActivityQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).
/// Eşzamanlıdır: iki kaynak yüklüyse ilk karede veri döner (sayfa açılışında ve her süzgeç
/// değişiminde yükleniyor karesi yok); biri yüklenirken / hatadaysa o durum taşınır.

@ProviderFor(activityView)
final activityViewProvider = ActivityViewProvider._();

/// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).
/// Eşzamanlıdır: iki kaynak yüklüyse ilk karede veri döner (sayfa açılışında ve her süzgeç
/// değişiminde yükleniyor karesi yok); biri yüklenirken / hatadaysa o durum taşınır.

final class ActivityViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivityView>,
          AsyncValue<ActivityView>,
          AsyncValue<ActivityView>
        >
    with $Provider<AsyncValue<ActivityView>> {
  /// Süzgecin uygulanmış görünümü (kayıtlar + görev kataloğu kişi/koordinatörlük eşlemesi).
  /// Eşzamanlıdır: iki kaynak yüklüyse ilk karede veri döner (sayfa açılışında ve her süzgeç
  /// değişiminde yükleniyor karesi yok); biri yüklenirken / hatadaysa o durum taşınır.
  ActivityViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityViewHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<ActivityView>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<ActivityView> create(Ref ref) {
    return activityView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ActivityView> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ActivityView>>(value),
    );
  }
}

String _$activityViewHash() => r'a6a8df23006fc7b2d57d22d1b04c063f81e05583';
