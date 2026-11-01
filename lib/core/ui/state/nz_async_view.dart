import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../errors/api_error.dart';
import '../widgets/feedback/nz_error_state.dart';
import '../widgets/feedback/nz_skeleton.dart';

/// [AsyncValue] → yükleniyor / hata / boş / veri.
///
/// - İlk yükleme (henüz değer yok): [loading] ya da genel parıltılı iskelet
///   (`NzSkeleton.page()`). Ekrana özgü iskelet [loading] ile verilir (gerçek düzene benzer).
/// - Hata: [NzErrorState] (`toApiError`; ApiError dışı istisna `client.invalid_response`
///   olur, ham istisna sızmaz).
/// - Yenileme (önceki veri varken; `invalidate`/`refresh`, aşağı çekerek yenileme, yeniden
///   ziyaret): eski veri yerinde kalır, yeni veri gelince yerinde güncellenir — iskelet ya da
///   gösterge YOK (Riverpod `skipLoadingOnRefresh`). Yenileme hatasında da önceki veri
///   gösterilmeye devam eder — hata `ref.listenErrors` / `NzPage.onRefresh` ile bildirilir.
/// - Bağımlılık değişimiyle yeniden kurulum (`ref.watch`, ör. kapsam değişimi —
///   `AsyncValue.isReloading`): varsayılan olarak eski veri kalır; [skeletonOnReload] true ise
///   veri başka bir kümeye aittir ve iskelet gösterilir (önceki programın/hesabın verisi yeni
///   kapsamın altında görünmez).
/// - Veri: [isEmpty] true ise [empty] (verilmediyse [data] çağrılır), değilse [data].
class NzAsyncView<T> extends StatelessWidget {
  const NzAsyncView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.loading,
    this.skeletonOnReload = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  /// İlk yükleme görünümü (ekrana özgü iskelet; örn. `NzSkeleton.list()`); null → genel
  /// sayfa iskeleti.
  final Widget? loading;

  /// Bağımlılık değişimiyle yeniden kurulurken ([AsyncValue.isReloading]) eski veri yerine
  /// iskelet (bkz. sınıf belgesi).
  final bool skeletonOnReload;

  @override
  Widget build(BuildContext context) {
    final skeleton = loading ?? const NzSkeleton.page();
    if (skeletonOnReload && value.isReloading) return skeleton;
    // hasValue: veri, yenilenirken (isLoading) ve yenileme hatasında (AsyncError) da önceki
    // değeri taşır → ekran boşalıp yanıp sönmez.
    if (value.hasValue) {
      final v = value.requireValue;
      final emptyView = empty;
      if (emptyView != null && (isEmpty?.call(v) ?? false)) return emptyView;
      return data(v);
    }
    // Hatadan sonra yeniden yükleme (AsyncLoading) önceki hatayı taşır; yükleniyor görünümü
    // hata görünümünden önce gelir ki "yeniden dene" sonrası geri bildirim görünsün.
    if (value.isLoading) return skeleton;
    return NzErrorState(error: toApiError(value.error!), onRetry: onRetry);
  }
}
