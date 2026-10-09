// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coordinator_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoordinatorRequest {

@JsonKey(name: 'account_id') String get accountId;
/// Create a copy of CoordinatorRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatorRequestCopyWith<CoordinatorRequest> get copyWith => _$CoordinatorRequestCopyWithImpl<CoordinatorRequest>(this as CoordinatorRequest, _$identity);

  /// Serializes this CoordinatorRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CoordinatorRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoordinatorRequest&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CoordinatorRequest;
  return Object.hash(runtimeType,_this.accountId);
}

@override
String toString() {
  final _this = this as CoordinatorRequest;
  return 'CoordinatorRequest(accountId: ${_this.accountId})';
}


}

/// @nodoc
abstract mixin class $CoordinatorRequestCopyWith<$Res>  {
  factory $CoordinatorRequestCopyWith(CoordinatorRequest value, $Res Function(CoordinatorRequest) _then) = _$CoordinatorRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class _$CoordinatorRequestCopyWithImpl<$Res>
    implements $CoordinatorRequestCopyWith<$Res> {
  _$CoordinatorRequestCopyWithImpl(this._self, this._then);

  final CoordinatorRequest _self;
  final $Res Function(CoordinatorRequest) _then;

/// Create a copy of CoordinatorRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,}) {
  return _then(CoordinatorRequest(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CoordinatorRequest].
extension CoordinatorRequestPatterns on CoordinatorRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoordinatorRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoordinatorRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoordinatorRequest value)  $default,){
final _that = this;
switch (_that) {
case _CoordinatorRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoordinatorRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CoordinatorRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoordinatorRequest() when $default != null:
return $default(_that.accountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  String accountId)  $default,) {final _that = this;
switch (_that) {
case _CoordinatorRequest():
return $default(_that.accountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  String accountId)?  $default,) {final _that = this;
switch (_that) {
case _CoordinatorRequest() when $default != null:
return $default(_that.accountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoordinatorRequest implements CoordinatorRequest {
  const _CoordinatorRequest({@JsonKey(name: 'account_id') required this.accountId});
  factory _CoordinatorRequest.fromJson(Map<String, dynamic> json) => _$CoordinatorRequestFromJson(json);

@override@JsonKey(name: 'account_id') final  String accountId;

/// Create a copy of CoordinatorRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatorRequestCopyWith<_CoordinatorRequest> get copyWith => __$CoordinatorRequestCopyWithImpl<_CoordinatorRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatorRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoordinatorRequest&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountId);
}

@override
String toString() {
    return 'CoordinatorRequest(accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$CoordinatorRequestCopyWith<$Res> implements $CoordinatorRequestCopyWith<$Res> {
  factory _$CoordinatorRequestCopyWith(_CoordinatorRequest value, $Res Function(_CoordinatorRequest) _then) = __$CoordinatorRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') String accountId
});




}
/// @nodoc
class __$CoordinatorRequestCopyWithImpl<$Res>
    implements _$CoordinatorRequestCopyWith<$Res> {
  __$CoordinatorRequestCopyWithImpl(this._self, this._then);

  final _CoordinatorRequest _self;
  final $Res Function(_CoordinatorRequest) _then;

/// Create a copy of CoordinatorRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,}) {
  return _then(_CoordinatorRequest(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
