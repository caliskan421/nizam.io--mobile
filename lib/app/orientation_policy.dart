import 'dart:async';
import 'dart:ui' show Display, FlutterView;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../core/logging/log.dart';

/// Yön kilidi eşiği (mantıksal dp). Fiziksel ekranın kısa kenarı bunun altındaysa cihaz
/// telefondur ve dikey kilitlenir. Yerleşim sınıflarından (WindowClass) bilerek ayrıdır:
/// bu karar pencereye değil cihaza bakar.
const double kOrientationLockShortestSide = 600;

/// Uygulamanın istediği yön politikası.
enum OrientationPolicy {
  /// Yalnız dikey (telefon).
  portraitOnly,

  /// İşletim sistemi varsayılanı (tablet, katlanabilir, bilinmeyen ekran).
  systemDefault,
}

/// Fiziksel ekran boyutu ve yoğunluğundan yön politikası. Geçersiz ölçü (NaN, sonsuz, sıfır,
/// negatif) kilitlemez: bilinmeyen ekranda OS varsayılanı korunur.
OrientationPolicy orientationPolicyFor(
  Size physicalSize,
  double devicePixelRatio,
) {
  final valid =
      devicePixelRatio.isFinite &&
      devicePixelRatio > 0 &&
      physicalSize.width.isFinite &&
      physicalSize.height.isFinite &&
      physicalSize.width > 0 &&
      physicalSize.height > 0;
  if (!valid) return OrientationPolicy.systemDefault;
  final shortestSide = physicalSize.shortestSide / devicePixelRatio;
  return shortestSide < kOrientationLockShortestSide
      ? OrientationPolicy.portraitOnly
      : OrientationPolicy.systemDefault;
}

/// Politikanın platform karşılığı; boş liste OS varsayılanıdır.
List<DeviceOrientation> orientationsFor(OrientationPolicy policy) =>
    switch (policy) {
      OrientationPolicy.portraitOnly => const [DeviceOrientation.portraitUp],
      OrientationPolicy.systemDefault => const [],
    };

/// Android'de fiziksel ekrana göre yön politikasını uygular; diğer platformlarda (iOS
/// Info.plist ile kilitlenir, web) yalnız [child]'ı döndürür. Pencere/MediaQuery boyutu
/// kullanılmaz: bölünmüş ekran ya da letterbox tableti kilitlemez. Ağaçta her platformda
/// durur, böylece altındaki ağacın kimliği platform kararından etkilenmez.
class OrientationPolicyHost extends StatefulWidget {
  const OrientationPolicyHost({super.key, required this.child});

  final Widget child;

  @override
  State<OrientationPolicyHost> createState() => _OrientationPolicyHostState();
}

class _OrientationPolicyHostState extends State<OrientationPolicyHost>
    with WidgetsBindingObserver {
  late final bool _enabled =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  FlutterView? _view;

  /// Son istenen (uçuşta ya da başarılı) politika; başarısız son çağrı bunu temizler ki
  /// sonraki gerçek metrik olayı yeniden denesin.
  OrientationPolicy? _requested;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    if (_enabled) WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_enabled) return;
    _view = View.of(context);
    _evaluate();
  }

  @override
  void didChangeMetrics() => _evaluate();

  @override
  void dispose() {
    if (_enabled) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _evaluate() {
    final view = _view;
    if (view == null) return;
    final Display display;
    try {
      display = view.display;
    } on StateError {
      _apply(OrientationPolicy.systemDefault);
      return;
    }
    _apply(orientationPolicyFor(display.size, display.devicePixelRatio));
  }

  void _apply(OrientationPolicy policy) {
    if (policy == _requested) return;
    _requested = policy;
    final generation = ++_generation;
    unawaited(
      SystemChrome.setPreferredOrientations(orientationsFor(policy)).then(
        (_) {},
        onError: (Object _) {
          // Daha yeni bir istek varsa onun kaydı korunur.
          if (generation != _generation) return;
          _requested = null;
          Log.warn('orientation policy could not be applied');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
