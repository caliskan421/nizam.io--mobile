import 'package:meta/meta.dart';

/// Program (dönem): kapsam seçiminin birimi. Domain varlığı; `data` katmanında üretilmiş
/// DTO'dan eşlenir. Liste ucu (S1) yalnız kimlik ve ad döner; [year] yalnız kapsamdaki program
/// okumasında (S2) dolu olabilir.
@immutable
final class Program {
  const Program({required this.id, required this.name, this.year});

  final String id;
  final String name;
  final int? year;

  @override
  bool operator ==(Object other) =>
      other is Program &&
      other.id == id &&
      other.name == name &&
      other.year == year;

  @override
  int get hashCode => Object.hash(id, name, year);
}
