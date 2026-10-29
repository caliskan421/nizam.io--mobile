// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dependency_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DependencyRequest {

@JsonKey(name: 'depends_on_work_item_id') String get dependsOnWorkItemId;
/// Create a copy of DependencyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DependencyRequestCopyWith<DependencyRequest> get copyWith => _$DependencyRequestCopyWithImpl<DependencyRequest>(this as DependencyRequest, _$identity);

  /// Serializes this DependencyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DependencyRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DependencyRequest&&(identical(other.dependsOnWorkItemId, _this.dependsOnWorkItemId) || other.dependsOnWorkItemId == _this.dependsOnWorkItemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DependencyRequest;
  return Object.hash(runtimeType,_this.dependsOnWorkItemId);
}

@override
String toString() {
  final _this = this as DependencyRequest;
  return 'DependencyRequest(dependsOnWorkItemId: ${_this.dependsOnWorkItemId})';
}


}

/// @nodoc
abstract mixin class $DependencyRequestCopyWith<$Res>  {
  factory $DependencyRequestCopyWith(DependencyRequest value, $Res Function(DependencyRequest) _then) = _$DependencyRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'depends_on_work_item_id') String dependsOnWorkItemId
});




}
/// @nodoc
class _$DependencyRequestCopyWithImpl<$Res>
    implements $DependencyRequestCopyWith<$Res> {
  _$DependencyRequestCopyWithImpl(this._self, this._then);

  final DependencyRequest _self;
  final $Res Function(DependencyRequest) _then;

/// Create a copy of DependencyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dependsOnWorkItemId = null,}) {
  return _then(DependencyRequest(
dependsOnWorkItemId: null == dependsOnWorkItemId ? _self.dependsOnWorkItemId : dependsOnWorkItemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DependencyRequest].
extension DependencyRequestPatterns on DependencyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DependencyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DependencyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DependencyRequest value)  $default,){
final _that = this;
switch (_that) {
case _DependencyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DependencyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DependencyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'depends_on_work_item_id')  String dependsOnWorkItemId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DependencyRequest() when $default != null:
return $default(_that.dependsOnWorkItemId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'depends_on_work_item_id')  String dependsOnWorkItemId)  $default,) {final _that = this;
switch (_that) {
case _DependencyRequest():
return $default(_that.dependsOnWorkItemId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'depends_on_work_item_id')  String dependsOnWorkItemId)?  $default,) {final _that = this;
switch (_that) {
case _DependencyRequest() when $default != null:
return $default(_that.dependsOnWorkItemId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DependencyRequest implements DependencyRequest {
  const _DependencyRequest({@JsonKey(name: 'depends_on_work_item_id') required this.dependsOnWorkItemId});
  factory _DependencyRequest.fromJson(Map<String, dynamic> json) => _$DependencyRequestFromJson(json);

@override@JsonKey(name: 'depends_on_work_item_id') final  String dependsOnWorkItemId;

/// Create a copy of DependencyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DependencyRequestCopyWith<_DependencyRequest> get copyWith => __$DependencyRequestCopyWithImpl<_DependencyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DependencyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DependencyRequest&&(identical(other.dependsOnWorkItemId, dependsOnWorkItemId) || other.dependsOnWorkItemId == dependsOnWorkItemId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dependsOnWorkItemId);
}

@override
String toString() {
    return 'DependencyRequest(dependsOnWorkItemId: $dependsOnWorkItemId)';
}


}

/// @nodoc
abstract mixin class _$DependencyRequestCopyWith<$Res> implements $DependencyRequestCopyWith<$Res> {
  factory _$DependencyRequestCopyWith(_DependencyRequest value, $Res Function(_DependencyRequest) _then) = __$DependencyRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'depends_on_work_item_id') String dependsOnWorkItemId
});




}
/// @nodoc
class __$DependencyRequestCopyWithImpl<$Res>
    implements _$DependencyRequestCopyWith<$Res> {
  __$DependencyRequestCopyWithImpl(this._self, this._then);

  final _DependencyRequest _self;
  final $Res Function(_DependencyRequest) _then;

/// Create a copy of DependencyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dependsOnWorkItemId = null,}) {
  return _then(_DependencyRequest(
dependsOnWorkItemId: null == dependsOnWorkItemId ? _self.dependsOnWorkItemId : dependsOnWorkItemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
