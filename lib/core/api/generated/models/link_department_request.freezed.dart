// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_department_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LinkDepartmentRequest {

@JsonKey(name: 'department_id') String get departmentId;
/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkDepartmentRequestCopyWith<LinkDepartmentRequest> get copyWith => _$LinkDepartmentRequestCopyWithImpl<LinkDepartmentRequest>(this as LinkDepartmentRequest, _$identity);

  /// Serializes this LinkDepartmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LinkDepartmentRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkDepartmentRequest&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LinkDepartmentRequest;
  return Object.hash(runtimeType,_this.departmentId);
}

@override
String toString() {
  final _this = this as LinkDepartmentRequest;
  return 'LinkDepartmentRequest(departmentId: ${_this.departmentId})';
}


}

/// @nodoc
abstract mixin class $LinkDepartmentRequestCopyWith<$Res>  {
  factory $LinkDepartmentRequestCopyWith(LinkDepartmentRequest value, $Res Function(LinkDepartmentRequest) _then) = _$LinkDepartmentRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class _$LinkDepartmentRequestCopyWithImpl<$Res>
    implements $LinkDepartmentRequestCopyWith<$Res> {
  _$LinkDepartmentRequestCopyWithImpl(this._self, this._then);

  final LinkDepartmentRequest _self;
  final $Res Function(LinkDepartmentRequest) _then;

/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departmentId = null,}) {
  return _then(LinkDepartmentRequest(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LinkDepartmentRequest].
extension LinkDepartmentRequestPatterns on LinkDepartmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkDepartmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkDepartmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _LinkDepartmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkDepartmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
return $default(_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'department_id')  String departmentId)  $default,) {final _that = this;
switch (_that) {
case _LinkDepartmentRequest():
return $default(_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'department_id')  String departmentId)?  $default,) {final _that = this;
switch (_that) {
case _LinkDepartmentRequest() when $default != null:
return $default(_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkDepartmentRequest implements LinkDepartmentRequest {
  const _LinkDepartmentRequest({@JsonKey(name: 'department_id') required this.departmentId});
  factory _LinkDepartmentRequest.fromJson(Map<String, dynamic> json) => _$LinkDepartmentRequestFromJson(json);

@override@JsonKey(name: 'department_id') final  String departmentId;

/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkDepartmentRequestCopyWith<_LinkDepartmentRequest> get copyWith => __$LinkDepartmentRequestCopyWithImpl<_LinkDepartmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LinkDepartmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkDepartmentRequest&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departmentId);
}

@override
String toString() {
    return 'LinkDepartmentRequest(departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$LinkDepartmentRequestCopyWith<$Res> implements $LinkDepartmentRequestCopyWith<$Res> {
  factory _$LinkDepartmentRequestCopyWith(_LinkDepartmentRequest value, $Res Function(_LinkDepartmentRequest) _then) = __$LinkDepartmentRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class __$LinkDepartmentRequestCopyWithImpl<$Res>
    implements _$LinkDepartmentRequestCopyWith<$Res> {
  __$LinkDepartmentRequestCopyWithImpl(this._self, this._then);

  final _LinkDepartmentRequest _self;
  final $Res Function(_LinkDepartmentRequest) _then;

/// Create a copy of LinkDepartmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departmentId = null,}) {
  return _then(_LinkDepartmentRequest(
departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
