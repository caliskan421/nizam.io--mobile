// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Program {

@JsonKey(name: 'program_id') String get programId; String get name; int? get year; String? get description;/// Yalnız oluşturma yanıtında; yeni kayıt açıldıysa `true`.
 bool? get created;
/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramCopyWith<Program> get copyWith => _$ProgramCopyWithImpl<Program>(this as Program, _$identity);

  /// Serializes this Program to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Program;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Program&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.created, _this.created) || other.created == _this.created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Program;
  return Object.hash(runtimeType,_this.programId,_this.name,_this.year,_this.description,_this.created);
}

@override
String toString() {
  final _this = this as Program;
  return 'Program(programId: ${_this.programId}, name: ${_this.name}, year: ${_this.year}, description: ${_this.description}, created: ${_this.created})';
}


}

/// @nodoc
abstract mixin class $ProgramCopyWith<$Res>  {
  factory $ProgramCopyWith(Program value, $Res Function(Program) _then) = _$ProgramCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'program_id') String programId, String name, int? year, String? description, bool? created
});




}
/// @nodoc
class _$ProgramCopyWithImpl<$Res>
    implements $ProgramCopyWith<$Res> {
  _$ProgramCopyWithImpl(this._self, this._then);

  final Program _self;
  final $Res Function(Program) _then;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? programId = null,Object? name = null,Object? year = freezed,Object? description = freezed,Object? created = freezed,}) {
  return _then(Program(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Program].
extension ProgramPatterns on Program {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Program value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Program value)  $default,){
final _that = this;
switch (_that) {
case _Program():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Program value)?  $default,){
final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId,  String name,  int? year,  String? description,  bool? created)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.programId,_that.name,_that.year,_that.description,_that.created);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'program_id')  String programId,  String name,  int? year,  String? description,  bool? created)  $default,) {final _that = this;
switch (_that) {
case _Program():
return $default(_that.programId,_that.name,_that.year,_that.description,_that.created);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'program_id')  String programId,  String name,  int? year,  String? description,  bool? created)?  $default,) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.programId,_that.name,_that.year,_that.description,_that.created);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Program implements Program {
  const _Program({@JsonKey(name: 'program_id') required this.programId, required this.name, this.year, this.description, this.created});
  factory _Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

@override@JsonKey(name: 'program_id') final  String programId;
@override final  String name;
@override final  int? year;
@override final  String? description;
/// Yalnız oluşturma yanıtında; yeni kayıt açıldıysa `true`.
@override final  bool? created;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramCopyWith<_Program> get copyWith => __$ProgramCopyWithImpl<_Program>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Program&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.name, name) || other.name == name)&&(identical(other.year, year) || other.year == year)&&(identical(other.description, description) || other.description == description)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,programId,name,year,description,created);
}

@override
String toString() {
    return 'Program(programId: $programId, name: $name, year: $year, description: $description, created: $created)';
}


}

/// @nodoc
abstract mixin class _$ProgramCopyWith<$Res> implements $ProgramCopyWith<$Res> {
  factory _$ProgramCopyWith(_Program value, $Res Function(_Program) _then) = __$ProgramCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'program_id') String programId, String name, int? year, String? description, bool? created
});




}
/// @nodoc
class __$ProgramCopyWithImpl<$Res>
    implements _$ProgramCopyWith<$Res> {
  __$ProgramCopyWithImpl(this._self, this._then);

  final _Program _self;
  final $Res Function(_Program) _then;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? programId = null,Object? name = null,Object? year = freezed,Object? description = freezed,Object? created = freezed,}) {
  return _then(_Program(
programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
