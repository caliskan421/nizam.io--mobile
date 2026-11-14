/// Etkin görünümün rolü (program × rol × koordinatörlük üçlüsünün ikinci ayağı). Saf Dart
/// (sınır kuralı S4); kapsam seçimi (core/scope), erişim kaynağı (tasks) ve menü tanımı
/// (scope) aynı enum'u kullanır.
///
/// Rol global değildir: seçenekleri kullanıcının o programdaki gerçek hakları belirler
/// ([ScopeGrants.roles]). Etkin görünüm arayüzü SÜZER, yetkiyi genişletmez; sunucu her istekte
/// yetkiyi kendisi denetler.
enum EffectiveRole {
  /// Şirket yöneticisi (`/v1/me` `company_admin`): tüm programı yönetir.
  admin,

  /// Programda en az bir `koordinator` satırı: kendi koordinatörlüğünü yönetir.
  coordinator,

  /// Programda en az bir `uye` satırı: yalnız atanan görevleri görür.
  member;

  /// Kayıt biçimi (ScopeStore `role` alanı); bilinmeyen değer `null` (varsayılan türetilir).
  String get wire => name;

  static EffectiveRole? fromWire(Object? raw) {
    for (final r in values) {
      if (r.name == raw) return r;
    }
    return null;
  }
}

/// Bir programdaki ekip satırının rol özeti (departman + o departmandaki rol).
typedef ScopeSeat = ({String departmentId, EffectiveRole role});

/// Çözülmüş etkin görünüm: rol + (yönetici değilse) koordinatörlük.
typedef ResolvedView = ({EffectiveRole role, String? departmentId});

/// Kullanıcının bir programdaki seçilebilir hakları: yönetici bayrağı + ekip satırları
/// (`koordinator` / `uye`, sıra sunucu sırası). Seçim geçerlilik denetimi ve varsayılan
/// türetme kuralının TEK yeri ([resolve]).
final class ScopeGrants {
  ScopeGrants({required this.admin, required List<ScopeSeat> seats})
    : seats = List.unmodifiable(seats);

  /// Hak yok (erişim henüz bilinmiyor): yalnız [EffectiveRole.member], koordinatörlük yok.
  static final none = ScopeGrants(admin: false, seats: const []);

  final bool admin;
  final List<ScopeSeat> seats;

  /// Seçilebilir roller (sıra: Yönetici, Koordinatör, Üye).
  List<EffectiveRole> get roles => [
    if (admin) EffectiveRole.admin,
    if (seats.any((s) => s.role == EffectiveRole.coordinator))
      EffectiveRole.coordinator,
    if (seats.any((s) => s.role == EffectiveRole.member)) EffectiveRole.member,
  ];

  /// [role] rolünde seçilebilen koordinatörlükler (departman kimliği; yönetici için boş:
  /// yönetici tüm koordinatörlükleri görür, kart gizlidir).
  List<String> departmentsFor(EffectiveRole role) => role == EffectiveRole.admin
      ? const []
      : [
          for (final s in seats)
            if (s.role == role) s.departmentId,
        ];

  /// Seçim ([role], [departmentId]) geçerliyse odur; değilse varsayılan:
  /// - rol geçersiz ya da yoksa: yönetici → Yönetici; koordinatörlük varsa → Koordinatör;
  ///   yoksa → Üye;
  /// - koordinatörlük, rolün satırları arasındaysa korunur; değilse rolün ilk satırı
  ///   (yöneticide her zaman `null`).
  /// Hiç hak yoksa (`roles` boş) Üye + `null` (fail-closed: yönetici/koordinatör eylemi yok).
  ResolvedView resolve(EffectiveRole? role, String? departmentId) {
    final allowed = roles;
    final r = role != null && allowed.contains(role)
        ? role
        : allowed.firstOrNull ?? EffectiveRole.member;
    final depts = departmentsFor(r);
    final dept = depts.contains(departmentId)
        ? departmentId
        : depts.firstOrNull;
    return (role: r, departmentId: dept);
  }
}
