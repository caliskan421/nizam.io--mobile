// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_program_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetProgramRequest {

 String get password;
/// Create a copy of ResetProgramRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetProgramRequestCopyWith<ResetProgramRequest> get copyWith => _$ResetProgramRequestCopyWithImpl<ResetProgramRequest>(this as ResetProgramRequest, _$identity);

  /// Serializes this ResetProgramRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResetProgramRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetProgramRequest&&(identical(other.password, _this.password) || other.password == _this.password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResetProgramRequest;
  return Object.hash(runtimeType,_this.password);
}



}

/// @nodoc
abstract mixin class $ResetProgramRequestCopyWith<$Res>  {
  factory $ResetProgramRequestCopyWith(ResetProgramRequest value, $Res Function(ResetProgramRequest) _then) = _$ResetProgramRequestCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$ResetProgramRequestCopyWithImpl<$Res>
    implements $ResetProgramRequestCopyWith<$Res> {
  _$ResetProgramRequestCopyWithImpl(this._self, this._then);

  final ResetProgramRequest _self;
  final $Res Function(ResetProgramRequest) _then;

/// Create a copy of ResetProgramRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,}) {
  return _then(ResetProgramRequest(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResetProgramRequest].
extension ResetProgramRequestPatterns on ResetProgramRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResetProgramRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResetProgramRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResetProgramRequest value)  $default,){
final _that = this;
switch (_that) {
case _ResetProgramRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResetProgramRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ResetProgramRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResetProgramRequest() when $default != null:
return $default(_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password)  $default,) {final _that = this;
switch (_that) {
case _ResetProgramRequest():
return $default(_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password)?  $default,) {final _that = this;
switch (_that) {
case _ResetProgramRequest() when $default != null:
return $default(_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResetProgramRequest implements ResetProgramRequest {
  const _ResetProgramRequest({required this.password});
  factory _ResetProgramRequest.fromJson(Map<String, dynamic> json) => _$ResetProgramRequestFromJson(json);

@override final  String password;

/// Create a copy of ResetProgramRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetProgramRequestCopyWith<_ResetProgramRequest> get copyWith => __$ResetProgramRequestCopyWithImpl<_ResetProgramRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResetProgramRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetProgramRequest&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,password);
}



}

/// @nodoc
abstract mixin class _$ResetProgramRequestCopyWith<$Res> implements $ResetProgramRequestCopyWith<$Res> {
  factory _$ResetProgramRequestCopyWith(_ResetProgramRequest value, $Res Function(_ResetProgramRequest) _then) = __$ResetProgramRequestCopyWithImpl;
@override @useResult
$Res call({
 String password
});




}
/// @nodoc
class __$ResetProgramRequestCopyWithImpl<$Res>
    implements _$ResetProgramRequestCopyWith<$Res> {
  __$ResetProgramRequestCopyWithImpl(this._self, this._then);

  final _ResetProgramRequest _self;
  final $Res Function(_ResetProgramRequest) _then;

/// Create a copy of ResetProgramRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_ResetProgramRequest(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
