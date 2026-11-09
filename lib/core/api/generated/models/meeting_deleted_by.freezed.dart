// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_deleted_by.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingDeletedBy {

@JsonKey(name: 'account_id') String get accountId;/// Hesabın bugünkü görünen adı; hesap bulunamazsa boş.
@JsonKey(name: 'full_name') String get fullName;
/// Create a copy of MeetingDeletedBy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingDeletedByCopyWith<MeetingDeletedBy> get copyWith => _$MeetingDeletedByCopyWithImpl<MeetingDeletedBy>(this as MeetingDeletedBy, _$identity);

  /// Serializes this MeetingDeletedBy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetingDeletedBy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingDeletedBy&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetingDeletedBy;
  return Object.hash(runtimeType,_this.accountId,_this.fullName);
}

@override
String toString() {
  final _this = this as MeetingDeletedBy;
  return 'MeetingDeletedBy(accountId: ${_this.accountId}, fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $MeetingDeletedByCopyWith<$Res>  {
  factory $MeetingDeletedByCopyWith(MeetingDeletedBy value, $Res Function(MeetingDeletedBy) _then) = _$MeetingDeletedByCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class _$MeetingDeletedByCopyWithImpl<$Res>
    implements $MeetingDeletedByCopyWith<$Res> {
  _$MeetingDeletedByCopyWithImpl(this._self, this._then);

  final MeetingDeletedBy _self;
  final $Res Function(MeetingDeletedBy) _then;

/// Create a copy of MeetingDeletedBy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,}) {
  return _then(MeetingDeletedBy(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingDeletedBy].
extension MeetingDeletedByPatterns on MeetingDeletedBy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingDeletedBy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingDeletedBy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingDeletedBy value)  $default,){
final _that = this;
switch (_that) {
case _MeetingDeletedBy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingDeletedBy value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingDeletedBy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingDeletedBy() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)  $default,) {final _that = this;
switch (_that) {
case _MeetingDeletedBy():
return $default(_that.accountId,_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName)?  $default,) {final _that = this;
switch (_that) {
case _MeetingDeletedBy() when $default != null:
return $default(_that.accountId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingDeletedBy implements MeetingDeletedBy {
  const _MeetingDeletedBy({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName});
  factory _MeetingDeletedBy.fromJson(Map<String, dynamic> json) => _$MeetingDeletedByFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
/// Hesabın bugünkü görünen adı; hesap bulunamazsa boş.
@override@JsonKey(name: 'full_name') final  String fullName;

/// Create a copy of MeetingDeletedBy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingDeletedByCopyWith<_MeetingDeletedBy> get copyWith => __$MeetingDeletedByCopyWithImpl<_MeetingDeletedBy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingDeletedByToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingDeletedBy&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName);
}

@override
String toString() {
    return 'MeetingDeletedBy(accountId: $accountId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$MeetingDeletedByCopyWith<$Res> implements $MeetingDeletedByCopyWith<$Res> {
  factory _$MeetingDeletedByCopyWith(_MeetingDeletedBy value, $Res Function(_MeetingDeletedBy) _then) = __$MeetingDeletedByCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName
});




}
/// @nodoc
class __$MeetingDeletedByCopyWithImpl<$Res>
    implements _$MeetingDeletedByCopyWith<$Res> {
  __$MeetingDeletedByCopyWithImpl(this._self, this._then);

  final _MeetingDeletedBy _self;
  final $Res Function(_MeetingDeletedBy) _then;

/// Create a copy of MeetingDeletedBy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,}) {
  return _then(_MeetingDeletedBy(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
