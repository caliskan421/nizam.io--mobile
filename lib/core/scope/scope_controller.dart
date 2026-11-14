import 'package:flutter/foundation.dart';

import '../domain/effective_role.dart';
import '../logging/log.dart';
import '../telemetry/report_source.dart';
import '../telemetry/unexpected_error.dart';
import 'scope_store.dart';

/// Seçili kapsam: etkin görünüm üçlüsü program × rol × koordinatörlük. Örtük varsayılan
/// program yoktur (C-04): S2 uçlar program, S3 uçlar ek olarak departman seçimi ister; seçim
/// yoksa istek GÖNDERİLMEZ (`client.scope_missing`).
///
/// [role] ve [departmentId] kullanıcının seçimidir; `null` → varsayılan erişim kaynağında
/// türetilir ([ScopeGrants.resolve]). Etkin değerin tek okunduğu yer tasks açık yüzündeki
/// `effectiveAccessProvider`'dır; ham alanlar yalnız önbellek sahibi ve kayıt içindir.
@immutable
final class ScopeSelection {
  const ScopeSelection({this.programId, this.departmentId, this.role});
  final String? programId;
  final String? departmentId;
  final EffectiveRole? role;

  /// Aynı görünüm mü (program, rol, koordinatörlük); uçuştaki okumanın bayatlık denetimi.
  bool sameView(ScopeSelection other) =>
      other.programId == programId &&
      other.departmentId == departmentId &&
      other.role == role;

  /// Program seçili mi (kabuk açık, `scoped` fazı; S2 istekleri program kimliğini taşır).
  bool get hasProgram => programId != null && programId!.isNotEmpty;
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

  /// Etkin rolü seçer. Yalnız [grants]'ın verdiği rol seçilebilir; değilse seçim değişmez ve
  /// `false` döner. Koordinatörlük yeni rolde geçerliyse korunur, değilse rolün ilk satırı
  /// (yöneticide `null`). Program yoksa `false`.
  bool selectRole(EffectiveRole role, ScopeGrants grants) {
    final cur = _state.value;
    if (!cur.hasProgram || !grants.roles.contains(role)) return false;
    final view = grants.resolve(role, cur.departmentId);
    _state.value = ScopeSelection(
      programId: cur.programId,
      role: view.role,
      departmentId: view.departmentId,
    );
    _persistSelection();
    return true;
  }

  /// Koordinatörlüğü seçer. [grants] verildiğinde yalnız etkin rolün (seçili ya da türetilen)
  /// satırlarından biri seçilebilir; yönetici rolünde koordinatörlük seçilmez; geçersizse seçim
  /// değişmez ve `false` döner. Etkin rol kayda yazılır (türetilmişse sabitlenir).
  ///
  /// [grants]'sız çağrı yalnız S3 başlığı için düşük düzey yoldur (rol dokunulmaz, denetim yok);
  /// arayüz her zaman [grants] verir.
  bool selectDepartment(String departmentId, {ScopeGrants? grants}) {
    final cur = _state.value;
    var role = cur.role;
    if (grants != null) {
      final view = grants.resolve(cur.role, cur.departmentId);
      if (!cur.hasProgram ||
          !grants.departmentsFor(view.role).contains(departmentId)) {
        return false;
      }
      role = view.role;
    }
    _state.value = ScopeSelection(
      programId: cur.programId,
      role: role,
      departmentId: departmentId,
    );
    _persistSelection();
    return true;
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
      } on Object catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.scope);
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
      if (!sel.hasProgram) return;
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
      } on Object catch (e, st) {
        // yerel depo hatası: yalnız yerel yeniden deneme (her deneme raporlanır; hız sınırı
        // aynı yığını tekrarlamaz)
        reportUnexpected(e, st, source: ReportSource.scope);
      }
    }
    return false;
  }
}
