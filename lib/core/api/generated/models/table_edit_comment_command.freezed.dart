// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_edit_comment_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableEditCommentCommand {

 TableEditCommentCommandKind get kind;/// Yorum kimliği.
 String get id; String get body;
/// Create a copy of TableEditCommentCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableEditCommentCommandCopyWith<TableEditCommentCommand> get copyWith => _$TableEditCommentCommandCopyWithImpl<TableEditCommentCommand>(this as TableEditCommentCommand, _$identity);

  /// Serializes this TableEditCommentCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableEditCommentCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableEditCommentCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.body, _this.body) || other.body == _this.body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableEditCommentCommand;
  return Object.hash(runtimeType,_this.kind,_this.id,_this.body);
}

@override
String toString() {
  final _this = this as TableEditCommentCommand;
  return 'TableEditCommentCommand(kind: ${_this.kind}, id: ${_this.id}, body: ${_this.body})';
}


}

/// @nodoc
abstract mixin class $TableEditCommentCommandCopyWith<$Res>  {
  factory $TableEditCommentCommandCopyWith(TableEditCommentCommand value, $Res Function(TableEditCommentCommand) _then) = _$TableEditCommentCommandCopyWithImpl;
@useResult
$Res call({
 TableEditCommentCommandKind kind, String id, String body
});




}
/// @nodoc
class _$TableEditCommentCommandCopyWithImpl<$Res>
    implements $TableEditCommentCommandCopyWith<$Res> {
  _$TableEditCommentCommandCopyWithImpl(this._self, this._then);

  final TableEditCommentCommand _self;
  final $Res Function(TableEditCommentCommand) _then;

/// Create a copy of TableEditCommentCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? body = null,}) {
  return _then(TableEditCommentCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableEditCommentCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableEditCommentCommand].
extension TableEditCommentCommandPatterns on TableEditCommentCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableEditCommentCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableEditCommentCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableEditCommentCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableEditCommentCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableEditCommentCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableEditCommentCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableEditCommentCommandKind kind,  String id,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableEditCommentCommand() when $default != null:
return $default(_that.kind,_that.id,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableEditCommentCommandKind kind,  String id,  String body)  $default,) {final _that = this;
switch (_that) {
case _TableEditCommentCommand():
return $default(_that.kind,_that.id,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableEditCommentCommandKind kind,  String id,  String body)?  $default,) {final _that = this;
switch (_that) {
case _TableEditCommentCommand() when $default != null:
return $default(_that.kind,_that.id,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableEditCommentCommand implements TableEditCommentCommand {
  const _TableEditCommentCommand({required this.kind, required this.id, required this.body});
  factory _TableEditCommentCommand.fromJson(Map<String, dynamic> json) => _$TableEditCommentCommandFromJson(json);

@override final  TableEditCommentCommandKind kind;
/// Yorum kimliği.
@override final  String id;
@override final  String body;

/// Create a copy of TableEditCommentCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableEditCommentCommandCopyWith<_TableEditCommentCommand> get copyWith => __$TableEditCommentCommandCopyWithImpl<_TableEditCommentCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableEditCommentCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableEditCommentCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,id,body);
}

@override
String toString() {
    return 'TableEditCommentCommand(kind: $kind, id: $id, body: $body)';
}


}

/// @nodoc
abstract mixin class _$TableEditCommentCommandCopyWith<$Res> implements $TableEditCommentCommandCopyWith<$Res> {
  factory _$TableEditCommentCommandCopyWith(_TableEditCommentCommand value, $Res Function(_TableEditCommentCommand) _then) = __$TableEditCommentCommandCopyWithImpl;
@override @useResult
$Res call({
 TableEditCommentCommandKind kind, String id, String body
});




}
/// @nodoc
class __$TableEditCommentCommandCopyWithImpl<$Res>
    implements _$TableEditCommentCommandCopyWith<$Res> {
  __$TableEditCommentCommandCopyWithImpl(this._self, this._then);

  final _TableEditCommentCommand _self;
  final $Res Function(_TableEditCommentCommand) _then;

/// Create a copy of TableEditCommentCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? body = null,}) {
  return _then(_TableEditCommentCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableEditCommentCommandKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
