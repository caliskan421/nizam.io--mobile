import 'window_class.dart';

/// Pencere sınıfına göre değer. Eksik sınıf bir küçüğüne düşer:
/// `medium ?? compact`, `expanded ?? medium ?? compact`.
///
/// `T` null kabul eden bir tür ise null "verilmedi" sayılır.
class AdaptiveValue<T> {
  const AdaptiveValue({required this.compact, this.medium, this.expanded});

  final T compact;
  final T? medium;
  final T? expanded;

  T resolve(WindowClass windowClass) => switch (windowClass) {
    WindowClass.compact => compact,
    WindowClass.medium => medium ?? compact,
    WindowClass.expanded => expanded ?? medium ?? compact,
  };
}
