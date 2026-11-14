// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_delete_comment_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableDeleteCommentCommand {

 TableDeleteCommentCommandKind get kind;/// Yorum kimliği.
 String get id;
/// Create a copy of TableDeleteCommentCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDeleteCommentCommandCopyWith<TableDeleteCommentCommand> get copyWith => _$TableDeleteCommentCommandCopyWithImpl<TableDeleteCommentCommand>(this as TableDeleteCommentCommand, _$identity);

  /// Serializes this TableDeleteCommentCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableDeleteCommentCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableDeleteCommentCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableDeleteCommentCommand;
  return Object.hash(runtimeType,_this.kind,_this.id);
}

@override
String toString() {
  final _this = this as TableDeleteCommentCommand;
  return 'TableDeleteCommentCommand(kind: ${_this.kind}, id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $TableDeleteCommentCommandCopyWith<$Res>  {
  factory $TableDeleteCommentCommandCopyWith(TableDeleteCommentCommand value, $Res Function(TableDeleteCommentCommand) _then) = _$TableDeleteCommentCommandCopyWithImpl;
@useResult
$Res call({
 TableDeleteCommentCommandKind kind, String id
});




}
/// @nodoc
class _$TableDeleteCommentCommandCopyWithImpl<$Res>
    implements $TableDeleteCommentCommandCopyWith<$Res> {
  _$TableDeleteCommentCommandCopyWithImpl(this._self, this._then);

  final TableDeleteCommentCommand _self;
  final $Res Function(TableDeleteCommentCommand) _then;

/// Create a copy of TableDeleteCommentCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,}) {
  return _then(TableDeleteCommentCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteCommentCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableDeleteCommentCommand].
extension TableDeleteCommentCommandPatterns on TableDeleteCommentCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableDeleteCommentCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableDeleteCommentCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableDeleteCommentCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableDeleteCommentCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableDeleteCommentCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableDeleteCommentCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableDeleteCommentCommandKind kind,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableDeleteCommentCommand() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableDeleteCommentCommandKind kind,  String id)  $default,) {final _that = this;
switch (_that) {
case _TableDeleteCommentCommand():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableDeleteCommentCommandKind kind,  String id)?  $default,) {final _that = this;
switch (_that) {
case _TableDeleteCommentCommand() when $default != null:
return $default(_that.kind,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableDeleteCommentCommand implements TableDeleteCommentCommand {
  const _TableDeleteCommentCommand({required this.kind, required this.id});
  factory _TableDeleteCommentCommand.fromJson(Map<String, dynamic> json) => _$TableDeleteCommentCommandFromJson(json);

@override final  TableDeleteCommentCommandKind kind;
/// Yorum kimliği.
@override final  String id;

/// Create a copy of TableDeleteCommentCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDeleteCommentCommandCopyWith<_TableDeleteCommentCommand> get copyWith => __$TableDeleteCommentCommandCopyWithImpl<_TableDeleteCommentCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDeleteCommentCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableDeleteCommentCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id);
}

@override
String toString() {
    return 'TableDeleteCommentCommand(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class _$TableDeleteCommentCommandCopyWith<$Res> implements $TableDeleteCommentCommandCopyWith<$Res> {
  factory _$TableDeleteCommentCommandCopyWith(_TableDeleteCommentCommand value, $Res Function(_TableDeleteCommentCommand) _then) = __$TableDeleteCommentCommandCopyWithImpl;
@override @useResult
$Res call({
 TableDeleteCommentCommandKind kind, String id
});




}
/// @nodoc
class __$TableDeleteCommentCommandCopyWithImpl<$Res>
    implements _$TableDeleteCommentCommandCopyWith<$Res> {
  __$TableDeleteCommentCommandCopyWithImpl(this._self, this._then);

  final _TableDeleteCommentCommand _self;
  final $Res Function(_TableDeleteCommentCommand) _then;

/// Create a copy of TableDeleteCommentCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(_TableDeleteCommentCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableDeleteCommentCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
