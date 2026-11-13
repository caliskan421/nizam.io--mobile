// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_delete_row_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableDeleteRowCommand {

 TableDeleteRowCommandKind get kind;/// Satır kimliği.
 String get id;
/// Create a copy of TableDeleteRowCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDeleteRowCommandCopyWith<TableDeleteRowCommand> get copyWith => _$TableDeleteRowCommandCopyWithImpl<TableDeleteRowCommand>(this as TableDeleteRowCommand, _$identity);

  /// Serializes this TableDeleteRowCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableDeleteRowCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableDeleteRowCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableDeleteRowCommand;
  return Object.hash(runtimeType,_this.kind,_this.id);
}

@override
String toString() {
  final _this = this as TableDeleteRowCommand;
  return 'TableDeleteRowCommand(kind: ${_this.kind}, id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $TableDeleteRowCommandCopyWith<$Res>  {
  factory $TableDeleteRowCommandCopyWith(TableDeleteRowCommand value, $Res Function(TableDeleteRowCommand) _then) = _$TableDeleteRowCommandCopyWithImpl;
@useResult
$Res call({
 TableDeleteRowCommandKind kind, String id
});




}
/// @nodoc
class _$TableDeleteRowCommandCopyWithImpl<$Res>
    implements $TableDeleteRowCommandCopyWith<$Res> {
  _$TableDeleteRowCommandCopyWithImpl(this._self, this._then);

  final TableDeleteRowCommand _self;
  final $Res Function(TableDeleteRowCommand) _then;

/// Create a copy of TableDeleteRowCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,}) {
  return _then(TableDeleteRowCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteRowCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableDeleteRowCommand].
extension TableDeleteRowCommandPatterns on TableDeleteRowCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableDeleteRowCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableDeleteRowCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableDeleteRowCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableDeleteRowCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableDeleteRowCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableDeleteRowCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableDeleteRowCommandKind kind,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableDeleteRowCommand() when $default != null:
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableDeleteRowCommandKind kind,  String id)  $default,) {final _that = this;
switch (_that) {
case _TableDeleteRowCommand():
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableDeleteRowCommandKind kind,  String id)?  $default,) {final _that = this;
switch (_that) {
case _TableDeleteRowCommand() when $default != null:
return $default(_that.kind,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableDeleteRowCommand implements TableDeleteRowCommand {
  const _TableDeleteRowCommand({required this.kind, required this.id});
  factory _TableDeleteRowCommand.fromJson(Map<String, dynamic> json) => _$TableDeleteRowCommandFromJson(json);

@override final  TableDeleteRowCommandKind kind;
/// Satır kimliği.
@override final  String id;

/// Create a copy of TableDeleteRowCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDeleteRowCommandCopyWith<_TableDeleteRowCommand> get copyWith => __$TableDeleteRowCommandCopyWithImpl<_TableDeleteRowCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDeleteRowCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableDeleteRowCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'TableDeleteRowCommand(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class _$TableDeleteRowCommandCopyWith<$Res> implements $TableDeleteRowCommandCopyWith<$Res> {
  factory _$TableDeleteRowCommandCopyWith(_TableDeleteRowCommand value, $Res Function(_TableDeleteRowCommand) _then) = __$TableDeleteRowCommandCopyWithImpl;
@override @useResult
$Res call({
 TableDeleteRowCommandKind kind, String id
});




}
/// @nodoc
class __$TableDeleteRowCommandCopyWithImpl<$Res>
    implements _$TableDeleteRowCommandCopyWith<$Res> {
  __$TableDeleteRowCommandCopyWithImpl(this._self, this._then);

  final _TableDeleteRowCommand _self;
  final $Res Function(_TableDeleteRowCommand) _then;

/// Create a copy of TableDeleteRowCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(_TableDeleteRowCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteRowCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
