// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marked_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkedCount {

@JsonKey(name: 'marked_count') int get markedCount;
/// Create a copy of MarkedCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkedCountCopyWith<MarkedCount> get copyWith => _$MarkedCountCopyWithImpl<MarkedCount>(this as MarkedCount, _$identity);

  /// Serializes this MarkedCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarkedCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkedCount&&(identical(other.markedCount, _this.markedCount) || other.markedCount == _this.markedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarkedCount;
  return Object.hash(runtimeType,_this.markedCount);
}

@override
String toString() {
  final _this = this as MarkedCount;
  return 'MarkedCount(markedCount: ${_this.markedCount})';
}


}

/// @nodoc
abstract mixin class $MarkedCountCopyWith<$Res>  {
  factory $MarkedCountCopyWith(MarkedCount value, $Res Function(MarkedCount) _then) = _$MarkedCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'marked_count') int markedCount
});




}
/// @nodoc
class _$MarkedCountCopyWithImpl<$Res>
    implements $MarkedCountCopyWith<$Res> {
  _$MarkedCountCopyWithImpl(this._self, this._then);

  final MarkedCount _self;
  final $Res Function(MarkedCount) _then;

/// Create a copy of MarkedCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? markedCount = null,}) {
  return _then(MarkedCount(
markedCount: null == markedCount ? _self.markedCount : markedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MarkedCount].
extension MarkedCountPatterns on MarkedCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarkedCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarkedCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarkedCount value)  $default,){
final _that = this;
switch (_that) {
case _MarkedCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarkedCount value)?  $default,){
final _that = this;
switch (_that) {
case _MarkedCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'marked_count')  int markedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarkedCount() when $default != null:
return $default(_that.markedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'marked_count')  int markedCount)  $default,) {final _that = this;
switch (_that) {
case _MarkedCount():
return $default(_that.markedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'marked_count')  int markedCount)?  $default,) {final _that = this;
switch (_that) {
case _MarkedCount() when $default != null:
return $default(_that.markedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarkedCount implements MarkedCount {
  const _MarkedCount({@JsonKey(name: 'marked_count') required this.markedCount});
  factory _MarkedCount.fromJson(Map<String, dynamic> json) => _$MarkedCountFromJson(json);

@override@JsonKey(name: 'marked_count') final  int markedCount;

/// Create a copy of MarkedCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkedCountCopyWith<_MarkedCount> get copyWith => __$MarkedCountCopyWithImpl<_MarkedCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkedCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarkedCount&&(identical(other.markedCount, markedCount) || other.markedCount == markedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,markedCount);
}

@override
String toString() {
    return 'MarkedCount(markedCount: $markedCount)';
}


}

/// @nodoc
abstract mixin class _$MarkedCountCopyWith<$Res> implements $MarkedCountCopyWith<$Res> {
  factory _$MarkedCountCopyWith(_MarkedCount value, $Res Function(_MarkedCount) _then) = __$MarkedCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'marked_count') int markedCount
});




}
/// @nodoc
class __$MarkedCountCopyWithImpl<$Res>
    implements _$MarkedCountCopyWith<$Res> {
  __$MarkedCountCopyWithImpl(this._self, this._then);

  final _MarkedCount _self;
  final $Res Function(_MarkedCount) _then;

/// Create a copy of MarkedCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? markedCount = null,}) {
  return _then(_MarkedCount(
markedCount: null == markedCount ? _self.markedCount : markedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
