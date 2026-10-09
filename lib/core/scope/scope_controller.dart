import 'package:flutter/foundation.dart';

/// Seçili kapsam. Örtük varsayılan kapsam yoktur (C-04): S2 uçlar program, S3 uçlar ek olarak
/// departman seçimi ister; seçim yoksa istek GÖNDERİLMEZ (`client.scope_missing`).
@immutable
final class ScopeSelection {
  const ScopeSelection({this.programId, this.departmentId});
  final String? programId;
  final String? departmentId;

  bool get hasProgram => programId != null && programId!.isNotEmpty;
  bool get hasDepartment => departmentId != null && departmentId!.isNotEmpty;
}

class ScopeController {
  final ValueNotifier<ScopeSelection> _state = ValueNotifier(
    const ScopeSelection(),
  );

  ValueListenable<ScopeSelection> get state => _state;
  ScopeSelection get current => _state.value;

  void selectProgram(String programId) =>
      _state.value = ScopeSelection(programId: programId);

  void selectDepartment(String departmentId) => _state.value = ScopeSelection(
    programId: _state.value.programId,
    departmentId: departmentId,
  );

  void clear() => _state.value = const ScopeSelection();
}
