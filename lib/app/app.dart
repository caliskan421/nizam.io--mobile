import 'package:flutter/material.dart';

import '../core/config/flavor.dart';

/// Minimal kabuk. Ekran yoktur (D-0174: ekran ve ürün tasarımı program dışı); MOB-0 yalnız
/// altyapıyı kurar.
class NizamioApp extends StatelessWidget {
  const NizamioApp({super.key, required this.flavor});

  final Flavor flavor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NIZAM.IO',
      debugShowCheckedModeBanner: flavor == Flavor.dev,
      home: const SizedBox.shrink(),
    );
  }
}
