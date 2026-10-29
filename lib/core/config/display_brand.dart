import 'flavor.dart';
import 'generated/app_version.gen.dart';

/// Ekranda görünen ürün adı ve sürüm etiketi (giriş başlığı, çekmece alt satırı).
///
/// - prod: [name] null → ARB ürün adı; [version] gerçek uygulama sürümü ([appVersion]).
/// - dev (prototip kipi = tasarım demosu): tasarım sunumundaki değerler (`12-Tablet`:
///   "RoketPortal", "v2.0"). Yalnız görünen metindir; paket kimliği, sürüm meta verisi ve
///   sunucuya bildirilen sürüm ([appVersion]) değişmez.
({String? name, String version}) displayBrand(Flavor flavor) =>
    switch (flavor) {
      Flavor.dev => (name: designDemoProductName, version: designDemoVersion),
      Flavor.prod => (name: null, version: appVersion),
    };

/// Tasarım prototipinin ürün adı ve sürüm etiketi (yalnız demo sunumu).
const designDemoProductName = 'RoketPortal';
const designDemoVersion = '2.0';
