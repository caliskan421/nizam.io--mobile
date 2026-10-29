// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'added_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddedCount {

 int get added;
/// Create a copy of AddedCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddedCountCopyWith<AddedCount> get copyWith => _$AddedCountCopyWithImpl<AddedCount>(this as AddedCount, _$identity);

  /// Serializes this AddedCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AddedCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddedCount&&(identical(other.added, _this.added) || other.added == _this.added));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AddedCount;
  return Object.hash(runtimeType,_this.added);
}

@override
String toString() {
  final _this = this as AddedCount;
  return 'AddedCount(added: ${_this.added})';
}


}

/// @nodoc
abstract mixin class $AddedCountCopyWith<$Res>  {
  factory $AddedCountCopyWith(AddedCount value, $Res Function(AddedCount) _then) = _$AddedCountCopyWithImpl;
@useResult
$Res call({
 int added
});




}
/// @nodoc
class _$AddedCountCopyWithImpl<$Res>
    implements $AddedCountCopyWith<$Res> {
  _$AddedCountCopyWithImpl(this._self, this._then);

  final AddedCount _self;
  final $Res Function(AddedCount) _then;

/// Create a copy of AddedCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? added = null,}) {
  return _then(AddedCount(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AddedCount].
extension AddedCountPatterns on AddedCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddedCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddedCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddedCount value)  $default,){
final _that = this;
switch (_that) {
case _AddedCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddedCount value)?  $default,){
final _that = this;
switch (_that) {
case _AddedCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int added)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddedCount() when $default != null:
return $default(_that.added);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int added)  $default,) {final _that = this;
switch (_that) {
case _AddedCount():
return $default(_that.added);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int added)?  $default,) {final _that = this;
switch (_that) {
case _AddedCount() when $default != null:
return $default(_that.added);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddedCount implements AddedCount {
  const _AddedCount({required this.added});
  factory _AddedCount.fromJson(Map<String, dynamic> json) => _$AddedCountFromJson(json);

@override final  int added;

/// Create a copy of AddedCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddedCountCopyWith<_AddedCount> get copyWith => __$AddedCountCopyWithImpl<_AddedCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddedCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddedCount&&(identical(other.added, added) || other.added == added));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,added);
}

@override
String toString() {
    return 'AddedCount(added: $added)';
}


}

/// @nodoc
abstract mixin class _$AddedCountCopyWith<$Res> implements $AddedCountCopyWith<$Res> {
  factory _$AddedCountCopyWith(_AddedCount value, $Res Function(_AddedCount) _then) = __$AddedCountCopyWithImpl;
@override @useResult
$Res call({
 int added
});




}
/// @nodoc
class __$AddedCountCopyWithImpl<$Res>
    implements _$AddedCountCopyWith<$Res> {
  __$AddedCountCopyWithImpl(this._self, this._then);

  final _AddedCount _self;
  final $Res Function(_AddedCount) _then;

/// Create a copy of AddedCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? added = null,}) {
  return _then(_AddedCount(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
