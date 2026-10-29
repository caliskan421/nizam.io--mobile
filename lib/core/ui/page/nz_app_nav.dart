import 'package:flutter/widgets.dart';

/// Görev listesinin açılış görünümü (ana sayfa özet kutuları, çekmece rozetleri). Görünüm
/// adıdır; hangi görevin hangi görünüme düştüğünü görevler ekranı belirler.
enum NzTaskView { all, late, inProgress, review, dateRequest, notStarted, done }

/// Ekranlar arası gezinme niyetleri (feature'lar birbirinin rotasını bilmez; rota tanımları
/// `app/router`'dadır, B2). Yalnız kimlik taşır (N1). Gerçekleştirme uygulama kökünde
/// ([NzAppNavScope]); testler sahtesini verir.
abstract interface class NzAppNav {
  void openHome();
  void openHistory();

  /// Görev listesi; [view] ve [people] (kişi kimlikleri) başlangıç süzgecidir.
  void openTasks({NzTaskView? view, List<String> people});
  void openTask(String code);

  /// Takvim modülü.
  void openCalendar();

  /// Zaman çizelgesi; [coordinatorship] verilirse o koordinatörlük seçili açılır.
  void openTimeline({String? coordinatorship});
  void openCoordinatorships();
  void openCoordinatorship(String code);
  void openArchive();
  void openArchiveFolder(String code);
  void openMessages();
  void openChat(String id);
  void openProfile();

  /// Sağdan açılan uygulama menüsü (tüm modüller, kapsam, çıkış); kök sayfaların üst çubuğundaki
  /// cam menü dairesi çağırır.
  void openMenu(BuildContext context);
}

/// Ağaçta [NzAppNav] sağlar. `NzAppNav.of(context)` yerine `context.appNav`.
class NzAppNavScope extends InheritedWidget {
  const NzAppNavScope({super.key, required this.nav, required super.child});

  final NzAppNav nav;

  static NzAppNav of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<NzAppNavScope>();
    assert(scope != null, 'NzAppNavScope yok: uygulama kökü (app.dart) sağlar');
    return scope!.nav;
  }

  @override
  bool updateShouldNotify(NzAppNavScope old) => old.nav != nav;
}

extension NzAppNavContext on BuildContext {
  NzAppNav get appNav => NzAppNavScope.of(this);
}
