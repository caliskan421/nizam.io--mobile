// GENERATED CODE - DO NOT MODIFY BY HAND
import 'models/update_program_request_color.dart';

/// Dönem PATCH isteğinde dış null alanı atlar; iç null alanı temizler.
final class ProgramPatchField<T> {
  const ProgramPatchField(this.value);
  final T? value;
}

ProgramPatchField<String>? programPatchStringFromJson(String? value) =>
    value == null ? null : ProgramPatchField(value);
String? programPatchStringToJson(ProgramPatchField<String>? value) =>
    value?.value;
ProgramPatchField<UpdateProgramRequestColor>? programPatchColorFromJson(
  String? value,
) => value == null
    ? null
    : ProgramPatchField(UpdateProgramRequestColor.fromJson(value));
String? programPatchColorToJson(
  ProgramPatchField<UpdateProgramRequestColor>? value,
) => value?.value?.json;
