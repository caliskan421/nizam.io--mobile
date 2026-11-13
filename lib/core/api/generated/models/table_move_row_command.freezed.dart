// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_move_row_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableMoveRowCommand {

 TableMoveRowCommandKind get kind; String get id;@JsonKey(name: 'after_id') String? get afterId;
/// Create a copy of TableMoveRowCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableMoveRowCommandCopyWith<TableMoveRowCommand> get copyWith => _$TableMoveRowCommandCopyWithImpl<TableMoveRowCommand>(this as TableMoveRowCommand, _$identity);

  /// Serializes this TableMoveRowCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableMoveRowCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableMoveRowCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.afterId, _this.afterId) || other.afterId == _this.afterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableMoveRowCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.afterId);
}

@override
String toString() {
  final _this = this as TableMoveRowCommand;
  return 'TableMoveRowCommand(kind: ${_this.kind}, id: ${_this.id}, afterId: ${_this.afterId})';
}


}

/// @nodoc
abstract mixin class $TableMoveRowCommandCopyWith<$Res>  {
  factory $TableMoveRowCommandCopyWith(TableMoveRowCommand value, $Res Function(TableMoveRowCommand) _then) = _$TableMoveRowCommandCopyWithImpl;
@useResult
$Res call({
 TableMoveRowCommandKind kind, String id,@JsonKey(name: 'after_id') String? afterId
});




}
/// @nodoc
class _$TableMoveRowCommandCopyWithImpl<$Res>
    implements $TableMoveRowCommandCopyWith<$Res> {
  _$TableMoveRowCommandCopyWithImpl(this._self, this._then);

  final TableMoveRowCommand _self;
  final $Res Function(TableMoveRowCommand) _then;

/// Create a copy of TableMoveRowCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? afterId = freezed,}) {
  return _then(TableMoveRowCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveRowCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,afterId: freezed == afterId ? _self.afterId : afterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableMoveRowCommand].
extension TableMoveRowCommandPatterns on TableMoveRowCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableMoveRowCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableMoveRowCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableMoveRowCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableMoveRowCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableMoveRowCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableMoveRowCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableMoveRowCommandKind kind,  String id, @JsonKey(name: 'after_id')  String? afterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableMoveRowCommand() when $default != null:
return $default(_that.kind,_that.id,_that.afterId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableMoveRowCommandKind kind,  String id, @JsonKey(name: 'after_id')  String? afterId)  $default,) {final _that = this;
switch (_that) {
case _TableMoveRowCommand():
return $default(_that.kind,_that.id,_that.afterId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableMoveRowCommandKind kind,  String id, @JsonKey(name: 'after_id')  String? afterId)?  $default,) {final _that = this;
switch (_that) {
case _TableMoveRowCommand() when $default != null:
return $default(_that.kind,_that.id,_that.afterId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableMoveRowCommand implements TableMoveRowCommand {
  const _TableMoveRowCommand({required this.kind, required this.id, @JsonKey(name: 'after_id') this.afterId});
  factory _TableMoveRowCommand.fromJson(Map<String, dynamic> json) => _$TableMoveRowCommandFromJson(json);

@override final  TableMoveRowCommandKind kind;
@override final  String id;
@override@JsonKey(name: 'after_id') final  String? afterId;

/// Create a copy of TableMoveRowCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableMoveRowCommandCopyWith<_TableMoveRowCommand> get copyWith => __$TableMoveRowCommandCopyWithImpl<_TableMoveRowCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableMoveRowCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableMoveRowCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.afterId, afterId) || other.afterId == afterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,afterId);
}

@override
String toString() {
    return 'TableMoveRowCommand(kind: $kind, id: $id, afterId: $afterId)';
}


}

/// @nodoc
abstract mixin class _$TableMoveRowCommandCopyWith<$Res> implements $TableMoveRowCommandCopyWith<$Res> {
  factory _$TableMoveRowCommandCopyWith(_TableMoveRowCommand value, $Res Function(_TableMoveRowCommand) _then) = __$TableMoveRowCommandCopyWithImpl;
@override @useResult
$Res call({
 TableMoveRowCommandKind kind, String id,@JsonKey(name: 'after_id') String? afterId
});




}
/// @nodoc
class __$TableMoveRowCommandCopyWithImpl<$Res>
    implements _$TableMoveRowCommandCopyWith<$Res> {
  __$TableMoveRowCommandCopyWithImpl(this._self, this._then);

  final _TableMoveRowCommand _self;
  final $Res Function(_TableMoveRowCommand) _then;

/// Create a copy of TableMoveRowCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? afterId = freezed,}) {
  return _then(_TableMoveRowCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableMoveRowCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,afterId: freezed == afterId ? _self.afterId : afterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
