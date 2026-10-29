import 'package:meta/meta.dart';

/// Departman içi rol. Sunucuda global rol yoktur: şirket yöneticiliği ayrı bayraktır, rol
/// departman başına tutulur (`koordinator` / `uye`). Sözleşmede rol serbest dizgedir (enum
/// değil); tanımsız ya da yeni değer [unknown] olur, asla hata fırlatılmaz.
///
/// Sunum katmanındaki `TeamRole` (admin/coordinator/member) ile örtüşür ama aynı kavram
/// değildir: `admin` departman rolü değil şirket yöneticisi bayrağıdır (entegrasyonda karar).
enum DepartmentRole {
  coordinator('koordinator'),
  member('uye'),
  unknown(null);

  const DepartmentRole(this.wire);

  /// Sözleşmedeki değer; [unknown] için `null`.
  final String? wire;

  /// Sunucu dizgesinden; `null` ya da tanımsız değer [unknown].
  static DepartmentRole fromWire(String? value) {
    for (final r in values) {
      if (r.wire != null && r.wire == value) return r;
    }
    return unknown;
  }
}

/// Oturumdaki hesabın bağlı olduğu departman ve oradaki rolü (`GET /v1/me/departments`, S1).
@immutable
final class MyDepartment {
  const MyDepartment({
    required this.id,
    required this.name,
    required this.role,
  });

  final String id;
  final String name;
  final DepartmentRole role;

  @override
  bool operator ==(Object other) =>
      other is MyDepartment &&
      other.id == id &&
      other.name == name &&
      other.role == role;

  @override
  int get hashCode => Object.hash(id, name, role);
}
