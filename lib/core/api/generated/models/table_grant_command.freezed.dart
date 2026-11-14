// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_grant_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableGrantCommand {

 TableGrantCommandKind get kind;@JsonKey(name: 'account_id') String get accountId; TableGrantCommandRole get role;
/// Create a copy of TableGrantCommand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableGrantCommandCopyWith<TableGrantCommand> get copyWith => _$TableGrantCommandCopyWithImpl<TableGrantCommand>(this as TableGrantCommand, _$identity);

  /// Serializes this TableGrantCommand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableGrantCommand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableGrantCommand&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableGrantCommand;
  return Object.hash(runtimeType,_this.kind,_this.accountId,_this.role);
}

@override
String toString() {
  final _this = this as TableGrantCommand;
  return 'TableGrantCommand(kind: ${_this.kind}, accountId: ${_this.accountId}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TableGrantCommandCopyWith<$Res>  {
  factory $TableGrantCommandCopyWith(TableGrantCommand value, $Res Function(TableGrantCommand) _then) = _$TableGrantCommandCopyWithImpl;
@useResult
$Res call({
 TableGrantCommandKind kind,@JsonKey(name: 'account_id') String accountId, TableGrantCommandRole role
});




}
/// @nodoc
class _$TableGrantCommandCopyWithImpl<$Res>
    implements $TableGrantCommandCopyWith<$Res> {
  _$TableGrantCommandCopyWithImpl(this._self, this._then);

  final TableGrantCommand _self;
  final $Res Function(TableGrantCommand) _then;

/// Create a copy of TableGrantCommand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? accountId = null,Object? role = null,}) {
  return _then(TableGrantCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableGrantCommandKind,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableGrantCommandRole,
  ));
}

}


/// Adds pattern-matching-related methods to [TableGrantCommand].
extension TableGrantCommandPatterns on TableGrantCommand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableGrantCommand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableGrantCommand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableGrantCommand value)  $default,){
final _that = this;
switch (_that) {
case _TableGrantCommand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableGrantCommand value)?  $default,){
final _that = this;
switch (_that) {
case _TableGrantCommand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableGrantCommandKind kind, @JsonKey(name: 'account_id')  String accountId,  TableGrantCommandRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableGrantCommand() when $default != null:
return $default(_that.kind,_that.accountId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableGrantCommandKind kind, @JsonKey(name: 'account_id')  String accountId,  TableGrantCommandRole role)  $default,) {final _that = this;
switch (_that) {
case _TableGrantCommand():
return $default(_that.kind,_that.accountId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableGrantCommandKind kind, @JsonKey(name: 'account_id')  String accountId,  TableGrantCommandRole role)?  $default,) {final _that = this;
switch (_that) {
case _TableGrantCommand() when $default != null:
return $default(_that.kind,_that.accountId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableGrantCommand implements TableGrantCommand {
  const _TableGrantCommand({required this.kind, @JsonKey(name: 'account_id') required this.accountId, required this.role});
  factory _TableGrantCommand.fromJson(Map<String, dynamic> json) => _$TableGrantCommandFromJson(json);

@override final  TableGrantCommandKind kind;
@override@JsonKey(name: 'account_id') final  String accountId;
@override final  TableGrantCommandRole role;

/// Create a copy of TableGrantCommand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableGrantCommandCopyWith<_TableGrantCommand> get copyWith => __$TableGrantCommandCopyWithImpl<_TableGrantCommand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableGrantCommandToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableGrantCommand&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,accountId,role);
}

@override
String toString() {
    return 'TableGrantCommand(kind: $kind, accountId: $accountId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TableGrantCommandCopyWith<$Res> implements $TableGrantCommandCopyWith<$Res> {
  factory _$TableGrantCommandCopyWith(_TableGrantCommand value, $Res Function(_TableGrantCommand) _then) = __$TableGrantCommandCopyWithImpl;
@override @useResult
$Res call({
 TableGrantCommandKind kind,@JsonKey(name: 'account_id') String accountId, TableGrantCommandRole role
});




}
/// @nodoc
class __$TableGrantCommandCopyWithImpl<$Res>
    implements _$TableGrantCommandCopyWith<$Res> {
  __$TableGrantCommandCopyWithImpl(this._self, this._then);

  final _TableGrantCommand _self;
  final $Res Function(_TableGrantCommand) _then;

/// Create a copy of TableGrantCommand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? accountId = null,Object? role = null,}) {
  return _then(_TableGrantCommand(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TableGrantCommandKind,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as TableGrantCommandRole,
  ));
}


}

// dart format on
