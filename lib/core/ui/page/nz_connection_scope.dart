import 'package:flutter/widgets.dart';

import '../../network/connectivity_monitor.dart';

/// Sayfanın ([NzPage]) bağlantı durumu; altındaki hata görünümü ([NzErrorState]) bağlantı
/// tasarımını ve kendiliğinden yenilemeyi buradan okur (Riverpod'a bağlanmadan).
class NzConnectionScope extends InheritedWidget {
  const NzConnectionScope({
    super.key,
    required this.state,
    required super.child,
  });

  final ConnectivityState state;

  /// Sayfa dışında (sayfasız test, alt pencere kökü) null.
  static ConnectivityState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NzConnectionScope>()?.state;

  @override
  bool updateShouldNotify(NzConnectionScope oldWidget) =>
      oldWidget.state != state;
}
