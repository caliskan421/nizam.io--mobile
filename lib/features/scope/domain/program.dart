import 'package:meta/meta.dart';

enum ProgramColor {
  violet,
  gold,
  blue,
  teal,
  green,
  orange,
  red,
  slate,
  unknown;

  static ProgramColor fromWire(String? value) => values.firstWhere(
    (color) => color != unknown && color.name == value,
    orElse: () => unknown,
  );
}

/// Güncellemede dış null değişmez, iç null alanı temizler.
final class ProgramField<T> {
  const ProgramField(this.value);
  final T? value;
}

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
    this.shortName,
    this.color,
  });

  final String id;
  final String name;
  final int? year;

  /// Sözleşmede isteğe bağlı (`Program.description`).
  final String? description;
  final String? shortName;
  final ProgramColor? color;

  @override
  bool operator ==(Object other) =>
      other is Program &&
      other.id == id &&
      other.name == name &&
      other.year == year &&
      other.description == description &&
      other.shortName == shortName &&
      other.color == color;

  @override
  int get hashCode =>
      Object.hash(id, name, year, description, shortName, color);
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
