// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserResult {

@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'membership_id') String? get membershipId; bool? get created; bool? get transferred;@JsonKey(name: 'changed_fields') List<String>? get changedFields;@JsonKey(name: 'revoked_sessions') int? get revokedSessions;
/// Create a copy of UserResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserResultCopyWith<UserResult> get copyWith => _$UserResultCopyWithImpl<UserResult>(this as UserResult, _$identity);

  /// Serializes this UserResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserResult&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.membershipId, _this.membershipId) || other.membershipId == _this.membershipId)&&(identical(other.created, _this.created) || other.created == _this.created)&&(identical(other.transferred, _this.transferred) || other.transferred == _this.transferred)&&const DeepCollectionEquality().equals(other.changedFields, _this.changedFields)&&(identical(other.revokedSessions, _this.revokedSessions) || other.revokedSessions == _this.revokedSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserResult;
  return Object.hash(runtimeType,_this.accountId,_this.membershipId,_this.created,_this.transferred,const DeepCollectionEquality().hash(_this.changedFields),_this.revokedSessions);
}

@override
String toString() {
  final _this = this as UserResult;
  return 'UserResult(accountId: ${_this.accountId}, membershipId: ${_this.membershipId}, created: ${_this.created}, transferred: ${_this.transferred}, changedFields: ${_this.changedFields}, revokedSessions: ${_this.revokedSessions})';
}


}

/// @nodoc
abstract mixin class $UserResultCopyWith<$Res>  {
  factory $UserResultCopyWith(UserResult value, $Res Function(UserResult) _then) = _$UserResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'membership_id') String? membershipId, bool? created, bool? transferred,@JsonKey(name: 'changed_fields') List<String>? changedFields,@JsonKey(name: 'revoked_sessions') int? revokedSessions
});




}
/// @nodoc
class _$UserResultCopyWithImpl<$Res>
    implements $UserResultCopyWith<$Res> {
  _$UserResultCopyWithImpl(this._self, this._then);

  final UserResult _self;
  final $Res Function(UserResult) _then;

/// Create a copy of UserResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? membershipId = freezed,Object? created = freezed,Object? transferred = freezed,Object? changedFields = freezed,Object? revokedSessions = freezed,}) {
  return _then(UserResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as bool?,transferred: freezed == transferred ? _self.transferred : transferred // ignore: cast_nullable_to_non_nullable
as bool?,changedFields: freezed == changedFields ? _self.changedFields : changedFields // ignore: cast_nullable_to_non_nullable
as List<String>?,revokedSessions: freezed == revokedSessions ? _self.revokedSessions : revokedSessions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserResult].
extension UserResultPatterns on UserResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserResult value)  $default,){
final _that = this;
switch (_that) {
case _UserResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserResult value)?  $default,){
final _that = this;
switch (_that) {
case _UserResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'membership_id')  String? membershipId,  bool? created,  bool? transferred, @JsonKey(name: 'changed_fields')  List<String>? changedFields, @JsonKey(name: 'revoked_sessions')  int? revokedSessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserResult() when $default != null:
return $default(_that.accountId,_that.membershipId,_that.created,_that.transferred,_that.changedFields,_that.revokedSessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'membership_id')  String? membershipId,  bool? created,  bool? transferred, @JsonKey(name: 'changed_fields')  List<String>? changedFields, @JsonKey(name: 'revoked_sessions')  int? revokedSessions)  $default,) {final _that = this;
switch (_that) {
case _UserResult():
return $default(_that.accountId,_that.membershipId,_that.created,_that.transferred,_that.changedFields,_that.revokedSessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'membership_id')  String? membershipId,  bool? created,  bool? transferred, @JsonKey(name: 'changed_fields')  List<String>? changedFields, @JsonKey(name: 'revoked_sessions')  int? revokedSessions)?  $default,) {final _that = this;
switch (_that) {
case _UserResult() when $default != null:
return $default(_that.accountId,_that.membershipId,_that.created,_that.transferred,_that.changedFields,_that.revokedSessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserResult implements UserResult {
  const _UserResult({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'membership_id') this.membershipId, this.created, this.transferred, @JsonKey(name: 'changed_fields')  List<String>? changedFields, @JsonKey(name: 'revoked_sessions') this.revokedSessions}): _changedFields = changedFields;
  factory _UserResult.fromJson(Map<String, dynamic> json) => _$UserResultFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'membership_id') final  String? membershipId;
@override final  bool? created;
@override final  bool? transferred;
 final  List<String>? _changedFields;
@override@JsonKey(name: 'changed_fields') List<String>? get changedFields {
  final value = _changedFields;
  if (value == null) return null;
  if (_changedFields is EqualUnmodifiableListView) return _changedFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'revoked_sessions') final  int? revokedSessions;

/// Create a copy of UserResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserResultCopyWith<_UserResult> get copyWith => __$UserResultCopyWithImpl<_UserResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserResult&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.created, created) || other.created == created)&&(identical(other.transferred, transferred) || other.transferred == transferred)&&const DeepCollectionEquality().equals(other.changedFields, _changedFields)&&(identical(other.revokedSessions, revokedSessions) || other.revokedSessions == revokedSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId,membershipId,created,transferred,const DeepCollectionEquality().hash(_changedFields),revokedSessions);
}

@override
String toString() {
    return 'UserResult(accountId: $accountId, membershipId: $membershipId, created: $created, transferred: $transferred, changedFields: $changedFields, revokedSessions: $revokedSessions)';
}


}

/// @nodoc
abstract mixin class _$UserResultCopyWith<$Res> implements $UserResultCopyWith<$Res> {
  factory _$UserResultCopyWith(_UserResult value, $Res Function(_UserResult) _then) = __$UserResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'membership_id') String? membershipId, bool? created, bool? transferred,@JsonKey(name: 'changed_fields') List<String>? changedFields,@JsonKey(name: 'revoked_sessions') int? revokedSessions
});




}
/// @nodoc
class __$UserResultCopyWithImpl<$Res>
    implements _$UserResultCopyWith<$Res> {
  __$UserResultCopyWithImpl(this._self, this._then);

  final _UserResult _self;
  final $Res Function(_UserResult) _then;

/// Create a copy of UserResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? membershipId = freezed,Object? created = freezed,Object? transferred = freezed,Object? changedFields = freezed,Object? revokedSessions = freezed,}) {
  return _then(_UserResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as bool?,transferred: freezed == transferred ? _self.transferred : transferred // ignore: cast_nullable_to_non_nullable
as bool?,changedFields: freezed == changedFields ? _self._changedFields : changedFields // ignore: cast_nullable_to_non_nullable
as List<String>?,revokedSessions: freezed == revokedSessions ? _self.revokedSessions : revokedSessions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
