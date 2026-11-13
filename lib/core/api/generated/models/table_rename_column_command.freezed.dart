// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_rename_column_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableRenameColumnCommand {

 TableRenameColumnCommandKind get kind;/// Sütun kimliği.
 String get id; String get name;@JsonKey(name: 'expected_schema') int get expectedSchema;
/// Create a copy of TableRenameColumnCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableRenameColumnCommandCopyWith<TableRenameColumnCommand> get copyWith => _$TableRenameColumnCommandCopyWithImpl<TableRenameColumnCommand>(this as TableRenameColumnCommand, _$identity);

  /// Serializes this TableRenameColumnCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableRenameColumnCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableRenameColumnCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.expectedSchema, _this.expectedSchema) || other.expectedSchema == _this.expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableRenameColumnCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.name,_this.expectedSchema);
}

@override
String toString() {
  final _this = this as TableRenameColumnCommand;
  return 'TableRenameColumnCommand(kind: ${_this.kind}, id: ${_this.id}, name: ${_this.name}, expectedSchema: ${_this.expectedSchema})';
}


}

/// @nodoc
abstract mixin class $TableRenameColumnCommandCopyWith<$Res>  {
  factory $TableRenameColumnCommandCopyWith(TableRenameColumnCommand value, $Res Function(TableRenameColumnCommand) _then) = _$TableRenameColumnCommandCopyWithImpl;
@useResult
$Res call({
 TableRenameColumnCommandKind kind, String id, String name,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableRenameColumnCommandCopyWithImpl<$Res>
    implements $TableRenameColumnCommandCopyWith<$Res> {
  _$TableRenameColumnCommandCopyWithImpl(this._self, this._then);

  final TableRenameColumnCommand _self;
  final $Res Function(TableRenameColumnCommand) _then;

/// Create a copy of TableRenameColumnCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? name = null,Object? expectedSchema = null,}) {
  return _then(TableRenameColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableRenameColumnCommand].
extension TableRenameColumnCommandPatterns on TableRenameColumnCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableRenameColumnCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableRenameColumnCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableRenameColumnCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableRenameColumnCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableRenameColumnCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableRenameColumnCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableRenameColumnCommandKind kind,  String id,  String name, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableRenameColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.name,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableRenameColumnCommandKind kind,  String id,  String name, @JsonKey(name: 'expected_schema')  int expectedSchema)  $default,) {final _that = this;
switch (_that) {
case _TableRenameColumnCommand():
return $default(_that.kind,_that.id,_that.name,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableRenameColumnCommandKind kind,  String id,  String name, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,) {final _that = this;
switch (_that) {
case _TableRenameColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.name,_that.expectedSchema);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableRenameColumnCommand implements TableRenameColumnCommand {
  const _TableRenameColumnCommand({required this.kind, required this.id, required this.name, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory _TableRenameColumnCommand.fromJson(Map<String, dynamic> json) => _$TableRenameColumnCommandFromJson(json);

@override final  TableRenameColumnCommandKind kind;
/// Sütun kimliği.
@override final  String id;
@override final  String name;
@override@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableRenameColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableRenameColumnCommandCopyWith<_TableRenameColumnCommand> get copyWith => __$TableRenameColumnCommandCopyWithImpl<_TableRenameColumnCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableRenameColumnCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableRenameColumnCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,name,expectedSchema);
}

@override
String toString() {
    return 'TableRenameColumnCommand(kind: $kind, id: $id, name: $name, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class _$TableRenameColumnCommandCopyWith<$Res> implements $TableRenameColumnCommandCopyWith<$Res> {
  factory _$TableRenameColumnCommandCopyWith(_TableRenameColumnCommand value, $Res Function(_TableRenameColumnCommand) _then) = __$TableRenameColumnCommandCopyWithImpl;
@override @useResult
$Res call({
 TableRenameColumnCommandKind kind, String id, String name,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class __$TableRenameColumnCommandCopyWithImpl<$Res>
    implements _$TableRenameColumnCommandCopyWith<$Res> {
  __$TableRenameColumnCommandCopyWithImpl(this._self, this._then);

  final _TableRenameColumnCommand _self;
  final $Res Function(_TableRenameColumnCommand) _then;

/// Create a copy of TableRenameColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? name = null,Object? expectedSchema = null,}) {
  return _then(_TableRenameColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRenameColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
