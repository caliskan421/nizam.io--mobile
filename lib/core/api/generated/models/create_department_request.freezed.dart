// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_department_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateDepartmentRequest {

 String get name; String get kind; String? get code; String? get description;
/// Create a copy of CreateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateDepartmentRequestCopyWith<CreateDepartmentRequest> get copyWith => _$CreateDepartmentRequestCopyWithImpl<CreateDepartmentRequest>(this as CreateDepartmentRequest, _$identity);

  /// Serializes this CreateDepartmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateDepartmentRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateDepartmentRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateDepartmentRequest;
  return Object.hash(runtimeType,_this.name,_this.kind,_this.code,_this.description);
}

@override
String toString() {
  final _this = this as CreateDepartmentRequest;
  return 'CreateDepartmentRequest(name: ${_this.name}, kind: ${_this.kind}, code: ${_this.code}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $CreateDepartmentRequestCopyWith<$Res>  {
  factory $CreateDepartmentRequestCopyWith(CreateDepartmentRequest value, $Res Function(CreateDepartmentRequest) _then) = _$CreateDepartmentRequestCopyWithImpl;
@useResult
$Res call({
 String name, String kind, String? code, String? description
});




}
/// @nodoc
class _$CreateDepartmentRequestCopyWithImpl<$Res>
    implements $CreateDepartmentRequestCopyWith<$Res> {
  _$CreateDepartmentRequestCopyWithImpl(this._self, this._then);

  final CreateDepartmentRequest _self;
  final $Res Function(CreateDepartmentRequest) _then;

/// Create a copy of CreateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? kind = null,Object? code = freezed,Object? description = freezed,}) {
  return _then(CreateDepartmentRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateDepartmentRequest].
extension CreateDepartmentRequestPatterns on CreateDepartmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateDepartmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateDepartmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateDepartmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateDepartmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String kind,  String? code,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String kind,  String? code,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CreateDepartmentRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String kind,  String? code,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CreateDepartmentRequest() when $default != null:
return $default(_that.name,_that.kind,_that.code,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateDepartmentRequest implements CreateDepartmentRequest {
  const _CreateDepartmentRequest({required this.name, required this.kind, this.code, this.description});
  factory _CreateDepartmentRequest.fromJson(Map<String, dynamic> json) => _$CreateDepartmentRequestFromJson(json);

@override final  String name;
@override final  String kind;
@override final  String? code;
@override final  String? description;

/// Create a copy of CreateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateDepartmentRequestCopyWith<_CreateDepartmentRequest> get copyWith => __$CreateDepartmentRequestCopyWithImpl<_CreateDepartmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateDepartmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateDepartmentRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.code, code) || other.code == code)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,kind,code,description);
}

@override
String toString() {
    return 'CreateDepartmentRequest(name: $name, kind: $kind, code: $code, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateDepartmentRequestCopyWith<$Res> implements $CreateDepartmentRequestCopyWith<$Res> {
  factory _$CreateDepartmentRequestCopyWith(_CreateDepartmentRequest value, $Res Function(_CreateDepartmentRequest) _then) = __$CreateDepartmentRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String kind, String? code, String? description
});




}
/// @nodoc
class __$CreateDepartmentRequestCopyWithImpl<$Res>
    implements _$CreateDepartmentRequestCopyWith<$Res> {
  __$CreateDepartmentRequestCopyWithImpl(this._self, this._then);

  final _CreateDepartmentRequest _self;
  final $Res Function(_CreateDepartmentRequest) _then;

/// Create a copy of CreateDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? kind = null,Object? code = freezed,Object? description = freezed,}) {
  return _then(_CreateDepartmentRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
