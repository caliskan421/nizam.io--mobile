// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_chat_members_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddChatMembersRequest {

@JsonKey(name: 'account_ids') List<String> get accountIds;
/// Create a copy of AddChatMembersRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddChatMembersRequestCopyWith<AddChatMembersRequest> get copyWith => _$AddChatMembersRequestCopyWithImpl<AddChatMembersRequest>(this as AddChatMembersRequest, _$identity);

  /// Serializes this AddChatMembersRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AddChatMembersRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddChatMembersRequest&&const DeepCollectionEquality().equals(other.accountIds, _this.accountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AddChatMembersRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.accountIds));
}

@override
String toString() {
  final _this = this as AddChatMembersRequest;
  return 'AddChatMembersRequest(accountIds: ${_this.accountIds})';
}


}

/// @nodoc
abstract mixin class $AddChatMembersRequestCopyWith<$Res>  {
  factory $AddChatMembersRequestCopyWith(AddChatMembersRequest value, $Res Function(AddChatMembersRequest) _then) = _$AddChatMembersRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_ids') List<String> accountIds
});




}
/// @nodoc
class _$AddChatMembersRequestCopyWithImpl<$Res>
    implements $AddChatMembersRequestCopyWith<$Res> {
  _$AddChatMembersRequestCopyWithImpl(this._self, this._then);

  final AddChatMembersRequest _self;
  final $Res Function(AddChatMembersRequest) _then;

/// Create a copy of AddChatMembersRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountIds = null,}) {
  return _then(AddChatMembersRequest(
accountIds: null == accountIds ? _self.accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AddChatMembersRequest].
extension AddChatMembersRequestPatterns on AddChatMembersRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddChatMembersRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddChatMembersRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddChatMembersRequest value)  $default,){
final _that = this;
switch (_that) {
case _AddChatMembersRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddChatMembersRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AddChatMembersRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_ids')  List<String> accountIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddChatMembersRequest() when $default != null:
return $default(_that.accountIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_ids')  List<String> accountIds)  $default,) {final _that = this;
switch (_that) {
case _AddChatMembersRequest():
return $default(_that.accountIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_ids')  List<String> accountIds)?  $default,) {final _that = this;
switch (_that) {
case _AddChatMembersRequest() when $default != null:
return $default(_that.accountIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddChatMembersRequest implements AddChatMembersRequest {
  const _AddChatMembersRequest({@JsonKey(name: 'account_ids') required  List<String> accountIds}): _accountIds = accountIds;
  factory _AddChatMembersRequest.fromJson(Map<String, dynamic> json) => _$AddChatMembersRequestFromJson(json);

 final  List<String> _accountIds;
@override@JsonKey(name: 'account_ids') List<String> get accountIds {
  if (_accountIds is EqualUnmodifiableListView) return _accountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accountIds);
}


/// Create a copy of AddChatMembersRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddChatMembersRequestCopyWith<_AddChatMembersRequest> get copyWith => __$AddChatMembersRequestCopyWithImpl<_AddChatMembersRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddChatMembersRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddChatMembersRequest&&const DeepCollectionEquality().equals(other.accountIds, _accountIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_accountIds));
}

@override
String toString() {
    return 'AddChatMembersRequest(accountIds: $accountIds)';
}


}

/// @nodoc
abstract mixin class _$AddChatMembersRequestCopyWith<$Res> implements $AddChatMembersRequestCopyWith<$Res> {
  factory _$AddChatMembersRequestCopyWith(_AddChatMembersRequest value, $Res Function(_AddChatMembersRequest) _then) = __$AddChatMembersRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_ids') List<String> accountIds
});




}
/// @nodoc
class __$AddChatMembersRequestCopyWithImpl<$Res>
    implements _$AddChatMembersRequestCopyWith<$Res> {
  __$AddChatMembersRequestCopyWithImpl(this._self, this._then);

  final _AddChatMembersRequest _self;
  final $Res Function(_AddChatMembersRequest) _then;

/// Create a copy of AddChatMembersRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountIds = null,}) {
  return _then(_AddChatMembersRequest(
accountIds: null == accountIds ? _self._accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
