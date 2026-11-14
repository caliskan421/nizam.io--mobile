// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_revoke_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableRevokeCommand {

 TableRevokeCommandKind get kind;@JsonKey(name: 'account_id') String get accountId;
/// Create a copy of TableRevokeCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableRevokeCommandCopyWith<TableRevokeCommand> get copyWith => _$TableRevokeCommandCopyWithImpl<TableRevokeCommand>(this as TableRevokeCommand, _$identity);

  /// Serializes this TableRevokeCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableRevokeCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableRevokeCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableRevokeCommand;
  return Object.hash(runtimeType,_this.kind,_this.accountId);
}

@override
String toString() {
  final _this = this as TableRevokeCommand;
  return 'TableRevokeCommand(kind: ${_this.kind}, accountId: ${_this.accountId})';
}


}

/// @nodoc
abstract mixin class $TableRevokeCommandCopyWith<$Res>  {
  factory $TableRevokeCommandCopyWith(TableRevokeCommand value, $Res Function(TableRevokeCommand) _then) = _$TableRevokeCommandCopyWithImpl;
@useResult
$Res call({
 TableRevokeCommandKind kind,@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class _$TableRevokeCommandCopyWithImpl<$Res>
    implements $TableRevokeCommandCopyWith<$Res> {
  _$TableRevokeCommandCopyWithImpl(this._self, this._then);

  final TableRevokeCommand _self;
  final $Res Function(TableRevokeCommand) _then;

/// Create a copy of TableRevokeCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? accountId = null,}) {
  return _then(TableRevokeCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRevokeCommandKind,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TableRevokeCommand].
extension TableRevokeCommandPatterns on TableRevokeCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableRevokeCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableRevokeCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableRevokeCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableRevokeCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableRevokeCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableRevokeCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableRevokeCommandKind kind, @JsonKey(name: 'account_id')  String accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableRevokeCommand() when $default != null:
return $default(_that.kind,_that.accountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableRevokeCommandKind kind, @JsonKey(name: 'account_id')  String accountId)  $default,) {final _that = this;
switch (_that) {
case _TableRevokeCommand():
return $default(_that.kind,_that.accountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableRevokeCommandKind kind, @JsonKey(name: 'account_id')  String accountId)?  $default,) {final _that = this;
switch (_that) {
case _TableRevokeCommand() when $default != null:
return $default(_that.kind,_that.accountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableRevokeCommand implements TableRevokeCommand {
  const _TableRevokeCommand({required this.kind, @JsonKey(name: 'account_id') required this.accountId});
  factory _TableRevokeCommand.fromJson(Map<String, dynamic> json) => _$TableRevokeCommandFromJson(json);

@override final  TableRevokeCommandKind kind;
@override@JsonKey(name: 'account_id') final  String accountId;

/// Create a copy of TableRevokeCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableRevokeCommandCopyWith<_TableRevokeCommand> get copyWith => __$TableRevokeCommandCopyWithImpl<_TableRevokeCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableRevokeCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableRevokeCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,accountId);
}

@override
String toString() {
    return 'TableRevokeCommand(kind: $kind, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$TableRevokeCommandCopyWith<$Res> implements $TableRevokeCommandCopyWith<$Res> {
  factory _$TableRevokeCommandCopyWith(_TableRevokeCommand value, $Res Function(_TableRevokeCommand) _then) = __$TableRevokeCommandCopyWithImpl;
@override @useResult
$Res call({
 TableRevokeCommandKind kind,@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class __$TableRevokeCommandCopyWithImpl<$Res>
    implements _$TableRevokeCommandCopyWith<$Res> {
  __$TableRevokeCommandCopyWithImpl(this._self, this._then);

  final _TableRevokeCommand _self;
  final $Res Function(_TableRevokeCommand) _then;

/// Create a copy of TableRevokeCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? accountId = null,}) {
  return _then(_TableRevokeCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableRevokeCommandKind,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
