// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'removed_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemovedCount {

 int get removed;
/// Create a copy of RemovedCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovedCountCopyWith<RemovedCount> get copyWith => _$RemovedCountCopyWithImpl<RemovedCount>(this as RemovedCount, _$identity);

  /// Serializes this RemovedCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RemovedCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovedCount&&(identical(other.removed, _this.removed) || other.removed == _this.removed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RemovedCount;
  return Object.hash(runtimeType,_this.removed);
}

@override
String toString() {
  final _this = this as RemovedCount;
  return 'RemovedCount(removed: ${_this.removed})';
}


}

/// @nodoc
abstract mixin class $RemovedCountCopyWith<$Res>  {
  factory $RemovedCountCopyWith(RemovedCount value, $Res Function(RemovedCount) _then) = _$RemovedCountCopyWithImpl;
@useResult
$Res call({
 int removed
});




}
/// @nodoc
class _$RemovedCountCopyWithImpl<$Res>
    implements $RemovedCountCopyWith<$Res> {
  _$RemovedCountCopyWithImpl(this._self, this._then);

  final RemovedCount _self;
  final $Res Function(RemovedCount) _then;

/// Create a copy of RemovedCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? removed = null,}) {
  return _then(RemovedCount(
removed: null == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RemovedCount].
extension RemovedCountPatterns on RemovedCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemovedCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemovedCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemovedCount value)  $default,){
final _that = this;
switch (_that) {
case _RemovedCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemovedCount value)?  $default,){
final _that = this;
switch (_that) {
case _RemovedCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int removed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemovedCount() when $default != null:
return $default(_that.removed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int removed)  $default,) {final _that = this;
switch (_that) {
case _RemovedCount():
return $default(_that.removed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int removed)?  $default,) {final _that = this;
switch (_that) {
case _RemovedCount() when $default != null:
return $default(_that.removed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RemovedCount implements RemovedCount {
  const _RemovedCount({required this.removed});
  factory _RemovedCount.fromJson(Map<String, dynamic> json) => _$RemovedCountFromJson(json);

@override final  int removed;

/// Create a copy of RemovedCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemovedCountCopyWith<_RemovedCount> get copyWith => __$RemovedCountCopyWithImpl<_RemovedCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RemovedCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemovedCount&&(identical(other.removed, removed) || other.removed == removed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,removed);
}

@override
String toString() {
    return 'RemovedCount(removed: $removed)';
}


}

/// @nodoc
abstract mixin class _$RemovedCountCopyWith<$Res> implements $RemovedCountCopyWith<$Res> {
  factory _$RemovedCountCopyWith(_RemovedCount value, $Res Function(_RemovedCount) _then) = __$RemovedCountCopyWithImpl;
@override @useResult
$Res call({
 int removed
});




}
/// @nodoc
class __$RemovedCountCopyWithImpl<$Res>
    implements _$RemovedCountCopyWith<$Res> {
  __$RemovedCountCopyWithImpl(this._self, this._then);

  final _RemovedCount _self;
  final $Res Function(_RemovedCount) _then;

/// Create a copy of RemovedCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? removed = null,}) {
  return _then(_RemovedCount(
removed: null == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
