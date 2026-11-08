// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_chat_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateChatRequest {

 String? get name; UpdateChatRequestSource? get source;@JsonKey(name: 'source_department_id') String? get sourceDepartmentId;
/// Create a copy of UpdateChatRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatRequestCopyWith<UpdateChatRequest> get copyWith => _$UpdateChatRequestCopyWithImpl<UpdateChatRequest>(this as UpdateChatRequest, _$identity);

  /// Serializes this UpdateChatRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateChatRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceDepartmentId, _this.sourceDepartmentId) || other.sourceDepartmentId == _this.sourceDepartmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateChatRequest;
  return Object.hash(runtimeType,_this.name,_this.source,_this.sourceDepartmentId);
}

@override
String toString() {
  final _this = this as UpdateChatRequest;
  return 'UpdateChatRequest(name: ${_this.name}, source: ${_this.source}, sourceDepartmentId: ${_this.sourceDepartmentId})';
}


}

/// @nodoc
abstract mixin class $UpdateChatRequestCopyWith<$Res>  {
  factory $UpdateChatRequestCopyWith(UpdateChatRequest value, $Res Function(UpdateChatRequest) _then) = _$UpdateChatRequestCopyWithImpl;
@useResult
$Res call({
 String? name, UpdateChatRequestSource? source,@JsonKey(name: 'source_department_id') String? sourceDepartmentId
});




}
/// @nodoc
class _$UpdateChatRequestCopyWithImpl<$Res>
    implements $UpdateChatRequestCopyWith<$Res> {
  _$UpdateChatRequestCopyWithImpl(this._self, this._then);

  final UpdateChatRequest _self;
  final $Res Function(UpdateChatRequest) _then;

/// Create a copy of UpdateChatRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? source = freezed,Object? sourceDepartmentId = freezed,}) {
  return _then(UpdateChatRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as UpdateChatRequestSource?,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatRequest].
extension UpdateChatRequestPatterns on UpdateChatRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  UpdateChatRequestSource? source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatRequest() when $default != null:
return $default(_that.name,_that.source,_that.sourceDepartmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  UpdateChatRequestSource? source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatRequest():
return $default(_that.name,_that.source,_that.sourceDepartmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  UpdateChatRequestSource? source, @JsonKey(name: 'source_department_id')  String? sourceDepartmentId)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatRequest() when $default != null:
return $default(_that.name,_that.source,_that.sourceDepartmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatRequest implements UpdateChatRequest {
  const _UpdateChatRequest({this.name, this.source, @JsonKey(name: 'source_department_id') this.sourceDepartmentId});
  factory _UpdateChatRequest.fromJson(Map<String, dynamic> json) => _$UpdateChatRequestFromJson(json);

@override final  String? name;
@override final  UpdateChatRequestSource? source;
@override@JsonKey(name: 'source_department_id') final  String? sourceDepartmentId;

/// Create a copy of UpdateChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatRequestCopyWith<_UpdateChatRequest> get copyWith => __$UpdateChatRequestCopyWithImpl<_UpdateChatRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceDepartmentId, sourceDepartmentId) || other.sourceDepartmentId == sourceDepartmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,source,sourceDepartmentId);
}

@override
String toString() {
    return 'UpdateChatRequest(name: $name, source: $source, sourceDepartmentId: $sourceDepartmentId)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatRequestCopyWith<$Res> implements $UpdateChatRequestCopyWith<$Res> {
  factory _$UpdateChatRequestCopyWith(_UpdateChatRequest value, $Res Function(_UpdateChatRequest) _then) = __$UpdateChatRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, UpdateChatRequestSource? source,@JsonKey(name: 'source_department_id') String? sourceDepartmentId
});




}
/// @nodoc
class __$UpdateChatRequestCopyWithImpl<$Res>
    implements _$UpdateChatRequestCopyWith<$Res> {
  __$UpdateChatRequestCopyWithImpl(this._self, this._then);

  final _UpdateChatRequest _self;
  final $Res Function(_UpdateChatRequest) _then;

/// Create a copy of UpdateChatRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? source = freezed,Object? sourceDepartmentId = freezed,}) {
  return _then(_UpdateChatRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as UpdateChatRequestSource?,sourceDepartmentId: freezed == sourceDepartmentId ? _self.sourceDepartmentId : sourceDepartmentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
