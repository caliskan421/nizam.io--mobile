// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_convert_column_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableConvertColumnCommand {

 TableConvertColumnCommandKind get kind; String get id; TableColumnType get type;@JsonKey(name: 'expected_schema') int get expectedSchema;
/// Create a copy of TableConvertColumnCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableConvertColumnCommandCopyWith<TableConvertColumnCommand> get copyWith => _$TableConvertColumnCommandCopyWithImpl<TableConvertColumnCommand>(this as TableConvertColumnCommand, _$identity);

  /// Serializes this TableConvertColumnCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableConvertColumnCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableConvertColumnCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.expectedSchema, _this.expectedSchema) || other.expectedSchema == _this.expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableConvertColumnCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.type,_this.expectedSchema);
}

@override
String toString() {
  final _this = this as TableConvertColumnCommand;
  return 'TableConvertColumnCommand(kind: ${_this.kind}, id: ${_this.id}, type: ${_this.type}, expectedSchema: ${_this.expectedSchema})';
}


}

/// @nodoc
abstract mixin class $TableConvertColumnCommandCopyWith<$Res>  {
  factory $TableConvertColumnCommandCopyWith(TableConvertColumnCommand value, $Res Function(TableConvertColumnCommand) _then) = _$TableConvertColumnCommandCopyWithImpl;
@useResult
$Res call({
 TableConvertColumnCommandKind kind, String id, TableColumnType type,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableConvertColumnCommandCopyWithImpl<$Res>
    implements $TableConvertColumnCommandCopyWith<$Res> {
  _$TableConvertColumnCommandCopyWithImpl(this._self, this._then);

  final TableConvertColumnCommand _self;
  final $Res Function(TableConvertColumnCommand) _then;

/// Create a copy of TableConvertColumnCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? type = null,Object? expectedSchema = null,}) {
  return _then(TableConvertColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableConvertColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableConvertColumnCommand].
extension TableConvertColumnCommandPatterns on TableConvertColumnCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableConvertColumnCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableConvertColumnCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableConvertColumnCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableConvertColumnCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableConvertColumnCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableConvertColumnCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableConvertColumnCommandKind kind,  String id,  TableColumnType type, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableConvertColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.type,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableConvertColumnCommandKind kind,  String id,  TableColumnType type, @JsonKey(name: 'expected_schema')  int expectedSchema)  $default,) {final _that = this;
switch (_that) {
case _TableConvertColumnCommand():
return $default(_that.kind,_that.id,_that.type,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableConvertColumnCommandKind kind,  String id,  TableColumnType type, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,) {final _that = this;
switch (_that) {
case _TableConvertColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.type,_that.expectedSchema);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableConvertColumnCommand implements TableConvertColumnCommand {
  const _TableConvertColumnCommand({required this.kind, required this.id, required this.type, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory _TableConvertColumnCommand.fromJson(Map<String, dynamic> json) => _$TableConvertColumnCommandFromJson(json);

@override final  TableConvertColumnCommandKind kind;
@override final  String id;
@override final  TableColumnType type;
@override@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableConvertColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableConvertColumnCommandCopyWith<_TableConvertColumnCommand> get copyWith => __$TableConvertColumnCommandCopyWithImpl<_TableConvertColumnCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableConvertColumnCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableConvertColumnCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,type,expectedSchema);
}

@override
String toString() {
    return 'TableConvertColumnCommand(kind: $kind, id: $id, type: $type, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class _$TableConvertColumnCommandCopyWith<$Res> implements $TableConvertColumnCommandCopyWith<$Res> {
  factory _$TableConvertColumnCommandCopyWith(_TableConvertColumnCommand value, $Res Function(_TableConvertColumnCommand) _then) = __$TableConvertColumnCommandCopyWithImpl;
@override @useResult
$Res call({
 TableConvertColumnCommandKind kind, String id, TableColumnType type,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class __$TableConvertColumnCommandCopyWithImpl<$Res>
    implements _$TableConvertColumnCommandCopyWith<$Res> {
  __$TableConvertColumnCommandCopyWithImpl(this._self, this._then);

  final _TableConvertColumnCommand _self;
  final $Res Function(_TableConvertColumnCommand) _then;

/// Create a copy of TableConvertColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? type = null,Object? expectedSchema = null,}) {
  return _then(_TableConvertColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableConvertColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TableColumnType,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
