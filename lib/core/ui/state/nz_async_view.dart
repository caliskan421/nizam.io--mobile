import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../errors/api_error.dart';
import '../widgets/feedback/nz_error_state.dart';
import '../widgets/feedback/nz_loader.dart';

/// [AsyncValue] → yükleniyor / hata / boş / veri.
///
/// - İlk yükleme: [loading] ya da `NzLoader.page()`.
/// - Hata: [NzErrorState] (`toApiError`; ApiError dışı istisna `client.invalid_response`
///   olur, ham istisna sızmaz).
/// - Yenileme (önceki veri varken): eski veri gösterilir; yenileme hatasında da önceki veri
///   gösterilmeye devam eder — hata `ref.listenErrors` ile bildirilir.
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
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  /// İlk yükleme görünümü (örn. `NzSkeleton.list()`).
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    // hasValue: veri, yenilenirken (AsyncLoading) ve yenileme hatasında (AsyncError) da
    // önceki değeri taşır → ekran boşalıp yanıp sönmez.
    if (value.hasValue) {
      final v = value.requireValue;
      final emptyView = empty;
      if (emptyView != null && (isEmpty?.call(v) ?? false)) return emptyView;
      return data(v);
    }
    if (value.hasError) {
      return NzErrorState(error: toApiError(value.error!), onRetry: onRetry);
    }
    return loading ?? const NzLoader.page();
  }
}
