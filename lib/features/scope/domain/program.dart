import 'package:meta/meta.dart';

/// Program (dönem): kapsam seçiminin birimi. Domain varlığı; `data` katmanında üretilmiş
/// DTO'dan eşlenir. Liste ucu (S1) yalnız kimlik ve ad döner; [year] ve [description] yalnız
/// kapsamdaki program okumasında (S2) ve yönetim yanıtlarında dolu olabilir.
@immutable
final class Program {
  const Program({
    required this.id,
    required this.name,
    this.year,
    this.description,
  });

  final String id;
  final String name;
  final int? year;

  /// Sözleşmede isteğe bağlı (`Program.description`).
  final String? description;

  @override
  bool operator ==(Object other) =>
      other is Program &&
      other.id == id &&
      other.name == name &&
      other.year == year &&
      other.description == description;

  @override
  int get hashCode => Object.hash(id, name, year, description);
}

/// Departmanın kapsamdaki programa bağı (`POST /v1/program/departments` yanıtı).
@immutable
final class ProgramDepartmentLink {
  const ProgramDepartmentLink({
    required this.programId,
    required this.departmentId,
  });

  final String programId;
  final String departmentId;

  @override
  bool operator ==(Object other) =>
      other is ProgramDepartmentLink &&
      other.programId == programId &&
      other.departmentId == departmentId;

  @override
  int get hashCode => Object.hash(programId, departmentId);
}
