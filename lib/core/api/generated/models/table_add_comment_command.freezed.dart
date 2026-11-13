// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_add_comment_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableAddCommentCommand {

 TableAddCommentCommandKind get kind;@JsonKey(name: 'row_id') String get rowId; String get body;@JsonKey(name: 'column_id') String? get columnId;
/// Create a copy of TableAddCommentCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableAddCommentCommandCopyWith<TableAddCommentCommand> get copyWith => _$TableAddCommentCommandCopyWithImpl<TableAddCommentCommand>(this as TableAddCommentCommand, _$identity);

  /// Serializes this TableAddCommentCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableAddCommentCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableAddCommentCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.rowId, _this.rowId) || other.rowId == _this.rowId)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.columnId, _this.columnId) || other.columnId == _this.columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableAddCommentCommand;
  return Object.hash(runtimeType,_this.kind,_this.rowId,_this.body,_this.columnId);
}

@override
String toString() {
  final _this = this as TableAddCommentCommand;
  return 'TableAddCommentCommand(kind: ${_this.kind}, rowId: ${_this.rowId}, body: ${_this.body}, columnId: ${_this.columnId})';
}


}

/// @nodoc
abstract mixin class $TableAddCommentCommandCopyWith<$Res>  {
  factory $TableAddCommentCommandCopyWith(TableAddCommentCommand value, $Res Function(TableAddCommentCommand) _then) = _$TableAddCommentCommandCopyWithImpl;
@useResult
$Res call({
 TableAddCommentCommandKind kind,@JsonKey(name: 'row_id') String rowId, String body,@JsonKey(name: 'column_id') String? columnId
});




}
/// @nodoc
class _$TableAddCommentCommandCopyWithImpl<$Res>
    implements $TableAddCommentCommandCopyWith<$Res> {
  _$TableAddCommentCommandCopyWithImpl(this._self, this._then);

  final TableAddCommentCommand _self;
  final $Res Function(TableAddCommentCommand) _then;

/// Create a copy of TableAddCommentCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? rowId = null,Object? body = null,Object? columnId = freezed,}) {
  return _then(TableAddCommentCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddCommentCommandKind,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableAddCommentCommand].
extension TableAddCommentCommandPatterns on TableAddCommentCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableAddCommentCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableAddCommentCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableAddCommentCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableAddCommentCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableAddCommentCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableAddCommentCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableAddCommentCommandKind kind, @JsonKey(name: 'row_id')  String rowId,  String body, @JsonKey(name: 'column_id')  String? columnId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableAddCommentCommand() when $default != null:
return $default(_that.kind,_that.rowId,_that.body,_that.columnId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableAddCommentCommandKind kind, @JsonKey(name: 'row_id')  String rowId,  String body, @JsonKey(name: 'column_id')  String? columnId)  $default,) {final _that = this;
switch (_that) {
case _TableAddCommentCommand():
return $default(_that.kind,_that.rowId,_that.body,_that.columnId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableAddCommentCommandKind kind, @JsonKey(name: 'row_id')  String rowId,  String body, @JsonKey(name: 'column_id')  String? columnId)?  $default,) {final _that = this;
switch (_that) {
case _TableAddCommentCommand() when $default != null:
return $default(_that.kind,_that.rowId,_that.body,_that.columnId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableAddCommentCommand implements TableAddCommentCommand {
  const _TableAddCommentCommand({required this.kind, @JsonKey(name: 'row_id') required this.rowId, required this.body, @JsonKey(name: 'column_id') this.columnId});
  factory _TableAddCommentCommand.fromJson(Map<String, dynamic> json) => _$TableAddCommentCommandFromJson(json);

@override final  TableAddCommentCommandKind kind;
@override@JsonKey(name: 'row_id') final  String rowId;
@override final  String body;
@override@JsonKey(name: 'column_id') final  String? columnId;

/// Create a copy of TableAddCommentCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableAddCommentCommandCopyWith<_TableAddCommentCommand> get copyWith => __$TableAddCommentCommandCopyWithImpl<_TableAddCommentCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableAddCommentCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableAddCommentCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.body, body) || other.body == body)&&(identical(other.columnId, columnId) || other.columnId == columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,rowId,body,columnId);
}

@override
String toString() {
    return 'TableAddCommentCommand(kind: $kind, rowId: $rowId, body: $body, columnId: $columnId)';
}


}

/// @nodoc
abstract mixin class _$TableAddCommentCommandCopyWith<$Res> implements $TableAddCommentCommandCopyWith<$Res> {
  factory _$TableAddCommentCommandCopyWith(_TableAddCommentCommand value, $Res Function(_TableAddCommentCommand) _then) = __$TableAddCommentCommandCopyWithImpl;
@override @useResult
$Res call({
 TableAddCommentCommandKind kind,@JsonKey(name: 'row_id') String rowId, String body,@JsonKey(name: 'column_id') String? columnId
});




}
/// @nodoc
class __$TableAddCommentCommandCopyWithImpl<$Res>
    implements _$TableAddCommentCommandCopyWith<$Res> {
  __$TableAddCommentCommandCopyWithImpl(this._self, this._then);

  final _TableAddCommentCommand _self;
  final $Res Function(_TableAddCommentCommand) _then;

/// Create a copy of TableAddCommentCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? rowId = null,Object? body = null,Object? columnId = freezed,}) {
  return _then(_TableAddCommentCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableAddCommentCommandKind,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
