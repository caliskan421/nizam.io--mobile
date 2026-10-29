// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'target_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TargetResult {

@JsonKey(name: 'target_id') String get targetId; String get status;
/// Create a copy of TargetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetResultCopyWith<TargetResult> get copyWith => _$TargetResultCopyWithImpl<TargetResult>(this as TargetResult, _$identity);

  /// Serializes this TargetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TargetResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetResult&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TargetResult;
  return Object.hash(runtimeType,_this.targetId,_this.status);
}

@override
String toString() {
  final _this = this as TargetResult;
  return 'TargetResult(targetId: ${_this.targetId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $TargetResultCopyWith<$Res>  {
  factory $TargetResultCopyWith(TargetResult value, $Res Function(TargetResult) _then) = _$TargetResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'target_id') String targetId, String status
});




}
/// @nodoc
class _$TargetResultCopyWithImpl<$Res>
    implements $TargetResultCopyWith<$Res> {
  _$TargetResultCopyWithImpl(this._self, this._then);

  final TargetResult _self;
  final $Res Function(TargetResult) _then;

/// Create a copy of TargetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetId = null,Object? status = null,}) {
  return _then(TargetResult(
targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TargetResult].
extension TargetResultPatterns on TargetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TargetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TargetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TargetResult value)  $default,){
final _that = this;
switch (_that) {
case _TargetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TargetResult value)?  $default,){
final _that = this;
switch (_that) {
case _TargetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'target_id')  String targetId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TargetResult() when $default != null:
return $default(_that.targetId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'target_id')  String targetId,  String status)  $default,) {final _that = this;
switch (_that) {
case _TargetResult():
return $default(_that.targetId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'target_id')  String targetId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _TargetResult() when $default != null:
return $default(_that.targetId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TargetResult implements TargetResult {
  const _TargetResult({@JsonKey(name: 'target_id') required this.targetId, required this.status});
  factory _TargetResult.fromJson(Map<String, dynamic> json) => _$TargetResultFromJson(json);

@override@JsonKey(name: 'target_id') final  String targetId;
@override final  String status;

/// Create a copy of TargetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetResultCopyWith<_TargetResult> get copyWith => __$TargetResultCopyWithImpl<_TargetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TargetResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TargetResult&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,targetId,status);
}

@override
String toString() {
    return 'TargetResult(targetId: $targetId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TargetResultCopyWith<$Res> implements $TargetResultCopyWith<$Res> {
  factory _$TargetResultCopyWith(_TargetResult value, $Res Function(_TargetResult) _then) = __$TargetResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'target_id') String targetId, String status
});




}
/// @nodoc
class __$TargetResultCopyWithImpl<$Res>
    implements _$TargetResultCopyWith<$Res> {
  __$TargetResultCopyWithImpl(this._self, this._then);

  final _TargetResult _self;
  final $Res Function(_TargetResult) _then;

/// Create a copy of TargetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetId = null,Object? status = null,}) {
  return _then(_TargetResult(
targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
