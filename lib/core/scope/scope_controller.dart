import 'package:flutter/foundation.dart';

import '../logging/log.dart';
import 'scope_store.dart';

/// Seçili kapsam. Örtük varsayılan kapsam yoktur (C-04): S2 uçlar program, S3 uçlar ek olarak
/// departman seçimi ister; seçim yoksa istek GÖNDERİLMEZ (`client.scope_missing`).
@immutable
final class ScopeSelection {
  const ScopeSelection({
    this.programId,
    this.departmentId,
    this.sample = false,
  });
  final String? programId;
  final String? departmentId;

  /// Örnek kapsam (ürün sahibi 2026-10-29): oturum açık ama program yokken kabuk statik örnek
  /// verilerle açılır. Program kimliği YOKTUR: S2/S3 istekleri ara katmanda reddedilir
  /// (`client.scope_missing`), sunucuya sahte kimlik gitmez. Kalıcılaştırılmaz.
  final bool sample;

  /// Kabuk açık mı (`scoped` fazı): gerçek program seçimi ya da örnek kapsam.
  bool get hasProgram => sample || (programId != null && programId!.isNotEmpty);

  /// Sunucuya gönderilebilir program kimliği var mı (örnek kapsamda yok).
  bool get hasServerProgram => programId != null && programId!.isNotEmpty;
  bool get hasDepartment => departmentId != null && departmentId!.isNotEmpty;
}

/// Seçili kapsamın sahibi. Seçim bellekte anında uygulanır; güvenli depoya ([ScopeStore]) yazım
/// ve silme TEK sıralı kuyruktan geçer (SessionController yazım kuyruğunun emsali, O5):
/// - [clear] nesli artırır ve silmeyi kuyruğa SONA ekler; kuyruktaki ya da sürmekte olan
///   yazımlar silmeden önce biter ya da kendi neslini yitirdiği için hiç yazmaz. Çıkıştan sonra
///   depoya eski seçimin geri yazılması imkânsızdır.
/// - Yazım yalnız bir oturum sahibi ([attachOwner] geri çağrısı) varsa yapılır; oturum etkin
///   değilse seçim yalnız bellektedir.
/// - Yazma hatası seçimi bozmaz (bellekte kalır; kimlik loglanmaz). Silme hatası yutulmaz:
///   [storeAttempts] kez yerel yeniden denenir, sürerse uyarı loglanır; kalan kayıt yine de
///   yalnız AYNI hesap + kurulumun açılışında geri yüklenebilir ([restore] eşleşmeyi doğrular).
class ScopeController {
  ScopeController({ScopeStore? store}) : _persist = store;

  /// Yerel depo işlemlerinin (ağ yok) deneme sayısı.
  static const storeAttempts = 3;

  final ScopeStore? _persist;
  ScopeOwner? Function()? _owner;

  final ValueNotifier<ScopeSelection> _state = ValueNotifier(
    const ScopeSelection(),
  );

  Future<void> _tail = Future<void>.value();
  int _generation = 0;

  ValueListenable<ScopeSelection> get state => _state;
  ScopeSelection get current => _state.value;

  /// Bekleyen depo işlemlerinin (yazım/silme) bittiği an (testler ve kapanış için).
  Future<void> get settled => _tail;

  /// Geçerli oturum sahibini veren geri çağrı (bileşim kökü kablosu). `null` dönerse ya da
  /// geri çağrı yoksa seçim kalıcılaştırılmaz. Söküm için `attachOwner(null)`.
  void attachOwner(ScopeOwner? Function()? owner) => _owner = owner;

  void selectProgram(String programId) {
    _state.value = ScopeSelection(programId: programId);
    _persistSelection();
  }

  /// Örnek kapsam: kabuk statik verilerle açılır; depoya yazılmaz ([ScopeSelection.sample]).
  void selectSample() {
    _generation++;
    _state.value = const ScopeSelection(sample: true);
    _enqueue(_delete);
  }

  void selectDepartment(String departmentId) {
    _state.value = ScopeSelection(
      programId: _state.value.programId,
      departmentId: departmentId,
    );
    _persistSelection();
  }

  /// Seçimi bellekten siler ve kayıtlı seçimi siler (sıralı kuyruk, nesil artar).
  void clear() {
    _generation++;
    _state.value = const ScopeSelection();
    _enqueue(_delete);
  }

  /// Açılışta (oturum `SessionActive` geri yüklendikten SONRA) son seçimi geri yükler.
  /// Kayıt yalnız [owner] ile birebir eşleşirse uygulanır; eşleşmeyen, bozuk ya da okunamayan
  /// kayıt silinir ve seçim yapılmaz (fail-closed, C-04). Geri yüklendiyse `true`.
  Future<bool> restore(ScopeOwner owner) {
    final store = _persist;
    if (store == null) return Future.value(false);
    final gen = _generation;
    return _enqueue<bool>(() async {
      if (gen != _generation) return false;
      try {
        final saved = await store.load();
        if (gen != _generation) return false;
        if (saved != null && saved.owner == owner) {
          _state.value = saved.selection;
          return true;
        }
        if (saved != null || await store.exists()) {
          Log.info('kapsam: kayıt bu oturuma ait değil ya da bozuk; siliniyor');
          await _delete();
        }
      } on Object {
        Log.warn('kapsam: kayıt okunamadı; seçim geri yüklenmedi');
        await _delete();
      }
      return false;
    });
  }

  void _persistSelection() {
    final store = _persist;
    final owner = _owner?.call();
    if (store == null || owner == null) return;
    final gen = _generation;
    _enqueue(() async {
      // Kuyrukta beklerken çıkış/yeniden bağlanma olduysa yazılmaz.
      if (gen != _generation) return;
      final sel = _state.value;
      if (!sel.hasServerProgram) return;
      if (!await _attempt(() => store.save(owner, sel))) {
        Log.warn('kapsam: seçim kalıcılaştırılamadı; yalnız bellekte');
      }
    });
  }

  Future<void> _delete() async {
    final store = _persist;
    if (store == null) return;
    if (!await _attempt(store.clear)) {
      Log.warn('kapsam: kayıtlı seçim silinemedi');
    }
  }

  Future<T> _enqueue<T>(Future<T> Function() op) {
    final run = _tail.then((_) => op());
    _tail = run.then((_) {}, onError: (Object _) {});
    return run;
  }

  Future<bool> _attempt(Future<void> Function() op) async {
    for (var i = 0; i < storeAttempts; i++) {
      try {
        await op();
        return true;
      } on Object {
        // yerel depo hatası: yalnız yerel yeniden deneme
      }
    }
    return false;
  }
}
