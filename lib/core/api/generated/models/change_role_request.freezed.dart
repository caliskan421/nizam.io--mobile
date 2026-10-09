// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_role_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangeRoleRequest {

 String get role; bool? get confirm;
/// Create a copy of ChangeRoleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeRoleRequestCopyWith<ChangeRoleRequest> get copyWith => _$ChangeRoleRequestCopyWithImpl<ChangeRoleRequest>(this as ChangeRoleRequest, _$identity);

  /// Serializes this ChangeRoleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChangeRoleRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeRoleRequest&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.confirm, _this.confirm) || other.confirm == _this.confirm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChangeRoleRequest;
  return Object.hash(runtimeType,_this.role,_this.confirm);
}

@override
String toString() {
  final _this = this as ChangeRoleRequest;
  return 'ChangeRoleRequest(role: ${_this.role}, confirm: ${_this.confirm})';
}


}

/// @nodoc
abstract mixin class $ChangeRoleRequestCopyWith<$Res>  {
  factory $ChangeRoleRequestCopyWith(ChangeRoleRequest value, $Res Function(ChangeRoleRequest) _then) = _$ChangeRoleRequestCopyWithImpl;
@useResult
$Res call({
 String role, bool? confirm
});




}
/// @nodoc
class _$ChangeRoleRequestCopyWithImpl<$Res>
    implements $ChangeRoleRequestCopyWith<$Res> {
  _$ChangeRoleRequestCopyWithImpl(this._self, this._then);

  final ChangeRoleRequest _self;
  final $Res Function(ChangeRoleRequest) _then;

/// Create a copy of ChangeRoleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? confirm = freezed,}) {
  return _then(ChangeRoleRequest(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,confirm: freezed == confirm ? _self.confirm : confirm // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeRoleRequest].
extension ChangeRoleRequestPatterns on ChangeRoleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeRoleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeRoleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeRoleRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChangeRoleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeRoleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeRoleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  bool? confirm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeRoleRequest() when $default != null:
return $default(_that.role,_that.confirm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  bool? confirm)  $default,) {final _that = this;
switch (_that) {
case _ChangeRoleRequest():
return $default(_that.role,_that.confirm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  bool? confirm)?  $default,) {final _that = this;
switch (_that) {
case _ChangeRoleRequest() when $default != null:
return $default(_that.role,_that.confirm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangeRoleRequest implements ChangeRoleRequest {
  const _ChangeRoleRequest({required this.role, this.confirm});
  factory _ChangeRoleRequest.fromJson(Map<String, dynamic> json) => _$ChangeRoleRequestFromJson(json);

@override final  String role;
@override final  bool? confirm;

/// Create a copy of ChangeRoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeRoleRequestCopyWith<_ChangeRoleRequest> get copyWith => __$ChangeRoleRequestCopyWithImpl<_ChangeRoleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeRoleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeRoleRequest&&(identical(other.role, role) || other.role == role)&&(identical(other.confirm, confirm) || other.confirm == confirm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,role,confirm);
}

@override
String toString() {
    return 'ChangeRoleRequest(role: $role, confirm: $confirm)';
}


}

/// @nodoc
abstract mixin class _$ChangeRoleRequestCopyWith<$Res> implements $ChangeRoleRequestCopyWith<$Res> {
  factory _$ChangeRoleRequestCopyWith(_ChangeRoleRequest value, $Res Function(_ChangeRoleRequest) _then) = __$ChangeRoleRequestCopyWithImpl;
@override @useResult
$Res call({
 String role, bool? confirm
});




}
/// @nodoc
class __$ChangeRoleRequestCopyWithImpl<$Res>
    implements _$ChangeRoleRequestCopyWith<$Res> {
  __$ChangeRoleRequestCopyWithImpl(this._self, this._then);

  final _ChangeRoleRequest _self;
  final $Res Function(_ChangeRoleRequest) _then;

/// Create a copy of ChangeRoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? confirm = freezed,}) {
  return _then(_ChangeRoleRequest(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,confirm: freezed == confirm ? _self.confirm : confirm // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
