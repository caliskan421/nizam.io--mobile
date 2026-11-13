// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_delete_column_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableDeleteColumnCommand {

 TableDeleteColumnCommandKind get kind;/// Sütun kimliği.
 String get id;@JsonKey(name: 'expected_schema') int get expectedSchema;
/// Create a copy of TableDeleteColumnCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDeleteColumnCommandCopyWith<TableDeleteColumnCommand> get copyWith => _$TableDeleteColumnCommandCopyWithImpl<TableDeleteColumnCommand>(this as TableDeleteColumnCommand, _$identity);

  /// Serializes this TableDeleteColumnCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableDeleteColumnCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableDeleteColumnCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.expectedSchema, _this.expectedSchema) || other.expectedSchema == _this.expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableDeleteColumnCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.expectedSchema);
}

@override
String toString() {
  final _this = this as TableDeleteColumnCommand;
  return 'TableDeleteColumnCommand(kind: ${_this.kind}, id: ${_this.id}, expectedSchema: ${_this.expectedSchema})';
}


}

/// @nodoc
abstract mixin class $TableDeleteColumnCommandCopyWith<$Res>  {
  factory $TableDeleteColumnCommandCopyWith(TableDeleteColumnCommand value, $Res Function(TableDeleteColumnCommand) _then) = _$TableDeleteColumnCommandCopyWithImpl;
@useResult
$Res call({
 TableDeleteColumnCommandKind kind, String id,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableDeleteColumnCommandCopyWithImpl<$Res>
    implements $TableDeleteColumnCommandCopyWith<$Res> {
  _$TableDeleteColumnCommandCopyWithImpl(this._self, this._then);

  final TableDeleteColumnCommand _self;
  final $Res Function(TableDeleteColumnCommand) _then;

/// Create a copy of TableDeleteColumnCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? expectedSchema = null,}) {
  return _then(TableDeleteColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableDeleteColumnCommand].
extension TableDeleteColumnCommandPatterns on TableDeleteColumnCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableDeleteColumnCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableDeleteColumnCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableDeleteColumnCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableDeleteColumnCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableDeleteColumnCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableDeleteColumnCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableDeleteColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableDeleteColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableDeleteColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema)  $default,) {final _that = this;
switch (_that) {
case _TableDeleteColumnCommand():
return $default(_that.kind,_that.id,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableDeleteColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,) {final _that = this;
switch (_that) {
case _TableDeleteColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.expectedSchema);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableDeleteColumnCommand implements TableDeleteColumnCommand {
  const _TableDeleteColumnCommand({required this.kind, required this.id, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory _TableDeleteColumnCommand.fromJson(Map<String, dynamic> json) => _$TableDeleteColumnCommandFromJson(json);

@override final  TableDeleteColumnCommandKind kind;
/// Sütun kimliği.
@override final  String id;
@override@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableDeleteColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDeleteColumnCommandCopyWith<_TableDeleteColumnCommand> get copyWith => __$TableDeleteColumnCommandCopyWithImpl<_TableDeleteColumnCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDeleteColumnCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableDeleteColumnCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,expectedSchema);
}

@override
String toString() {
    return 'TableDeleteColumnCommand(kind: $kind, id: $id, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class _$TableDeleteColumnCommandCopyWith<$Res> implements $TableDeleteColumnCommandCopyWith<$Res> {
  factory _$TableDeleteColumnCommandCopyWith(_TableDeleteColumnCommand value, $Res Function(_TableDeleteColumnCommand) _then) = __$TableDeleteColumnCommandCopyWithImpl;
@override @useResult
$Res call({
 TableDeleteColumnCommandKind kind, String id,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class __$TableDeleteColumnCommandCopyWithImpl<$Res>
    implements _$TableDeleteColumnCommandCopyWith<$Res> {
  __$TableDeleteColumnCommandCopyWithImpl(this._self, this._then);

  final _TableDeleteColumnCommand _self;
  final $Res Function(_TableDeleteColumnCommand) _then;

/// Create a copy of TableDeleteColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? expectedSchema = null,}) {
  return _then(_TableDeleteColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
