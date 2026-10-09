// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'known_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KnownUser {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'full_name') String get fullName; List<String>? get memberships;
/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnownUserCopyWith<KnownUser> get copyWith => _$KnownUserCopyWithImpl<KnownUser>(this as KnownUser, _$identity);

  /// Serializes this KnownUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KnownUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnownUser&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&const DeepCollectionEquality().equals(other.memberships, _this.memberships));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KnownUser;
  return Object.hash(runtimeType,_this.accountId,_this.fullName,const DeepCollectionEquality().hash(_this.memberships));
}

@override
String toString() {
  final _this = this as KnownUser;
  return 'KnownUser(accountId: ${_this.accountId}, fullName: ${_this.fullName}, memberships: ${_this.memberships})';
}


}

/// @nodoc
abstract mixin class $KnownUserCopyWith<$Res>  {
  factory $KnownUserCopyWith(KnownUser value, $Res Function(KnownUser) _then) = _$KnownUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<String>? memberships
});




}
/// @nodoc
class _$KnownUserCopyWithImpl<$Res>
    implements $KnownUserCopyWith<$Res> {
  _$KnownUserCopyWithImpl(this._self, this._then);

  final KnownUser _self;
  final $Res Function(KnownUser) _then;

/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? fullName = null,Object? memberships = freezed,}) {
  return _then(KnownUser(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,memberships: freezed == memberships ? _self.memberships : memberships // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [KnownUser].
extension KnownUserPatterns on KnownUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnownUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnownUser value)  $default,){
final _that = this;
switch (_that) {
case _KnownUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnownUser value)?  $default,){
final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<String>? memberships)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
return $default(_that.accountId,_that.fullName,_that.memberships);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<String>? memberships)  $default,) {final _that = this;
switch (_that) {
case _KnownUser():
return $default(_that.accountId,_that.fullName,_that.memberships);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'full_name')  String fullName,  List<String>? memberships)?  $default,) {final _that = this;
switch (_that) {
case _KnownUser() when $default != null:
return $default(_that.accountId,_that.fullName,_that.memberships);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KnownUser implements KnownUser {
  const _KnownUser({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') required this.fullName, required  List<String>? memberships}): _memberships = memberships;
  factory _KnownUser.fromJson(Map<String, dynamic> json) => _$KnownUserFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'full_name') final  String fullName;
 final  List<String>? _memberships;
@override List<String>? get memberships {
  final value = _memberships;
  if (value == null) return null;
  if (_memberships is EqualUnmodifiableListView) return _memberships;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnownUserCopyWith<_KnownUser> get copyWith => __$KnownUserCopyWithImpl<_KnownUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KnownUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnownUser&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.memberships, _memberships));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,fullName,const DeepCollectionEquality().hash(_memberships));
}

@override
String toString() {
    return 'KnownUser(accountId: $accountId, fullName: $fullName, memberships: $memberships)';
}


}

/// @nodoc
abstract mixin class _$KnownUserCopyWith<$Res> implements $KnownUserCopyWith<$Res> {
  factory _$KnownUserCopyWith(_KnownUser value, $Res Function(_KnownUser) _then) = __$KnownUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'full_name') String fullName, List<String>? memberships
});




}
/// @nodoc
class __$KnownUserCopyWithImpl<$Res>
    implements _$KnownUserCopyWith<$Res> {
  __$KnownUserCopyWithImpl(this._self, this._then);

  final _KnownUser _self;
  final $Res Function(_KnownUser) _then;

/// Create a copy of KnownUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? fullName = null,Object? memberships = freezed,}) {
  return _then(_KnownUser(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,memberships: freezed == memberships ? _self._memberships : memberships // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
