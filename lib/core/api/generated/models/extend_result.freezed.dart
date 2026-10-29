// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extend_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtendResult {

@JsonKey(name: 'cascade_count') int get cascadeCount;@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime get newEndOn;
/// Create a copy of ExtendResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtendResultCopyWith<ExtendResult> get copyWith => _$ExtendResultCopyWithImpl<ExtendResult>(this as ExtendResult, _$identity);

  /// Serializes this ExtendResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExtendResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtendResult&&(identical(other.cascadeCount, _this.cascadeCount) || other.cascadeCount == _this.cascadeCount)&&(identical(other.newEndOn, _this.newEndOn) || other.newEndOn == _this.newEndOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExtendResult;
  return Object.hash(runtimeType,_this.cascadeCount,_this.newEndOn);
}

@override
String toString() {
  final _this = this as ExtendResult;
  return 'ExtendResult(cascadeCount: ${_this.cascadeCount}, newEndOn: ${_this.newEndOn})';
}


}

/// @nodoc
abstract mixin class $ExtendResultCopyWith<$Res>  {
  factory $ExtendResultCopyWith(ExtendResult value, $Res Function(ExtendResult) _then) = _$ExtendResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'cascade_count') int cascadeCount,@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime newEndOn
});




}
/// @nodoc
class _$ExtendResultCopyWithImpl<$Res>
    implements $ExtendResultCopyWith<$Res> {
  _$ExtendResultCopyWithImpl(this._self, this._then);

  final ExtendResult _self;
  final $Res Function(ExtendResult) _then;

/// Create a copy of ExtendResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cascadeCount = null,Object? newEndOn = null,}) {
  return _then(ExtendResult(
cascadeCount: null == cascadeCount ? _self.cascadeCount : cascadeCount // ignore: cast_nullable_to_non_nullable
as int,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtendResult].
extension ExtendResultPatterns on ExtendResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtendResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtendResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtendResult value)  $default,){
final _that = this;
switch (_that) {
case _ExtendResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtendResult value)?  $default,){
final _that = this;
switch (_that) {
case _ExtendResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'cascade_count')  int cascadeCount, @DateOnlyConverter()@JsonKey(name: 'new_end_on')  DateTime newEndOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtendResult() when $default != null:
return $default(_that.cascadeCount,_that.newEndOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'cascade_count')  int cascadeCount, @DateOnlyConverter()@JsonKey(name: 'new_end_on')  DateTime newEndOn)  $default,) {final _that = this;
switch (_that) {
case _ExtendResult():
return $default(_that.cascadeCount,_that.newEndOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'cascade_count')  int cascadeCount, @DateOnlyConverter()@JsonKey(name: 'new_end_on')  DateTime newEndOn)?  $default,) {final _that = this;
switch (_that) {
case _ExtendResult() when $default != null:
return $default(_that.cascadeCount,_that.newEndOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtendResult implements ExtendResult {
  const _ExtendResult({@JsonKey(name: 'cascade_count') required this.cascadeCount, @DateOnlyConverter()@JsonKey(name: 'new_end_on') required this.newEndOn});
  factory _ExtendResult.fromJson(Map<String, dynamic> json) => _$ExtendResultFromJson(json);

@override@JsonKey(name: 'cascade_count') final  int cascadeCount;
@override@DateOnlyConverter()@JsonKey(name: 'new_end_on') final  DateTime newEndOn;

/// Create a copy of ExtendResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtendResultCopyWith<_ExtendResult> get copyWith => __$ExtendResultCopyWithImpl<_ExtendResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtendResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtendResult&&(identical(other.cascadeCount, cascadeCount) || other.cascadeCount == cascadeCount)&&(identical(other.newEndOn, newEndOn) || other.newEndOn == newEndOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cascadeCount,newEndOn);
}

@override
String toString() {
    return 'ExtendResult(cascadeCount: $cascadeCount, newEndOn: $newEndOn)';
}


}

/// @nodoc
abstract mixin class _$ExtendResultCopyWith<$Res> implements $ExtendResultCopyWith<$Res> {
  factory _$ExtendResultCopyWith(_ExtendResult value, $Res Function(_ExtendResult) _then) = __$ExtendResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'cascade_count') int cascadeCount,@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime newEndOn
});




}
/// @nodoc
class __$ExtendResultCopyWithImpl<$Res>
    implements _$ExtendResultCopyWith<$Res> {
  __$ExtendResultCopyWithImpl(this._self, this._then);

  final _ExtendResult _self;
  final $Res Function(_ExtendResult) _then;

/// Create a copy of ExtendResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cascadeCount = null,Object? newEndOn = null,}) {
  return _then(_ExtendResult(
cascadeCount: null == cascadeCount ? _self.cascadeCount : cascadeCount // ignore: cast_nullable_to_non_nullable
as int,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
