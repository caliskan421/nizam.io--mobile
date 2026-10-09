import 'package:flutter/widgets.dart';

/// Arka plan ekran maskesi altyapısı (F14 kapsam 9; ADR-0006). Uygulama ön planda değilken
/// (inactive/hidden/paused) [masked] açılır; [PrivacyMask] içeriğin üstüne opak bir katman
/// koyar — görev değiştiricideki anlık görüntüde içerik görünmez. Ekran yoktur; ekran
/// çalışması bu sarmalayıcıyı kullanır.
class PrivacyMaskController extends ValueNotifier<bool> {
  PrivacyMaskController() : super(false) {
    _listener = AppLifecycleListener(onStateChange: _onState);
  }

  late final AppLifecycleListener _listener;

  void _onState(AppLifecycleState s) => value = s != AppLifecycleState.resumed;

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}

class PrivacyMask extends StatelessWidget {
  const PrivacyMask({
    super.key,
    required this.controller,
    required this.child,
    this.color = const Color(0xFF000000),
  });

  final PrivacyMaskController controller;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      child: child,
      builder: (context, masked, child) => Stack(
        textDirection: TextDirection.ltr,
        children: [
          child!,
          if (masked)
            Positioned.fill(
              child: ColoredBox(
                key: const ValueKey('privacy-mask'),
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
