import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../storage/secure_store.dart';
import 'scope_controller.dart';

/// Kapsamın ait olduğu oturum: hesap + sunucu kurulumu (ADR-0003 karar 20). Kayıt YALNIZ bu
/// ikiliyle birebir eşleşen oturumda geri yüklenir.
@immutable
final class ScopeOwner {
  const ScopeOwner({required this.accountId, required this.instanceId});
  final String accountId;
  final String instanceId;

  @override
  bool operator ==(Object other) =>
      other is ScopeOwner &&
      other.accountId == accountId &&
      other.instanceId == instanceId;

  @override
  int get hashCode => Object.hash(accountId, instanceId);
}

/// Son seçili kapsamın güvenli depodaki TEK kaydı (ADR-0003 karar 20). Düz tercihe
/// ([AppPreferences]) yazılmaz: kapsam kimliği oturuma bağlıdır ve oturumla birlikte silinir.
///
/// Kayıt biçimi: `{"account_id","instance_id","program_id"[,"department_id"]}`. Bozuk, eksik
/// ya da çözülemeyen kayıt [load]'da `null` döner (çağıran siler); hata fırlatmaz.
class ScopeStore {
  ScopeStore(this._store);

  static const key = 'nizamio.scope.v1';

  final SecureStore _store;

  /// Depodaki ham kayıt var mı (çözülemese bile)? Okuma hatası fırlatır.
  Future<bool> exists() async => await _store.read(key) != null;

  /// Kayıtlı sahip + seçim. Kayıt yoksa ya da bozuksa `null`. Okuma hatası fırlatır.
  Future<({ScopeOwner owner, ScopeSelection selection})?> load() async {
    final raw = await _store.read(key);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw);
      if (m is! Map<String, dynamic>) return null;
      final account = m['account_id'];
      final instance = m['instance_id'];
      final program = m['program_id'];
      final department = m['department_id'];
      if (account is! String ||
          account.isEmpty ||
          instance is! String ||
          instance.isEmpty ||
          program is! String ||
          program.isEmpty ||
          (department != null &&
              (department is! String || department.isEmpty))) {
        return null;
      }
      return (
        owner: ScopeOwner(accountId: account, instanceId: instance),
        selection: ScopeSelection(
          programId: program,
          departmentId: department as String?,
        ),
      );
    } on FormatException {
      return null;
    }
  }

  /// Var olan kaydın ÜZERİNE yazar.
  Future<void> save(ScopeOwner owner, ScopeSelection selection) => _store.write(
    key,
    jsonEncode({
      'account_id': owner.accountId,
      'instance_id': owner.instanceId,
      'program_id': selection.programId,
      if (selection.hasDepartment) 'department_id': selection.departmentId,
    }),
  );

  Future<void> clear() => _store.delete(key);
}
