// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_department_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateDepartmentRequest {

 String? get name; String? get kind; String? get code; String? get description;
/// Create a copy of UpdateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateDepartmentRequestCopyWith<UpdateDepartmentRequest> get copyWith => _$UpdateDepartmentRequestCopyWithImpl<UpdateDepartmentRequest>(this as UpdateDepartmentRequest, _$identity);

  /// Serializes this UpdateDepartmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateDepartmentRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateDepartmentRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateDepartmentRequest;
  return Object.hash(runtimeType,_this.name,_this.kind,_this.code,_this.description);
}

@override
String toString() {
  final _this = this as UpdateDepartmentRequest;
  return 'UpdateDepartmentRequest(name: ${_this.name}, kind: ${_this.kind}, code: ${_this.code}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $UpdateDepartmentRequestCopyWith<$Res>  {
  factory $UpdateDepartmentRequestCopyWith(UpdateDepartmentRequest value, $Res Function(UpdateDepartmentRequest) _then) = _$UpdateDepartmentRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? kind, String? code, String? description
});




}
/// @nodoc
class _$UpdateDepartmentRequestCopyWithImpl<$Res>
    implements $UpdateDepartmentRequestCopyWith<$Res> {
  _$UpdateDepartmentRequestCopyWithImpl(this._self, this._then);

  final UpdateDepartmentRequest _self;
  final $Res Function(UpdateDepartmentRequest) _then;

/// Create a copy of UpdateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? kind = freezed,Object? code = freezed,Object? description = freezed,}) {
  return _then(UpdateDepartmentRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateDepartmentRequest].
extension UpdateDepartmentRequestPatterns on UpdateDepartmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateDepartmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateDepartmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateDepartmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateDepartmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? kind,  String? code,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateDepartmentRequest() when $default != null:
return $default(_that.name,_that.kind,_that.code,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? kind,  String? code,  String? description)  $default,) {final _that = this;
switch (_that) {
case _UpdateDepartmentRequest():
return $default(_that.name,_that.kind,_that.code,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? kind,  String? code,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _UpdateDepartmentRequest() when $default != null:
return $default(_that.name,_that.kind,_that.code,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateDepartmentRequest implements UpdateDepartmentRequest {
  const _UpdateDepartmentRequest({this.name, this.kind, this.code, this.description});
  factory _UpdateDepartmentRequest.fromJson(Map<String, dynamic> json) => _$UpdateDepartmentRequestFromJson(json);

@override final  String? name;
@override final  String? kind;
@override final  String? code;
@override final  String? description;

/// Create a copy of UpdateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDepartmentRequestCopyWith<_UpdateDepartmentRequest> get copyWith => __$UpdateDepartmentRequestCopyWithImpl<_UpdateDepartmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateDepartmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDepartmentRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,kind,code,description);
}

@override
String toString() {
    return 'UpdateDepartmentRequest(name: $name, kind: $kind, code: $code, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UpdateDepartmentRequestCopyWith<$Res> implements $UpdateDepartmentRequestCopyWith<$Res> {
  factory _$UpdateDepartmentRequestCopyWith(_UpdateDepartmentRequest value, $Res Function(_UpdateDepartmentRequest) _then) = __$UpdateDepartmentRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? kind, String? code, String? description
});




}
/// @nodoc
class __$UpdateDepartmentRequestCopyWithImpl<$Res>
    implements _$UpdateDepartmentRequestCopyWith<$Res> {
  __$UpdateDepartmentRequestCopyWithImpl(this._self, this._then);

  final _UpdateDepartmentRequest _self;
  final $Res Function(_UpdateDepartmentRequest) _then;

/// Create a copy of UpdateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? kind = freezed,Object? code = freezed,Object? description = freezed,}) {
  return _then(_UpdateDepartmentRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
