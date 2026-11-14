// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_resize_column_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableResizeColumnCommand {

 TableResizeColumnCommandKind get kind;/// Sütun kimliği.
 String get id; int get width;@JsonKey(name: 'expected_schema') int get expectedSchema;
/// Create a copy of TableResizeColumnCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableResizeColumnCommandCopyWith<TableResizeColumnCommand> get copyWith => _$TableResizeColumnCommandCopyWithImpl<TableResizeColumnCommand>(this as TableResizeColumnCommand, _$identity);

  /// Serializes this TableResizeColumnCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableResizeColumnCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableResizeColumnCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.expectedSchema, _this.expectedSchema) || other.expectedSchema == _this.expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableResizeColumnCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.width,_this.expectedSchema);
}

@override
String toString() {
  final _this = this as TableResizeColumnCommand;
  return 'TableResizeColumnCommand(kind: ${_this.kind}, id: ${_this.id}, width: ${_this.width}, expectedSchema: ${_this.expectedSchema})';
}


}

/// @nodoc
abstract mixin class $TableResizeColumnCommandCopyWith<$Res>  {
  factory $TableResizeColumnCommandCopyWith(TableResizeColumnCommand value, $Res Function(TableResizeColumnCommand) _then) = _$TableResizeColumnCommandCopyWithImpl;
@useResult
$Res call({
 TableResizeColumnCommandKind kind, String id, int width,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class _$TableResizeColumnCommandCopyWithImpl<$Res>
    implements $TableResizeColumnCommandCopyWith<$Res> {
  _$TableResizeColumnCommandCopyWithImpl(this._self, this._then);

  final TableResizeColumnCommand _self;
  final $Res Function(TableResizeColumnCommand) _then;

/// Create a copy of TableResizeColumnCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? width = null,Object? expectedSchema = null,}) {
  return _then(TableResizeColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableResizeColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableResizeColumnCommand].
extension TableResizeColumnCommandPatterns on TableResizeColumnCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableResizeColumnCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableResizeColumnCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableResizeColumnCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableResizeColumnCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableResizeColumnCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableResizeColumnCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableResizeColumnCommandKind kind,  String id,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableResizeColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.width,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableResizeColumnCommandKind kind,  String id,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema)  $default,) {final _that = this;
switch (_that) {
case _TableResizeColumnCommand():
return $default(_that.kind,_that.id,_that.width,_that.expectedSchema);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableResizeColumnCommandKind kind,  String id,  int width, @JsonKey(name: 'expected_schema')  int expectedSchema)?  $default,) {final _that = this;
switch (_that) {
case _TableResizeColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.width,_that.expectedSchema);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableResizeColumnCommand implements TableResizeColumnCommand {
  const _TableResizeColumnCommand({required this.kind, required this.id, required this.width, @JsonKey(name: 'expected_schema') required this.expectedSchema});
  factory _TableResizeColumnCommand.fromJson(Map<String, dynamic> json) => _$TableResizeColumnCommandFromJson(json);

@override final  TableResizeColumnCommandKind kind;
/// Sütun kimliği.
@override final  String id;
@override final  int width;
@override@JsonKey(name: 'expected_schema') final  int expectedSchema;

/// Create a copy of TableResizeColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableResizeColumnCommandCopyWith<_TableResizeColumnCommand> get copyWith => __$TableResizeColumnCommandCopyWithImpl<_TableResizeColumnCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableResizeColumnCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableResizeColumnCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,width,expectedSchema);
}

@override
String toString() {
    return 'TableResizeColumnCommand(kind: $kind, id: $id, width: $width, expectedSchema: $expectedSchema)';
}


}

/// @nodoc
abstract mixin class _$TableResizeColumnCommandCopyWith<$Res> implements $TableResizeColumnCommandCopyWith<$Res> {
  factory _$TableResizeColumnCommandCopyWith(_TableResizeColumnCommand value, $Res Function(_TableResizeColumnCommand) _then) = __$TableResizeColumnCommandCopyWithImpl;
@override @useResult
$Res call({
 TableResizeColumnCommandKind kind, String id, int width,@JsonKey(name: 'expected_schema') int expectedSchema
});




}
/// @nodoc
class __$TableResizeColumnCommandCopyWithImpl<$Res>
    implements _$TableResizeColumnCommandCopyWith<$Res> {
  __$TableResizeColumnCommandCopyWithImpl(this._self, this._then);

  final _TableResizeColumnCommand _self;
  final $Res Function(_TableResizeColumnCommand) _then;

/// Create a copy of TableResizeColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? width = null,Object? expectedSchema = null,}) {
  return _then(_TableResizeColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableResizeColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
