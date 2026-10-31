// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtask_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubtaskCounts {

 int get total; int get done;
/// Create a copy of SubtaskCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubtaskCountsCopyWith<SubtaskCounts> get copyWith => _$SubtaskCountsCopyWithImpl<SubtaskCounts>(this as SubtaskCounts, _$identity);

  /// Serializes this SubtaskCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubtaskCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubtaskCounts&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.done, _this.done) || other.done == _this.done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubtaskCounts;
  return Object.hash(runtimeType,_this.total,_this.done);
}

@override
String toString() {
  final _this = this as SubtaskCounts;
  return 'SubtaskCounts(total: ${_this.total}, done: ${_this.done})';
}


}

/// @nodoc
abstract mixin class $SubtaskCountsCopyWith<$Res>  {
  factory $SubtaskCountsCopyWith(SubtaskCounts value, $Res Function(SubtaskCounts) _then) = _$SubtaskCountsCopyWithImpl;
@useResult
$Res call({
 int total, int done
});




}
/// @nodoc
class _$SubtaskCountsCopyWithImpl<$Res>
    implements $SubtaskCountsCopyWith<$Res> {
  _$SubtaskCountsCopyWithImpl(this._self, this._then);

  final SubtaskCounts _self;
  final $Res Function(SubtaskCounts) _then;

/// Create a copy of SubtaskCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? done = null,}) {
  return _then(SubtaskCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SubtaskCounts].
extension SubtaskCountsPatterns on SubtaskCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubtaskCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubtaskCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubtaskCounts value)  $default,){
final _that = this;
switch (_that) {
case _SubtaskCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubtaskCounts value)?  $default,){
final _that = this;
switch (_that) {
case _SubtaskCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int done)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubtaskCounts() when $default != null:
return $default(_that.total,_that.done);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int done)  $default,) {final _that = this;
switch (_that) {
case _SubtaskCounts():
return $default(_that.total,_that.done);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int done)?  $default,) {final _that = this;
switch (_that) {
case _SubtaskCounts() when $default != null:
return $default(_that.total,_that.done);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubtaskCounts implements SubtaskCounts {
  const _SubtaskCounts({required this.total, required this.done});
  factory _SubtaskCounts.fromJson(Map<String, dynamic> json) => _$SubtaskCountsFromJson(json);

@override final  int total;
@override final  int done;

/// Create a copy of SubtaskCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubtaskCountsCopyWith<_SubtaskCounts> get copyWith => __$SubtaskCountsCopyWithImpl<_SubtaskCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubtaskCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubtaskCounts&&(identical(other.total, total) || other.total == total)&&(identical(other.done, done) || other.done == done));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,done);
}

@override
String toString() {
    return 'SubtaskCounts(total: $total, done: $done)';
}


}

/// @nodoc
abstract mixin class _$SubtaskCountsCopyWith<$Res> implements $SubtaskCountsCopyWith<$Res> {
  factory _$SubtaskCountsCopyWith(_SubtaskCounts value, $Res Function(_SubtaskCounts) _then) = __$SubtaskCountsCopyWithImpl;
@override @useResult
$Res call({
 int total, int done
});




}
/// @nodoc
class __$SubtaskCountsCopyWithImpl<$Res>
    implements _$SubtaskCountsCopyWith<$Res> {
  __$SubtaskCountsCopyWithImpl(this._self, this._then);

  final _SubtaskCounts _self;
  final $Res Function(_SubtaskCounts) _then;

/// Create a copy of SubtaskCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? done = null,}) {
  return _then(_SubtaskCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
