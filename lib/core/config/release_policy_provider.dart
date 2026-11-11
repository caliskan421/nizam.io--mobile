import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mobile_release_policy.dart';

/// Kaynağın yaşam döngüsü bileşim köküne aittir; core Firebase tanımaz.
final releasePolicySourceProvider = Provider<ReleasePolicySource>(
  (ref) => throw UnimplementedError(
    'releasePolicySourceProvider bileşim kökünde bağlanır',
  ),
);
