import 'package:flutter/widgets.dart';

/// Metin ölçeği üst sınırı: kullanıcı ölçeği saygı görür, [maxScaleFactor]'ü aşmaz.
/// Tek yerde (kabukta) uygulanır; bileşenler kendi sınırını koymaz.
class NzTextScaleLimit extends StatelessWidget {
  const NzTextScaleLimit({
    super.key,
    this.maxScaleFactor = defaultMaxScaleFactor,
    required this.child,
  });

  static const double defaultMaxScaleFactor = 2.0;

  final double maxScaleFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    maxScaleFactor: maxScaleFactor,
    child: child,
  );
}
