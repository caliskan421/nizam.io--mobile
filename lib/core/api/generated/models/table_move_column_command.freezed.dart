// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_move_column_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableMoveColumnCommand {

 TableMoveColumnCommandKind get kind; String get id;@JsonKey(name: 'expected_schema') int get expectedSchema;@JsonKey(name: 'after_id') String? get afterId;
/// Create a copy of TableMoveColumnCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableMoveColumnCommandCopyWith<TableMoveColumnCommand> get copyWith => _$TableMoveColumnCommandCopyWithImpl<TableMoveColumnCommand>(this as TableMoveColumnCommand, _$identity);

  /// Serializes this TableMoveColumnCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableMoveColumnCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableMoveColumnCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.expectedSchema, _this.expectedSchema) || other.expectedSchema == _this.expectedSchema)&&(identical(other.afterId, _this.afterId) || other.afterId == _this.afterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableMoveColumnCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.expectedSchema,_this.afterId);
}

@override
String toString() {
  final _this = this as TableMoveColumnCommand;
  return 'TableMoveColumnCommand(kind: ${_this.kind}, id: ${_this.id}, expectedSchema: ${_this.expectedSchema}, afterId: ${_this.afterId})';
}


}

/// @nodoc
abstract mixin class $TableMoveColumnCommandCopyWith<$Res>  {
  factory $TableMoveColumnCommandCopyWith(TableMoveColumnCommand value, $Res Function(TableMoveColumnCommand) _then) = _$TableMoveColumnCommandCopyWithImpl;
@useResult
$Res call({
 TableMoveColumnCommandKind kind, String id,@JsonKey(name: 'expected_schema') int expectedSchema,@JsonKey(name: 'after_id') String? afterId
});




}
/// @nodoc
class _$TableMoveColumnCommandCopyWithImpl<$Res>
    implements $TableMoveColumnCommandCopyWith<$Res> {
  _$TableMoveColumnCommandCopyWithImpl(this._self, this._then);

  final TableMoveColumnCommand _self;
  final $Res Function(TableMoveColumnCommand) _then;

/// Create a copy of TableMoveColumnCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? expectedSchema = null,Object? afterId = freezed,}) {
  return _then(TableMoveColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,afterId: freezed == afterId ? _self.afterId : afterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableMoveColumnCommand].
extension TableMoveColumnCommandPatterns on TableMoveColumnCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableMoveColumnCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableMoveColumnCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableMoveColumnCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableMoveColumnCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableMoveColumnCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableMoveColumnCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableMoveColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema, @JsonKey(name: 'after_id')  String? afterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableMoveColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.expectedSchema,_that.afterId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableMoveColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema, @JsonKey(name: 'after_id')  String? afterId)  $default,) {final _that = this;
switch (_that) {
case _TableMoveColumnCommand():
return $default(_that.kind,_that.id,_that.expectedSchema,_that.afterId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableMoveColumnCommandKind kind,  String id, @JsonKey(name: 'expected_schema')  int expectedSchema, @JsonKey(name: 'after_id')  String? afterId)?  $default,) {final _that = this;
switch (_that) {
case _TableMoveColumnCommand() when $default != null:
return $default(_that.kind,_that.id,_that.expectedSchema,_that.afterId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableMoveColumnCommand implements TableMoveColumnCommand {
  const _TableMoveColumnCommand({required this.kind, required this.id, @JsonKey(name: 'expected_schema') required this.expectedSchema, @JsonKey(name: 'after_id') this.afterId});
  factory _TableMoveColumnCommand.fromJson(Map<String, dynamic> json) => _$TableMoveColumnCommandFromJson(json);

@override final  TableMoveColumnCommandKind kind;
@override final  String id;
@override@JsonKey(name: 'expected_schema') final  int expectedSchema;
@override@JsonKey(name: 'after_id') final  String? afterId;

/// Create a copy of TableMoveColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableMoveColumnCommandCopyWith<_TableMoveColumnCommand> get copyWith => __$TableMoveColumnCommandCopyWithImpl<_TableMoveColumnCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableMoveColumnCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableMoveColumnCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.expectedSchema, expectedSchema) || other.expectedSchema == expectedSchema)&&(identical(other.afterId, afterId) || other.afterId == afterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,expectedSchema,afterId);
}

@override
String toString() {
    return 'TableMoveColumnCommand(kind: $kind, id: $id, expectedSchema: $expectedSchema, afterId: $afterId)';
}


}

/// @nodoc
abstract mixin class _$TableMoveColumnCommandCopyWith<$Res> implements $TableMoveColumnCommandCopyWith<$Res> {
  factory _$TableMoveColumnCommandCopyWith(_TableMoveColumnCommand value, $Res Function(_TableMoveColumnCommand) _then) = __$TableMoveColumnCommandCopyWithImpl;
@override @useResult
$Res call({
 TableMoveColumnCommandKind kind, String id,@JsonKey(name: 'expected_schema') int expectedSchema,@JsonKey(name: 'after_id') String? afterId
});




}
/// @nodoc
class __$TableMoveColumnCommandCopyWithImpl<$Res>
    implements _$TableMoveColumnCommandCopyWith<$Res> {
  __$TableMoveColumnCommandCopyWithImpl(this._self, this._then);

  final _TableMoveColumnCommand _self;
  final $Res Function(_TableMoveColumnCommand) _then;

/// Create a copy of TableMoveColumnCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? expectedSchema = null,Object? afterId = freezed,}) {
  return _then(_TableMoveColumnCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveColumnCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expectedSchema: null == expectedSchema ? _self.expectedSchema : expectedSchema // ignore: cast_nullable_to_non_nullable
as int,afterId: freezed == afterId ? _self.afterId : afterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
